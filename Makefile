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

export PREFIX = /usr

ifndef PWD
  export BUILD_DIR = build
  export TEST_DIR = tests
  export SRC_DIR = src
  export VENDOR_DIR = vendor
else
  export BUILD_DIR = $(PWD)/build
  export TEST_DIR = $(PWD)/tests
  export SRC_DIR = $(PWD)/src
  export VENDOR_DIR = $(PWD)/vendor
endif

### START UNIX tree ###
export INIT_D = etc/init.d
### END UNIX tree ###

ifndef SHELL_PATH
  export SHELL_PATH = /bin/bash
endif

ifndef MAKE
  export MAKE = make
endif

export MKDIR = /bin/mkdir -p
export CP = /bin/cp -u
export RM = /bin/rm -f --preserve-root
export CAT = /bin/cat -s
export MV = /bin/mv
export INSTALL = /usr/bin/install
export GIT = /usr/bin/git

all: $(BUILD_DIR)

$(BUILD_DIR): hasPWD vendor
	$(MKDIR) $@/$(INIT_D)
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE)

test: $(TEST_DIR) $(BUILD_DIR)
	@cd $< && $(MAKE)

install: isROOT all test
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@

isROOT: FORCE
	@if [ `id -u` != 0 ];then echo "/!\\ You must be root /!\\" >&2; exit 1; fi;

hasPWD: FORCE
	@if [ -z "$(PWD)" ];then echo "Need PWD on the environement" >&2; exit 1; fi;

vendor: $(GIT) $(VENDOR_DIR) FORCE
	@cd $(VENDOR_DIR) && $(MAKE)

$(GIT): FORCE
	@if [ ! -x "$(GIT)" ];then echo "Need to install git" >&2; exit 1; fi;

clean: hasPWD
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@
	@cd $(TEST_DIR) && $(MAKE) $@

mrproper: hasPWD clean
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@
	@cd $(TEST_DIR) && $(MAKE) $@
	$(RM) -r $(BUILD_DIR)

.PHONY: FORCE clean mrproper

