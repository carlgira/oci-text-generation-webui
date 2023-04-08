#!/bin/bash

main_function() {
USER='opc'

# Resize root partition
printf "fix\n" | parted ---pretend-input-tty /dev/sda print
VALUE=$(printf "unit s\nprint\n" | parted ---pretend-input-tty /dev/sda |  grep lvm | awk '{print $2}' | rev | cut -c2- | rev)
printf "rm 3\nIgnore\n" | parted ---pretend-input-tty /dev/sda
printf "unit s\nmkpart\n/dev/sda3\n\n$VALUE\n100%%\n" | parted ---pretend-input-tty /dev/sda
pvresize /dev/sda3
pvs
vgs
lvextend -l +100%FREE /dev/mapper/ocivolume-root
xfs_growfs -d /

sudo dnf install wget git python3.9 python39-devel.x86_64 libsndfile rustc cargo unzip zip git git-lfs -y

APP='text-generation-webui'
APP_DIR="/home/$USER/$APP"

cat <<EOT > /etc/systemd/system/$APP.service
[Unit]
Description=Instance to serve $APP
[Service]
Environment="python_cmd=python3.9"
Environment="pip_cmd=pip"
ExecStart=/bin/bash $APP_DIR/start.sh
User=$USER
[Install]
WantedBy=multi-user.target
EOT

mkdir -p $APP_DIR/repositories
su -c "git clone https://github.com/oobabooga/text-generation-webui.git $APP_DIR" $USER
su -c "git clone https://github.com/qwopqwop200/GPTQ-for-LLaMa $APP_DIR/repositories/GPTQ-for-LLaMa" $USER
su -c "wget -O $APP_DIR/start.sh https://raw.githubusercontent.com/carlgira/oci-text-generation-webui/main/start.sh" $USER

systemctl daemon-reload
systemctl enable $APP
systemctl start $APP
}

main_function 2>&1 >> /var/log/startup.log
