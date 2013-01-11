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

EXENAME ?= iptables-init
EXEC_PATH = $(SD_BUILD)/$(INIT_D)/$(EXENAME)
SRC = $(wildcard *.sh)
OBJ = $(SRC:.sh=.o)
HEADERS = $(wildcard $(SD_DIST)/alquerci/shlib/src/*.h) $(wildcard *.h)
DOCBLOCK = main.doc
RUNTIME = $(SD_DIST)/alquerci/shlib/src/runtime

all: $(EXEC_PATH)

$(EXEC_PATH): $(DOCBLOCK) $(OBJ) $(RUNTIME)
	$(CAT) $^ > $@

%.o: $(HEADERS) %.sh 
	$(CAT) $^ > $@

install: $(EXEC_PATH)
	@update-rc.d -f $(EXENAME) remove
	install -m 700 $< /$(INIT_D)
	@update-rc.d $(EXENAME) defaults

clean: FORCE
	$(RM) *.o

mrproper: FORCE
	$(RM) $(EXEC_PATH)

.PHONY: FORCE

