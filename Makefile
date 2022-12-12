
LUA=lua/lua
LUA_INCLUDE=lua
LIBLUA=lua/liblua.a
LIBSQLITE3=sqlite-amalgamation-3400000/libsqlite3.a
LIBLSQLITE3=lsqlite3/liblsqlite3.a

LUASTATIC = luastatic/luastatic

ifeq ($(OS),Windows_NT)
	EXE=.exe
	LUA_CFLAGS_EXTRA=
else
	EXE=
	LUA_CFLAGS_EXTRA=-DLUA_USE_LINUX
endif

LUA_CFLAGS="-Wall -Os -std=c99 -fno-stack-protector -fno-common -march=native $(LUA_CFLAGS_EXTRA)"

test-sqlite3$(EXE): test-sqlite3.lua $(LUASTATIC) $(LIBLUA) $(LIBLSQLITE3) $(LIBSQLITE3)
	$(LUASTATIC) $< $(LIBLUA) $(LIBLSQLITE3) $(LIBSQLITE3) -I $(LUA_INCLUDE) 

$(LUA):
	$(MAKE) CFLAGS=$(LUA_CFLAGS) MYLDFLAGS= MYLIBS= lua -C $(@D)

$(LIBLUA):
	$(MAKE) CFLAGS=$(LUA_CFLAGS) $(@F)  -C $(@D)

$(LIBLSQLITE3):
	cp Makefile.lsqlite3.static $(@D)/Makefile.static
	$(MAKE) -f Makefile.static $(@F) -C $(@D)

$(LIBSQLITE3):
	$(MAKE) $(@F) -C $(@D)

$(LUASTATIC): $(LUA) $(LIBLUA)
	$(MAKE) LUA=$(PWD)/$(LUA) LIBLUA_A=$(PWD)/$(LIBLUA) LUA_INCLUDE=$(PWD)/$(LUA_INCLUDE) luastatic -C $(@D)

.PHONY: clean

clean:
	@$(MAKE) clean -C $(dir $(LIBLUA))
	@$(MAKE) clean -C $(dir $(LUASTATIC))
	@$(MAKE) clean -C $(dir $(LIBSQLITE3))
	@$(RM) $(LIBSQLITE3)
	@$(MAKE) -f Makefile.static clean -C $(dir $(LIBLSQLITE3))
	@$(RM) test-sqlite3$(EXE) test-sqlite3.luastatic.exe

