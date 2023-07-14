# CHANGE ME :-)
# where IDA_DIR must be the full path to ida.app (not ida64.app)
# IDA 7.6 example: /Applications/IDA Pro 7.6/ida.app/
IDA_DIR="/Applications/IDA Pro 7.7/ida.app/"
# path to IDA SDK folder
IDA_SDK="/Applications/IDA Pro 7.7/idasdk77"
# path to plugins folder
INSTALL_DIR="/Users/changeme/.idapro/plugins"

NAME="GiveMeHex"

CC=g++
LD=ld
LDFLAGS=-shared -m64

LIBDIR=-L$(IDA_DIR)/Contents/MacOS
SRCDIR=./
HEXRAYS_SDK=$(IDA_DIR)/Contents/MacOS/plugins/hexrays_sdk
INCLUDES=-I$(IDA_SDK)/include -I$(HEXRAYS_SDK)/include
__X64__=1

SRC=$(SRCDIR)main.cpp
	
OBJS=$(subst .cpp,.o,$(SRC))

CFLAGS=-m64 -fPIC -D__MAC__ -D__PLUGIN__ -std=c++14 -D__X64__ -D_GLIBCXX_USE_CXX11_ABI=0 -Wno-logical-op-parentheses -Wno-nullability-completeness
LIBS=-lc -lpthread -ldl
EXT=dylib

CFLAGS+=-D__EA64__
LIBS+=-lida64
SUFFIX=64

all: check-env $(NAME)$(SUFFIX).$(EXT)

$(NAME)$(SUFFIX).$(EXT): $(OBJS)
	$(CC) $(LDFLAGS) $(LIBDIR) -o $(NAME)$(SUFFIX).$(EXT) $(OBJS) $(LIBS)

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f $(OBJS) $(NAME)$(SUFFIX).$(EXT)

install: $(NAME)$(SUFFIX).$(EXT)
	cp -f $(NAME)$(SUFFIX).$(EXT) $(INSTALL_DIR)

check-env:
ifndef IDA_SDK
	$(error IDA_SDK is undefined)
endif
ifndef IDA_DIR
	$(error IDA_DIR is undefined)
endif
.PHONY: check-env $(NAME)$(SUFFIX).$(EXT)
