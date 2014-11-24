title: Installing VirtualBox Binaries on a Ubuntu 7.10 (Gutsy Gibbon) Host
category: Linux
tags: linux, Ubuntu, VirtualBox
summary: How I got VirtualBox running on Ubuntu 7.10 (Gutsy Gibbon).

I actually installed [VirtualBox][1] on Xubuntu 7.10, but everything except the
window manager should be the same, so this should work fine for Ubuntu users as well. There is an open source edition of VirtualBox, but the closed binary offers USB support, and was actually very easy to install. Any instructions I found for older versions of Ubuntu required all sorts of manual steps that were all automated for me.

First install some prerequisites (I simply copied these from [elsewhere][3].
They may not all be necessary, so YMMV):

    $ sudo aptitude install bcc iasl xsltproc xalan libxalan110-dev uuid-dev zlib1g-dev libidl-dev libsdl1.2-dev libxcursor-dev libqt3-headers libqt3-mt-dev libasound2-dev libstdc++5 linux-headers-`uname -r` build-essential

Then check the [VirtualBox download page][2] for the url to add to your
`/etc/apt/sources.list`. I added the following lines to the end of that file:

    # Virtualbox Binaries under the PUEL licence
    deb http://www.virtualbox.org/debian gutsy non-free

After saving that file, download and add the innotek public key for apt-secure:

    $ wget -q http://www.virtualbox.org/debian/innotek.asc -O- | sudo apt-key add -

Now update your sources:

    $ sudo aptitude update

Once that finishes, your ready to install VirtualBox:

    $ sudo aptitude install virtualbox

That's it! Well, almost. After all, we're using the binary distribution for 
USB support. To add USB support, as per [these instructions][4], 
you'll need to edit `/etc/init.d/mountdevsubfs.sh` and uncomment 
lines 42 through 45:

    #
    # Magic to make /proc/bus/usb work
    #
    mkdir -p /dev/bus/usb/.usbfs
    domount usbfs "" /dev/bus/usb/.usbfs -obusmode=0700,devmode=0600,listmode=0644
    ln -s .usbfs/devices /dev/bus/usb/devices
    mount --rbind /dev/bus/usb /proc/bus/usb

Then run the script:

    $ sudo /etc/init.d/mountdevsubfs.sh start

Assuming you had no problems, VirtualBox should be in your menu and
ready to use. The first time you launch, it will ask you to register. Then your
ready to start adding virtual machines.

[1]: http://www.virtualbox.org/
[2]: http://www.virtualbox.org/wiki/Downloads
[3]: http://www.howtoforge.com/virtualbox_ubuntu
[4]: http://buranen.info/?p=187
