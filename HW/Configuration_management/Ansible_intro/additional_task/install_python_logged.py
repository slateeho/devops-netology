#!/usr/bin/env python3
import docker
import logging
import subprocess

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

client = docker.APIClient(base_url='unix:///var/run/docker.sock')
containers = client.containers(all=True)
running = [i for i in containers if i['State'] == 'running']
playbook_containers = ['centos7', 'ubuntu', 'fedora']
running = [c for c in running if c['Names'][0].removeprefix('/') in playbook_containers]

os_install_cmds = {
    'debian': 'apt-get update && apt-get install -y python3',
    'ubuntu': 'apt-get update && apt-get install -y python3',
    'rhel': 'sed -i "s/mirrorlist/#mirrorlist/g" /etc/yum.repos.d/CentOS-*.repo && sed -i "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*.repo && dnf install -y python39',
    'fedora': 'dnf install -y python39',
    'centos': 'sed -i "s/mirrorlist/#mirrorlist/g" /etc/yum.repos.d/CentOS-*.repo && sed -i "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*.repo && dnf install -y python39',
    'alpine': 'apk add --no-cache python3',
    'arch': 'pacman -Sy --noconfirm python3',
    'opensuse': 'zypper install -y python3',
    'slackware': 'slackpkg install python3',
    'gentoo': 'emerge python',
}

for container in running:
    cid = container['Id']
    name = container['Names'][0].removeprefix('/')
    
    os_stream = client.exec_start(client.exec_create(cid, ['/bin/sh', '-c', 'grep "^ID=" /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d \'"\''], stdout=True, stderr=True), stream=1)
    os_bytes = b''.join(os_stream)
    os_decoded = os_bytes.decode()
    os_stripped = os_decoded.strip()
    os_type = os_stripped if os_stripped else 'alpine'
    
    if os_type not in os_install_cmds:
        cmd = 'export PATH=/usr/bin:/usr/sbin:/bin:$PATH && export LD_LIBRARY_PATH=/lib:/usr/lib:$LD_LIBRARY_PATH && wget --no-check-certificate -O /tmp/apk-tools.apk https://dl-cdn.alpinelinux.org/alpine/v3.17/main/x86_64/apk-tools-2.12.14-r0.apk && cd /tmp && tar -xvf /tmp/apk-tools.apk && mkdir -p /usr/bin && cp /tmp/sbin/apk /usr/bin/apk && cp -r /tmp/lib/* /lib/ 2>/dev/null || true && chmod +x /usr/bin/apk && echo "http://mirror.yandex.ru/mirrors/alpine/v3.17/main" > /etc/apk/repositories && echo "http://mirror.yandex.ru/mirrors/alpine/v3.17/community" >> /etc/apk/repositories && /usr/bin/apk update && /usr/bin/apk add --no-cache --allow-untrusted python3 py3-pip python3-dev curl'
    else:
        cmd = os_install_cmds.get(os_type)
    
    logger.info(f"Installing python3 in {name} ({os_type})")
    try:
        install_stream = client.exec_start(client.exec_create(cid, ['/bin/sh', '-c', cmd], stdout=True, stderr=True), stream=1)
        install_bytes = b''.join(install_stream)
        install_decoded = install_bytes.decode()
        install_stripped = install_decoded.strip()
        logger.info(f"{name}: python3 installed")
    except Exception as e:
        logger.error(f"{name}: python3 NOT installed - {str(e)}")

# Run ansible playbook
logger.info("Running Ansible playbook...")
playbook_result = subprocess.run(["ansible-playbook", "-i", "inventory/prod.yml", "site.yml", "--vault-password-file", "/dev/stdin"], 
                                 input=b"netology", cwd="/home/a/netology/modules/Git/devops-netology/HW/Configuration_management/Ansible_intro/main_task")

if playbook_result.returncode == 0:
    logger.info("Playbook executed successfully")
    logger.info("Stopping all containers...")
    for container in running:
        cid = container['Id']
        name = container['Names'][0].removeprefix('/')
        client.stop(cid)
        logger.info(f"Stopped {name}")
else:
    logger.error("Playbook NOT executed - failed")
