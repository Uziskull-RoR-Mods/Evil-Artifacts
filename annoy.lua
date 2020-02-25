-- Made by Uziskull

--------------
-- Artifact --
--------------

local artifact = Artifact.new("Mischievousness")
artifact.displayName = "Mischievousness"
artifact.loadoutSprite = Sprite.load("evil_artifacts_mischievousness", "sprites/annoy", 2, 9, 9)
artifact.loadoutText = "Hey, don't click me!"
artifact.unlocked = true

-----------
-- Stuff --
-----------

local allTheThingsToDo = 2

-- list:
-- 1. big enough
-- 2. look at my cat
-- 3. bee movie
-- 4. dude that controlls stuff (somehting mantis)
local interestingThingToDo
local interestingThingsDone

registercallback("onGameStart", function()
    interestingThingToDo = 0
    interestingThingsDone = {}
end)

--------------------------------

-- big enough

local beCalm = Sound.load("evil_artifacts_mischievousness_sound_be_calm", "sound/annoy/bigEnough/calm")
local beBuildup = Sound.load("evil_artifacts_mischievousness_sound_be_buildup", "sound/annoy/bigEnough/buildup")
local beAaaaa = Sound.load("evil_artifacts_mischievousness_sound_be_aaaaa", "sound/annoy/bigEnough/aaaaa")
local beSprite1 = Sprite.load("evil_artifacts_mischievousness_sound_be_sprite1", "sprites/annoy/bigEnough/1", 51, 0, 0)
local beSprite2 = Sprite.load("evil_artifacts_mischievousness_sound_be_sprite2", "sprites/annoy/bigEnough/2", 51, 0, 0)
local beSprite3 = Sprite.load("evil_artifacts_mischievousness_sound_be_sprite3", "sprites/annoy/bigEnough/3", 51, 0, 0)
local beSprite4 = Sprite.load("evil_artifacts_mischievousness_sound_be_sprite4", "sprites/annoy/bigEnough/4", 51, 0, 0)
local beSprite5 = Sprite.load("evil_artifacts_mischievousness_sound_be_sprite5", "sprites/annoy/bigEnough/5", 51, 0, 0)
local beSprite6 = Sprite.load("evil_artifacts_mischievousness_sound_be_sprite6", "sprites/annoy/bigEnough/6", 51, 0, 0)

local beState = 0
local beFrames = 0

local function bigEnoughBackground(handler, frame)
    local playerX = misc.players[1].x
    local playerY = misc.players[1].y
    local cameraWidth, cameraHeight = graphics.getGameResolution()
    local stageWidth, stageHeight = Stage.getDimensions()
    local drawX = 0
    if playerX > cameraWidth / 2 then
        drawX = playerX - cameraWidth / 2
        if drawX + cameraWidth > stageWidth then
            drawX = stageWidth - cameraWidth
        end
    end
    local drawY = 0
    if playerY > cameraHeight / 2 then
        drawY = playerY - cameraHeight / 2
        if drawY + cameraHeight > stageHeight then
            drawY = stageHeight - cameraHeight
        end
    end
    if not beBuildup:isPlaying() then
        if beState == 0 then
            if not beCalm:isPlaying() then
                beCalm:play(1, 0.5)
            end
        else
            if not beAaaaa:isPlaying() then
                if beState == 0.5 then
                    beState = 1
                else
                    beState = beState + 1
                end
                beFrames = 0
                beAaaaa:play(1, 0.5 + beState / 2)
            end
            local spriteToDraw = beSprite6
            local lowerLimit = 25 * 60
            if beFrames < (5 * 60) then
                spriteToDraw = beSprite1
                lowerLimit = 0
            elseif beFrames < (10 * 60) then
                spriteToDraw = beSprite2
                lowerLimit = 5 * 60
            elseif beFrames < (15 * 60) then
                spriteToDraw = beSprite3
                lowerLimit = 10 * 60
            elseif beFrames < (20 * 60) then
                spriteToDraw = beSprite4
                lowerLimit = 15 * 60
            elseif beFrames < (25 * 60) then
                spriteToDraw = beSprite5
                lowerLimit = 20 * 60
            end
            graphics.drawImage{
                image = spriteToDraw,
                x = drawX,
                y = drawY,
                subimage = 1 + math.floor((beFrames - lowerLimit) / 6),
                xscale = cameraWidth / beSprite1.width,
                yscale = cameraHeight / beSprite1.height
            }
            if beFrames < 30 * 60 then
                beFrames = beFrames + 1
            end
        end
    else
        if beState == 0 then beState = 0.5 end
        graphics.drawImage{
            image = beSprite1,
            x = drawX,
            y = drawY,
            subimage = 1,
            alpha = beFrames / (14 * 60),
            xscale = cameraWidth / beSprite1.width,
            yscale = cameraHeight / beSprite1.height
        }
        if beFrames < (14 * 60) then
            beFrames = beFrames + 1
        end
    end
end

-- look at my cat

local catSprite1 = Sprite.load("evil_artifacts_mischievousness_cat_sprite1", "sprites/annoy/cat/cat1", 1, 274, 0)
local catSprite2 = Sprite.load("evil_artifacts_mischievousness_cat_sprite2", "sprites/annoy/cat/cat2", 1, 0, 0)

local catFont = {}

local function catForeground(handler, frame)
    local frameCount = frame % (130 * 60)
    local intro1 = "&p&hey&!&"
    local intro2 = "&r&hav u seen&!&\n&r&my cat?&!&"
    if frame >= 130 * 60 then
        intro1 = "&p&hey its me again&!&"
        intro2 = "&r&do u miss my cat? :))&!&"
    end

    local playerX = misc.players[1].x
    local playerY = misc.players[1].y
    local cameraWidth, cameraHeight = graphics.getGameResolution()
    local stageWidth, stageHeight = Stage.getDimensions()
    local canvasWidth = 800
    local canvasHeight = 600
    local drawX = 0
    if playerX > cameraWidth / 2 then
        drawX = playerX - cameraWidth / 2
        if drawX + cameraWidth > stageWidth then
            drawX = stageWidth - cameraWidth
        end
    end
    local drawY = 0
    if playerY > cameraHeight / 2 then
        drawY = playerY - cameraHeight / 2
        if drawY + cameraHeight > stageHeight then
            drawY = stageHeight - cameraHeight
        end
    end
    if frameCount > 5 * 60 and frameCount <= 10 * 60 then
        graphics.printColor(
            intro1,
            drawX + (cameraWidth * 80 / canvasWidth),
            drawY + (cameraHeight * 70 / canvasHeight),
            catFont.large
        )
    elseif frameCount > 12 * 60 and frameCount <= 20 * 60 then
        graphics.printColor(
            intro2,
            drawX + (cameraWidth * 435 / canvasWidth),
            drawY + (cameraHeight * 369 / canvasHeight),
            catFont.medium
        )
    elseif frameCount > 25 * 60 and frameCount <= 32 * 60 then
        graphics.printColor(
            "&g&hes a pretty&!&\n&g&cool cat&!&",
            drawX + (cameraWidth * 83 / canvasWidth),
            drawY + (cameraHeight * 395 / canvasHeight),
            catFont.medium
        )
    elseif frameCount > 35 * 60 and frameCount <= 43 * 60 then
        graphics.printColor(
            "&b&hes kinda like&!&\n&b&this one&!&",
            drawX + (cameraWidth * 377 / canvasWidth),
            drawY + (cameraHeight * 161 / canvasHeight),
            catFont.medium
        )
        graphics.drawImage{
            image = catSprite1,
            x = drawX + (cameraWidth * 376 / canvasWidth),
            y = drawY + (cameraHeight * 161 / canvasHeight),
        }
        graphics.printColor(
            "&w&but mines cuter lol&!&",
            drawX + (cameraWidth * 205 / canvasWidth),
            drawY + (cameraHeight * 525 / canvasHeight),
            catFont.small
        )
    elseif frameCount > 45 * 60 and frameCount <= 48 * 60 then
        graphics.printColor(
            "&g&im gonna get a picture of&!&\n&g&him, hold on&!&",
            drawX + (cameraWidth * 113 / canvasWidth),
            drawY + (cameraHeight * 279 / canvasHeight),
            catFont.medium
        )
    elseif frameCount > 55 * 60 and frameCount <= 62 * 60 then
        graphics.drawImage{
            image = catSprite2,
            x = drawX + 3,
            y = drawY + 5,
            xscale = (cameraWidth * 1.25) / catSprite2.width,
            yscale = (cameraHeight * 0.95) / catSprite2.height
        }
    elseif frameCount > 65 * 60 and frameCount <= 70 * 60 then
        graphics.printColor(
            "&r&he a very pretty boy :))))&!&",
            drawX + (cameraWidth * 111 / canvasWidth),
            drawY + (cameraHeight * 183 / canvasHeight),
            catFont.large
        )
    -- elseif frameCount > 70 * 60 and frameCount <= 75 * 60 then
        -- graphics.printColor(
            -- "&y&heyyy&!&",
            -- drawX + (cameraWidth * 483 / canvasWidth),
            -- drawY + (cameraHeight * 271 / canvasHeight),
            -- catFont.large
        -- )
    elseif frameCount > 73 * 60 and frameCount <= 77 * 60 then
        graphics.printColor(
            "&b&i also hav a dog :))&!&",
            drawX + (cameraWidth * 80 / canvasWidth),
            drawY + (cameraHeight * 80 / canvasHeight),
            catFont.large
        )
    elseif frameCount > 80 * 60 and frameCount <= 85 * 60 then
        graphics.printColor(
            "&r&but im not going to show it&!&",
            drawX + (cameraWidth * 237 / canvasWidth),
            drawY + (cameraHeight * 347 / canvasHeight),
            catFont.medium
        )
    elseif frameCount > 88 * 60 and frameCount <= 95 * 60 then
        graphics.printColor(
            "&p&my mom doesnt let me :(&!&",
            drawX + (cameraWidth * 163 / canvasWidth),
            drawY + (cameraHeight * 31 / canvasHeight),
            catFont.medium
        )
    elseif frameCount > 100 * 60 and frameCount <= 105 * 60 then
        graphics.printColor(
            "&b&but hes SOOOOOOOOOOOOOOOOO&!&\n&b&            CUTE!!!!&!&",
            drawX + (cameraWidth * 45 / canvasWidth),
            drawY + (cameraHeight * 227 / canvasHeight),
            catFont.large
        )
    elseif frameCount > 109 * 60 and frameCount <= 114 * 60 then
        graphics.drawImage{
            image = catSprite2,
            x = drawX + 10,
            y = drawY,
            xscale = cameraWidth / catSprite2.width,
            yscale = (cameraHeight * 1.4) / catSprite2.height
        }
        graphics.printColor(
            "&y&but my cat is very fluffy and&!&\n&y&my dog isnt&!&",
            drawX + (cameraWidth * 90 / canvasWidth),
            drawY + (cameraHeight * 240 / canvasHeight),
            catFont.large
        )
    elseif frameCount > 117 * 60 and frameCount <= 120 * 60 then
        graphics.printColor(
            "&r&anyways its my brothers turn at the&!&\n&r&pc so im going to go&!&\n\n&r&goodbye!!!!!!1!&!&",
            drawX + (cameraWidth * 320 / canvasWidth),
            drawY + (cameraHeight * 15 / canvasHeight),
            catFont.medium
        )
    end
end

------------------
-- Actual Stuff --
------------------

local stageTeleporter

registercallback("onStageEntry", function()
    stageTeleporter = Object.find("Teleporter"):find(1)
    if artifact.active then
        done = 0
        while done == 0 do
            interestingThingToDo = math.random(allTheThingsToDo)
            if #interestingThingsDone == allTheThingsToDo then
                interestingThingsDone = {}
            end
            if #interestingThingsDone == 0 then
                done = 1
                table.insert(interestingThingsDone, interestingThingToDo)
            else
                for i = 1, #interestingThingsDone do
                    if interestingThingToDo == interestingThingsDone[i] then
                        break
                    end
                    if i == #interestingThingsDone then
                        done = 1
                        table.insert(interestingThingsDone, interestingThingToDo)
                    end
                end
            end
        end
    end
    
    -- big enough
    
    if beCalm:isPlaying() then
        beCalm:stop()
    end
    if beBuildup:isPlaying() then
        beBuildup:stop()
    end
    if beAaaaa:isPlaying() then
        beAaaaa:stop()
    end
    
    if interestingThingToDo == 1 then
        beState = 0
        beFrames = 0
        graphics.bindDepth(5000, bigEnoughBackground)
    end
    
    -- look at my cat
    if next(catFont) ~= nil then
        graphics.fontDelete(catFont.small)
        graphics.fontDelete(catFont.medium)
        graphics.fontDelete(catFont.large)
        catFont = {}
    end
    if interestingThingToDo == 2 then
        catFont = {
            small = graphics.fontFromFile("sprites/annoy/cat/comicbd", 24),
            medium = graphics.fontFromFile("sprites/annoy/cat/comicbd", 36),
            large = graphics.fontFromFile("sprites/annoy/cat/comicbd", 72)
        }
        graphics.bindDepth(-5000, catForeground)
    end
    
end)

registercallback("onStep", function()
    if interestingThingToDo == 1 then
        if stageTeleporter:get("active") ~= 0 and beState == 0 and not beBuildup:isPlaying() then
            if beCalm:isPlaying() then
                beCalm:stop()
            end
            beBuildup:play(1, 0.75)
        end
    end
end)