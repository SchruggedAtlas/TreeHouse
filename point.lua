require "class"

Point = class(
  function(a, name)
    a.name = name
  end
)

function Point:init(x,y)
  self.x = x
  self.y = y
end

function Point:update(x,y)
  self.x = x
  self.y = y
end
