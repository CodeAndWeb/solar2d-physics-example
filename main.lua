-- 
-- Abstract: PhysicsEditor Demo
--
-- Demonstrates using PhysicsEditor to create complex collision shapes
--
-- This demo loads physics bodies created with http://www.physicseditor.de


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- init physics
local physics = require("physics")
physics.start()

-- add background image to the center of the screen
local bkg = display.newImage( "Background.png" )
bkg.x = display.contentCenterX
bkg.y = display.contentCenterY

-- load the physics data, scale factor is set to 1.0
local physicsData = (require "shapedefs").physicsData(1.0)

-- create physical floor shape to the bottom of the screen
local bar = display.newImage("Floor.png")
bar.x = display.contentCenterX
bar.y = display.contentHeight - display.screenOriginY
bar.myName = "Floor"
physics.addBody( bar, "static", physicsData:get("Floor") )

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
function newItem()

    -- all items
	local names = {"Apple_00", "Apple_01", "Apple_02", "Ball", "Duck"};

    -- just pick a random one
	local name = names[math.random(#names)];

	-- set the graphics
	obj = display.newImage(name..".png");

	-- remember object's type
	obj.myName = name

	-- set the shape
	physics.addBody( obj, physicsData:get(name))

	-- random start location
	obj.x = math.random( 60, display.contentWidth-60 )
	obj.y = -100

	-- add collision handler
    obj.collision = onLocalCollision
    obj:addEventListener( "collision", obj )
end

timer.performWithDelay( 1000, newItem, 100 )