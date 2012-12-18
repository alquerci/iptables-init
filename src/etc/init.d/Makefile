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

EXEC = iptables-init
SRC = $(wildcard *.sh)
OBJ = $(SRC:.sh=.o)
HEADERS = $(wildcard $(VENDOR_DIR)/alquerci/shlib/src/*.h) $(wildcard *.h)
DOCBLOCK = main.doc
RUNTIME = $(VENDOR_DIR)/alquerci/shlib/src/runtime

all: $(EXEC)

$(EXEC): $(DOCBLOCK) $(OBJ) $(RUNTIME)
	$(CAT) $^ > $@
	$(INSTALL) -m 755 $@ $(BUILD_DIR)/$(INIT_D)

%.o: $(HEADERS) %.sh 
	$(CAT) $^ > $@

install: $(EXEC)
	@update-rc.d -f $< remove
	install -m 700 $< /$(INIT_D)
	@update-rc.d $< defaults

clean: FORCE
	$(RM) *.o

mrproper: FORCE
	$(RM) $(EXEC)

.PHONY: FORCE

