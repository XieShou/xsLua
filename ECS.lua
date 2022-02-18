local core = require "ecs.core"

local ecs = {}

local entities = {}	-- all Entities, eid -> entity
local entity_id = 0
ecs.entities = entities

-- cset: component set
local cset = { __mode = "kv" }

-- cctypes: C component type
local cctypes  = {}

-- ctype: component type
local ctypes = { _typeid = 0 }
setmetatable(ctypes, ctypes)

function ctypes:__index(newtype)
    local typeid = self._typeid + 1
    assert(typeid < 0xffff)
    self._typeid = typeid
    self[newtype] = typeid
    self[typeid] = newtype
    return typeid
end

function ecs.register_type(newtype)
    local ctype = assert(newtype.typename)
    local cnew = assert(newtype.new)
    local cdel = assert(newtype.del)

    assert(rawget(ctypes, ctype) == nil, "Register ctype first")
    local typeid = ctypes[ctype]
    assert(cctypes[typeid] == nil, "Already register ctype")
    cctypes[typeid] = { new = cnew, del = cdel }
end

-- etype: entity type
local etypes = { __mode = "kv" }
setmetatable(etypes, etypes)

function etypes:__index(typekey)
    local info = {}
    local n = #typekey
    for i = 1, n, 2 do
        local typeid = string.unpack("H",typekey,i)
        local c = cctypes[typeid]
        if c then
            info[ctypes[typeid]] = c.del
        else
            info[ctypes[typeid]] = false
        end
    end
    self[typekey] = info
    return info
end

function ecs.new_entity()
    local e = { _type = "" }
    entity_id = entity_id + 1
    entities[entity_id] = e
    return entity_id
end

function ecs.delete_entity(eid)
    local e = assert(entities[eid])
    local typeinfo = etypes[e._type]
    for typename, del in pairs(typeinfo) do
        if del then
            del(e[typename])
            e[typename] = nil
        end
    end

    entities[eid] = nil
end

function ecs.new_component(eid, ctype)
    local e = assert(entities[eid])
    local typeid = ctypes[ctype]
    e._type = core.add_component(e._type, typeid)
    local set = cset[ctype]
    if set then
        set[#set + 1] = eid
    end
    local c = cctypes[typeid]
    if c then
        local obj = c.new(eid)
        e[ctype] = obj
        return obj
    else
        return e
    end
end

function ecs.component(eid, ctype)
    local e = assert(entities[eid])
    local typeinfo = etypes[e._type]
    local c = typeinfo[ctype]
    if c ~= nil then
        if c then
            return e[ctype]
        else
            return e
        end
    end
end

function ecs.set(ctype)
    local s = cset[ctype]
    if s == nil then
        s = {}
        for eid, e in pairs(entities) do
            local typeinfo = etypes[e._type]
            local c = typeinfo[ctype]
            if c ~= nil then
                s[#s+1] = eid
            end
        end
        cset[ctype] = s
    end
    return s
end

-- Lua Version

--local function component_next(set, index)
--	local n = #set
--	index = index + 1
--	while index <= n do
--		local eid = set[index]
--		local e = entities[eid]
--		if e then
--			return index, e
--		end
--		set[index] = set[n]
--		set[n] = nil
--		n = n - 1
--	end
--end

-- C Version
local component_next = core.component_next(entities)

function ecs.ipairs(ctype)
    return component_next, ecs.set(ctype), 0
end

-- Iterator
function ecs.components(eid)
    local e = assert(entities[eid])
    return next, etypes[e._type], nil
end

return ecs

--[[
#define LUA_LIB

#include <lua.h>
#include <lauxlib.h>
#include <stdint.h>

static int
ladd_component(lua_State *L) {
	size_t sz;
	const uint16_t *t = (const uint16_t *)luaL_checklstring(L, 1, &sz);
	uint16_t typeid = (uint16_t)luaL_checkinteger(L, 2);
	luaL_Buffer b;
	uint16_t * buff = (uint16_t *)luaL_buffinitsize(L, &b, sz+2);
	int i;
	int n = (int)sz / 2;
	for (i=0;i<n;i++) {
		if (typeid < t[i])
			break;
		if (typeid == t[i]) {
			return luaL_error(L, "Duplicate component %d", typeid);
		}
		buff[i] = t[i];
	}
	buff[i] = typeid;
	for (;i<n;i++) {
		buff[i+1] = t[i];
	}
	luaL_addsize(&b, sz+2);
	luaL_pushresult(&b);
	return 1;
}

static int
lnext(lua_State *L) {
	int n = lua_rawlen(L, 1);
	int index = luaL_checkinteger(L, 2) + 1;
	while (index <= n) {
		lua_rawgeti(L, 1, index);
		int eid = lua_tointeger(L, -1);
		if (lua_rawgeti(L, lua_upvalueindex(1), eid) == LUA_TTABLE) {
			lua_pushinteger(L, index);
			lua_replace(L, -3);
			return 2;
		} else {
			lua_pop(L, 2);
			lua_rawgeti(L, 1, n);
			lua_rawseti(L, 1, index);
			lua_pushnil(L);
			lua_rawseti(L, 1, n);
			--n;
		}
	}
	return 0;
}

static int
lcomponent_next(lua_State *L) {
	luaL_checktype(L, 1, LUA_TTABLE);
	lua_pushcclosure(L, lnext, 1);
	return 1;
}

LUAMOD_API int
luaopen_ecs_core(lua_State *L) {
	luaL_checkversion(L);
	luaL_Reg l[] = {
		{ "add_component", ladd_component },
		{ "component_next", lcomponent_next },
		{ NULL, NULL },
	};
	luaL_newlib(L, l);
	return 1;
}
]]