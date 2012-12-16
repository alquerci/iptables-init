EXEC = iptables-init
SRC = $(wildcard *.sh)
OBJ = $(SRC:.sh=.o)
HEADERS = $(wildcard *.h)
DOCBLOCK = main.doc
FUNCTIONS = $(wildcard *.fct)

all: $(EXEC)

$(EXEC): $(DOCBLOCK) $(HEADERS) $(FUNCTIONS) $(OBJ)
	$(CAT) $^ > $@

%.o: %.sh
	$(CAT) $< > $@

install: $(EXEC)
	@update-rc.d -f $< remove
	install -m 700 $< /$(INIT_D)
	@update-rc.d $< defaults

clean: FORCE
	$(RM) *.o

mrproper: FORCE
	$(RM) $(EXEC)

.PHONY: FORCE

