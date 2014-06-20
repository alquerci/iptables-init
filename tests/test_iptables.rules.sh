#!/bin/bash
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

oneTimeSetUp()
{
    . ${SD_SRC}/${INIT_D}/*.o > /dev/null
};

test_set_interface()
{
    set_interface;
    assertEquals "code retour" "$?" "0";
    assertNotNull "The variable 'interface' was assigned" "$interface"
};

test_set_network_addr()
{
    set_network_addr;
    assertEquals "code retour" "$?" "0";
    assertNotNull "The variable 'network_addr' was assigned" "$network_addr"
};

test_set_inet_addr()
{
    set_inet_addr;
    assertEquals "code retour" "$?" "0";
    assertNotNull "The variable 'inet_addr' was assigned" "$inet_addr"
};

test_set_bcast_addr()
{
    set_bcast_addr;
    assertEquals "code retour" "$?" "0";
    assertNotNull "The variable 'bcast_addr' was assigned" "$bcast_addr"
};

test_set_network_mask()
{
    set_network_mask;
    assertEquals "code retour" "$?" "0";
    assertNotNull "The variable 'network_mask' was assigned" "$network_mask"
};

. shunit2;
