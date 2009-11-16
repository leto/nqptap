# Copyright (C) 2009, Parrot Foundation.

# Command aliases and portability fixes
PERL        = /usr/local/bin/perl
RM_F        = $(PERL) -MExtUtils::Command -e rm_f
CP          = $(PERL) -MExtUtils::Command -e cp
CHMOD       = $(PERL) -MExtUtils::Command -e ExtUtils::Command::chmod

O           = .o
EXE         = 

PARROT_BIN  = /Users/leto/git/nqp-rx/parrot_install/bin
PARROT_LIB  = /Users/leto/git/nqp-rx/parrot_install/lib/1.7.0-devel

PARROT      = $(PARROT_BIN)/parrot
PBC_TO_EXE  = $(PARROT_BIN)/pbc_to_exe
PARROT_NQP  = $(PARROT_BIN)/parrot-nqp

# The default target
all: plparrot$(EXE)

# Always run the FORCEd targets, without checking the filesystem
.PHONY: FORCE

FORCE:

# Rebuild the Makefile if needed
Makefile: src/Makefile.in Configure.nqp
	$(PARROT_NQP) Configure.nqp

# List all user-visible targets
help: FORCE
	@echo ""
	@echo "The following targets are available:"
	@echo ""
	@echo "  all:         Generate plparrot executable (default target)"
	@echo "  clean:       Clean generated files"
	@echo "  test:        Test plparrot and its libraries"
	@echo "  help:        Print this help message"
	@echo ""

# The main build sequence
plparrot$(EXE): src/plparrot$(EXE)
	$(CP) src/plparrot$(EXE) plparrot$(EXE)
	$(CHMOD) 0755 plparrot$(EXE)

src/plparrot$(EXE): Makefile src/plparrot.pbc src/lib/Metadata.pbc src/lib/Util.pbc src/lib/Glue.pbc
	$(PBC_TO_EXE) src/plparrot.pbc

.SUFFIXES: .nqp .pir .pbc

.pir.pbc:
	$(PARROT) -o $@ $<

.nqp.pir:
	$(PARROT_NQP) --target=pir -o $@ $<

# Convenience
realclean: clean

clean: FORCE
	$(RM_F) "*~" "src/lib/*.pbc" "src/*.pbc" "src/*$(O)" "src/*.c" \
	        src/lib/Util.pir src/lib/Metadata.pir src/plparrot.pir \
	        src/plparrot$(EXE) plparrot$(EXE) Makefile

test: FORCE
	$(PARROT_NQP) t/harness t/*.t

# Local variables:
#   mode: makefile
# End:
# vim: ft=make:
