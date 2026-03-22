# Vector Role

Ansible role to install and configure Vector log aggregator and processor.

## Table of contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Tags](#tags)
- [Requirements](#requirements)
- [Default Variables](#default-variables)

## Installation

### Prerequisites

- Ansible 2.20.3+
- Python 3.13.5+
- Jinja 3.1.6+
- Docker 26.1.5+ (for Docker mode)
- Docker Compose 5.0.2+ (for Docker mode)
- glibc 2.29+ (CentOS 8 Stream default)
- SSH key pair (id_ed)

Install required collections:
```bash
ansible-galaxy collection install community.docker community.general --collections-path ~/.ansible/collections
```

### Quick Start

Run the playbook for Vector:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags vector
```

## Configuration

### Installation Modes

Configure the installation mode in `roles/vector_role/vars/main.yml`:

- **Docker mode** (`docker: true`): Deploys Vector as a Docker container using docker-compose.
- **Host mode** (`docker: false`): Installs Vector directly on the host system.
- **Kubernetes mode** (`helm: true`): Deploys Vector using Helm charts.

Note: The role implementation should define how to handle conflicting flags (for example, if both docker: true and helm: true are set). The README preserves the initial defaults; ensure your tasks include explicit conditionals or precedence rules to avoid ambiguous behavior.

### Custom Variables

Override Vector defaults with `--extra-vars`:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags vector \
  --extra-vars "docker=false vector_version=0.55.0"
```

## Tags

Available tags:

- `vector` - Install and configure Vector

## Requirements

None beyond the optional `community.docker` collection for Docker mode.

## Default Variables

#### docker

```YAML
docker: true
```

#### helm

```YAML
helm: false
```

#### vector_version

```YAML
vector_version: 0.54.0
```

#### vector_config_dir

```YAML
vector_config_dir: /etc/vector
```

#### vector_log_dir

```YAML
vector_log_dir: /var/log/vector
```

#### vector_prefix

```YAML
vector_prefix: /usr/local
```

#### vector_bin

```YAML
vector_bin: '{{ vector_prefix }}/bin/vector'
```

#### vector_output_log

```YAML
vector_output_log: '{{ vector_log_dir }}/output.log'
```

#### docker_cpu_limit

```YAML
docker_cpu_limit: '0.5'
```

#### docker_memory_limit

```YAML
docker_memory_limit: 512m
```

#### telemetry_address

```YAML
telemetry_address: 0.0.0.0:8686
```

#### telemetry_port

```YAML
telemetry_port: '8686'
```

## License

MIT

## Author Information

slateeho
