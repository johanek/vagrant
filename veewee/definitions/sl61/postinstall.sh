#http://chrisadams.me.uk/2010/05/10/setting-up-a-centos-base-box-for-development-and-testing-with-vagrant/

date > /etc/vagrant_box_build_time

yum -y erase wireless-tools gtk2 libX11 hicolor-icon-theme freetype 
yum -y clean all
yum -y install gcc make

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'http://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm VBoxGuestAdditions_$VBOX_VERSION.iso

yum -y remove gcc kernel-devel make glibc-headers glibc-devel kernel-headers cloog-ppl ppl cpp mpfr libgomp

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed "s/^\(.*kernel.*\)/\1 noapic/" /etc/grub.conf

dd if=/dev/zero of=/tmp/clean || rm /tmp/clean

exit
