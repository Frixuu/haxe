_hx_utils.clamp = function(v)
  if v < -2147483648 then
    return -2147483648
  elseif v > 2147483647 then
    return 2147483647
  elseif v > 0 then
    return _G.math.floor(v)
  else
    return _G.math.ceil(v)
  end
end
