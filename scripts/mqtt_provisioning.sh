#!/bin/bash
echo "Starting to install VerneMQ"
curl -L https://github.com/vernemq/vernemq/releases/download/1.12.2/vernemq-1.12.2.bullseye.x86_64.deb -o vernemq-1.12.2.bullseye.x86_64.deb
dpkg -i vernemq-1.12.2.bullseye.x86_64.deb
apt-get install -f -y
cat <<EOT >> /etc/vernemq/vernemq.conf
accept_eula = yes
listener.tcp.default = 0.0.0.0:1883
allow_anonymous = on
EOT
systemctl start vernemq
systemctl enable vernemq
echo "VerneMQ is ready!"

# install node-exporter 1.6.1
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

tar xvfz node_exporter-*.*-amd64.tar.gz

cd node_exporter-*.*-amd64

chmod +x ./node_exporter

sudo mv ./node_exporter /usr/local/bin/

sudo useradd -rs /bin/false node_exporter

sudo echo "[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable node_exporter.service
sudo systemctl start node_exporter.service
sudo systemctl is-active node_exporter.service
