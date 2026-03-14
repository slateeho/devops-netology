#!/usr/bin/env bash

set -euo pipefail

log_info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - INFO - $*"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR - $*" >&2
}

playbook_containers=("centos7" "ubuntu" "fedora")

mapfile -t all_container_ids < <(docker ps -a -q)

running_containers=()
for cid in "${all_container_ids[@]}"; do
    state=$(docker inspect -f '{{.State.Status}}' "$cid")
    if [[ "$state" == "running" ]]; then
        name=$(docker inspect -f '{{.Name}}' "$cid" | sed 's|^/||')
        for pc in "${playbook_containers[@]}"; do
            if [[ "$name" == "$pc" ]]; then
                running_containers+=("$cid:$name")
                break
            fi
        done
    fi
done

declare -A os_install_cmds=(
    [debian]='apt-get update && apt-get install -y python3'
    [ubuntu]='apt-get update && apt-get install -y python3'
    [rhel]='sed -i "s/mirrorlist/#mirrorlist/g" /etc/yum.repos.d/CentOS-*.repo && sed -i "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*.repo && dnf install -y python39'
    [fedora]='dnf install -y python39'
    [centos]='sed -i "s/mirrorlist/#mirrorlist/g" /etc/yum.repos.d/CentOS-*.repo && sed -i "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*.repo && dnf install -y python39'
    [alpine]='apk add --no-cache python3'
    [arch]='pacman -Sy --noconfirm python3'
    [opensuse]='zypper install -y python3'
    [slackware]='slackpkg install python3'
    [gentoo]='emerge python'
)

for entry in "${running_containers[@]}"; do
    IFS=":" read -r cid name <<< "$entry"

    os_type=$(docker exec "$cid" sh -c 'grep "^ID=" /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d "\"" || echo alpine' || echo alpine)
    os_type=${os_type:-alpine}

    if [[ -z "${os_install_cmds[$os_type]:-}" ]]; then
        cmd='export PATH=/usr/bin:/usr/sbin:/bin:$PATH && export LD_LIBRARY_PATH=/lib:/usr/lib:$LD_LIBRARY_PATH && wget --no-check-certificate -O /tmp/apk-tools.apk https://dl-cdn.alpinelinux.org/alpine/v3.17/main/x86_64/apk-tools-2.12.14-r0.apk && cd /tmp && tar -xvf /tmp/apk-tools.apk && mkdir -p /usr/bin && cp /tmp/sbin/apk /usr/bin/apk && cp -r /tmp/lib/* /lib/ 2>/dev/null || true && chmod +x /usr/bin/apk && echo "http://mirror.yandex.ru/mirrors/alpine/v3.17/main" > /etc/apk/repositories && echo "http://mirror.yandex.ru/mirrors/alpine/v3.17/community" >> /etc/apk/repositories && /usr/bin/apk update && /usr/bin/apk add --no-cache --allow-untrusted python3 py3-pip python3-dev curl'
    else
        cmd=${os_install_cmds[$os_type]}
    fi

    log_info "Installing python3 in $name ($os_type)"
    if docker exec "$cid" sh -c "$cmd"; then
        log_info "$name: python3 installed"
    else
        log_error "$name: python3 NOT installed"
    fi
done

log_info "Running Ansible playbook..."
cd /home/a/netology/modules/Git/devops-netology/HW/Configuration_management/Ansible_intro/main_task
if ansible-playbook -i inventory/prod.yml site.yml --vault-password-file /dev/stdin <<< "netology"; then
    log_info "Playbook executed successfully"
    log_info "Stopping all containers..."
    for entry in "${running_containers[@]}"; do
        IFS=":" read -r cid name <<< "$entry"
        docker stop "$cid"
        log_info "Stopped $name"
    done
else
    log_error "Playbook NOT executed - failed"
fi
