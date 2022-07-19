# About

This repository contains the installation procedure of the Drakvuf, A VMI based black-box malware analysis tool. Drakvuf allows the execution of the malware binaries without using any third party tools. It uses the XEN Hypervisor which is installed in the DOM0 environment and Analysis part of the malware is done in the DOM1, DOM2 and so on.

# Drakvuf Installation

Drakvuf is a black box binary dynamic malware analysis tool. It works on the principle of the VMI (Virtual Machine Introspection).

1. Make sure to disable the "Secure Boot" from the BIOS.
2. While Installating the ubuntu make at least 200 GB space free for LVM group.

## Installation

### Operating System

- Before installing the drakvuf you have to make partition in the system for the LVM and system space.

![Installation](/images/1.png)

- Make sure to check the all boxes as pe the below image before proceeding furthur. However it not mandatory but still it helps to install the latest verison of software.

![Installation](/images/2.png)

- In Installation type, select the Something else.

![Installation](/images/3.png)

- If you already have some installed lvm partition you run the following command to delete it.

![Installation](/images/4.png)

- Now create the swap space, efi space and the main system space for DOM0 XEN installation.

![Installation](/images/5.png)

- Click on the Install button.

![Installation](/images/6.png)

These commands works fine with Debian based linux distro. We have used the Ubunut 20.04 Focal Fossa operting system. First isnstall the required dependencies.

```bash
  sudo apt-get install wget git bcc bin86 gawk bridge-utils iproute2 libcurl4-openssl-dev bzip2 libpci-dev build-essential make gcc clang libc6-dev linux-libc-dev zlib1g-dev libncurses5-dev patch libvncserver-dev libssl-dev libsdl-dev iasl libbz2-dev e2fslibs-dev git-core uuid-dev ocaml libx11-dev bison flex ocaml-findlib xz-utils gettext libyajl-dev libpixman-1-dev libaio-dev libfdt-dev cabextract libglib2.0-dev autoconf automake libtool libjson-c-dev libfuse-dev liblzma-dev autoconf-archive kpartx python3-dev python3-pip golang python-dev libsystemd-dev nasm -y
```

pip3 command is used to install those dependency pakages which old and cannot be installed from apt command.

```bash
  sudo pip3 install pefile construct
```

```bash
  cd ~
  git clone https://github.com/tklengyel/drakvuf
  cd drakvuf
  git submodule update --init
  cd xen
  ./configure --enable-githttp --enable-systemd --enable-ovmf --disable-pvshim
  make -j4 dist-xen
  sudo apt-get install -y ninja-build
  make -j4 dist-tools
  make -j4 debball
```

```bash
  sudo su
  apt-get remove xen* libxen*
  dpkg -i dist/xen*.deb
  echo "GRUB_CMDLINE_XEN_DEFAULT=\"dom0_mem=4096M,max:4096M dom0_max_vcpus=4 dom0_vcpus_pin=1 force-ept=1 ept=ad=0 hap_1gb=0 hap_2mb=0 altp2m=1 hpet=legacy-replacement smt=0\"" >> /etc/default/grub
  echo "/usr/local/lib" > /etc/ld.so.conf.d/xen.conf
  ldconfig
  echo "none /proc/xen xenfs defaults,nofail 0 0" >> /etc/fstab
  echo "xen-evtchn" >> /etc/modules
  echo "xen-privcmd" >> /etc/modules
  systemctl enable xen-qemu-dom0-disk-backend.service
  systemctl enable xen-init-dom0.service
  systemctl enable xenconsoled.service
  update-grub
  uname -r
  cd /etc/grub.d/;mv 20_linux_xen 09_linux_xen
  update-grub
  reboot
```

```bash
  sudo xl list
```

```bash
  sudo apt-get install lvm2 -y
  pvcreate /dev/sda2
  vgcreate vg /dev/sda2
  lvcreate -L110G -n windows7-sp1 vg
```

Now Install the VMM utility from the ubuntu software software

Now install the networking tool.

```bash
  $sudo apt-get install bridge-utils
  $sudo nano /etc/network/interfaces      //open the interface file
```

Copy the following text and paste it in the interfaces files.

```bash
  auto lo
  iface lo inet loopback

  auto enp1s0
  iface enp1s0 inet manual

  auto virbr0
  iface virbr0 inet dhcp
       bridge_ports enp1s0
```

Note: Change according to your network interface (run “ifconfig”).

```bash
  sudo service network-manager restart
```

Now turn on the network bridge service.

```bash
  $sudo gedit /etc/NetworkManager/NetworkManager.conf
  manages = true  //make true from false
  $service netwrok-manager restart
```

To show network Vm interfaces.

```bash
  brctl show
```

#### Download link for windows 7 iso: [Click Here](https://drive.google.com/drive/folders/1dWSDHGIdmVdWbnbU3AfEzrsPCRPaCxam)

Next step is to edit the xen VM's configuration file.

```bash
  $ sudo gedit /etc/xen/win7.cfg
```

```bash
  rch = 'x86_64'
  name = "windows7-sp1"
  maxmem = 3000
  memory = 3000
  vcpus = 2
  maxvcpus = 2
  builder = "hvm"
  boot = "cd"
  hap = 1
  on_poweroff = "destroy"
  on_reboot = "destroy"
  on_crash = "destroy"
  vnc = 1
  vnclisten = "0.0.0.0"
  vga = "stdvga"
  usb = 1
  usbdevice = "tablet"
  audio = 1
  soundhw = "hda"
  viridian = 1
  altp2m = 2
  shadow_memory = 32
  vif = [ 'type=ioemu,model=e1000,bridge=virbr0,mac=48:9e:bd:9e:2b:0d']
  disk = [ 'phy:/dev/vg/windows7-sp1,hda,w', 'file:/home/pc-1/Downloads/windows7.iso,hdc:cdrom,r' ]
```

Note: Make changes according to your file path of windows iso image and mac address

```bash
  cd ~/drakvuf/libvmi
  autoreconf -vif
  ./configure --disable-kvm --disable-bareflank --disable-file
  make
  sudo make install
  sudo echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib" >> ~/.bashrc
```

```bash
  cd ~/drakvuf/volatility3
  python3 ./setup.py build
  sudo python3 ./setup.py install
```

```bash
  cd ~/drakvuf/libvmi
  ./autogen.sh
  ./configure –disable-kvm
  sudo xl list
  sudo xl create /etc/xen/win7.cfg
```

In order to login into the virtula machine which you have created, you first have to install the "gvncviewer".

```bash
  sudo apt install gvncviewer
```

Now login to Virtual Machine and install the windows with giving it login password.

```bash
  gvncviewer localhost
```

When the Windows Installation is finished, follow the following step.

1. Create a partition of 50G. (A seperate Disk drive)
2. Turn all the firewall off.
3. Create a restore point using the newely created partitoin (new drive) // Serach for “create a restore point” in windows start menu.

```bash
  sudo vmi-win-guid name windows7-sp1
```

Note: If found error create run the following commands.

```bash
  sudo /sbin/ldconfig -v
```

Copy the following string from the terminal output

```bash
  PDB GUID: f794d83b0f3c4b7980797437dc4be9e71
	Kernel filename: ntkrnlmp.pdb
```

Now run the following commands from the by changing the paramater accordingly.

```bash
cd /tmp
  python3 ~/drakvuf/volatility3/volatility/framework/symbols/windows/pdbconv.py --guid f794d83b0f3c4b7980797437dc4be9e71 -p ntkrnlmp.pdb -o windows7-sp1.json
  sudo mv windows7-sp1.json /root
```

```bash
  sudo su
  printf "windows7-sp1 {\n\tvolatility_ist = \"/root/windows7-sp1.json\";\n}" >> /etc/libvmi.conf
  exit
```

Now build the drakvuf using the following commands

```bash
  cd ~/drakvuf
  autoreconf -vi
  ./configure
  make
```

Now run the following to get the PID's of the processes.

```bash
  sudo vmi-process-list windows7-sp1
```

#### Tracing Commands

- System tracing:

```bash
  sudo ./src/drakvuf -r /root/windows7-sp1.json -d id
```

Here, id of virtual machine (use sudo xl list command)

- Malware Tracing Command

```bash
  sudo ./src/drakvuf -r /root/windows7-sp1.json -d 1 -x socketmon -t 120 -i 1300 -e “E:\\zbot\\zbot_1.exe” > zbot_1.txt
```

Here,

1300 = change according to pid of explorer.exe
1= id of virtual machine (use sudo xl list command)
“E:\\zbot\\zbot_1.exe”= Location of malware ".exe" file in the created windows VM.
zbot_1.txt= Location of the output file. By default is drakvuf location.

- Network Tracing

```bash
  ping -n 10000 www.google.com  (from cmd of VM)
  sudo tcpdump -w "zbot_1.pcap" -i vif1.0-emu   (can be obtained from brctl show)
```

#### Other Commmands

Xen version:

```bash
  sudo xen-detect
```

List of VMs:

```bash
  sudo xl list
```

Destroy VM:

```bash
  sudo xl destroy id
```

VM boot:

```bash
  gvncviewer localhost
```

CREATE VM:

```bash
  sudo xl create /etc/xen/win7.cfg
```

Windows json file:

```bash
  sudo vmi-win-guid name windows7-sp1
```

VMI process list:

```bash
  sudo vmi-process-list windows7-sp1
```

Enabling the debug:

```bash
  make clean
  ./configure --enable-debug
  make
```

Debug output: (With process injection)

```bash
sudo ./src/drakvuf -r /root/windows7-sp1.json -d 1 -x socketmon -t 120 -i 1300 -e “E:\\zbot\\zbot_1.exe” -v 1> zbot_1.txt
```

Note: Retype all the quotes from the keyboard in the terminal before running the command
Here,

1300 = change according to pid of explorer.exe
1= id of virtual machine (use sudo xl list command)
