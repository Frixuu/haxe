_hx.error = function(obj)
  if obj.value then
    _G.print("runtime error:\n " .. _hx_utils.tostring(obj.value));
  else
    _G.print("runtime error:\n " .. tostring(obj));
  end

  if _G.debug and _G.debug.traceback then
    _G.print(debug.traceback());
  end
end
