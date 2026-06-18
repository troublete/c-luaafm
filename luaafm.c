#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdlib.h>
#include "afm.h"

int afmsession(lua_State *L) {
	const char* system = lua_tostring(L, 1);
	if (system == NULL) {
		system = "";
	}
	void* s = session(system);
	lua_pushlightuserdata(L, s);
	return 1;
}

int afminference(lua_State *L) {
	void* sess = lua_touserdata(L, 1);
	const char* prompt = luaL_checkstring(L, 2);
	const char* result = inference(sess, prompt);
	lua_pushstring(L, result);
	return 1;
}

int afmclosesession(lua_State *L) {
	void* sess = lua_touserdata(L, 1);
	close_session(sess);
	return 0;
}

int luaopen_luaafm(lua_State *L) {
	lua_pushcfunction(L, afmsession);
	lua_setglobal(L, "session");

	lua_pushcfunction(L, afmclosesession);
	lua_setglobal(L, "close_session");

	lua_pushcfunction(L, afminference);
	lua_setglobal(L, "inference");
	return 0;
}
