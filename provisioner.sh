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

# Try to find out if we are running inside ING, if so set proxy
if curl -s www.retail.intranet >/dev/null ; then
  echo "Detected ING network. Setting proxy for ING"
  export http_proxy=http://m05h306:Kurtie13@proxynldcv.europe.intranet:8080/
  export https_proxy=${http_proxy}
fi

# to configure things correctly for X11 forwarding
yum -y install xorg-x11-xauth
# Note, this will make things work with a *trusted* connection (ssh -Y).
# For PuTTY, likely some more work is required.
# See: http://www.udel.edu/it/research/training/config_laptop/puTTY.shtml

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
mysql -v -e "UPDATE mysql.user SET Password=PASSWORD('vagrant') WHERE User='root';"
mysql -v -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -v -e "DELETE FROM mysql.user WHERE User='';"
mysql -v -e "DROP DATABASE test;"
mysql -v -e "FLUSH PRIVILEGES;"

# Maven:
echo "Installing Maven"
wget http://mirrors.gigenet.com/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
tar -zxvf apache-maven-3.0.5-bin.tar.gz -C /opt/

cat >>/etc/profile.d/maven.sh <<-'EOF'
	export M2_HOME=/opt/apache-maven-3.0.5
	export M2=$M2_HOME/bin
	export PATH=$M2:$PATH
EOF

# get git
echo "Installing Git"
yum -y install git

# clone ranger repo
echo "Getting Ranger"
mkdir ~vagrant/dev
cd ~vagrant/dev
git clone -b ranger-0.5 https://github.com/apache/incubator-ranger.git ranger
chown -R vagrant ranger
# cd ranger
# mvn clean compile package assembly:assembly

# Install Eclipse
# Download from browser, or
# wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR2/eclipse-jee-luna-SR2-linux-gtk-x86_64.tar.gz&mirror_id=1186
# For now assume it is in /vagrant
echo "Installing Eclipse"
tar xfz /vagrant/eclipse-jee-luna-SR2-linux-gtk-x86_64.tar.gz -C /usr/local

cat >>/etc/profile.d/eclipse.sh <<-'EOF'
	export PATH=/usr/local/eclipse:$PATH
EOF

# Set path, export DISPLAY. Make sure host has xhost + enabled
# Configure plugin site:  EGit - http://download.eclipse.org/egit/updates 
# Configure plugin site:  m2eclipse - http://download.eclipse.org/technology/m2e/releases
