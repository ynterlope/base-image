#!/usr/bin/env bash

set -x
cd /root

# register daily security updates
echo "
#!/usr/bin/env bash
yum update --security -y
" > /etc/cron.daily/yumsecurity.cron
chmod +x /etc/cron.daily/yumsecurity.cron

# latest updates
yum update -y

# install epel so we can get jq :/
yum install -y epel-release

# dev utilities
yum install -y \
  amazon-efs-utils \
  awscli \
  docker \
  jq \
  mysql \
  nano \
  unzip \
  vim \
;

# install docker-compose for convenience
DC_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest \
  | jq -r .tag_name)

curl -s -L -o docker-compose \
  "https://github.com/docker/compose/releases/download/$DC_VERSION/docker-compose-linux-x86_64"
install -m 0755 -t /usr/bin docker-compose
which docker-compose
docker version
docker-compose -v

# install vault
curl -s -L -o vault.zip \
  "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_386.zip"
unzip vault.zip
install -m 0755 -t /usr/bin vault
which vault
vault -v

# install consul
curl -s -L -o consul.zip \
  "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_386.zip"
unzip consul.zip
install -m 0755 -t /usr/bin consul
which consul
consul -v

# install step-ca utils
curl -L -o step https://files.smallstep.com/step-linux-$STEP_VERSION
install -m 0755 -t /usr/bin step
which step
step -v

# install step-ssh
curl -LO "https://files.smallstep.com/step-ssh-$STEP_SSH_VERSION.el7.x86_64.rpm"
yum -y install step-ssh-0.18.8-1.el7.x86_64.rpm

# bootstrap the ssh certificate authority
echo "bootstrapping $STEP_TEAMNAME ssh certificate authority"
step ca bootstrap --team="$STEP_TEAMNAME"