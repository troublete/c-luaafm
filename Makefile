clean:
	rm -rf lua

.PHONY: fetch-lua
fetch-lua:
	curl -R -O https://www.lua.org/ftp/lua-5.5.0.tar.gz
	tar zxf lua-5.5.0.tar.gz && mv lua-5.5.0 lua
	cd lua && make && make local

.PHONY: swift-lib	
swift-lib:
	swiftc afm.swift\
		-emit-library \
		-static \
		-emit-objc-header \
		-emit-objc-header-path afm.h \
		-cxx-interoperability-mode=default \
		-o afm.a

.PHONY: build
build:
	gcc -shared -fPIC -O2 \
    -o luaafm.so \
    luaafm.c \
    afm.a \
    -I/lua/install/include \
    -undefined dynamic_lookup \
    -framework Foundation \
    -framework FoundationModels \
    -L/usr/lib/swift \
    -lswiftCore

all: clean fetch-lua swift-lib build