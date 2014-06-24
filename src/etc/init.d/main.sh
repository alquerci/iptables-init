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

main()
{
    case "$1" in
        stop)
            iptables_save;
            exit $?;
        ;;
        start|restart)
            iptables_restore;
            exit "$?";
        ;;
        init)
            iptables_init;
            exit "$?";
        ;;
        *)
            echo "usage: $SELF_PATH <start|stop|restart>";
        ;;
    esac;
};

