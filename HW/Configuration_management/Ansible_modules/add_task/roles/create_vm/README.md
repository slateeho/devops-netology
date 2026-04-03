# create_vm Role

This role creates a VM in Yandex Cloud.

## Requirements

- Ansible >= 2.9
- Yandex Cloud SDK

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| vm_name | - | VM name |
| vm_cores | 2 | Number of CPU cores |
| vm_memory | 2 | Memory in GB |

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - create_vm
```

## License

MIT