require 'point'
require 'boundary'
require 'quadtree'

function love.load()
  love.window.setMode(0,0, {vsync=true})
  love.window.setFullscreen(true, "desktop")
  screen_w = love.graphics.getWidth()
  screen_h = love.graphics.getHeight()
  points = {}
  point_x = 0
  point_y = 0
  total_time = 0
  treehouse = get_quadtree(screen_w/2,screen_h/2,screen_w,screen_h)
  print(tostring(screen_w)..":"..tostring(screen_h))
  --test_boundary()
  --test_quadtree()
end

function test_boundary()
  local p = Point()
  local b = Boundary()
  local p_in = Point()
  local b_in = Boundary()
  local p_out = Point()
  local b_out = Boundary()
  p:init(screen_w/2,screen_h/2)
  b:init(p,screen_w,screen_h)
  p_in:init(30,30)
  b_in:init(p_in,5,5)
  p_out:init(1000,1000)
  b_out:init(p_out,5,5)
  print(b:intersects(b_in))
  print(b_in:intersects(b))
  print(b:intersects(b_out))
  print(b_out:intersects(b))
  print(b:contains_point(p_in))
  print(b:contains_point(p_out))
end

function test_quadtree()
  local p = Point()
  local b = Boundary()
  local q = QuadTree()
  p:init(screen_w/2,screen_h/2)
  b:init(p,screen_w,screen_h)
  q:init(b)
  for i=10,50,10 do
    local pt = Point()
    pt:init(i,i)
    q:insert(pt)
  end
  pir = q:query(b)
  print("Points in range: "..tostring(#pir))
  print("Points in q: "..tostring(#q.points))
  local p_small = Point()
  p_small:init(20,20)
  local b_small = Boundary()
  b_small:init(p_small,15,15)
  pir = q:query(b_small)
  print("Points in range: "..tostring(#pir))
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  end
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
      point_x = x
      point_y = y
      add_point(x,y)
   end
end

function love.update(dt)
  total_time = total_time + dt
end

function get_point(x,y)
  local pt = Point()
  pt:init(x,y)
  return pt
end

function get_boundary(p,w,h)
  local b = Boundary()
  b:init(p,w,h)
  return b
end

function get_quadtree(x,y,w,h)
  local pt = get_point(x,y)
  local b = get_boundary(pt,w,h)
  local q = QuadTree()
  q:init(b)
  return q
end

function add_point(x,y)
  p = get_point(x,y)
  table.insert(points,p)
  treehouse:insert(p)
end

function draw_points()
  love.graphics.setColor(1, 0.47, 0, 1)
  for _,pt in ipairs(points) do
    love.graphics.circle("fill", pt.x, pt.y, 3, 50)
  end
end

function love.draw()
  draw_points()
  treehouse:draw()
end
