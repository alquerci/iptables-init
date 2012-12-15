EXEC = iptables-restore-rules.sh
SRC = iptables.rules.sh

all:

install: 
	@if [ `id -u` != 0 ];then echo "Must install with root rights"; exit 1; fi;
	update-rc.d -f $(EXEC) remove
	install -m 700 $(SRC) /etc/init.d/$(EXEC)
	update-rc.d $(EXEC) defaults
	
