
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
  >Ответ:
  Основное преимущество, это что все практически все действия связанные с созданием и эксплуатацией ит сред может быть автоматизировано, а значит многократно использоваться с предсказуемым результатом, что полезно для опредления сроков и времени на решение тех или иных задач. Также это полезно для миграции на другое обородувание или в другое железо. Если все возможные задачи автоматизированы, то это можно делегировать другим специалистам. Любаая автоматизация снижает риски человечесского фактора, устраняет рутину, что ускоряет получение результата - получение решения/продукта для бизнеса.
   
- Какой из принципов IaaC является основополагающим?
  >Ответ:
  Идемпоте́нтность-свойство операции, при выполнеии которой мы получаем то же самый результат при многократном выполнении. 
## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
  >Ответ:
  Для работы с виртуальными машинами достаточно надичие подключения по SSH. Не нужно ставить на них никаких агентов.
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
  >Ответ:
  На мой взгляд, метод Pull (Получение кофигурации с сервера конфигураций) более надежный, т.к. зарнее определяются что, где и по какому расписанию запрашиваются изменения в кофигурации каждой отдельной системы, и они применяются только при наличии изменений, то есть исключаются ненужные перезапуски сервисов и т.п. действия. При Push подходе вероятно будут вноситься изменения в файлы даже если они идентичины изначальным, логично будет перезапускать и сами сервисы.

## Задача 3

Установить на личный компьютер:

- VirtualBox
>sudo apt-get update
>sudo apt-get install Virtualbox
devuser@devuser-virtual-machine:~/Desktop$ sudo apt-get install virtualbox
Reading package lists... Done
Building dependency tree       
Reading state information... Done
virtualbox is already the newest version (6.1.26-dfsg-3~ubuntu1.20.04.2).
The following packages were automatically installed and are no longer required:
  augeas-lenses cpu-checker cryptsetup-bin db-util db5.3-util debootstrap dmeventd extlinux fonts-lato hfsplus ibverbs-providers icoutils ipxe-qemu ipxe-qemu-256k-compat-efi-roms
  javascript-common kpartx ldmtool libafflib0v5 libaio1 libarchive-tools libaugeas0 libboost-iostreams1.71.0 libcacard0 libconfig9 libdate-manip-perl libdevmapper-event1.02.1
  libewf2 libfdt1 libguestfs-hfsplus libguestfs-perl libguestfs-reiserfs libguestfs-tools libguestfs-xfs libguestfs0 libhfsp0 libhivex0 libibverbs1 libintl-perl libintl-xs-perl
  libiscsi7 libjs-jquery libldm-1.0-0 liblvm2cmd2.03 libnetpbm10 libpmem1 librados2 librbd1 librdmacm1 libruby2.7 libslirp0 libspice-server1 libstring-shellquote-perl
  libsys-virt-perl libtsk13 libusbredirparser1 libvirglrenderer1 libvirt0 libwin-hivex-perl libyajl2 libyara3 lsscsi lvm2 msr-tools netpbm nfs-kernel-server osinfo-db ovmf
  qemu-block-extra qemu-system-common qemu-system-data qemu-system-gui qemu-system-x86 qemu-utils rake ruby ruby-bcrypt-pbkdf ruby-builder ruby-childprocess ruby-concurrent
  ruby-domain-name ruby-ed25519 ruby-erubis ruby-excon ruby-ffi ruby-fog-core ruby-fog-json ruby-fog-libvirt ruby-fog-xml ruby-formatador ruby-http-cookie ruby-i18n ruby-libvirt
  ruby-listen ruby-log4r ruby-mime-types ruby-mime-types-data ruby-minitest ruby-multi-json ruby-net-scp ruby-net-sftp ruby-net-ssh ruby-net-telnet ruby-netrc ruby-nokogiri ruby-oj
  ruby-pkg-config ruby-power-assert ruby-rb-inotify ruby-rest-client ruby-sqlite3 ruby-test-unit ruby-unf ruby-unf-ext ruby-vagrant-cloud ruby-xmlrpc ruby-zip ruby2.7
  rubygems-integration scrub seabios sleuthkit sqlite3 supermin syslinux syslinux-common thin-provisioning-tools vagrant-libvirt
Use 'sudo apt autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.



- Vagrant
>Ответ:
devuser@devuser-virtual-machine:~/Desktop$ sudo apt-get install vagrant
devuser@devuser-virtual-machine:~/Desktop$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
devuser@devuser-virtual-machine:~/Desktop$ 
devuser@devuser-virtual-machine:~/Desktop$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Hit:1 http://ru.archive.ubuntu.com/ubuntu focal InRelease
Hit:2 http://ru.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:3 http://ru.archive.ubuntu.com/ubuntu focal-backports InRelease
Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:5 https://apt.releases.hashicorp.com focal InRelease [6 117 B]             
Get:6 https://apt.releases.hashicorp.com focal/main amd64 Packages [34,9 kB]   
Fetched 155 kB in 2s (82,9 kB/s)    
Reading package lists... Done
devuser@devuser-virtual-machine:~/Desktop$ sudo apt-get update && sudo apt-get install vagrant
Hit:1 http://ru.archive.ubuntu.com/ubuntu focal InRelease
Hit:2 http://ru.archive.ubuntu.com/ubuntu focal-updates InRelease              
Hit:3 http://ru.archive.ubuntu.com/ubuntu focal-backports InRelease            
Hit:4 https://apt.releases.hashicorp.com focal InRelease                       
Get:5 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]      
Fetched 114 kB in 2s (61,2 kB/s)    
Reading package lists... Done
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following packages were automatically installed and are no longer required:
  augeas-lenses cpu-checker cryptsetup-bin db-util db5.3-util debootstrap
  dmeventd extlinux fonts-lato hfsplus ibverbs-providers icoutils ipxe-qemu
....                                          
(Reading database ... 178958 files and directories currently installed.)
Preparing to unpack .../vagrant_2.2.18_amd64.deb ...
Unpacking vagrant (2.2.18) over (2.2.6+dfsg-2ubuntu3) ...
Setting up vagrant (2.2.18) ...
Processing triggers for man-db (2.9.1-1) ...
devuser@devuser-virtual-machine:~/Desktop$ vagrant -v
Vagrant 2.2.18
****

- Ansible
>Ответ:
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible


>devuser@devuser-virtual-machine:~/Desktop$ sudo apt install software-properties-common
Reading package lists... Done
Building dependency tree       
Reading state information... Done
software-properties-common is already the newest version (0.98.9.5).
software-properties-common set to manually installed.
The following packages were automatically installed and are no longer required:
  augeas-lenses cpu-checker cryptsetup-bin db-util db5.3-util debootstrap dmeventd extlinux fonts-lato hfsplus ibverbs-providers icoutils ipxe-qemu ipxe-qemu-256k-compat-efi-roms
  javascript-common kpartx ldmtool libafflib0v5 libaio1 libarchive-tools libaugeas0 libboost-iostreams1.71.0 libcacard0 libconfig9 libdate-manip-perl libdevmapper-event1.02.1
  libewf2 libfdt1 libguestfs-hfsplus libguestfs-perl libguestfs-reiserfs libguestfs-tools libguestfs-xfs libguestfs0 libhfsp0 libhivex0 libibverbs1 libintl-perl libintl-xs-perl
  libiscsi7 libjs-jquery libldm-1.0-0 liblvm2cmd2.03 libnetpbm10 libpmem1 librados2 librbd1 librdmacm1 libruby2.7 libslirp0 libspice-server1 libstring-shellquote-perl
  libsys-virt-perl libtsk13 libusbredirparser1 libvirglrenderer1 libvirt0 libwin-hivex-perl libyajl2 libyara3 lsscsi lvm2 msr-tools netpbm nfs-kernel-server osinfo-db ovmf
  qemu-block-extra qemu-system-common qemu-system-data qemu-system-gui qemu-system-x86 qemu-utils rake ruby ruby-bcrypt-pbkdf ruby-builder ruby-childprocess ruby-concurrent
  ruby-domain-name ruby-ed25519 ruby-erubis ruby-excon ruby-ffi ruby-fog-core ruby-fog-json ruby-fog-libvirt ruby-fog-xml ruby-formatador ruby-http-cookie ruby-i18n ruby-libvirt
  ruby-listen ruby-log4r ruby-mime-types ruby-mime-types-data ruby-minitest ruby-multi-json ruby-net-scp ruby-net-sftp ruby-net-ssh ruby-net-telnet ruby-netrc ruby-nokogiri ruby-oj
  ruby-pkg-config ruby-power-assert ruby-rb-inotify ruby-rest-client ruby-sqlite3 ruby-test-unit ruby-unf ruby-unf-ext ruby-vagrant-cloud ruby-xmlrpc ruby-zip ruby2.7
  rubygems-integration scrub seabios sleuthkit sqlite3 supermin syslinux syslinux-common thin-provisioning-tools vagrant-libvirt
Use 'sudo apt autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.

>devuser@devuser-virtual-machine:~/Desktop$ sudo add-apt-repository --yes --update ppa:ansible/ansible
Hit:1 http://ru.archive.ubuntu.com/ubuntu focal InRelease
Hit:2 http://ru.archive.ubuntu.com/ubuntu focal-updates InRelease                        
Get:3 http://ppa.launchpad.net/ansible/ansible/ubuntu focal InRelease [18,0 kB]          
Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]                                                   
Hit:5 http://ru.archive.ubuntu.com/ubuntu focal-backports InRelease                                                                     
Hit:6 https://apt.releases.hashicorp.com focal InRelease                                                                                
Get:7 http://ppa.launchpad.net/ansible/ansible/ubuntu focal/main i386 Packages [1 060 B]
Get:8 http://ppa.launchpad.net/ansible/ansible/ubuntu focal/main amd64 Packages [1 060 B]
Get:9 http://ppa.launchpad.net/ansible/ansible/ubuntu focal/main Translation-en [716 B]
Fetched 135 kB in 2s (75,3 kB/s)                    
Reading package lists... Done

>sudo apt install ansible
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following packages were automatically installed and are no longer required:
  augeas-lenses cpu-checker cryptsetup-bin db-util db5.3-util debootstrap dmeventd extlinux fonts-lato hfsplus ibverbs-providers icoutils ipxe-qemu ipxe-qemu-256k-compat-efi-roms
  javascript-common kpartx ldmtool libafflib0v5 libaio1 libarchive-tools libaugeas0 libboost-iostreams1.71.0 libcacard0 libconfig9 libdate-manip-perl libdevmapper-event1.02.1
  libewf2 libfdt1 libguestfs-hfsplus libguestfs-perl libguestfs-reiserfs libguestfs-tools libguestfs-xfs libguestfs0 libhfsp0 libhivex0 libibverbs1 libintl-perl libintl-xs-perl
  libiscsi7 libjs-jquery libldm-1.0-0 liblvm2cmd2.03 libnetpbm10 libpmem1 librados2 librbd1 librdmacm1 libruby2.7 libslirp0 libspice-server1 libstring-shellquote-perl
  libsys-virt-perl libtsk13 libusbredirparser1 libvirglrenderer1 libvirt0 libwin-hivex-perl libyajl2 libyara3 lsscsi lvm2 msr-tools netpbm nfs-kernel-server osinfo-db ovmf
  qemu-block-extra qemu-system-common qemu-system-data qemu-system-gui qemu-system-x86 qemu-utils rake ruby ruby-bcrypt-pbkdf ruby-builder ruby-childprocess ruby-concurrent
  ruby-domain-name ruby-ed25519 ruby-erubis ruby-excon ruby-ffi ruby-fog-core ruby-fog-json ruby-fog-libvirt ruby-fog-xml ruby-formatador ruby-http-cookie ruby-i18n ruby-libvirt
  ruby-listen ruby-log4r ruby-mime-types ruby-mime-types-data ruby-minitest 

  > devuser@devuser-virtual-machine:~/Desktop$ ansible --version
ansible [core 2.11.6] 
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/devuser/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/devuser/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Sep 28 2021, 16:10:42) [GCC 9.3.0]
  jinja version = 2.10.1
  libyaml = True




*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

>Ответ
vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> server1.netology: Clearing any previously set forwarded ports...
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/devuser/home_works/05-virt-02-iaac/src/vagrant
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...
[WARNING]: Ansible is being run in a world writable directory
(/home/devuser/home_works/05-virt-02-iaac/src/vagrant), ignoring it as an
ansible.cfg source. For more information see
https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-
world-writable-dir

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
changed: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: If you are using a module and expect the file to exist on the remote, see the remote_src option
fatal: [server1.netology]: FAILED! => {"changed": false, "msg": "Could not find or access '~/.ssh/id_rsa.pub' on the Ansible Controller.\nIf you are using a module and expect the file to exist on the remote, see the remote_src option"}
...ignoring

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=git)
ok: [server1.netology] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=1   

devuser@devuser-virtual-machine:~/home_works/05-virt-02-iaac/src/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu 04 Nov 2021 04:20:54 PM UTC

  System load:  0.53              Users logged in:          0
  Usage of /:   3.2% of 61.31GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 20%               IPv4 address for eth0:    10.0.2.15
  Swap u
  Processes:    111


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Thu Nov  4 16:20:34 2021 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
