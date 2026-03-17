# vector-role

Ansible role to install and configure Vector log aggregator and Clickhouse database on Linux systems.

Vector supports multiple installation modes:
- **Docker container** or **Kubernetes Vector via Helm**
- **Host system**

Clickhouse supports RPM and Arch Linux distributions.

This repository README is split into two parallel blocks — one for Vector and one for Clickhouse. Each block follows the same structure so you can find installation, configuration, tags, default variables, and dependencies for each service quickly. All initial default data is preserved.

## Quick Navigation

- [Vector](#vector)
  - [Installation](#vector-installation)
  - [Configuration](#vector-configuration)
  - [Tags](#vector-tags)
  - [Default Variables](#vector-default-variables)
- [Clickhouse](#clickhouse)
  - [Installation](#clickhouse-installation)
  - [Configuration](#clickhouse-configuration)
  - [Tags](#clickhouse-tags)
  - [Default Variables](#clickhouse-default-variables)

## Vector

### Table of contents

- [Installation](#vector-installation)
- [Configuration](#vector-configuration)
- [Tags](#vector-tags)
- [Requirements](#vector-requirements)
- [Default Variables](#vector-default-variables)

### Installation

#### Prerequisites

- Ansible 2.9+
- Python 3.6+
- Required collection: `community.docker` (only required for Docker mode)

Install the required collection:

```bash
ansible-galaxy collection install community.docker
```

#### Quick Start

Run the playbook for Vector:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags vector
```

### Configuration

#### Installation Modes

Configure the installation mode in `roles/vector-role/vars/main.yml`:

- **Docker mode** (`docker: true`): Deploys Vector as a Docker container using docker-compose.
- **Host mode** (`docker: false`): Installs Vector directly on the host system.
- **Kubernetes mode** (`helm: true`): Deploys Vector using Helm charts.

Note: The role implementation should define how to handle conflicting flags (for example, if both docker: true and helm: true are set). The README preserves the initial defaults; ensure your tasks include explicit conditionals or precedence rules to avoid ambiguous behavior.

#### Custom Variables

Override Vector defaults with `--extra-vars`:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags vector \
  --extra-vars "docker=false vector_version=0.55.0"
```

### Tags

Run specific components using tags:

```bash
# Install only Vector
ansible-playbook -i inventory/prod.yml site.yml --tags vector

# Install both Vector and Clickhouse (default)
ansible-playbook -i inventory/prod.yml site.yml
```

Available tags:

- `vector` - Install and configure Vector

### Requirements

None beyond the optional `community.docker` collection for Docker mode.

### Default Variables

All initial default values are preserved exactly as provided.

#### ansible_playbook_dir

```YAML
ansible_playbook_dir: /home/a/netology/modules/Git/devops-netology/HW/Configuration_management/Ansible_playbook/main_task
```

#### ansible_roles_dir

```YAML
ansible_roles_dir: /home/a/netology/modules/Git/devops-netology/HW/Configuration_management/Ansible_roles/main_task
```

#### docker

```YAML
docker: true
```

#### docker_buildx_path

```YAML
docker_buildx_path: ~/.docker/cli-plugins/docker-buildx
```

#### docker_buildx_url

```YAML
docker_buildx_url: https://github.com/docker/buildx/releases/download/v{{ docker_buildx_version }}/buildx-v{{ docker_buildx_version }}.linux-amd64
```

#### docker_buildx_version

```YAML
docker_buildx_version: 0.17.0
```

#### docker_cpu_limit

```YAML
docker_cpu_limit: '0.5'
```

#### docker_logs

```YAML
docker_logs:
  - /var/lib/docker/containers/*/*.log
```

#### docker_memory_limit

```YAML
docker_memory_limit: 512m
```

#### elasticsearch_endpoint

```YAML
elasticsearch_endpoint: http://es.example.local:9200
```

#### elasticsearch_port

```YAML
elasticsearch_port: '9200'
```

#### helm

```YAML
helm: false
```

#### k8s_logs

```YAML
k8s_logs:
  - /var/log/containers/*.log
  - /var/log/pods/*/*.log
```

#### loki_endpoint

```YAML
loki_endpoint: http://loki.example.local:3100/loki/api/v1/push
```

#### loki_port

```YAML
loki_port: '3100'
```

#### nginx_access_logs

```YAML
nginx_access_logs:
  - /var/log/nginx/*access*.log
```

#### nginx_error_logs

```YAML
nginx_error_logs:
  - /var/log/nginx/*error*.log
```

#### postgres_logs

```YAML
postgres_logs:
  - /var/log/postgresql/postgresql-*.log
  - /var/log/postgresql/*.log
```

#### redis_logs

```YAML
redis_logs:
  - /var/log/redis/redis-server*.log
  - /var/log/redis/*.log
```

#### syslog_files

```YAML
syslog_files:
  - /var/log/syslog
  - /var/log/auth.log
  - /var/log/kern.log
```

#### systemd_cpu_quota

```YAML
systemd_cpu_quota: 50%
```

#### systemd_cpu_weight

```YAML
systemd_cpu_weight: '100'
```

#### systemd_memory_high

```YAML
systemd_memory_high: 400m
```

#### systemd_memory_max

```YAML
systemd_memory_max: 512m
```

#### systemd_memory_swap_max

```YAML
systemd_memory_swap_max: '0'
```

#### telemetry_address

```YAML
telemetry_address: 0.0.0.0:8686
```

#### telemetry_port

```YAML
telemetry_port: '8686'
```

#### vector_bin

```YAML
vector_bin: '{{ vector_prefix }}/bin/vector'
```

#### vector_config_dir

```YAML
vector_config_dir: /etc/vector
```

#### vector_config_volume

```YAML
vector_config_volume: vector_config
```

#### vector_install_script

```YAML
vector_install_script: https://sh.vector.dev
```

#### vector_log_dir

```YAML
vector_log_dir: /var/log/vector
```

#### vector_logs_volume

```YAML
vector_logs_volume: vector_logs
```

#### vector_output_log

```YAML
vector_output_log: '{{ vector_log_dir }}/output.log'
```

#### vector_prefix

```YAML
vector_prefix: /usr/local
```

#### vector_setup_script

```YAML
vector_setup_script: https://setup.vector.dev
```

#### vector_version

```YAML
vector_version: 0.54.0
```


---

## Clickhouse

### Table of contents

- [Installation](#clickhouse-installation)
- [Configuration](#clickhouse-configuration)
- [Tags](#clickhouse-tags)
- [Requirements](#clickhouse-requirements)
- [Default Variables](#clickhouse-default-variables)
- [Dependencies](#clickhouse-dependencies)

### Installation

#### Prerequisites

- Ansible 2.9+
- Python 3.6+

#### Quick Start

Clickhouse is installed on hosts tagged with the `clickhouse` group:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags clickhouse
```

### Configuration

#### Supported Platforms

- RPM based distributions (YUM/DNF)
- Arch Linux (pacman)

#### Custom Variables

Override Clickhouse defaults with `--extra-vars`:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags clickhouse \
  --extra-vars "clickhouse_version=22.3.3.44 clickhouse_database=logs"
```

### Tags

Run specific components using tags:

```bash
# Install only Clickhouse
ansible-playbook -i inventory/prod.yml site.yml --tags clickhouse

# Install only Vector
ansible-playbook -i inventory/prod.yml site.yml --tags vector

# Install both (default)
ansible-playbook -i inventory/prod.yml site.yml
```

Available tags:

- `clickhouse` - Install and configure Clickhouse
- `vector` - Install and configure Vector

### Requirements

None.

### Default Variables

All initial default values are preserved exactly as provided.

#### clickhouse_version

```YAML
clickhouse_version: 22.3.3.44
```

#### clickhouse_database

```YAML
clickhouse_database: logs
```

#### clickhouse_port

```YAML
clickhouse_port: 9000
```

