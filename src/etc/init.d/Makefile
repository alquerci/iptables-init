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

