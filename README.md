# Marvell SDK tools

Directory and Files:

1.	marvell: Holds scripts to build images from Armada SDK. Built images are placed in /tftpboot directory.
    a.	env.sh: Configurable global variables. 
    b.	build.sh: Automatically builds Linux Kernel, MUSDK, DPDK (with MUSDK support) and OVS. Path to tarballs and build directories are present in env.sh
2.	marvell/root: Holds the scripts executed on DUT. Has support for Vanilla DPDK and DPDK+OVS
    a.	run.sh : DPDK test setup (phy to phy)
    b.	ovs_run.sh: OVS+DPDK test setup (phy to phy)
    c.	ovspvp.sh: OVS+DPDK PVP test setup (phy to vm to phy)
        i.	vm.sh: run the guest host with vhost-user-client support (preferred)
        ii.	vm_userhost.sh: run the guest host with vhost-user support
3.	marvell/qemu: Holds scripts to build applications that run on VM
    a.	env.sh: Configurable global variables
    b.	build_ext4.sh: Builds the ext4 rootfs for VM
    c.	dpdk.sh: Builds Vanilla DPDK that runs on VM
4.	marvell/qemu/root: Holds the scripts executed on VM running on DUT
    a.	run.sh: Sets up the DPDK env and runs the testpmd app (phy to vm to phy)
    b.	testpmd.sh: Runs only the testpmd app (phy to vm to phy)
