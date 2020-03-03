modprobe r8152

sleep 3

udhcpc -i eth7

ifconfig eth0 192.168.1.1 up
ifconfig eth1 192.168.2.1 up
ifconfig eth2 192.168.3.1 up
ifconfig eth3 192.168.4.1 up

