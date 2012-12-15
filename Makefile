EXEC = iptables-restore-rules.sh
SRC = iptables.rules.sh

all:

install: 
	@if [ `id -u` != 0 ];then echo "Must install with root rights"; exit 1; fi;
	install -m 700 $(SRC) /etc/init.d/$(EXEC)
	update-rc.d -f $(EXEC) remove
	update-rc.d $(EXEC) defaults
	
