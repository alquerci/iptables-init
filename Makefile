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

all: $(BUILD_DIR)

$(BUILD_DIR): hasPWD FORCE
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

clean: hasPWD
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@
	@cd $(TEST_DIR) && $(MAKE) $@

mrproper: hasPWD clean
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@
	@cd $(TEST_DIR) && $(MAKE) $@
	$(RM) -r $(BUILD_DIR)

.PHONY: FORCE clean mrproper

