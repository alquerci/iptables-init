############## GNU GENERAL PUBLIC LICENSE, Version 3 ####################
# git-version-gen - Tool provides version auto-generation using git tags
# Copyright (C) 2012 Junio C Hamano <gitster@pobox.com>
#                    loops
#                    Tay Ray Chuan <rctay89@gmail.com>
#                    Alexandre Quercia <alquerci@email.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#########################################################################

SHELL_PATH ?= /bin/sh

# Use this version if no tag is defined
export VERSION ?= 0.0.1

# file auto-generate containing the macro VERSION to be included into the Makefile
export GVG_FILE ?= GVG-VERSION~

# Directory to auto generator script
GVG_DIR ?= vendor/alquerci/git-version-gen

# Path to auto generator script
GVG_PATH = $(GVG_DIR)/src/git-version-gen.sh

$(GVG_FILE): FORCE
	@$(SHELL_PATH) $(GVG_PATH)
-include $(GVG_FILE)

# Version must be generate for each times
.PHONY: FORCE


