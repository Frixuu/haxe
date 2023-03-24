do
  local bitop = {}
  local bitop_impl

  local has_bit32, bit32 = pcall(require, 'bit32')
  if has_bit32 then
    bitop_impl = bit32
  else
    pcall(require, 'bit')
    bitop_impl = _G.bit
  end

  local clamp
  if bitop_impl then
    clamp = function(v)
      if v <= 2147483647 and v >= -2147483648 then
        if v > 0 then
          return _G.math.floor(v)
        else
          return _G.math.ceil(v)
        end
      end
      if v > 2251798999999999 then
        v = v * 2
      end
      if (v ~= v or math.abs(v) == _G.math.huge) then
        return nil
      end
      return bitop_impl.band(v, 2147483647) - math.abs(bitop_impl.band(v, 2147483648))
    end
  else
    clamp = _hx_utils.clamp
  end

  -- see https://github.com/HaxeFoundation/haxe/issues/8849
  bitop.bor = function(...) return clamp(bitop_impl.bor(...)) end;
  bitop.band = function(...) return clamp(bitop_impl.band(...)) end;
  bitop.arshift = function(...) return clamp(bitop_impl.arshift(...)) end;

  if has_bit32 then
    -- Lua 5.2 weirdness
    bitop.bnot = function(...) return clamp(bitop_impl.bnot(...)) end;
    bitop.bxor = function(...) return clamp(bitop_impl.bxor(...)) end;
  end

  _hx_utils.bitop = setmetatable(bitop, { __index = bitop_impl })
  _hx_utils.bitop_impl = bitop_impl
  _hx_utils.clamp = clamp
end
