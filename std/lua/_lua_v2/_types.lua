do
  -- Store object fields in a separate weak table, not along with the object like v1
  local fields = _hx_reflect.fields or setmetatable({}, { __mode = "k" })
  _hx_reflect.fields = fields

  local obj_newindex = function(t, k, v)
    fields[t][k] = true
    rawset(t, k, v)
  end

  local _hx_tostring = _hx_utils.tostring
  local obj_mt = _hx_reflect.obj_mt or {
    __newindex = obj_newindex,
    __tostring = _hx_tostring
  }
  _hx_reflect.obj_mt = obj_mt

  local existing_into_obj = function(o)
    fields[o] = o.__fields__ or {}
    o.__fields__ = nil
    return setmetatable(o, obj_mt)
  end

  local existing_with_fields_into_obj = function(o, f)
    fields[o] = f
    return setmetatable(o, obj_mt)
  end

  local new_obj = function()
    local o = {}
    fields[o] = {}
    return setmetatable(o, obj_mt)
  end

  local new_from_prototype = function(prototype)
    local o = {}
    fields[o] = {}
    return setmetatable(o, {
      __index = prototype,
      __newindex = obj_newindex,
      __tostring = _hx_tostring
    })
  end

  _hx_reflect.existing_into_obj = existing_into_obj
  _hx_reflect.existing_with_fields_into_obj = existing_with_fields_into_obj
  _hx_reflect.new_obj = new_obj
  _hx_reflect.new_from_prototype = new_from_prototype
end

local _hx_e = _hx_reflect.new_obj
local _hx_o = _hx_reflect.existing_into_obj
local _hx_o2 = _hx_reflect.existing_with_fields_into_obj
local _hx_new = _hx_reflect.new_from_prototype

local Int = _hx_e();
local Dynamic = _hx_e();
local Float = _hx_e();
local Bool = _hx_e();
local Class = _hx_e();
local Enum = _hx_e();
