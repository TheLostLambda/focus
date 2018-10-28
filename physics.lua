local base = _G

module("physics")

local function boundingPoints(obj)
   points = {}
   points[1] = {obj.x, obj.y}
   points[2] = {obj.x + obj.w, obj.y + obj.h}
   points[3] = {obj.x, obj.y + obj.h}
   points[4] = {obj.x + obj.w, obj.y}
   return points
end

local function between(p, p1, p2)
   return p1[1] <= p[1] and p[1] <= p2[1] and p1[2] <= p[2] and p[2] <= p2[2]
end

local function inside(p, obj)
   bounds = boundingPoints(obj)
   return between(p, bounds[1], bounds[2])
end

-- 1 : Bottom left
-- 2 : Top Right
-- 3 : Top Left
-- 4 : Bottom Right
function collisions(obj, w)
   rektdBy = {}
   box = boundingPoints(obj)
   for i, obstacle in base.ipairs(w) do
      for j = 1, #box do
	 if inside(box[j], obstacle) then
	    rektdBy[#rektdBy+1] = {j, obstacle}
	    break
	 end
      end
   end
   return rektdBy
end
