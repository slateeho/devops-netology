# ClickHouse Role

Ansible role to install and configure ClickHouse columnar database for analytics.

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

Install required collections:
```bash
ansible-galaxy collection install community.general --collections-path ~/.ansible/collections
```

### Quick Start

ClickHouse is installed on hosts tagged with the `clickhouse` group:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags clickhouse
```

## Configuration

### Supported Platforms

- CentOS 8 Stream (uses dnf module for package management)
- Arch Linux (pacman)
- Debian/Ubuntu
- Fedora

### Custom Variables

Override ClickHouse defaults with `--extra-vars`:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags clickhouse \
  --extra-vars "clickhouse_version=22.3.3.44 clickhouse_database=logs"
```

## Tags

Available tags:

- `clickhouse` - Install and configure ClickHouse

## Requirements

None.

## Default Variables

#### clickhouse_version

```YAML
clickhouse_version: 22.3.8.39
```

#### clickhouse_port

```YAML
clickhouse_port: 9000
```

#### clickhouse_http_port

```YAML
clickhouse_http_port: 8123
```

#### clickhouse_database

```YAML
clickhouse_database: logs
```

#### clickhouse_user

```YAML
clickhouse_user: default
```

#### clickhouse_password

```YAML
clickhouse_password: password
```

## License

MIT

## Author Information

slateeho
