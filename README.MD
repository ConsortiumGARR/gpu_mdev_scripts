# nvidia mdevs scripts

## What is it?
Scripts to save and restore VMs vgpu mdevs after reboots.

## Requirement
* properly configured nvidia drivers, passthrough and vgpu support
* mdevctl (`sudo apt-get install mdevctl`)

## Install
You may need to adjust **SYSPATH** and **CREATE_PATH** env variables in **nvidia_mdevs_undefined_restore.sh**!!!
* Undefined mdevs file in **/etc/saved_nvidia_mdevs/nvidia_mdevs** is updated every 5minutes, timer starts 5minutes after system boot, you can change the frequency in **save_nvidia_mdevs.timer** if needed.
* Removal of unused mdevs runs every hour, you can change it in **remove_unused_nvidia_mdevs.timer** if needed.

### Scripts
1. Create **/etc/saved_nvidia_mdevs/** folder: `sudo mkdir /etc/saved_nvidia_mdevs`
2. Copy **nvidia_mdevs_saver.sh**, **remove_unused_nvidia_mdevs.sh** and **nvidia_mdevs_undefined_restore.sh** to **/etc/saved_nvidia_mdevs/nvidia_mdevs**: `sudo cp nvidia_mdevs_saver.sh remove_unused_nvidia_mkdevs.sh nvidia_mdevs_undefined_restore.sh /etc/saved_nvidia_mdevs/`
3. Set correct owner to .sh scripts: `chown root:root /etc/saved_nvidia_mdevs/*.sh`
4. Set correct permissions to scripts: `chmod 744 /etc/saved_nvidia_mdevs/*.sh`
5. Copy systemd units to **/etc/systemd/system/**: `sudo cp systemd_units/*.service /etc/systemd/system/`
6. Copy systemd timers to **/etc/systemd/system/**`sudo cp systemd_timers/*.timer /etc/systemd/system/`
7. Enable systemd units and timers:
    * `systemctl enable --now save_nvidia_mdevs.timer`
    * `systemctl enable --now remove_unused_nvidia_mdevs.timer`
    * `systemctl enable restore_nvidia_mdevs.service`

### find_nvidia_mdevs.sh
1. Copy find_nvidia_mdevs.sh to **/usr/local/sbin**: `cp find_nvidia_mdevs.sh /user/local/sbin/`
2. Set correct owner to .sh scripts: `chown root:root /usr.local.sbin/find_nvidia_mdevs.sh`
3. Set correct permissions to scripts: `chmod 744 /usr/local/sbin/find_nvidia_mdevs.sh`

Example output:
```bash
root@pa1-r4-gpu01:/home/ubuntu/test_emanuele# find_nvidia_mdevs.sh 
++++++++++++++++++++++++++++++++++++++++++ Virsh VMs with nvidia mdevs +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Virsh VM Name: instance-00005a8c, OpenStack ID: 48d937b3-a626-4e7a-a6bf-3d043e74de29, mdev in use d27cb407-855c-46bd-ae6a-ac15ecfbb5d8
Virsh VM Name: instance-00005aaf, OpenStack ID: 4102db67-c94c-44a1-a94d-a6aa24ba3790, mdev in use ac3635ae-da96-4276-8998-94bfb51fcdbc
Virsh VM Name: instance-00005a8b, OpenStack ID: 888a4c61-f519-4315-abef-1050f66f4c47, mdev in use 3a961ebf-e9ed-41be-b1c5-b8a4994d74f9
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-------------------------------------------- mdevs with no associated VMs ------------------------------------------------------------
7e98b69a-57c2-4d18-b9fa-2d26db3e04c5
0cb94404-89a6-4e4c-aef3-f0d63dc3bbcb
--------------------------------------------------------------------------------------------------------------------------------------
```