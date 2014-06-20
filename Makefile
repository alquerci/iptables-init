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

# Default target
all::

# vars utils
UTIL_SPACE := $() #

# Programs
SHELL_PATH = /bin/sh
CP = /bin/cp -f
RM = /bin/rm -f --preserve-root
MV = /bin/mv
MKDIR = /bin/mkdir -p
CAT = /bin/cat
INSTALL = /bin/install
GZ = /bin/gzip --best
TAR = /bin/tar
PYTHON = /usr/bin/python
MAKE ?= /usr/bin/make
GIT = /usr/bin/git

# Source directories
SD_ROOT = $(subst $(UTIL_SPACE),\$(UTIL_SPACE),$(shell pwd))
SD_BUILD = $(SD_ROOT)/build
SD_SRC = $(SD_ROOT)/src
SD_TEST = $(SD_ROOT)/tests
SD_DIST = $(SD_ROOT)/vendor
SD_DOC = $(SD_ROOT)/doc
SD_TOOLS = $(SD_ROOT)/tools

# source environement
VERSION = $(shell $(SD_ROOT)/git-version-gen.sh)

# install environement
EXENAME = iptables-init

# Install directories
ID_ROOT = 
ifdef PREFIX
  ID_PREFIX := $(PREFIX)
else
  ID_PREFIX = usr
endif
ID_LOCALSTATE = var
ID_SYSCONF = etc
ID_LIBEXEC = $(ID_PREFIX)/lib
ID_EXEC = $(ID_PREFIX)/bin
ID_DATA = $(ID_PREFIX)/share
ID_MAN = $(ID_DATA)/man
ID_INFO = $(ID_DATA)/info

### START UNIX tree ###
INIT_D = $(ID_SYSCONF)/init.d
### END UNIX tree ###

all:: $(SD_BUILD)

$(SD_BUILD): dist
	$(MKDIR) $@/$(INIT_D)
	@cd $(SD_SRC)/$(INIT_D) && $(MAKE)

test: $(SD_TEST) $(SD_BUILD)
	@cd $< && $(MAKE)

install: isROOT all test
	@cd $(SD_SRC)/$(INIT_D) && $(MAKE) $@

uninstall: isROOT
	@cd $(SD_SRC)/$(INIT_D) && $(MAKE) $@

isROOT: FORCE
	@if [ `id -u` != 0 ];then echo "/!\\ You must be root /!\\" >&2; exit 1; fi;

dist: $(SD_DIST) FORCE
	@cd $(SD_DIST) && $(MAKE)

$(GIT): FORCE
	@if [ ! -x "$(GIT)" ];then echo "Need to install git" >&2; exit 1; fi;

clean:
	@cd $(SD_SRC)/$(INIT_D) && $(MAKE) $@
	@cd $(SD_TEST) && $(MAKE) $@
	$(RM) *~

mrproper: clean
	@cd $(SD_SRC)/$(INIT_D) && $(MAKE) $@
	@cd $(SD_TEST) && $(MAKE) $@
	@cd $(SD_DIST) && $(MAKE) $@
	$(RM) -r $(SD_BUILD)

.PHONY: FORCE clean mrproper
.EXPORT_ALL_VARIABLES:
