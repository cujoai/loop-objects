-- Project: LOOP - Lua Object-Oriented Programming
-- Release: 3.0 beta
-- Title  : General Instrospection Operations for LOOP Classes and Objects
-- Author : Renato Maia <maia@inf.puc-rio.br>

local _G = require "_G"
local pairs = _G.pairs
local getmetatable = _G.getmetatable

module "loop"

local function dummy() end

local function isingle(single, index)
	if single and not index then
		return 1, single
	end
end

local ClassOps = {
	new = false,
	rawnew = false,
	getmember = false,
	members = false,
	getsuper = dummy,
	supers = function(class)
		return isingle, getsuper(class)
	end,
}

for name, default in pairs(ClassOps) do
	_M[name] = function(class, ...)
		local meta = getmetatable(class)
		local method = meta and meta[name]
		if method == nil and default then
			method = default
		end
		return method(class, ...)
	end
end

function getclass(object)
	local class = getmetatable(object)
	if ClassOf then class = ClassOf[class] or class end
	return class
end

function issubclassof(class, super)
	if class == super then return true end
	for _, base in supers(class) do
		if issubclassof(base, super) then
			return true
		end
	end
	return false
end

function isinstanceof(object, class)
	return issubclassof(getclass(object), class)
end