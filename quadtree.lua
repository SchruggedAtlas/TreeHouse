require 'class'
require 'point'
require 'boundary'

QuadTree = class(
  function(a, name)
    a.name = name
  end
)

function QuadTree:init(boundary)
  self.node_capacity = 4
  self.boundary = boundary
  self.points = {}
  self.ne = nil
  self.nw = nil
  self.se = nil
  self.sw = nil
end
-- TODO: Test insert
function QuadTree:insert(apoint)
  -- Ignore objects that do not belong in this quad tree
  if(not(self.boundary:contains_point(apoint))) then
    return false
  end
  -- If there is space in this quad tree and if doesn't have subdivisions, add
  -- the object here
  if(#self.points < self.node_capacity and (self.ne == nil)) then
    table.insert(self.points,apoint)
    return true
  end
  -- Otherwise, subdivide and then add the point to whichever node will accept it
  if(self.nw == nil) then
    self:subdivide()
  end
  -- Realize the insertion
  if(self.nw:insert(apoint)) then
    return true
  end
  if(self.ne:insert(apoint)) then
    return true
  end
  if(self.sw:insert(apoint)) then
    return true
  end
  if(self.se:insert(apoint)) then
    return true
  end
  -- Otherwise, the point cannot be inserted for some unknown reason (this should never happen)
  return false
end

function QuadTree:catenate_table(t1,t2)
  for k,v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

function QuadTree:spawn_child(new_width,new_height,new_x,new_y)
  local new_center
  local new_boundary
  local new_child
  new_center = Point()
  new_center:init(new_x,new_y)
  new_boundary = Boundary()
  new_boundary:init(new_center,new_width,new_height)
  new_child = QuadTree()
  new_child:init(new_boundary)
  return new_child
end

function QuadTree:subdivide()
  local new_width
  local new_height
  local new_x
  local new_y

  new_width = self.boundary.half_width
  new_height = self.boundary.half_height
  -- Create northeast child
  new_x = self.boundary.center.x + new_width/2
  new_y = self.boundary.center.y - new_height/2
  self.ne = self:spawn_child(new_width,new_height,new_x,new_y)
  -- Create southeast child
  new_x = self.boundary.center.x + new_width/2
  new_y = self.boundary.center.y + new_height/2
  self.se = self:spawn_child(new_width,new_height,new_x,new_y)
  -- Create northwest child
  new_x = self.boundary.center.x - new_width/2
  new_y = self.boundary.center.y - new_height/2
  self.nw = self:spawn_child(new_width,new_height,new_x,new_y)
  -- Create southwest child
  new_x = self.boundary.center.x - new_width/2
  new_y = self.boundary.center.y + new_height/2
  self.sw = self:spawn_child(new_width,new_height,new_x,new_y)
end

function QuadTree:query(boundary)
  -- Prepare a table of results
  local points_in_range = {}
  -- Automatically abort if the range does not intersect this quad
  if(not(self.boundary:intersects(boundary))) then
    return points_in_range
  end
  -- Check objects at this quad level
  for index, p in ipairs(self.points) do
    if(boundary:contains_point(p)) then
      table.insert(points_in_range,p)
    end
  end
  -- Terminate here, if there are no children
  if(self.nw == nil) then
    return points_in_range
  end
  -- Otherwise, add points from the children
  points_in_range = self:catenate_table(points_in_range,self.nw:query(boundary))
  points_in_range = self:catenate_table(points_in_range,self.ne:query(boundary))
  points_in_range = self:catenate_table(points_in_range,self.sw:query(boundary))
  points_in_range = self:catenate_table(points_in_range,self.se:query(boundary))

  return points_in_range
end
