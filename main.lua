-- 
-- Abstract: Physicsdemo
-- Demonstrates complex body construction by generating 100 random physics objects
--
-- This demo loads physics bodies created with http://www.physicseditor.de
--
-- Code is based on ANSCA's Create demo
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

local physics = require("physics")
physics.start()
display.setStatusBar( display.HiddenStatusBar )

-- background shape
local bkg = display.newImage( "bkg_cor.png" )

-- load the physics data, scale factor is set to 1.0
local physicsData = (require "shapedefs").physicsData(1.0)

-- create physical floor shape
local bar = display.newImage("bar.png")
bar.x = 160; bar.y = 440
bar.myName = "bar"
physics.addBody( bar, "static", physicsData:get("bar") )

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
	local names = {"orange", "drink", "hamburger", "hotdog", "icecream", "icecream2", "icecream3"};

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

local dropCrates = timer.performWithDelay( 500, newItem, 100 )