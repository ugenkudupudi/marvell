![MACCHIATObin Double Shot](http://macchiatobin.net/wp-content/uploads/2017/11/1.png)
# 

![MACCHIATObin PVP Setup](https://user-images.githubusercontent.com/15847985/56220807-b29c9080-6086-11e9-8e64-98b070bde330.PNG)

# Automation scripts for Marvell SDK

Directory and Files:

1.	**marvell** : Holds scripts to build images from Armada SDK. Built images are placed in /tftpboot directory.

    * env.sh : Configurable global variables. 
    
    * **build.sh** : Automatically builds Linux Kernel, MUSDK, DPDK (with MUSDK support) and OVS. Path to tarballs and build directories are present in env.sh
    
2.	**marvell/qemu** : Holds scripts to build applications that run on VM
    * env.sh : Configurable global variables
    * **build_ext4.sh** : Builds the ext4 rootfs for VM
    * **dpdk.sh** : Builds Vanilla DPDK that runs on VM

3.	**marvell/root** : Holds the scripts executed on DUT. Has support for Vanilla DPDK and DPDK+OVS
    * run.sh : DPDK test setup (phy to phy)
    * ovs_run.sh : OVS+DPDK test setup (phy to phy)
    * **ovspvp.sh** : OVS+DPDK PVP test setup (phy to vm to phy)
        1. **vm.sh** : run the guest host with vhost-user-client support (preferred)
        2. vm_userhost.sh : run the guest host with vhost-user support

4.	**marvell/qemu/root** : Holds the scripts executed on VM running on DUT
    * **run.sh** : Sets up the DPDK env and runs the testpmd app (phy to vm to phy)
    * testpmd.sh : Runs only the testpmd app (phy to vm to phy)

**DB**
```
ovs-vsctl list open_vswitch
ovs-vsctl list interface
ovs-vsctl --columns=ofport,name list Interface
ovs-vsctl --columns=ofport,name --format=table list Interface
ovs-vsctl -f csv --no-heading --columns=_uuid list controller
ovs-vsctl --format=table --columns=name,mac_in_use find Interface name=br-dpdk1
ovs-vsctl get interface vhub656c3cb-23 name

ovs-vsctl set port vlan1729 tag=1729
ovs-vsctl get port vlan1729 tag
ovs-vsctl remove port vlan1729 tag 1729

# not sure this is best
ovs-vsctl set interface vlan1729 mac='5c\:b9\:01\:8d\:3e\:9d'

ovs-vsctl clear Bridge br0 stp_enable

ovs-vsctl --may-exist add-br br0 -- set bridge br0 datapath_type=netdev
ovs-vsctl --if-exists del-br br0
```
**Flows**
```
ovs-ofctl dump-flows br-int

# include hidden flows
ovs-appctl bridge/dump-flows br0

# remove stats on older versions that don't have --no-stats
ovs-ofctl dump-flows br-int | cut -d',' -f3,6,7-
ovs-ofctl -O OpenFlow13 dump-flows br-int | cut -d',' -f3,6,7-

ovs-appctl dpif/show
ovs-ofctl show br-int | egrep "^ [0-9]"

ovs-ofctl add-flow brbm priority=1,in_port=11,dl_src=00:05:95:41:ec:8c/ff:ff:ff:ff:ff:ff,actions=drop
ovs-ofctl --strict del-flows brbm priority=0,in_port=11,dl_src=00:05:95:41:ec:8c

# kernel datapath
ovs-dpctl dump-flows
ovs-appctl dpctl/dump-flows
ovs-appctl dpctl/dump-flows system@ovs-system
ovs-appctl dpctl/dump-flows netdev@ovs-netdev
```
**DPDK**
```
ovs-appctl dpif/show
ovs-ofctl dump-ports br-int
ovs-appctl dpctl/dump-flows
ovs-appctl dpctl/show --statistics
ovs-appctl dpif-netdev/pmd-stats-show
ovs-appctl dpif-netdev/pmd-stats-clear
ovs-appctl dpif-netdev/pmd-rxq-show
```
**Debug log**
```
ovs-appctl vlog/list | grep dpdk
ovs-appctl vlog/set dpdk:file:dbg

# log openflow
ovs-appctl vlog/set vconn:file:dbg
```
**Misc**
```
ovs-appctl list-commands
ovs-appctl fdb/show brbm

ovs-appctl ofproto/trace br-int in_port=6

ovs-appctl ofproto/trace br-int tcp,in_port=3,vlan_tci=0x0000,dl_src=fa:16:3e:8d:26:61,dl_dst=fa:16:3e:0d:f5:e6,nw_src=10.0.0.26,nw_dst=10.0.0.9,nw_tos=0,nw_ecn=0,nw_ttl=0,tp_src=0,tp_dst=22,tcp_flags=0

# history
ovsdb-tool -mm show-log /etc/openvswitch/conf.db

top -p `pidof ovs-vswitchd` -H -d1

# port and dp cache stats
ovs-appctl dpctl/show -s
ovs-appctl memory/show
ovs-appctl upcall/show

```
