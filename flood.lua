-- Made by Uziskull

--------------
-- Artifact --
--------------

local artifact = Artifact.new("The Flood")
artifact.displayName = "The Flood"
artifact.loadoutSprite = Sprite.load("evil_artifacts_flood", "sprites/flood", 2, 9, 9)
artifact.loadoutText = "Every once in a while, a giant wave will sweep the screen."
artifact.unlocked = true

local warningSprite = Sprite.load("evil_artifacts_flood_warning", "sprites/flood/warning", 2, 35, 17)
local waveSprite = Sprite.load("evil_artifacts_flood_wave", "sprites/flood/wave", 4, 50, 50)
local objectWave = Object.new("Flood Wave")
objectWave.sprite = waveSprite

local waveBuff = Buff.new("Wave Crashed")
waveBuff.sprite = Sprite.load("evil_artifacts_flood_buff", "sprites/flood/waveBuff", 1, 1, 4)
local waveBuffStuff = {}
waveBuff:addCallback("start", function(player)
    if not modloader.checkFlag("flood_easy_mode") then
        waveBuffStuff[player.id] = {player:get("pHmax"), player:get("armor")}
        player:set("pHmax", waveBuffStuff[player.id][1] * 1/2)
        player:set("armor", waveBuffStuff[player.id][2] * 1/2)
    end
end)
waveBuff:addCallback("end", function(player)
    if not modloader.checkFlag("flood_easy_mode") then
        player:set("pHmax", waveBuffStuff[player.id][1])
        player:set("armor", waveBuffStuff[player.id][2])
        waveBuffStuff[player.id] = {}
    end
end)

local cooldown = 20 * 60

local function scalingFunction(w, h, t)
    -- max 9/10, min 3
    return (((4.5/30)*h - 0.5) * math.cos(t / (math.pi * w / 10)) + (4.5/30)*h + 0.5) * 3
end

local function playerCollidesWave(player, wave)
    local result = player:collidesWith(wave, player.x, player.y)
    if result then
        local frameSpeed = wave.spriteSpeed
        local frame = wave:get("time") - 1
        local coords = {
            (player.x - player.sprite.xorigin - wave.x) / wave.xscale,
            (player.y - player.sprite.yorigin - wave.y) / wave.yscale * -1, -- reverse axes
            (player.x + player.sprite.width - player.sprite.xorigin - wave.x) / wave.xscale,
            (player.y + player.sprite.height - player.sprite.yorigin - wave.y) / wave.yscale * -1 -- reverse axes
        }
        local corners = {
            {coords[1], coords[2]}, -- top left
            {coords[3], coords[2]}, -- top right
            {coords[1], coords[4]}, -- bottom left
            {coords[3], coords[4]}, -- bottom right
            {(coords[1] + coords[3]) / 2, (coords[2] + coords[4]) / 2} -- middle
        }
        if frame % (4 / frameSpeed) >= (1 / frameSpeed) and frame % (4 / frameSpeed) < (2 / frameSpeed) then
            for _, c in ipairs(corners) do
                local x = c[1]
                local y = c[2]
                result = y <= -1 * math.sqrt((x + (-3.3) * wave:get("direction")) / (-0.0374 * wave:get("direction"))) - 14.14 and x <= 2.7 * wave:get("direction")
                if result then
                    break
                end
                result = x >= 2.7 * wave:get("direction") and y <= -0.02845 * (x + (-2.6) * wave:get("direction"))^2 + 13
                if result then
                    break
                end
                result = x <= 2.7 * wave:get("direction") and x >= -32 * wave:get("direction") and y >= -0.07 * (x + 9.36 * wave:get("direction"))^2 + 3.1
                    and y >= -0.0176 * (x + 12.4 * wave:get("direction"))^2 + 3.2 and y <= -0.012 * (x + (-2.9) * wave:get("direction"))^2 + 13.1
                if result then
                    break
                end
            end
        elseif frame % (4 / frameSpeed) >= (3 / frameSpeed) and frame % (4 / frameSpeed) < (4 / frameSpeed) then
            for _, c in ipairs(corners) do
                local x = c[1]
                local y = c[2]
                result = y <= -1 * math.sqrt((x - 9.2) / -0.0384) - 12 and x <= 9.1
                if result then
                    break
                end
                result = x >= 9.1 and y <= -0.0424 * (x - 11.4)^2 + 17.6
                if result then
                    break
                end
                result = x <= 9.1 and x >= -27 and y >= -0.08 * (x + 3.17)^2 + 8.2
                    and y >= -0.0176 * (x + 7)^2 + 8.3 and y <= -0.015 * (x - 4.1)^2 + 18.2
                if result then
                    break
                end
            end
        else
            for _, c in ipairs(corners) do
                local x = c[1]
                local y = c[2]
                result = y <= -1 * math.sqrt((x - 4.2) / -0.0363) - 13.04 and x <= 4
                if result then
                    break
                end
                result = x >= 4 and y <= -0.0312 * (x - 3.6)^2 + 17.24
                if result then
                    break
                end
                result = x <= 4 and x >= -31 and y >= -0.07 * (x + 8.4)^2 + 6.2
                    and y >= -0.02 * (x + 11.4)^2 + 6.2 and y <= -0.015 * (x - 2.9)^2 + 17.24
                if result then
                    break
                end
            end
        end
    end
    
    return result
end

local function warningWave(handler, frame)
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
    local dX
    if handler:get("facing") == -1 then
        dX = 5
    else
        dX = cameraWidth - 5
    end
    if frame == 1 then
        misc.shakeScreen(2 * 60)
    end
    if frame % 30 < 15 then
        graphics.drawImage{
            image = warningSprite,
            x = drawX + dX,
            y = drawY + cameraHeight / 2,
            subimage = 1,
            xscale = 2 * handler:get("facing"),
            yscale = 2
        }
    else
        graphics.drawImage{
            image = warningSprite,
            x = drawX + dX,
            y = drawY + cameraHeight / 2,
            subimage = 2,
            xscale = 2 * handler:get("facing"),
            yscale = 2
        }
    end
    if frame >= 2 * 60 then
        local wave = objectWave:create(0, 0)
        wave.spriteSpeed = 1/4 -- 15fps
        wave.xscale = scalingFunction(stageWidth, stageHeight, 0) / wave.sprite.width * handler:get("facing")
        wave.yscale = scalingFunction(stageWidth, stageHeight, 0) / wave.sprite.height
        wave.y = stageHeight - (wave.sprite.height - wave.sprite.yorigin) * wave.yscale
        if handler:get("facing") == 1 then
            wave.x = stageWidth + wave.sprite.xorigin * wave.xscale
        else
            wave.x = (wave.sprite.width - wave.sprite.xorigin) * wave.xscale
        end
        wave:set("time", 1)
        wave:set("direction", handler:get("facing"))
        cooldown = 15 * 60
        handler:destroy()
    end
end

registercallback("onStep", function()
    if artifact.active then
        for _, player in ipairs(misc.players) do
            if player:get("ridingWave") ~= nil then
                player:set("ridingWave", nil)
            end
        end
    
        if cooldown > 0 then
            cooldown = cooldown - 1
        end
        if cooldown <= 10 * 60 and cooldown % 60 == 0 then
            if math.random(cooldown / 60) == 1 then
                local handler = graphics.bindDepth(-102, warningWave)
                if math.random(2) == 1 then
                    handler:set("facing", 1)
                else
                    handler:set("facing", -1)
                end
                cooldown = -1
            end
        end
        
        for i, wave in ipairs(objectWave:findAll()) do
            if wave:isValid() then
                local stageWidth, stageHeight = Stage.getDimensions()
                if (wave:get("direction") == -1 and wave.x + wave.sprite.xorigin * wave.xscale > stageWidth)
                  or (wave:get("direction") == 1 and wave.x + (wave.sprite.width - wave.sprite.xorigin) * wave.xscale < 0) then
                    wave:destroy()
                else
                    local oldYScale = wave.yscale
                    wave.x = wave.x + wave:get("direction") * -2
                    wave.xscale = scalingFunction(stageWidth, stageHeight, wave:get("time")) / wave.sprite.width * wave:get("direction")
                    wave.yscale = scalingFunction(stageWidth, stageHeight, wave:get("time")) / wave.sprite.height
                    wave.y = wave.y + ((wave.sprite.height - wave.sprite.yorigin) * oldYScale - (wave.sprite.height - wave.sprite.yorigin) * wave.yscale)
                    wave:set("time", wave:get("time") + 1)
                
                    -- collision
                    for _, player in ipairs(misc.players) do
                        if not player:hasBuff(waveBuff) then
                            if playerCollidesWave(player, wave) then
                                if player:get("ridingWave") == nil then
                                    player:set("ridingWave", 1)
                                    if player:get("activity") ~= 30 then
                                        if not player:collidesMap(player.x - 1 * wave:get("direction"), player.y) then
                                            player.x = player.x - 2 * wave:get("direction")
                                            if player:collidesMap(player.x, player.y) then
                                                player.x = player.x + 1 * wave:get("direction")
                                            end
                                            player:set("pVspeed", player:get("pGravity1") * -1)
                                        else--if not player:collidesMap(player.x, player.y - 1) then
                                            -- player.y = player.y - 2
                                            -- if player:collidesMap(player.x, player.y) then
                                                -- player.y = player.y + 1
                                            -- end
                                            player:set("pVspeed", player:get("pGravity1") * -2)
                                        end
                                    end
                                else -- touched another wave before this one
                                    if player:get("activity") ~= 30 then
                                        player:set("pVspeed", -3)
                                    end
                                    player:applyBuff(waveBuff, 5 * 60)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

registercallback("onStageEntry", function()
    cooldown = 20 * 60
end)