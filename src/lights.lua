package.path = package.path .. ";../../insulines-src/src/?.lua"

require 'defines'
require 'resource_cache'
-- require 'room'
-- require 'rooms/dummy'
-- require 'characters/main_character'
-- require 'game'
WORLD_RESOLUTION_X = 960
WORLD_RESOLUTION_Y = 540
SCREEN_RESOLUTION_X = 1920
SCREEN_RESOLUTION_Y = 1080

MOAISim.openWindow ( 'The Insulines', SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y )

-- Setup viewport
viewport = MOAIViewport.new ()

viewport:setSize ( SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y )
viewport:setScale ( WORLD_RESOLUTION_X, WORLD_RESOLUTION_Y )


-- Define a room to apply lights
room = {}
room.layers = {}

camera = MOAICamera2D.new()

function room:addLayer ( name, filename, width, height, parallax_x, parallax_y, parallax_z )
  local layer_obj = {}
  -- Create layer prop
  layer_obj.gfx = resource_cache.loadImage( name , filename, -width/2, -height/2, width/2, height/2)
  layer_obj.prop = MOAIProp2D.new ()
  layer_obj.prop:setDeck ( layer_obj.gfx )
  layer_obj.prop:setLoc ( 0, 0 )


  -- Setup layer
  layer_obj.layer = MOAILayer2D.new ()
  layer_obj.layer:insertProp ( layer_obj.prop )
  layer_obj.layer:setParallax(parallax_x, parallax_y, parallax_z)

  table.insert(self.layers, layer_obj.layer)
  return layer_obj
end



function main ()
  
  room:addLayer("background", "../../insulines-gfx/b2_l0.png", 1920, 1200, 1.2, 1, 1.6)
  room:addLayer("background 1", "../../insulines-gfx/b2_l1.png", 1920, 1200, 1.1, 1, 1.3)
  room:addLayer("background 2", "../../insulines-gfx/b2_l2.png", 1920, 1200, 1, 1, 1)

  spriteSheet = MOAITileDeck2D.new ()
  spriteSheet:setTexture ( '../../insulines-gfx/gb_walk.png' ) -- load a texture
  spriteSheet:setSize ( 6, 3 ) -- subdivide the texture into 8 x 8 = 64 frames
  spriteSheet:setRect ( -106, -150, 106, 150 ) -- set the world space dimensions of the sprites  

  remapper = MOAIDeckRemapper.new ()
  remapper:reserve ( 14 )
  
  -- room.layers[2]:insertProp ( prop )
  
  local layer_obj = {}

  layer_obj.prop = MOAIProp2D.new ()
  layer_obj.prop:setDeck ( spriteSheet )
  layer_obj.prop:setRemapper(remapper)
  layer_obj.prop:setLoc ( 0, 0 )


  -- Setup layer
  layer_obj.layer = MOAILayer2D.new ()
  layer_obj.layer:insertProp ( layer_obj.prop )

  table.insert(room.layers, layer_obj.layer)
  
  room:addLayer("background 3", "../../insulines-gfx/b2_l3.png", 1920, 1200, 1, 1, 1)
  camera:setScl(1.1, 1.1)
  
  layer_obj.prop:setLoc ( -700, -270 )
  
  
  local shadows = room:addLayer("shadows", "../../insulines-gfx/b2_shadows.png", 1920, 1200, 1, 1, 1)
  shadows.prop:setBlendMode(MOAIProp2D.BLEND_MULTIPLY)
  
  local lights = room:addLayer("lights", "../../insulines-gfx/b2_lights.png", 1920, 1200, 1, 1, 1)
  lights.prop:setBlendMode(MOAIProp2D.BLEND_ADD)
  
  for k, layer in pairs( room.layers ) do 
    layer:setViewport ( viewport )
    layer:setCamera ( camera )
    MOAIRenderMgr.pushRenderPass ( layer )
  end


  -- camera:moveScl(0.2, 0.2, 5, MOAIEaseType.LINEAR)
  camera:moveLoc(200, 0, 10, MOAIEaseType.LINEAR)
  camera:moveLoc(0, -40, 6, MOAIEaseType.LINEAR)
  camera:seekScl(1.6, 1.6, 3)
  
  curve = MOAIAnimCurve.new ()

  curve:reserveKeys ( 15 )

  local i = 1
  while i < 16 do
    curve:setKey ( i, i*0.25, 1 + i % 6, MOAIEaseType.FLAT )
    i = i + 1
  end

  anim = MOAIAnim:new ()
  anim:reserveLinks ( 1 )
  anim:setLink ( 1, curve, remapper, 1 )
  anim:setMode ( MOAITimer.NORMAL )
  
  layer_obj.prop:moveLoc ( 1920, 0, 8, MOAIEaseType.LINEAR )

  MOAICoroutine.blockOnAction ( anim:start () )
  
  curve = MOAIAnimCurve.new ()

  curve:reserveKeys ( 19 )
  
  local i = 1
  while i < 20 do
    curve:setKey ( i, i*0.25, 7 + i % 6, MOAIEaseType.FLAT )
    i = i + 1
  end

  anim = MOAIAnim:new ()
  anim:reserveLinks ( 1 )
  anim:setLink ( 1, curve,remapper, 1 )
  anim:setMode ( MOAITimer.NORMAL )
  MOAICoroutine.blockOnAction ( anim:start () )
  
  for k, layer in pairs( room.layers ) do 
    layer:seekColor (0, 0, 0, 0, 1)
  end
  
end

gameThread = MOAIThread.new ()
gameThread:run ( main )
