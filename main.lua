-----------------------------------------------------------------------------------------
--
-- Sample code for "How to use game physics with Solar2D"
-- https://www.codeandweb.com/physicseditor/tutorials/how-to-use-game-physics-in-solar2d
--
-----------------------------------------------------------------------------------------


-- init display
display.setStatusBar( display.HiddenStatusBar )

-- background image
local background = display.newImage( "sprites/background.png" )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- init physics
local physics = require("physics")
physics.start()

-- load the physics data, scale factor is set to 1.0
local physicsData = (require "shapedefs").physicsData(1.0)

-- create physical ground shape
local ground = display.newImage("sprites/ground.png")
ground.x = display.contentCenterX; 
ground.y = display.contentHeight-ground.height/2
ground.myName = "ground"
physics.addBody( ground, "static", physicsData:get("ground") )

-- uncomment to debug your physics shapes
-- physics.setDrawMode( "hybrid" )


-- local collision handler
-- called for each contact point of collidin objects
local function onLocalCollision( self, event )
    
    -- retrieve fixture names from physics data
    local selfFixtureId = physicsData:getFixtureId(self.myName, event.selfElement)
    local otherFixtureId = physicsData:getFixtureId(event.other.myName, event.otherElement)
    
    -- print collision information
    print( 
        self.myName .. ":" .. selfFixtureId ..
        " collision "..event.phase.." with " .. 
        event.other.myName .. ":" .. otherFixtureId
        )
end


-- create a random new object
local function newItem()	
    
    -- all items
	local names = {"banana", "crate", "cherries", "orange"};

    -- just pick a random one
	local name = names[math.random(#names)];

	-- set the graphics 
	obj = display.newImage("sprites/"..name..".png");
	
	-- remember object's name for collision output
	obj.myName = name

	-- set the shape
	physics.addBody( obj, physicsData:get(name))	
	
	-- random start location
	obj.x = math.random( display.contentWidth/2  ) + display.contentWidth/4
	obj.y = -obj.contentHeight
	
	-- add collision handler
    obj.collision = onLocalCollision
    obj:addEventListener( "collision", obj )
end


-- call newItem 20 times with a delay of 1s
timer.performWithDelay( 1000, newItem, 20 )



