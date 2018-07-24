# Variables to override
#
# CC            C compiler
# CROSSCOMPILE	crosscompiler prefix, if any
# CFLAGS	compiler flags for compiling all C files
# LDFLAGS	linker flags for linking all binaries
# SUDO_ASKPASS  path to ssh-askpass when modifying ownership of wpa_ex
# SUDO          path to SUDO. If you don't want the privileged parts to run, set to "true"

# Check that we're on a supported build platform
ifeq ($(CROSSCOMPILE),)
    # Not crosscompiling, so check that we're on Linux.
    ifneq ($(shell uname -s),Linux)
        $(warning nerves_wpa_supplicant only works on Linux, but crosscompilation)
        $(warning is supported by defining $$CROSSCOMPILE.)
        $(warning See Makefile for details. If using Nerves,)
        $(warning this should be done automatically.)
        $(warning .)
        $(warning Skipping C compilation unless targets explicitly passed to make.)
	DEFAULT_TARGETS = priv
    endif
endif
DEFAULT_TARGETS ?= priv priv/wpa_ex

WPA_DEFINES = -DCONFIG_CTRL_IFACE -DCONFIG_CTRL_IFACE_UNIX

LDFLAGS += -lrt
CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter
CC ?= $(CROSSCOMPILE)-gcc

# If not cross-compiling, then run sudo by default
ifeq ($(origin CROSSCOMPILE), undefined)
SUDO_ASKPASS ?= /usr/bin/ssh-askpass
SUDO ?= sudo
else
# If cross-compiling, then permissions need to be set some build system-dependent way
SUDO ?= true
endif

.PHONY: all clean

all: $(DEFAULT_TARGETS)

%.o: %.c
	$(CC) -c $(WPA_DEFINES) $(CFLAGS) -o $@ $<

priv:
	mkdir -p priv

priv/wpa_ex: src/wpa_ex.o src/wpa_ctrl/os_unix.o src/wpa_ctrl/wpa_ctrl.o
	$(CC) $^ $(LDFLAGS) -o $@
	# setuid root wpa_ex so that it can interact with the wpa_supplicant
	SUDO_ASKPASS=$(SUDO_ASKPASS) $(SUDO) -- sh -c 'chown root:root $@; chmod +s $@'

clean:
	rm -f priv/wpa_ex src/*.o src/wpa_ctrl/*.o
