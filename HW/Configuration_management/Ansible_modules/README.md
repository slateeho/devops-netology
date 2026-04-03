
# slateeho.anyhostupload

Ansible collection for file upload via SSH. Works on Linux and Windows.

## Requirements

- Ansible >= 2.9
- Python >= 3.8
- paramiko (`pip install paramiko`)

## Installation

```bash
ansible-galaxy collection install slateeho.anyhostupload
```
## Upload Algorithm

1. **SFTP (primary)** - File transfer via SFTP subsystem on Linux\Windows.

2. **Base64 fallback** - If SFTP failed, file transferred via SSH:
   - Linux: `base64 -d` command
   - Windows: PowerShell `[System.Convert]::FromBase64String()`

## Role: upload_file

### Defaults

| Parameter | Default | Description |
|-----------|---------|-------------|
| `file` | `""` | Local file path (required) |
| `dest` | `""` | Remote destination path |
| `ansible_host` | `""` | Remote host IP/hostname (required) |
| `ansible_port` | `22` | SSH port |
| `ansible_user` | `root` | SSH username |
| `ansible_password` | `""` | SSH password |
| `ansible_ssh_private_key_file` | `""` | SSH private key path |
| `auto_add_host_key` | `false` | Auto-add host key |

## Usage

```yaml
- name: Upload file
  hosts: all
  gather_facts: no
  roles:
    - role: slateeho.anyhostupload.upload_file
      vars:
        file: /local/file.txt
        dest: /remote/file.txt
        ansible_host: "{{ ansible_host }}"
        ansible_user: root
        ansible_password: "{{ vault_password }}"
```
```bash
ansible-playbook playbook.yml -i inventory.ini
```

## Module: anyhostupload

Direct module usage:

```yaml
- name: Upload via module
  slateeho.anyhostupload.anyhostupload:
    file: /local/file.txt
    dest: /remote/file.txt
    ansible_host: 192.168.1.100
    ansible_user: root
    ansible_password: secret
  delegate_to: localhost
```
## Features

- **Idempotent** - SHA256 hash comparison, skips identical files
- **Cross-platform** - Linux/Unix and Windows support
- **Multiple auth** - Password and SSH key authentication