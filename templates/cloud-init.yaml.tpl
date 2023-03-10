#cloud-config

apt:
  sources:
    docker.list:
      source: deb [arch=arm64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

package_update: true
package_upgrade: true

packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-compose-plugin
  - python3-pip
  - firewalld

groups:
  - docker
system_info:
  default_user:
    groups: [docker]


write_files:
  - path: /home/ubuntu/compose.yaml
    permissions: "0644"
    owner: "ubuntu"
    content: |
      services:
        app-yolo-offline:
          image: ghcr.io/amperecomputingai/yolo-offline-demo:1.1
          ipc: host
          environment:
            GRADIO_SERVER_NAME: $${GRADIO_SERVER_NAME:-0.0.0.0}
            GRADIO_SERVER_PORT: $${GRADIO_SERVER_PORT:-7860}
            HOST_PORT: $${HOST_PORT:-7861}
            NUM_THREADS: $${NUM_THREADS:-32}
          ports:
            - "$${HOST_PORT}:$${GRADIO_SERVER_PORT:-7860}"

runcmd:
  - sudo firewall-cmd --permanent --add-port=7000/tcp
  - sudo firewall-cmd --reload
  - sudo systemctl restart docker.socket
  - export GRADIO_SERVER_NAME="0.0.0.0"
  - export GRADIO_SERVER_PORT=7860
  - export HOST_PORT=7000
  - export NUM_THREADS=32
  - echo `docker version` > "before-docker.log"
  - docker compose -f /home/ubuntu/compose.yaml -p cont-1 up -d app-yolo-offline
  - touch "after-docker.log"
