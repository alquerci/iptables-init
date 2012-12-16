export PREFIX = /usr

ifndef PWD
  export BUILD_DIR = build
  export TEST_DIR = tests
  export SRC_DIR = src
else
  export BUILD_DIR = $(PWD)/build
  export TEST_DIR = $(PWD)/tests
  export SRC_DIR = $(PWD)/src
endif

export EXEC = iptables-init

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

all: $(EXEC)

$(BUILD_DIR):
	$(MKDIR) $@
	@cd $@; $(MKDIR) $(INIT_D)

$(EXEC): $(BUILD_DIR) FORCE
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@
	$(CP) $(SRC_DIR)/$(INIT_D)/$@ $(BUILD_DIR)/$(INIT_D)/$@

install: isroot all
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@
	
test: all
	@cd $(TEST_DIR) && $(MAKE)

isroot: FORCE
	@if [ `id -u` != 0 ];then echo "/!\\ You must be root /!\\"; exit 1; fi;

clean:
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@
	@cd $(TEST_DIR) && $(MAKE) $@

mrproper: clean
	@cd $(SRC_DIR)/$(INIT_D) && $(MAKE) $@
	@cd $(TEST_DIR) && $(MAKE) $@
	$(RM) -r $(BUILD_DIR)

.PHONY: FORCE clean mrproper

