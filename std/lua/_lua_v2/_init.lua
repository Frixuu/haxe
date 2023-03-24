-- Create a new runtime or reuse an existing, exposed one
local _hx = _G._hx or {
  classes = {},
  classes_by_name = {},
  reflect = {},
  utils = {}
}

-- Store categories as locals for faster lookup
local _hx_classes = _hx.classes
local _hx_classes_by_name = _hx.classes_by_name
local _hx_reflect = _hx.reflect
local _hx_utils = _hx.utils

-- Special fields that must be ignored when reflecting properties/printing objects to a string
local _hx_hidden = {
  __class__ = true,
  __id__ = true,
  __fields__ = true,
  __ifields__ = true,
  __name__ = true,
  __properties__ = true,
  hx__closures = true,
  super = true,
  prototype = true,
}
