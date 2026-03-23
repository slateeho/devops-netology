# Lighthouse Role

Ansible role to install and configure Lighthouse web UI for ClickHouse.

## Table of contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Tags](#tags)
- [Requirements](#requirements)
- [Default Variables](#default-variables)

## Installation

### Prerequisites

- Ansible 2.20.2+
- Python 3.14.3+
- Jinja 3.1.6+
- ClickHouse running on accessible host

Install required collections:
```bash
ansible-galaxy collection install community.general
```

### Quick Start

Install Lighthouse on dedicated host:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags lighthouse
```

Install with ClickHouse:

```bash
ansible-playbook -i inventory/prod.yml site.yml -e install_lighthouse=true
```

## Configuration

### Connection to ClickHouse

Lighthouse connects to ClickHouse via HTTP API:

- **Host**: ClickHouse server IP/hostname
- **Port**: 8123 (HTTP API)
- **Auth**: Basic auth with ClickHouse credentials
- **Database**: logs (default)

### Custom Variables

Override Lighthouse defaults:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags lighthouse \
  --extra-vars "clickhouse_host=192.168.1.100 clickhouse_port=9000"
```

## Tags

Available tags:

- `lighthouse` - Install and configure Lighthouse

## Requirements

- Nginx web server
- Git for cloning Lighthouse repository
- ClickHouse server (for data queries)

## Default Variables

#### clickhouse_www_path

```YAML
clickhouse_www_path: /var/www/lighthouse
```

#### clickhouse_git_url

```YAML
clickhouse_git_url: https://github.com/VKCOM/lighthouse.git
```

#### clickhouse_config_path

```YAML
clickhouse_config_path: /etc/nginx/conf.d/default.conf
```

#### clickhouse_host

```YAML
clickhouse_host: localhost
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
