--[[
This a little program to test my A* algorithm for LUA
Made by Altair
21 septembre 2006
--]]

dofile("A-star algorithm release.lua")

wit=Color.new(255,255,255)
rood=Color.new(255,0,0)
groen=Color.new(0,255,0)
grijs=Color.new(100,100,100)
blauw=Color.new(0,0,255)

x=100
y=100
player={x=0, y=0, xmove=0, ymove=0, speed=5, path={}, cur=1, pathLength=0, move=false}
orderMove=false
deler=16
xInterval=50
yInterval=50

Player=Image.createEmpty(xInterval-1, yInterval-1)
Player:clear(groen)

map=	{
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,1,0,0,0,0},
	{0,0,0,0,1,0,0,0,0},
	{0,0,0,0,1,0,0,0,0},
	{0,0,0,0,0,0,0,0,0}
	}
	
function drawGrid(map,xInterval,yInterval,color)
         local w=table.getn(map[1])
         local h=table.getn(map)
         for n=1,w do
             if n*xInterval<480 then
                screen:drawLine(n*xInterval,0,n*xInterval,h*yInterval,color)
             end
         end
         for n=1,h do
             if n*yInterval<272 then
                screen:drawLine(0,n*yInterval,w*xInterval,n*yInterval,color)
             end
         end
end

function drawBlock(map,xInterval,yInterval,color)
         local w=table.getn(map[1])
         local h=table.getn(map)
         for n=1,w do
             for i=1,h do
             	 if map[i][n]==1 then
             	    screen:fillRect((n-1)*xInterval+1, (i-1)*yInterval+1, xInterval-1, yInterval-1, color)
	     	 end
	     end
	 end
end

while true do

  screen:clear()

  drawGrid(map,xInterval,yInterval,grijs)
  drawBlock(map,xInterval,yInterval,blauw)

  screen:blit(player.x+1,player.y+1,Player)
  screen:drawLine(x-5, y, x+5, y, wit)
  screen:drawLine(x, y-5, x, y+5, wit)

  pad = Controls.read()

  dx = pad:analogX()
  if math.abs(dx) > 32 then
    x = x + dx / deler
  end

  dy = pad:analogY()
  if math.abs(dy) > 32 then
    y = y + dy / deler
  end

  if x<0 then
    x=0
  end

  if y<0 then
    y=0
  end

  if x>=table.getn(map[1])*xInterval then
    x=table.getn(map[1])*xInterval-1
  end

  if y>=table.getn(map)*yInterval then
    y=table.getn(map)*yInterval-1
  end

  local mapx=math.floor(x/xInterval)+1
  local mapy=math.floor(y/yInterval)+1

if pad~=oldpad then
  if pad:cross() then
     orderMove=true
  end

  if pad:square() then
     if map[mapy][mapx]==0 then
     	map[mapy][mapx]=1
     elseif map[mapy][mapx]==1 then
     	map[mapy][mapx]=0
     end
  end

  if pad:l() then
     deler=deler*2
  end

  if pad:r() then
     deler=deler/2
  end

  if pad:start() then
     break
  end
end
oldpad=pad

  if orderMove==true then
     player.path=CalcPath(CalcMoves(map, math.floor(player.x/xInterval)+1, math.floor(player.y/yInterval)+1, mapx, mapy))
     if player.path==nil then
     	orderMove=false
     end
     if player.path~=nil then
     	player.pathLength=table.getn(player.path)
     	player.cur=1
     	player.xmove=(player.path[player.cur].x*xInterval)-xInterval
     	player.ymove=(player.path[player.cur].y*yInterval)-yInterval
     	orderMove=false
     	player.move=true
     end
  end

  -- Movement
if player.move==true then
  if player.xmove>player.x then
     player.x=player.x+player.speed
  elseif player.xmove<player.x then
     player.x=player.x-player.speed
  end
  if player.ymove>player.y then
     player.y=player.y+player.speed
  elseif player.ymove<player.y then
     player.y=player.y-player.speed
  end

  if player.y==player.ymove and player.x==player.xmove and player.cur<player.pathLength then
     player.cur=player.cur+1
     player.xmove=(player.path[player.cur].x*xInterval)-xInterval
     player.ymove=(player.path[player.cur].y*yInterval)-yInterval
  end
  if player.y==player.ymove and player.x==player.xmove and player.cur>=player.pathLength then
     player.move=false
  end
end

screen:print(0,264,"A* algorithm for LUA - Ported by Altair 2006",wit)
screen.waitVblankStart()
screen:flip()

end