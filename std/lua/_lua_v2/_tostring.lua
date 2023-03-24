_hx_utils.print_class = function(obj, depth)
  local first, result, _hx_tostring = true, '', _hx_utils.tostring
  for k, v in pairs(obj) do
    if _hx_hidden[k] == nil then
      if first then
        first = false
      else
        result = result .. ', '
      end
      if _hx_hidden[k] == nil then
        result = result .. k .. ':' .. _hx_tostring(v, depth + 1)
      end
    end
  end
  return '{ ' .. result .. ' }'
end

_hx_utils.print_enum = function(o, depth)
  if o.length == 2 then
    return o[0]
  else
    local str, _hx_tostring = o[0] .. "(", _hx_utils.tostring
    for i = 2, (o.length - 1) do
      if i ~= 2 then
        str = str .. "," .. _hx_tostring(o[i], depth + 1)
      else
        str = str .. _hx_tostring(o[i], depth + 1)
      end
    end
    return str .. ")"
  end
end

do
  local function _hx_tostring(obj, depth)
    depth = depth or 0
    if depth > 5 then
      return "<...>"
    end

    local tstr = _G.type(obj)
    if tstr == "string" then
      return obj
    elseif tstr == "nil" then
      return "null"
    elseif tstr == "number" then
      if obj == 0 then
        return "0"
      elseif obj == _G.math.POSITIVE_INFINITY then
        return "Infinity"
      elseif obj == _G.math.NEGATIVE_INFINITY then
        return "-Infinity"
      elseif obj ~= obj then
        return "NaN"
      else
        return _G.tostring(obj)
      end
    elseif tstr == "boolean" then
      return _G.tostring(obj)
    elseif tstr == "table" then
      if obj.__enum__ ~= nil then
        return _hx_utils.print_enum(obj, depth)
      elseif obj.toString ~= nil and not _hx_is_array(obj) then
        return obj:toString()
      elseif _hx_is_array(obj) then
        if obj.length > 5 then
          return "[...]"
        else
          local str = ""
          for i = 0, (obj.length - 1) do
            if i == 0 then
              str = str .. _hx_tostring(obj[i], depth + 1)
            else
              str = str .. "," .. _hx_tostring(obj[i], depth + 1)
            end
          end
          return "[" .. str .. "]"
        end
      elseif obj.__class__ ~= nil then
        return _hx_utils.print_class(obj, depth)
      else
        local buffer = {}
        local ref = obj
        if obj.__fields__ ~= nil then
          ref = obj.__fields__
        end
        for k, v in pairs(ref) do
          if _hx_hidden[k] == nil then
            _G.table.insert(buffer, _hx_tostring(k, depth + 1) .. ' : ' .. _hx_tostring(obj[k], depth + 1))
          end
        end

        return "{ " .. table.concat(buffer, ", ") .. " }"
      end
    elseif tstr == "userdata" then
      local mt = _G.getmetatable(obj)
      if mt ~= nil and mt.__tostring ~= nil then
        return _G.tostring(obj)
      else
        return "<userdata>"
      end
    elseif tstr == "function" then
      return "<function>"
    elseif tstr == "thread" then
      return "<thread>"
    else
      _G.error("Unknown Lua type", 0)
      return ""
    end
  end
  _hx_utils.tostring = _hx_tostring
end
