#!/usr/bin/env python3
import os
import sys
import re
import signal
import subprocess
import json
import time
import argparse
import platform
import logging
import logging.handlers
from datetime import datetime, timezone, timedelta
import psutil

if os.geteuid() != 0:
    print("Run as root: sudo python3 monitoring_final.py")
    sys.exit(1)


class Monitor:
    def __init__(self) -> None:
        self.args = self._parse_args()
        self.path = self.get_tracing_path()
        self.log_file = f"/home/a/PY/{datetime.now().strftime('%y-%m-%d')}-awesome-monitoring.log"
        handler = logging.handlers.RotatingFileHandler(
            self.log_file, maxBytes=10*1024*1024, backupCount=7
        )
        logging.basicConfig(handlers=[handler], level=logging.INFO, format='%(message)s')
        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)
        if self.args.pid and self.args.pid != -1:
            try:
                self.proc_name = f" ({psutil.Process(self.args.pid).name()})"
            except:
                self.proc_name = ""
            print(f"Tracing PID {self.args.pid}{self.proc_name}")

    def _parse_args(self):
        parser = argparse.ArgumentParser(description='Linux system monitor: cpu, memory, disk_io, load, ftrace kernel functions')
        parser.add_argument('-p', '--pid', type=int, help='Filter ftrace by PID (use -1 to clear). Example: -p $(pgrep spotify | head -1)')
        parser.add_argument('-j', '--json-pretty', action='store_true', help='Pretty print JSON output with indent=2')
        return parser.parse_args()

    def get_tracing_path(self) -> str:
        try:
            lines = subprocess.check_output(['mount'], text=True).split('\n')
            has_debugfs = any('debugfs' in line for line in lines)
            path = '/sys/kernel/debug/tracing' if has_debugfs and os.path.exists('/sys/kernel/debug/tracing/trace') else '/sys/kernel/tracing'
            if not os.path.exists(f'{path}/trace'):
                raise FileNotFoundError(f"Tracing not available. Check /boot/config-$(uname -r) for CONFIG_FTRACE=y")
            return path
        except FileNotFoundError as e:
            print(f"Kernel: {platform.uname().release} - Rebuild with: CONFIG_FTRACE=y CONFIG_TRACEFS=y CONFIG_FUNCTION_TRACER=y")
            print(f"Error: {e}")
            exit(1)
        except:
            return '/sys/kernel/tracing'

    def _signal_handler(self, sig, frame):
        self.cleanup()
        exit(0)

    def _format(self, raw):
        ftrace_keys = [k for k in raw if k.startswith('ftrace')]
        disk_keys = [k for k in raw if k.startswith('disk')]
        base_keys = [k for k in raw if k not in ftrace_keys and k not in disk_keys and k != 'timestamp']
        result = {'timestamp': raw['timestamp']}
        i = 1
        for k in base_keys:
            result[f'metric_{i}'] = [k, raw[k]]
            i += 1
        result[f'metric_{i}'] = ['ftrace', {k: raw[k] for k in ftrace_keys}]
        i += 1
        result[f'metric_{i}'] = ['disk', {k: raw[k] for k in disk_keys}]
        return result

    def _write(self, f, v):
        try:
            with open(f'{self.path}/{f}', 'w') as fh: fh.write(v)
        except:
            pass

    def cleanup(self):
        for f, v in [('tracing_on','0'),('current_tracer','nop'),('trace',''),('set_ftrace_filter',''),('set_ftrace_pid','')]:
            self._write(f, v)

    def prepare(self):
        try:
            self._write('tracing_on', '0')
            if self.args.pid:
                self._write('set_ftrace_pid', str(self.args.pid))
            self._write('current_tracer', 'function')
            self._write('function_profile_enabled', '1')
            self._write('events/raw_syscalls/enable', '1')
            self._write('tracing_on', '1')
        except Exception as e:
            print(f"Warning: Tracing setup failed: {e}")
            self.cleanup()

    def parse_trace_stat(self):
        """Parse function profiling stats with timing from trace_stat"""
        try:
            result = subprocess.run(['head', '-5000', f'{self.path}/trace_stat/function0'],
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                return {
                    v[0]: {"hit": int(v[1]), "time_us": v[2], "avg_us": v[4]}
                    for v in [x.split() for x in result.stdout.split('\n') if x.strip() and not x.strip().startswith('F') and not x.strip().startswith('-')]
                    if len(v) >= 5 and v[1].isdigit()
                }
        except:
            pass
        return {}

    def parse_trace(self):
        try:
            result = subprocess.run(['head', '-500', f'{self.path}/trace'],
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                lines = result.stdout.split('\n')
                if self.args.pid:
                    lines = [v for v in lines if re.search(rf'\w+-{self.args.pid}\s+\[', v)]
                funcs = [x.group(1) for x in [re.search(r':\s+(\w+)\s+<-', v) for v in lines] if x]
                syscall_ids = [x.group(1) for x in [re.search(r'sys_enter.*id=(\d+)', v) for v in lines] if x]
                if funcs:
                    func_dict = {v: funcs.count(v) for v in set(funcs)}
                    event_list = list(set([x.group(1) for x in [re.search(r'(\w+/\w+)', v) for v in lines if '<-' in v] if x]))
                    return {'functions': func_dict, 'events': event_list, 'syscall_ids': syscall_ids}
        except:
            pass
        return None

    def get_storage(self):
        try:
            stats = psutil.disk_io_counters(perdisk=True, nowrap=True)
            return {dev: {'read': v.read_bytes, 'write': v.write_bytes} for dev, v in stats.items()}
        except:
            return {}

    def collect(self):
        metrics = {'timestamp': datetime.now(timezone(timedelta(hours=3))).strftime("%Y-%m-%dT%H:%M:%S.%f+03:00")}

        with open('/proc/stat', 'r') as f:
            cpu = f.readline().split()
            metrics['cpu_user_jiffies'] = int(cpu[1])
            metrics['cpu_system_jiffies'] = int(cpu[3])
            metrics['cpu_idle_jiffies'] = int(cpu[4])

        with open('/proc/meminfo', 'r') as f:
            metrics['mem_available_mb'] = round(int([l for l in f if 'MemAvailable:' in l][0].split()[1]) / 1024, 1)

        with open('/proc/loadavg', 'r') as f:
            metrics['load_1min'] = float(f.read().split()[0])

        with open('/proc/uptime', 'r') as f:
            metrics['uptime_seconds'] = int(float(f.read().split()[0]))

        trace = self.parse_trace()
        stat = self.parse_trace_stat()
        if trace:
            func_dict = trace.get('functions', {})
            total_calls = sum(func_dict.values())
            top_n = sorted(func_dict.items(), key=lambda x: x[1], reverse=True)
            if not self.args.pid:
                top_n = top_n[:30]
            metrics.update({
                'ftrace_functions': len(func_dict),
                'ftrace_top_func': max(func_dict.items(), key=lambda x: x[1])[0] if func_dict else None,
                'ftrace_top_count': max(func_dict.values()) if func_dict else 0,
                'ftrace_top_n': [{"rank": i+1, "func": v, "count": c, "percent": f"{c*100/total_calls:.1f}", **(stat.get(v, {}))} for i, (v, c) in enumerate(top_n)],
                'ftrace_events': trace.get('events', [])
            })
        else:
            metrics.update({'ftrace_functions': 0, 'ftrace_top_func': None, 'ftrace_top_count': 0, 'ftrace_top_n': [], 'ftrace_events': []})

        metrics.update({
            f'disk_{dev}_{k}_mb': round(v / 1024 / 1024, 1)
            for dev, x in self.get_storage().items()
            for k, v in [('read', x['read']), ('write', x['write'])]
        })

        return metrics

    def run(self):
        self.cleanup()
        self.prepare()
        time.sleep(2)
        [logging.info(json.dumps(self.collect())) or time.sleep(1) for _ in range(1)]
        with open(self.log_file, 'r') as f:
            lines = f.readlines()
        with open(self.log_file, 'w') as f:
            f.writelines(lines[-5:])
        with open(self.log_file, 'r') as f:
            last = f.readlines()[-1].strip()
            data = self._format(json.loads(last))
            print(json.dumps(data, indent=2) if self.args.json_pretty else json.dumps(data))
        self.cleanup()


Monitor().run()
