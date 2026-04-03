# Ansible YC VM Creation with add_host Module

This project creates a VM in Yandex Cloud using the `ycc_vm` module and deploys ClickHouse, Vector, and Lighthouse.

## Requirements

- Ansible >= 2.9
- Python 3.8+
- Yandex Cloud SDK
- paramiko

## Installation

```bash
pip install ansible paramiko
pip install git+https://github.com/yandex-cloud/python-sdk

```
Forked from [link](https://github.com/arenadata/ansible-module-yandex-cloud)


## Usage

```bash
export $(cat .env | xargs)
ansible-playbook -i localhost, ansible-playbook.yml
```

## Playbook Structure

The playbook has two plays:

1. **Create VM** - Creates Yandex Cloud VM using `ycc_vm` module
2. **Deploy Services** - Installs ClickHouse, Vector, Lighthouse

## Services Deployed

| Service | Description |
|---------|-------------|
| ClickHouse | Column-oriented DBMS |
| Vector | Log processing tool |
| Lighthouse | ClickHouse web UI (served via Nginx) |

## Directory Structure

```
add_task/
├── ansible-playbook.yml    # Main playbook
├── .env                    # Environment variables
├── plugins/
│   ├── modules/
│   │   └── ycc_vm.py       # VM creation module
│   └── module_utils/
│       └── yc.py           # Yandex Cloud utilities
├── roles/
│   └── create_vm/
│       ├── defaults/
│       └── tasks/
└── README.md
```

## License

MIT