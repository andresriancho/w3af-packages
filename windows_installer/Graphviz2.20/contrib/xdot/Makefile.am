## Process this file with automake to produce Makefile.in

pdfdir = $(pkgdatadir)/doc/pdf
pkgconfigdir = $(libdir)/pkgconfig

AM_CPPFLAGS = -I$(top_srcdir)/contrib/xdot

noinst_HEADERS = xdot.h
noinst_LTLIBRARIES = libxdot_C.la libxdot.la
#pkgconfig_DATA = libxdot.pc
#man_MANS = xdot.3
#pdf_DATA = xdot.pdf

libxdot_C_la_SOURCES = xdot.c
libxdot_la_SOURCES = $(libxdot_C_la_SOURCES)

.3.pdf:
	-groff -Tps -man $< | ps2pdf - - >$@

EXTRA_DIST = $(man_MANS) $(pdf_DATA) Makefile.old

DISTCLEANFILES = $(pdf_DATA)
