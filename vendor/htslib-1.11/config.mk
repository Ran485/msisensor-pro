#  Optional configure Makefile overrides for htslib.
#
#    Copyright (C) 2015-2017, 2019 Genome Research Ltd.
#
#    Author: John Marshall <jm18@sanger.ac.uk>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

# This is config.mk.  Generated from config.mk.in by configure.
#
# If you use configure, this file overrides variables and augments rules
# in the Makefile to reflect your configuration choices.  If you don't run
# configure, the main Makefile contains suitable conservative defaults.

prefix       = /usr/local
exec_prefix  = ${prefix}
bindir       = ${exec_prefix}/bin
includedir   = ${prefix}/include
libdir       = ${exec_prefix}/lib
libexecdir   = ${exec_prefix}/libexec
datarootdir  = ${prefix}/share
mandir       = ${datarootdir}/man

CC     = /home/pengjia/miniconda3/bin/x86_64-conda_cos6-linux-gnu-cc
RANLIB = /home/pengjia/miniconda3/bin/x86_64-conda_cos6-linux-gnu-ranlib

CPPFLAGS = -DNDEBUG -D_FORTIFY_SOURCE=2 -O2 -isystem /home/pengjia/miniconda3/include
CFLAGS   =  -Wall -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -isystem /home/pengjia/miniconda3/include -fvisibility=hidden
LDFLAGS  = -Wl,-O2 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,--disable-new-dtags -Wl,--gc-sections -Wl,-rpath,/home/pengjia/miniconda3/lib -Wl,-rpath-link,/home/pengjia/miniconda3/lib -L/home/pengjia/miniconda3/lib -fvisibility=hidden
LIBS     = -ldeflate -llzma -lbz2 -lz -lm 

PLATFORM   = default
PLUGIN_EXT = .so

# The default Makefile enables some of the optional files, but we blank
# them so they can be controlled by configure instead.
NONCONFIGURE_OBJS =

# Lowercase here indicates these are "local" to config.mk
plugin_OBJS =
noplugin_LDFLAGS =
noplugin_LIBS =

# ifeq/.../endif, +=, and target-specific variables are GNU Make-specific.
# If you don't have GNU Make, comment out this conditional and note that
# to enable libcurl you will need to implement the following elsewhere.
ifeq "libcurl-enabled" "libcurl-enabled"

LIBCURL_LIBS = -lcurl

plugin_OBJS += hfile_libcurl.o

hfile_libcurl$(PLUGIN_EXT): LIBS += $(LIBCURL_LIBS)

noplugin_LIBS += $(LIBCURL_LIBS)

endif

ifeq "gcs-enabled" "gcs-enabled"
plugin_OBJS += hfile_gcs.o
endif

ifeq "s3-enabled" "s3-enabled"
plugin_OBJS += hfile_s3.o
plugin_OBJS += hfile_s3_write.o

CRYPTO_LIBS = -lcrypto
noplugin_LIBS += $(CRYPTO_LIBS)
hfile_s3$(PLUGIN_EXT): LIBS += $(CRYPTO_LIBS)
hfile_s3_write$(PLUGIN_EXT): LIBS += $(CRYPTO_LIBS) $(LIBCURL_LIBS)
endif

ifeq "plugins-no" "plugins-yes"

plugindir  = $(libexecdir)/htslib
pluginpath = $(libexecdir)/htslib

LIBHTS_OBJS += plugin.o
PLUGIN_OBJS += $(plugin_OBJS)

plugin.o plugin.pico: CPPFLAGS += -DPLUGINPATH=\"$(pluginpath)\"

# When built as separate plugins, these record their version themselves.
hfile_gcs.o hfile_gcs.pico: version.h
hfile_libcurl.o hfile_libcurl.pico: version.h
hfile_s3.o hfile_s3.pico: version.h
hfile_s3_write.o hfile_s3_write.pico: version.h

# Windows DLL plugins depend on the import library, built as a byproduct.
$(plugin_OBJS:.o=.cygdll): cyghts-$(LIBHTS_SOVERSION).dll

else

LIBHTS_OBJS += $(plugin_OBJS)
LDFLAGS += $(noplugin_LDFLAGS)
LIBS += $(noplugin_LIBS)

endif
