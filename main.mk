MAKEFLAGS		+= --no-builtin-rules

# Path to this file
OP_MAKEFILE		:= $(lastword $(MAKEFILE_LIST))

# The OrgPress root directory
export OP_ROOT		:= $(abspath $(dir $(OP_MAKEFILE)))

export OP_PLATFORM_LIST = epub kindle web text pdf

# The book project root directory
export OP_BOOK_DIR	:= $(abspath $(CURDIR))

# The root for all built files
export OP_BUILD_DIR 	:= $(abspath $(CURDIR)/build)

export OP_LIB_DIR	:= $(abspath $(OP_ROOT)/lib)

# The name (for file naming purposes) of the book being built
export OP_BOOK_NAME	?= $(notdir $(OP_BOOK_DIR))

export OP_SOURCES 	?= $(OP_BOOK_NAME).org

export OP_FRONTMATTER	?= $(OP_LIB_DIR)/basic-frontmatter.org

# We use the bookbinding meaning of "signature", to mean "a section
# that contains text".
export OP_SIGNATURE_NAMES ?= $(basename $(OP_FRONTMATTER)) \
			     $(basename $(OP_SOURCES))     \
                             $(basename $(OP_BACKMATTER))

# The list of stages
export OP_STAGES	:= normalize concatenate extract prepare-objects

CALC_VPATH		= $(OP_ROOT)/bin/calc_vpath

################################################################################
# FUNCTIONS
################################################################################

# $(call stage_makefile,foo) => full path of the stage makefile
stage_makefile		= $(abspath $(OP_LIB_DIR)/stage.mk)

platform_build_dir	= $(abspath $(OP_BUILD_DIR)/$1/$2)

# $(call build_stage_command,<STAGE>,<PLATFORM>)
define build_stage_command
mkdir -p $(call platform_build_dir,$1,$2);
$(MAKE) -C $(call platform_build_dir,$1,$2)
	-f $(call stage_makefile,$1)
	OP_STAGE=$1
	OP_PLATFORM=$2
endef

# $(call stage_vpath,<STAGE>,<PLATFORM>)
stage_vpath		= $(shell $(CALC_VPATH) $(OP_BOOK_DIR) $1 $2 $(OP_STAGES))

stage_neutral_dir       = $(call platform_build_dir,$1,neutral)

source_platform_dir     = $(abspath $(OP_BOOK_DIR)/$1)

################################################################################
# SPECIAL RULES
################################################################################


# The stages are all virtual targets
.PHONY: $(OP_STAGES) neutral

################################################################################
# RULES
################################################################################

ifdef OP_PLATFORM
$(OP_STAGES):
	$(strip $(call build_stage_command,$@,neutral))
	$(strip $(call build_stage_command,$@,$(OP_PLATFORM)))
else
$(OP_STAGES):
	for platform in $(OP_PLATFORM_LIST); do \
	  $(MAKE) -f $(OP_MAKEFILE) OP_PLATFORM=$${platform} $@;\
	done
endif


