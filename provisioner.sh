#!/bin/bash
#-------------------------------------------------------------------------------
# Provisioning script
#-------------------------------------------------------------------------------

# If the provisioner ran already, do nothing.
tagfile=/root/.provisioned

if [ -f $tagfile ] ; then
  echo "$tagfile already present, exiting"
  exit
fi
touch $tagfile

# to configure things correctly for X11 forwarding
yum -y install xorg-x11-xauth

# Install JDK
yum -y install java-1.7.0-openjdk-devel

# Install GCC
yum -y install gcc

# Download mysql-community-release-el6-5.noarch.rpm from
# http://dev.mysql.com/downloads/repo/yum/ and save it to the VM's base
# directory.
# Install the repo:
rpm -Uvh /vagrant/mysql-community-release-el6-5.noarch.rpm
# Install MySQL server:
yum -y install mysql-community-server
# Enable and start services:
service mysqld start
chkconfig mysqld on
# Manually run the commands used by mysql_secure_installation.
# See http://www.hackviking.com/2015/02/auto-config-mysql/
mysql -e "UPDATE mysql.user SET Password=PASSWORD('vagrant') WHERE User='root';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE test;"
mysql -e "FLUSH PRIVILEGES;"

# Maven:
wget http://mirrors.gigenet.com/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
tar -zxvf apache-maven-3.0.5-bin.tar.gz -C /opt/

cat >>/etc/profile.d/maven.sh <<-EOF
	export M2_HOME=/opt/apache-maven-3.0.5
	export M2=$M2_HOME/bin
	export PATH=$M2:$PATH
EOF

# get git
yum -y install git

# clone ranger repo
mkdir ~/dev
cd ~/dev
git clone -b ranger-0.4 https://github.com/apache/incubator-ranger.git ranger
# cd ranger
# mvn clean compile package assembly:assembly

