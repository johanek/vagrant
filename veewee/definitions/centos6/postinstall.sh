#http://chrisadams.me.uk/2010/05/10/setting-up-a-centos-base-box-for-development-and-testing-with-vagrant/

date > /etc/vagrant_box_build_time

rm -rf /etc/yum.repos.d/*
yum-config-manager --add-repo=http://mirrors/centos/6.2/os/x86_64/
yum-config-manager --add-repo=http://mirrors/centos/6.2/updates/x86_64/
yum-config-manager --add-repo=http://mirrors/epel/6/x86_64/
yum-config-manager --add-repo=http://mirrors/dneg/centos/6/x86_64/
yum-config-manager --add-repo=http://mirrors/dneg/centos/6/i386/
yum-config-manager --add-repo=http://linuxdownload.adobe.com/linux/i386/
yum-config-manager --add-repo=http://linuxdownload.adobe.com/linux/x86_64/
yum-config-manager --add-repo=http://yum.puppetlabs.com/el/6/products/x86_64/

rpm --import https://fedoraproject.org/static/0608B895.txt
rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
rpm --import http://mirrors/centos/6.2/os/x86_64/RPM-GPG-KEY-CentOS-6

yum -y install gcc make gcc-c++ ruby kernel-devel-`uname -r` zlib-devel openssl-devel readline-devel sqlite-devel perl
yum -y install puppet facter ruby-devel rubygems
yum -y clean all

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
curl -L -o authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chown -R vagrant /home/vagrant/.ssh

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
curl -L -o VBoxGuestAdditions_$VBOX_VERSION.iso http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

dd if=/dev/zero of=/tmp/clean || rm /tmp/clean

exit
