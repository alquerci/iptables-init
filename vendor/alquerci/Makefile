SHLIB = shlib
SHLIB_URL = http://github.com/alquerci/shlib.git

REPOSITORIES = $(SHLIB)

$(SHLIB).update:
	@test -d $(SHLIB) && cd $(SHLIB) && $(GIT) pull || $(GIT) clone $(SHLIB_URL) $(SHLIB)


