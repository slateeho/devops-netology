#!/usr/bin/env python3
import docker
import logging
import os

# ---------------------------------------------------------
# LOGGING (console + file, append mode)
# ---------------------------------------------------------
script_dir = os.path.dirname(os.path.abspath(__file__))
log_path = os.path.join(script_dir, "container_python_installer.log")

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)

file_handler = logging.FileHandler(log_path, mode="a")
file_handler.setLevel(logging.INFO)
file_handler.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(message)s"))
logger.addHandler(file_handler)

# ---------------------------------------------------------
# DOCKER SETUP
# ---------------------------------------------------------
client = docker.APIClient(base_url="unix:///var/run/docker.sock")
containers = client.containers(all=True)
running = [c for c in containers if c["State"] == "running"]

# Molecule container names (add oracle + ubuntu_latest)
playbook_containers = ["debian", "ubuntu", "ubuntu_latest", "centos", "fedora", "arch", "oracle"]
running = [c for c in running if any(name in c["Names"][0] for name in playbook_containers)]

# ---------------------------------------------------------
# INSTALL COMMANDS (FINAL MERGED LOGIC)
# ---------------------------------------------------------
os_install_cmds = {
    "debian": "apt-get update && apt-get install -y python3",
    "ubuntu": "apt-get update && apt-get install -y python3",
    "ubuntu_latest": "apt-get update && apt-get install -y python3",

    # RHEL-family (CentOS, RHEL)
    "rhel": (
        'sed -i "s/mirrorlist/#mirrorlist/g" /etc/yum.repos.d/CentOS-*.repo && '
        'sed -i "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*.repo && '
        'dnf install -y python39'
    ),
    "centos": (
        'sed -i "s/mirrorlist/#mirrorlist/g" /etc/yum.repos.d/CentOS-*.repo && '
        'sed -i "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*.repo && '
        'dnf install -y python39'
    ),

    # Oracle Linux (no vault fix needed)
    "oracle": "dnf install -y python39",
    "ol": "dnf install -y python39",
    "oraclelinux": "dnf install -y python39",

    "fedora": "dnf install -y python39",
    "alpine": "apk add --no-cache python3",
    "arch": "pacman -Sy --noconfirm python3",
    "opensuse": "zypper install -y python3",
    "slackware": "slackpkg install python3",
    "gentoo": "emerge python",
}

# ---------------------------------------------------------
# MAIN LOOP
# ---------------------------------------------------------
for container in running:
    cid = container["Id"]
    name = container["Names"][0].removeprefix("/")

    # ---------------------------------------------------------
    # OS DETECTION (GREP ONLY)
    # ---------------------------------------------------------
    os_stream = client.exec_start(
        client.exec_create(
            cid,
            ["/bin/sh", "-c",
             'grep "^ID=" /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d \'"\''],
            stdout=True, stderr=True
        ),
        stream=1
    )
    os_decoded = b"".join(os_stream).decode().strip().lower()

    # Ubuntu fallback
    if os_decoded == "":
        lsb_stream = client.exec_start(
            client.exec_create(
                cid,
                ["/bin/sh", "-c",
                 'grep "^DISTRIB_ID=" /etc/lsb-release 2>/dev/null | cut -d= -f2 | tr -d \'"\''],
                stdout=True, stderr=True
            ),
            stream=1
        )
        os_decoded = b"".join(lsb_stream).decode().strip().lower()

    # Normalize Oracle Linux IDs
    if os_decoded in ("ol", "oracle", "oraclelinux"):
        os_type = "oracle"
    elif os_decoded in ("ubuntu", "debian", "centos", "fedora", "arch", "ubuntu_latest"):
        os_type = os_decoded
    elif os_decoded == "":
        os_type = "ubuntu"
    else:
        os_type = "alpine"

    # ---------------------------------------------------------
    # SELECT INSTALL COMMAND
    # ---------------------------------------------------------
    cmd = os_install_cmds.get(os_type)

    logger.info(f"[{name}] → Installing python3 (detected OS: {os_type})")

    # ---------------------------------------------------------
    # EXECUTE INSTALL
    # ---------------------------------------------------------
    try:
        install_stream = client.exec_start(
            client.exec_create(
                cid,
                ["/bin/sh", "-c", cmd],
                stdout=True, stderr=True
            ),
            stream=1
        )

        install_output = b"".join(install_stream).decode().strip()
        tail_lines = "\n".join(install_output.splitlines()[-9:])

        logger.info(f"[{name}] last 9 lines:\n{tail_lines}")
        logger.info(f"[{name}] ✔ python3 installed")

    except Exception as e:
        logger.error(f"[{name}] ✖ python3 NOT installed — {str(e)}")