############## GNU GENERAL PUBLIC LICENSE, Version 3 #################
# iptables-init - Bash script for auto-restore iptables rules
# Copyright (C) 2012 Alexandre Quercia
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#######################################################################

##
# Sets an interface name into $interface.
#
set_interface()
{
    local interfaces=;
    local interface_check=;

    test ! -z "$interface" && return 0;

    interfaces=$(/sbin/ifconfig | cut -d " " -f 1 | grep .);

    for interface_check in $interfaces; do
        if [ ! -z "$(/sbin/ifconfig $interface_check | grep 'Bcast:')" ]; then
            interface=$(echo "$interface_check" | awk '{ print $1 }');

            return 0;
        fi;
    done;

    echo 2>&1 "Cannot detect an availble network interface.";

    return 1;
};

##
# Sets a network address into $network_addr.
#
set_network_addr()
{
    set_interface || return 1;
    set_network_mask || return 1;
    test ! -z "$network_addr" && return 0;
    network_addr=$(/sbin/route | grep "$interface" | grep \* | grep -m 1 "$network_mask" | awk '{ print $1 }');
    return $?;
};

##
# Sets an inet address into $inet_addr.
#
set_inet_addr()
{
    set_interface || return 1
    test ! -z "$inet_addr" && return 0;
    inet_addr=$(/sbin/ifconfig $interface | grep 'Bcast:' | cut -d: -f2 | awk '{ print $1}');
    return $?;
};

##
# Sets a broadcast address into $bcast_addr.
#
set_bcast_addr()
{
    set_interface || return 1;
    test ! -z "$bcast_addr" && return 0;
    bcast_addr=$(/sbin/ifconfig $interface | grep 'Bcast:' | cut -d: -f3 | awk '{ print $1}');
    return $?;
};

##
# Sets a network mask into $network_mask.
#
set_network_mask()
{
    set_interface || return 1;
    test ! -z "$network_mask" && return 0;
    network_mask=$(/sbin/ifconfig $interface | grep 'Bcast:' | cut -d: -f4 | awk '{ print $1}');
    return $?;
};

##
# Sets path of the backup rules files into $rules_path.
#
set_rules_path()
{
    test ! -z "$rules_path" && return 0;

    rules_path="/var/backups/iptables.rules";
    return $?;
};

##
# Initialize all iptables rules.
#
# Determine and save into $rules_path all rules with the current network config.
#
iptables_init()
{
    echo "IPTABLES";
    echo -e "\tGet network configuration:";

    set_interface || return 1;
    echo -e "\t\tInterface:$interface";

    set_inet_addr || return 1;
    echo -e "\t\tInet adr:$inet_addr";

    set_bcast_addr || return 1;
    echo -e "\t\tBcast:$bcast_addr";

    set_network_addr || return 1;
    set_network_mask || return 1;
    echo -e "\t\tNetwork address:$network_addr/$network_mask";

    set_rules_path || return 1;

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
-A OUTPUT -s $inet_addr/32 -j ACCEPT
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
-A local_networks -s $network_addr/$network_mask -i $interface -j ACCEPT
-A local_networks -i lo -j ACCEPT
-A tcp_packets -p tcp -m tcp --dport 22 -j ACCEPT
-A tcp_packets -p tcp -m tcp --dport 80 -j ACCEPT
-A tcp_packets -p tcp -m tcp --dport 443 -j ACCEPT
-A tcp_packets -p tcp -m tcp --dport 143 -j ACCEPT
-A udp_packets -d 255.255.255.255/32 -p udp -j ACCEPT
### Broadcast adress ###
-A udp_packets -d $bcast_addr/32 -p udp -j ACCEPT
########################
-A udp_packets -d 224.0.0.251/32 -p udp -m udp --dport 5353 -j ACCEPT
COMMIT
" > "$rules_path";

    echo "Rules saved into: '$rules_path'";

    return $?;
};

##
# Restore rules from $rules_path.
#
# Require root access.
#
iptables_restore()
{
    set_rules_path || return 1;

    if [ ! -f "$rules_path" ]; then
        iptables_init;
    fi;

    echo -ne "IPTABLES - Restoring rules from '$rules_path' ... ";

    cat "$rules_path" | /sbin/iptables-restore;

    if [ "$?" = 0 ]; then
        echo "done";
        return 0;
    fi;

    echo "fail";
    return 1;
};

##
# Save current iptables rules into $rules_path.
#
# Require root access.
#
iptables_save()
{
    set_rules_path || return 1;

    /sbin/iptables-save > "$rules_path";
    return $?;
};

