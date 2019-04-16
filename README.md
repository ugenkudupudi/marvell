![MACCHIATObin Double Shot](http://macchiatobin.net/wp-content/uploads/2017/11/1.png)
# 

![MACCHIATObin PVP Setup](https://user-images.githubusercontent.com/15847985/56220807-b29c9080-6086-11e9-8e64-98b070bde330.PNG)

# Automation scripts for Marvell SDK

Directory and Files:

1.	**marvell** : Holds scripts to build images from Armada SDK. Built images are placed in /tftpboot directory.

    * env.sh : Configurable global variables. 
    
    * **build.sh** : Automatically builds Linux Kernel, MUSDK, DPDK (with MUSDK support) and OVS. Path to tarballs and build directories are present in env.sh
    
2.	**marvell/root** : Holds the scripts executed on DUT. Has support for Vanilla DPDK and DPDK+OVS
    * run.sh : DPDK test setup (phy to phy)
    * ovs_run.sh : OVS+DPDK test setup (phy to phy)
    * **ovspvp.sh** : OVS+DPDK PVP test setup (phy to vm to phy)
        1. **vm.sh** : run the guest host with vhost-user-client support (preferred)
        2. vm_userhost.sh : run the guest host with vhost-user support
3.	**marvell/qemu** : Holds scripts to build applications that run on VM
    * env.sh : Configurable global variables
    * **build_ext4.sh** : Builds the ext4 rootfs for VM
    * **dpdk.sh** : Builds Vanilla DPDK that runs on VM
4.	**marvell/qemu/root** : Holds the scripts executed on VM running on DUT
    * **run.sh** : Sets up the DPDK env and runs the testpmd app (phy to vm to phy)
    * testpmd.sh : Runs only the testpmd app (phy to vm to phy)
