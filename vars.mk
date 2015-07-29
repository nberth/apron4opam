# Definitions of common variables.

ifneq ($(OCAMLFIND),)
MLGMPIDL_INCLUDE = $(shell $(OCAMLFIND) query gmp)
MLGMPIDL_LIB = $(MLGMPIDL_INCLUDE)
else
MLGMPIDL_INCLUDE = $(MLGMPIDL_PREFIX)/include
MLGMPIDL_LIB = $(MLGMPIDL_PREFIX)/lib
endif

APRON_INCLUDE = $(APRON_PREFIX)/include
APRON_LIB = $(APRON_PREFIX)/lib
PREFIX = $(APRON_PREFIX)
INCDIR = $(APRON_INCLUDE)
LIBDIR = $(APRON_LIB)
BINDIR = $(PREFIX)/bin
CAMLDIR = $(PREFIX)/lib

OCAMLPACK := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/ocamlpack

ifneq ($(HAS_SHARED),)
OCAMLMKLIB := $(OCAMLMKLIB) -dllpath $(APRON_LIB)
endif
