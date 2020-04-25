require 'class'
require 'point'

Boundary = class(
  function(a, name)
    a.name = name
  end
)

function Boundary:init(center,width,height)
  self.half_width = width/2
  self.half_height = height/2
  self.center = center
  self.min_x = self.center.x - self.half_width
  self.max_x = self.center.x + self.half_width
  self.min_y = self.center.y - self.half_height
  self.max_y = self.center.y + self.half_height
end

function Boundary:contains_point(apoint)
  if apoint.x > self.min_x and
     apoint.x < self.max_x and
     apoint.y > self.min_y and
     apoint.y < self.max_y then
       return true
  else
    return false
  end
end

function Boundary:intersects(aboundary)
  if(self.min_x >= aboundary.max_x or aboundary.min_x >= self.max_x) then
    return false
  end
  if(self.max_y <= aboundary.min_y or aboundary.max_y <= self.min_y) then
    return false
  end
  return true
end
