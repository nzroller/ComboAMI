# Now using these: http://uec-images.ubuntu.com/releases/maverick/release/
# Current as of 03/29/2012
### Script provided by DataStax.

#if [ ! -f cert-*.pem ];
#then
#    echo "Cert files not found on machine!"
#    exit
#fi

# Download and install repo keys
gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
gpg --export --armor 2B5C1B00 | sudo apt-key add -
wget -O - http://installer.datastax.com/downloads/ubuntuarchive.repo_key | sudo apt-key add -
wget -O - http://debian.datastax.com/debian/repo_key | sudo apt-key add -

# Prime for Java installation
sudo echo "sun-java6-bin shared/accepted-sun-dlj-v1-1 boolean true" | sudo debconf-set-selections

# Install Git
sudo apt-get -y update
sudo apt-get -y install git


# Install Java
cd $HOME
wget https://s3.amazonaws.com/ds-java/jdk-6u31-linux-x64.bin
sudo mkdir -p /opt/java/64
sudo mv jdk-6u31-linux-x64.bin /opt/java/64/
cd /opt/java/64
sudo chmod +x jdk*
sudo ./jdk*

# Setup java alternatives
sudo update-alternatives --install "/usr/bin/java" "java" "/opt/java/64/jdk1.6.0_31/bin/java" 1
sudo update-alternatives --set java /opt/java/64/jdk1.6.0_31/bin/java
export JAVA_HOME=/opt/java/64/jdk1.6.0_31

# Git these files on to the server's home directory
git config --global color.ui auto
git config --global color.diff auto
git config --global color.status auto
git clone git://github.com/nzroller/ComboAMI.git datastax_ami

# Begin the actual priming
cd datastax_ami
git checkout $(head -n 1 presetup/VERSION)

# git pull && rm -rf ~/.bash_history && history -c
git pull
sudo python presetup/pre_2.py
sudo chown -R ubuntu:ubuntu . 
rm -rf ~/.bash_history 
history -c


