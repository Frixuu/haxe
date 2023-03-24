do
  local array_mt = {
    __newindex = function(t, k, v)
      local len = t.length
      t.length = k >= len and (k + 1) or len
      rawset(t, k, v)
    end
  }
  _hx_utils.array_mt = array_mt

  _hx_utils.is_array = function(o)
    return type(o) == "table" and getmetatable(o) == array_mt and o.__enum__ == nil
  end

  local array_from_table = function(tab, length)
    tab.length = length
    return setmetatable(tab, array_mt)
  end
  _hx_utils.array_from_table = array_from_table

  local fields = _hx_reflect.fields
  _hx_reflect.get_fields_as_array = function(obj)
    local result, i = {}, 0
    local fields_info = fields[obj]
    if fields_info ~= nil then
      obj = fields_info
    end
    for k, _ in pairs(obj) do
      if _hx_hidden[k] == nil then
        result[i] = k
        i = i + 1
      end
    end
    return array_from_table(result, i)
  end
end

local _hx_is_array = _hx_utils.is_array
local _hx_tab_array = _hx_utils.array_from_table
local _hx_field_arr = _hx_reflect.get_fields_as_array
