#!/bin/bash

# sudo apt-get install -y unzip jq
sudo apt update && sudo apt install -y unzip

# add user and group
sudo groupadd --force --system vault
sudo adduser --system --gid vault --home /etc/vault.d --no-create-home --comment "vault" --shell /bin/false vault >/dev/null
sudo usermod -aG sudo vault

NODE_ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
VAULT_ZIP="vault.zip"
VAULT_URL="${vault_download_url}"

curl --silent --output /tmp/$${VAULT_ZIP} $${VAULT_URL}
sudo unzip -o /tmp/$${VAULT_ZIP} -d /usr/local/bin/
sudo chmod 0755 /usr/local/bin/vault
sudo chown vault:vault /usr/local/bin/vault
sudo mkdir -pm 0755 /etc/vault.d
sudo mkdir -pm 0755 /opt/vault
sudo chown vault:vault /opt/vault

export VAULT_ADDR=http://127.0.0.1:8200

sudo cat << EOF > /lib/systemd/system/vault.service
[Unit]
Description=Vault Agent
Requires=network-online.target
After=network-online.target
[Service]
Restart=on-failure
PermissionsStartOnly=true
ExecStartPre=/sbin/setcap 'cap_ipc_lock=+ep' /usr/local/bin/vault
ExecStart=/usr/local/bin/vault server -config /etc/vault.d/config.hcl
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=vault
Group=vault
[Install]
WantedBy=multi-user.target
EOF

sudo cat << EOF > /etc/vault.d/config.hcl
storage "raft" {
  path = "/opt/vault"
  node_id = "$NODE_ID"
  retry_join {
    leader_api_addr = "http://10.0.2.11:8200"
  }
  retry_join {
    leader_api_addr = "http://10.0.2.12:8200"
  }
  retry_join {
    leader_api_addr = "http://10.0.2.13:8200"
  }
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"
ui=true
disable_mlock = true
EOF

sudo chmod 0664 /lib/systemd/system/vault.service
sudo systemctl daemon-reload
sudo chown -R vault:vault /etc/vault.d
sudo chmod -R 0644 /etc/vault.d/*

cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true
EOF

sudo systemctl enable vault
sudo systemctl start vault

sudo cat << EOF > /tmp/setup.sh
set -v
export VAULT_ADDR="http://127.0.0.1:8200"
EOF

sudo chmod +x /tmp/setup.sh
