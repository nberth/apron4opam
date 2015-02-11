include Makefile.config
PKGNAME = apron
VERSION_STR = 0.9.11-3

LCFLAGS = \
-Lapron -Litv -Lbox -Loctagons -Lnewpolka -Ltaylor1plus \
-L$(PPL_PREFIX)/lib -Lppl \
-Lproducts \
-L$(GMP_PREFIX)/lib -L$(MPFR_PREFIX)/lib \
-L$(CAMLIDL_PREFIX)/lib/ocaml

all: c
ifneq ($(HAS_OCAML),)
all: ml
endif
ifneq ($(HAS_CPP),)
all: cxx
endif
ifneq ($(HAS_JAVA),)
all: java
endif

c:
	(cd num; $(MAKE) all)
	(cd itv; $(MAKE) all)
	(cd apron; $(MAKE) all)
	(cd newpolka; $(MAKE) all)
	(cd box; $(MAKE) all)
	(cd octagons; $(MAKE) MPQ D)
	(cd taylor1plus; $(MAKE) all)
ifneq ($(HAS_PPL),)
	(cd ppl; $(MAKE))
	(cd products; $(MAKE))
endif

cxx:
	(cd apronxx; $(MAKE))

java:
	(cd japron; $(MAKE))

ml:
	(cd mlapronidl; $(MAKE) all)
	(cd newpolka; $(MAKE) ml)
	(cd box; $(MAKE) ml)
	(cd octagons; $(MAKE) mlMPQ mlD)
	(cd taylor1plus; $(MAKE) ml)
ifneq ($(HAS_PPL),)
	(cd ppl; $(MAKE) ml)
	(cd products; $(MAKE) ml)
endif

.PHONY: aprontop apronppltop

aprontop:
	$(OCAMLMKTOP) -I $(MLGMPIDL_PREFIX)/lib -I $(APRON_PREFIX)/lib -verbose -o $@ \
	bigarray.cma gmp.cma apron.cma boxMPQ.cma octMPQ.cma polkaMPQ.cma t1pMPQ.cma

apronppltop:
	$(OCAMLMKTOP) -I $(MLGMPIDL_PREFIX)/lib -I $(APRON_PREFIX)/lib -verbose -o $@ \
	bigarray.cma gmp.cma apron.cma boxMPQ.cma octMPQ.cma polkaMPQ.cma ppl.cma polkaGrid.cma t1pMPQ.cmxa

rebuild:
ifneq ($(HAS_OCAML),)
	(cd mlapronidl; $(MAKE) rebuild)
	(cd newpolka; $(MAKE) rebuild)
	(cd box; $(MAKE) rebuild)
	(cd octagons; $(MAKE) rebuild)
	(cd taylor1plus; $(MAKE) rebuild)
	(cd ppl; $(MAKE) rebuild)
	(cd products; $(MAKE) rebuild)
endif

OCAMLFIND_PROTO_BASE = libxxx.a libxxx_debug.a
ifneq ($(INSTALL_SHARED),)
  OCAMLFIND_PROTO_BASE += libxxx.so libxxx_debug.so
endif

OCAMLFIND_PROTO_ML = xxx.cma xxx.cmxa xxx.a libxxx_caml.a libxxx_caml_debug.a
ifneq ($(HAS_SHARED),)
  OCAMLFIND_PROTO_ML += dllxxx_caml.so
endif

OCAMLFIND_PROTO = $(OCAMLFIND_PROTO_BASE) $(OCAMLFIND_PROTO_ML)
OCAMLFIND_FILES = \
	$(patsubst %,apron/%, $(subst xxx,apron, $(OCAMLFIND_PROTO_BASE))) \
	$(patsubst %,mlapronidl/%, apron.cmi apron.cmx) \
	$(patsubst %,mlapronidl/%, $(subst xxx,apron, $(OCAMLFIND_PROTO_ML))) \
	$(patsubst %,box/%, box.mli box.cmi box.cmx) \
	$(patsubst %,box/%, $(subst xxx,boxD, $(OCAMLFIND_PROTO))) \
	$(patsubst %,box/%, $(subst xxx,boxMPQ, $(OCAMLFIND_PROTO))) \
	$(patsubst %,box/%, $(subst xxx,boxMPFR, $(OCAMLFIND_PROTO))) \
	$(patsubst %,octagons/%, oct.mli oct.cmi oct.cmx) \
	$(patsubst %,octagons/%, $(subst xxx,octD, $(OCAMLFIND_PROTO))) \
	$(patsubst %,octagons/%, $(subst xxx,octMPQ, $(OCAMLFIND_PROTO))) \
	$(patsubst %,newpolka/%, polka.mli polka.cmi polka.cmx) \
	$(patsubst %,newpolka/%, $(subst xxx,polkaMPQ, $(OCAMLFIND_PROTO))) \
	$(patsubst %,newpolka/%, $(subst xxx,polkaRll, $(OCAMLFIND_PROTO))) \
	$(patsubst %,taylor1plus/%, t1p.mli t1p.cmi t1p.cmx) \
	$(patsubst %,taylor1plus/%, $(subst xxx,t1pD, $(OCAMLFIND_PROTO))) \
	$(patsubst %,taylor1plus/%, $(subst xxx,t1pMPQ, $(OCAMLFIND_PROTO))) \
	$(patsubst %,taylor1plus/%, $(subst xxx,t1pMPFR, $(OCAMLFIND_PROTO))) \
	$(patsubst %,mlapronidl/%.idl, scalar interval coeff \
	  dim linexpr0 lincons0 generator0 texpr0 tcons0 manager abstract0 \
	  var environment linexpr1 lincons1 generator1 texpr1 tcons1 abstract1 policy \
	  disjunction) \
	mlapronidl/apron_caml.h

ifneq ($(HAS_PPL),)
OCAMLFIND_FILES += \
	$(patsubst %,ppl/%, ppl.idl ppl.mli ppl.cmi ppl.cma ppl.cmx ppl.cmxa ppl.a libap_ppl_caml.a libap_ppl_caml_debug.a dllap_ppl_caml.so) \
	$(patsubst %,products/%, polkaGrid.idl polkaGrid.mli polkaGrid.cmi polkaGrid.cmx) \
	$(patsubst %,products/%, $(subst xxx,polkaGrid, $(OCAMLFIND_PROTO)))
endif
ifneq ($(OCAMLPACK),)
OCAMLFIND_FILES += mlapronidl/apron_ocamldoc.mli
endif
ifneq ($(HAS_TYPEREX),)
OCAMLFIND_FILES += mlapronidl/apron.cmt \
	$(patsubst %,box/%, box.cmti box.cmt) \
	$(patsubst %,octagons/%, oct.cmti oct.cmt) \
	$(patsubst %,newpolka/%, polka.cmti polka.cmt) \
	$(patsubst %,taylor1plus/%, t1p.cmti t1p.cmt)
ifneq ($(HAS_PPL),)
OCAMLFIND_FILES += \
	$(patsubst %,ppl/%, ppl.cmti ppl.cmt) \
	$(patsubst %,products/%, polkaGrid.cmti polkaGrid.cmt)
endif
endif

install: mlapronidl/META all
	(cd num; $(MAKE) install)
	(cd itv; $(MAKE) install)
	(cd apron; $(MAKE) install)
	(cd newpolka; $(MAKE) install)
	(cd box; $(MAKE) install)
	(cd octagons; $(MAKE) install)
	(cd taylor1plus; $(MAKE) install)
ifneq ($(HAS_PPL),)
	(cd ppl; $(MAKE) install)
	(cd products; $(MAKE) install)
endif
ifneq ($(HAS_OCAML),)
ifeq ($(OCAMLFIND),)
	(cd mlapronidl; $(MAKE) install)
	$(INSTALLd) $(APRON_PREFIX)/bin
	if test -f aprontop; then $(INSTALL) aprontop $(APRON_PREFIX)/bin; fi
ifneq ($(HAS_PPL),)
	if test -f apronppltop; then $(INSTALL) apronppltop $(APRON_PREFIX)/bin; fi
endif
else
	-$(OCAMLFIND) remove apron
	$(OCAMLFIND) install apron mlapronidl/META $(OCAMLFIND_FILES) \
	  mlapronidl/apron.d.cmxa mlapronidl/apron.d.a \
	  newpolka/polkaMPQ.d.cmxa newpolka/polkaMPQ.d.a \
	  newpolka/polkaRll.d.cmxa newpolka/polkaRll.d.a \
	  $(OCAMLFIND_EXTRA)

install-findlib: mlapronidl/META all
	-$(OCAMLFIND) remove apron;
	$(OCAMLFIND) install apron mlapronidl/META $(OCAMLFIND_FILES)	\
	  mlapronidl/apron.d.cmxa mlapronidl/apron.d.a			\
	  newpolka/polkaMPQ.d.cmxa newpolka/polkaMPQ.d.a		\
	  newpolka/polkaRll.d.cmxa newpolka/polkaRll.d.a		\
	  $(OCAMLFIND_EXTRA)

mlapronidl/META: mlapronidl/META.in
	$(SED) -e "s!@VERSION@!$(VERSION_STR)!g;" $< > $@;

endif
endif
ifneq ($(HAS_CPP),)
	(cd apronxx; $(MAKE) install)
endif

clean:
	(cd num; $(MAKE) clean)
	(cd itv; $(MAKE) clean)
	(cd apron; $(MAKE) clean)
	(cd mlapronidl; $(MAKE) clean)
	(cd box; $(MAKE) clean)
	(cd newpolka; $(MAKE) clean)
	(cd octagons; $(MAKE) clean)
	(cd taylor1plus; $(MAKE) clean)
	(cd ppl; $(MAKE) clean)
	(cd products; $(MAKE) clean)
	(cd apronxx; $(MAKE) clean)
	(cd examples; $(MAKE) clean)
	(cd test; $(MAKE) clean)
	rm -fr online tmp apron*run aprontop apronppltop

distclean: clean
	rm -f mlapronidl/META
	(cd num; $(MAKE) uninstall)
	(cd itv; $(MAKE) uninstall)
	(cd apron; $(MAKE) uninstall)
	(cd mlapronidl; $(MAKE) distclean)
	(cd box; $(MAKE) distclean)
	(cd octagons; $(MAKE) distclean)
	(cd taylor1plus; $(MAKE) distclean)
	(cd newpolka; $(MAKE) distclean)
	(cd ppl; $(MAKE) distclean)
	(cd products; $(MAKE) distclean)
	(cd examples; $(MAKE) distclean)
	(cd apronxx; $(MAKE) distclean)

uninstall:
	(cd num; $(MAKE) uninstall)
	(cd itv; $(MAKE) uninstall)
	(cd apron; $(MAKE) uninstall)
	(cd mlapronidl; $(MAKE) uninstall)
	(cd box; $(MAKE) uninstall)
	(cd newpolka; $(MAKE) uninstall)
	(cd octagons; $(MAKE) uninstall)
	(cd taylor1plus; $(MAKE) uninstall)
	(cd examples; $(MAKE) uninstall)
	(cd ppl; $(MAKE) uninstall)
	(cd products; $(MAKE) uninstall)
	(cd apronxx; $(MAKE) uninstall)
	(cd $(APRON_PREFIX)/bin; rm -f apron*)
ifneq ($(OCAMLFIND),)
	$(OCAMLFIND) remove apron
endif

doc:
	(cd apron; $(MAKE) html apron.pdf)
ifneq ($(HAS_OCAML),)
	(cd mlapronidl; $(MAKE) html mlapronidl.pdf)
endif
ifneq ($(HAS_CPP),)
	(cd apronxx; $(MAKE) doc)
endif

# make distribution, update to reflect current version

PKG  = $(PKGNAME)-$(VERSION_STR)
PKGFILES = Makefile README README.windows README.mac AUTHORS COPYING Makefile.config.model Changes
PKGDIRS  = apron num itv octagons box newpolka taylor1plus ppl products mlapronidl examples test apronxx

dist:
	$(MAKE) all
	$(MAKE) doc
	mkdir -p $(PKG)
	$(MAKE) $(foreach pkg,$(PKGDIRS),pkg_$(pkg))
	cp $(PKGFILES) $(PKG)
	tar vczf $(PKG).tgz $(PKG)
	rm -rf $(PKG)

# these 2 targets are for main developpers only
index.html: index.tex
	hyperlatex index.tex
online: doc index.html
	rm -fr online
	mkdir -p online
	mv index.html poster.gif flyer.pdf online
	mv apron/html online/apron
	mv mlapronidl/html online/mlapronidl
	cp apron/apron.pdf online
	cp mlapronidl/mlapronidl.pdf online
	cp examples/example1.c online
	cp examples/mlexample?.ml online
	cp Changes online

pkg_%:
	(cd $*; $(MAKE) dist)
	(cd $(PKG); tar xzf ../$*.tgz)
	rm -rf $*.tgz

#-----------------------------------
# OPAM Packaging
#-----------------------------------

ifneq ($(OPAM_DEVEL_DIR),)

  OPAM_DIR = opam
  OPAM_FILES = descr opam files

  # XXX: force full cleanup when building opam distribution archive,
  # to avoid having to select all files manually.
  DIST_DEPS = distclean
  DIST_FILES = apron apronxx AUTHORS box Changes COPYING examples	\
    index.tex itv japron Makefile Makefile.config.* mlapronidl		\
    newpolka num octagons ppl products README* taylor1plus test		\
    ocamlpack configure

  -include $(OPAM_DEVEL_DIR)/opam-dist.mk

endif

# ---

.PHONY: force
force:
