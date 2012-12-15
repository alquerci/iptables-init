#!/bin/bash
### BEGIN INIT INFO
# Provides:          iptables-restore
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Interactive:     true
# Short-Description: Use iptables-restore to load iptables rules. 
### END INIT INFO

function makeroute
{
    local prefixaddr=${reseauaddr%.*};
    local PING="ping -qn -c 1 -W 1";
    local sufixs="1 254";
    local passerelle="";

    for sufix in $sufixs;
    do
        passerelle="$prefixaddr.$sufix";
        ${PING} "$passerelle" > /dev/null 2>&1;
        if [ $? == 0 ];
        then
            /sbin/route add default gw "$passerelle" > /dev/null 2>&1;
            return 0;
        fi;
    done;

    return 1;
};

function iptables_restore
{
    echo "IPTABLES";
    echo -e "\tGet network configuration:";

    interface=$(/sbin/ifconfig | cut -d " " -f 1 | grep -m 1 . | awk '{ print $1 }');
    echo -e "\t\tInterface:$interface";

    inetaddr=$(/sbin/ifconfig $interface | grep 'Bcast:' | cut -d: -f2 | awk '{ print $1}');
    echo -e "\t\tInet adr:$inetaddr";

    bcastaddr=$(/sbin/ifconfig $interface | grep 'Bcast:' | cut -d: -f3 | awk '{ print $1}');
    echo -e "\t\tBcast:$bcastaddr";

    reseauaddr=$(/sbin/route | grep $interface | grep \* | awk '{ print $1 }');
    reseaumask=$(/sbin/route | grep $interface | grep \* | awk '{ print $3 }');
    echo -e "\t\tNetwork address:$reseauaddr/$reseaumask";

    makeroute;

    echo -ne "\tRestoring rules... ";

    echo "
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]
:allowed - [0:0]
:bad_tcp_packets - [0:0]
:icmp_packets - [0:0]
:local_networks - [0:0]
:tcp_packets - [0:0]
:udp_packets - [0:0]
-A INPUT -p tcp -j bad_tcp_packets 
-A INPUT -j local_networks 
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
-A INPUT -i $interface -p udp -j udp_packets 
-A INPUT -i $interface -p tcp -j tcp_packets 
-A INPUT -i $interface -p icmp -j icmp_packets 
-A INPUT -p igmp -j ACCEPT 
-A INPUT -m limit --limit 3/min --limit-burst 3 -j LOG --log-prefix \"IPT INPUT packet died: \" --log-level 7 
-A FORWARD -p tcp -j bad_tcp_packets 
-A FORWARD -i $interface -j ACCEPT 
-A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT 
-A FORWARD -m limit --limit 3/min --limit-burst 3 -j LOG --log-prefix \"IPT FORWARD packet died: \" --log-level 7 
-A OUTPUT -p tcp -j bad_tcp_packets 
-A OUTPUT -s 127.0.0.1/32 -j ACCEPT 
-A OUTPUT -o $interface -j ACCEPT 
### adress reseau ###
-A OUTPUT -s $inetaddr/32 -j ACCEPT 
#####################
-A OUTPUT -m limit --limit 3/min --limit-burst 3 -j LOG --log-prefix \"IPT OUTPUT packet died: \" --log-level 7 
-A allowed -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT 
-A allowed -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT 
-A allowed -p tcp -j DROP 
-A bad_tcp_packets -p tcp -m tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j REJECT --reject-with tcp-reset 
-A bad_tcp_packets -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -m limit --limit 3/min --limit-burst 3 -j LOG --log-prefix \"IPT New not syn: \" 
-A bad_tcp_packets -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j DROP 
-A icmp_packets -p icmp -m icmp --icmp-type 8 -j ACCEPT 
-A icmp_packets -p icmp -m icmp --icmp-type 11 -j ACCEPT 
-A icmp_packets -p icmp -m limit --limit 50/sec --limit-burst 100 -j LOG --log-prefix \"IPT INPUT others-icmp: \" --log-level 7 
-A local_networks -i $interface -p udp -m udp --sport 68 --dport 67 -j ACCEPT 
# address reseau
-A local_networks -s $reseauaddr/$reseaumask -i $interface -j ACCEPT 
-A local_networks -i lo -j ACCEPT 
-A tcp_packets -p tcp -m tcp --dport 22 -j ACCEPT 
-A tcp_packets -p tcp -m tcp --dport 80 -j ACCEPT 
-A tcp_packets -p tcp -m tcp --dport 443 -j ACCEPT 
-A tcp_packets -p tcp -m tcp --dport 143 -j ACCEPT 
-A udp_packets -d 255.255.255.255/32 -p udp -j ACCEPT 
### Broadcast adress ###
-A udp_packets -d $bcastaddr/32 -p udp -j ACCEPT 
########################
-A udp_packets -d 224.0.0.251/32 -p udp -m udp --dport 5353 -j ACCEPT 
COMMIT
" | /sbin/iptables-restore;

    if [ $? == 0 ];
    then
        echo "done";
    else
        echo "fail";
        return 1;
    fi;
    return 0;
};

function iptables_save
{
    /sbin/iptables-save > /var/backups/iptables.rules;
}

case $1 in
    stop)
        iptables_save
    ;;
    *)
        iptables_restore
    ;;
esac;


exit $?;
