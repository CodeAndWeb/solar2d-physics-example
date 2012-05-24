-- 
-- Abstract: PhysicsEditor Demo
--
-- Demonstrates using PhysicsEditor to create complex collision shapes
--
-- This demo loads physics bodies created with http://www.physicseditor.de
--
-- Code is based on ANSCA's Crate demo
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--

local physics = require("physics")
physics.start()
display.setStatusBar( display.HiddenStatusBar )

-- background shape
local bkg = display.newImage( "background.png" )

-- load the physics data, scale factor is set to 1.0
local physicsData = (require "shapedefs").physicsData(1.0)

-- create physical floor shape
local bar = display.newImage("Floor.png")
bar.x = 160; bar.y = 450
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
	obj.x = 60 + math.random( 160 )
	obj.y = -100
	
	-- add collision handler
    obj.collision = onLocalCollision
    obj:addEventListener( "collision", obj )
end

local dropCrates = timer.performWithDelay( 1000, newItem, 100 )