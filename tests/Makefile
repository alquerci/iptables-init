TESTS = $(wildcard test*.sh)

ifndef SHELL_PATH
  SHELL_PATH = /bin/bash
endif

all: $(TESTS)

$(TESTS): FORCE
	@$(SHELL_PATH) ./$@;

clean:

mrproper:

.PHONY: FORCE

