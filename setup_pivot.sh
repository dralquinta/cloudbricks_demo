#!/bin/bash
#Author: DALQUINT - denny.alquinta@oracle.com
#Purpose: The following script helps autoconfiguring a Development Staging environment on OCI
#Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved. 
if [ "$#" -ne 2 ]; then

echo "Missing arguments. Usage: ./setup_pivot.sh guid email"

else

echo "[0/22] Setting up .bashrc aliases"
sudo tee -a /home/opc/.bashrc > /dev/null <<'EOF'
export WORKON_HOME=~/envs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS=' -p /usr/bin/python3 '
source /usr/local/bin/virtualenvwrapper.sh
export PATH="/home/opc/Terraform-Docs":"/home/opc/Terraform":${PATH}
alias ocibe="cd /home/opc/REPOS/OCIBE"
alias ocife="cd /home/opc/REPOS/OCIFE"
alias k="kubectl"
alias tfversion='f(){ cd ~/Terraform ; unzip -oqq terraform_"$@"_linux_amd64.zip ; cd - ; terraform -version unset -f f; }; f'
EOF
echo -e "[0/22] Done.\n\n"

echo "[1/22] Importing Wandisco Repository for GIT 2.x installation"
sudo tee -a /etc/yum.repos.d/wandisco-git.repo  > /dev/null <<'EOF'
[wandisco-git]
name=Wandisco GIT Repository
baseurl=http://opensource.wandisco.com/rhel/7/git/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
EOF
sudo rpm --import http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
echo -e "[1/22] Done.\n\n"

echo "[2/22] Enabling epel repo"
sudo sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/oracle-epel-ol7.repo
echo -e "[2/22] Done.\n\n"

sudo yum -y install go 
sudo yum -y install git
sudo yum -y install ansible
sudo yum -y install java
sudo yum -y install python3
sudo yum -y install kubectl
sudo yum -y install docker-engine
sudo yum -y install oracle-epel-release-el7
echo -e "[4/22] Done.\n\n"

echo "[5/22] Configuring Docker Engine"
sudo usermod -a -G docker $USER
sudo usermod -a -G docker $USER
sudo systemctl enable docker.service 
sudo systemctl start docker.service 
sudo chmod 666 /var/run/docker.sock
echo -e "[5/22] Done.\n\n"

echo "[6/22] Installing Python PIP and extra modules"
sudo runuser -l opc -c 'curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py'
sudo runuser -l opc -c 'python get-pip.py'
sudo runuser -l opc -c 'pip install "pywinrm>=0.2.2"'
sudo runuser -l opc -c 'pip install oci'
pip3 install --user opc  jupyterlab
pip3 install --user opc xlutils
pip3 install --user opc kubernetes
sudo pip3 install ansible
sudo pip3 install virtualenv
sudo pip3 install virtualenvwrapper

echo -e "[6/22] Done.\n\n"

echo "[7/22] Download and Install Terraform latest stable release and Terraform Docs"
mkdir -p /home/opc/Terraform
sudo runuser -l opc -c 'wget $(echo "https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')_linux_amd64.zip") -P /home/opc/Terraform'
sudo runuser -l opc -c 'unzip /home/opc/Terraform/* -d /home/opc/Terraform'

mkdir -p /home/opc/Terraform-Docs
sudo runuser -l opc -c 'cd /home/opc/Terraform-Docs; wget $(echo "https://github.com/terraform-docs/terraform-docs/releases/download/v$(curl -s https://github.com/terraform-docs/terraform-docs/releases/latest |cut -d 'v' -f 2 | cut -d \"  -f 1)/terraform-docs-v$(curl -s https://github.com/terraform-docs/terraform-docs/releases/latest |cut -d 'v' -f 2 | cut -d \"  -f 1)-linux-amd64.tar.gz ")' 
sudo runuser -l opc -c 'cd /home/opc/Terraform-Docs; tar -xvf terraform-docs-v$(curl -s https://github.com/terraform-docs/terraform-docs/releases/latest |cut -d 'v' -f 2 | cut -d \"  -f 1)-linux-amd64.tar.gz'
echo -e "[7/22] Done.\n\n"


echo "[8/22] Installing Steampipe"
sudo /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)"
steampipe plugin install oci

sudo tee -a ~/.steampipe/config/oci.spc > /dev/null <<'EOF'
connection "oci_tenant_y" {
  plugin              = "oci"
  config_file_profile = "DEFAULT"          # Name of the profile
  config_path         = "~/.oci/config"    # Path to config file
  regions             = ["home-region-first", "us-ashburn-1", "sa-saopaulo-1", "us-phoenix-1"] # List of regions
}
EOF
echo -e "[8/22] Done.\n\n"


echo "[9/22] Initializing AWS credentials"
sudo mkdir -p /home/opc/.aws
sudo tee -a /home/opc/.aws/credentials > /dev/null <<'EOF'
[default]
aws_access_key_id=
aws_secret_access_key=
EOF
sudo chown opc:opc -R /home/opc/.aws
sudo chmod 0600  /home/opc/.aws/credentials
echo -e "[9/22] Done.\n\n"

echo "[10/22] Create hosting directories"

mkdir -p /home/opc/REPOS/OCIFE
mkdir -p /home/opc/REPOS/OCIBE
mkdir -p /home/opc/Terraform
mkdir -p /home/opc/.ssh/OCI_KEYS/API
mkdir -p /home/opc/.ssh/OCI_KEYS/SSH
echo -e "[10/22] Done.\n\n"

echo "[11/22] Create API Keys"
cd /home/opc/.ssh/OCI_KEYS/API
openssl genrsa -out ./auto_api_key.pem 2048
chmod go-rwx ./auto_api_key.pem
openssl rsa -pubout -in ./auto_api_key.pem -out ./auto_api_key_public.pem
openssl rsa -pubout -outform DER -in ./auto_api_key.pem | openssl md5 -c
echo -e "[11/22] Done.\n\n"

echo "[12/22] Create SSH Keys"
cd /home/opc/.ssh/OCI_KEYS/SSH
ssh-keygen -t rsa -N "" -b 2048 -C "autossh" -f ./auto_ssh_id_rsa
cp auto_ssh_id_rsa ../../id_rsa
echo -e "[12/22] Done.\n\n"

echo "[13/22] Disabling epel repo"
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/oracle-epel-ol7.repo
echo -e "[13/22] Done.\n\n"

echo "[14/22] Installing K9s"
mkdir -p /home/opc/k9s_installer
wget https://github.com/derailed/k9s/releases/download/v0.24.7/k9s_Linux_x86_64.tar.gz -P /home/opc/k9s_installer
tar -xvf /home/opc/k9s_installer/k9* -C /home/opc/k9s_installer
sudo cp /home/opc/k9s_installer/k9s /usr/sbin
rm -rf /home/opc/k9s_installer
echo -e "[14/22] Done.\n\n"

echo "[15/22] Installing OCI-CLI"
sudo runuser -l opc -c 'mkdir -p /home/opc/oci_cli'
sudo runuser -l opc -c 'wget https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh'
sudo runuser -l opc -c 'chmod +x install.sh'
sudo runuser -l opc -c '/home/opc/install.sh --install-dir /home/opc/oci_cli/lib/oracle-cli --exec-dir /home/opc/oci_cli/bin --accept-all-defaults'
sudo runuser -l opc -c 'cp -rl /home/opc/bin /home/opc/oci_cli'
sudo runuser -l opc -c 'rm -r /home/opc/bin'
sudo runuser -l opc -c 'mkdir -p /home/opc/.oci'
sudo runuser -l opc -c 'touch /home/opc/.oci/config'
sudo runuser -l opc -c 'oci setup repair-file-permissions --file /home/opc/.oci/config'
echo -e "[15/22] Done.\n\n"

echo "[16/22] Disabling firewall"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
echo "[16/22] Done"

echo "[17/22] Installing HELM Client"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh
echo -e "[17/22] Done.\n\n"

echo "[18/22] Update OS"
sudo yum -y update
echo -e "[18/22] Done.\n\n"

echo "[19/22] Fixing Terminal watch for VSCode"
echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
echo "[19/22] Done"


echo "[20/22] Fixing Installing Oracle Functions CLI"
curl -LSs https://raw.githubusercontent.com/fnproject/cli/master/install | sh
echo "[20/22] Done"

echo "[21/22] Installing Pulumi"
curl -fsSL https://get.pulumi.com | sh
echo "[21/22] Done.\n\n"

echo "[22/22] Rebooting terminal"
exec -l $SHELL
echo -e "[22/22] Done.\n\n"

echo "Setting up GIT username and mail"
git config --global user.name $1
git config --global user.email $2
echo -e "Done.\n\n"

fi
