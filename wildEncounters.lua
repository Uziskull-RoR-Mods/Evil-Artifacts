-- Made by Uziskull

--------------
-- Artifact --
--------------

local ticking = Sound.find("Watch")

local artifact = Artifact.new("Wild Encounters")
artifact.displayName = "Wild Encounters"
artifact.loadoutSprite = Sprite.load("evil_artifacts_wild_encounters", "sprites/wildEncounters", 2, 9, 9)
artifact.loadoutText = "Fight every enemy in close encounters."
artifact.unlocked = true

local wildBattleIntro = Sound.load("evil_artifacts_wild_encounters_sound_wild_intro", "sound/wildEncounters/wild_battle_intro")
local wildBattleLoop = Sound.load("evil_artifacts_wild_encounters_sound_wild_loop", "sound/wildEncounters/wild_battle_loop")
local wildBattleVictoryIntro = Sound.load("evil_artifacts_wild_encounters_sound_wild_victory_intro", "sound/wildEncounters/wild_battle_victory_intro")
local wildBattleVictoryLoop = Sound.load("evil_artifacts_wild_encounters_sound_wild_victory_loop", "sound/wildEncounters/wild_battle_victory_loop")
local bossBattleIntro = Sound.load("evil_artifacts_wild_encounters_sound_boss_intro", "sound/wildEncounters/boss_battle_intro")
local bossBattleLoop = Sound.load("evil_artifacts_wild_encounters_sound_boss_loop", "sound/wildEncounters/boss_battle_loop")
local bossBattleVictoryIntro = Sound.load("evil_artifacts_wild_encounters_sound_boss_victory_intro", "sound/wildEncounters/boss_battle_victory_intro")
local bossBattleVictoryLoop = Sound.load("evil_artifacts_wild_encounters_sound_boss_victory_loop", "sound/wildEncounters/boss_battle_victory_loop")

local boxCorner1 = Sprite.load("evil_artifacts_wild_encounters_box_corner_1", "sprites/wildEncounters/corner1", 1, 0, 0)
local boxCorner2 = Sprite.load("evil_artifacts_wild_encounters_box_corner_2", "sprites/wildEncounters/corner2", 1, 0, 0)
local boxCorner3 = Sprite.load("evil_artifacts_wild_encounters_box_corner_3", "sprites/wildEncounters/corner3", 1, 0, 0)
local boxCorner4 = Sprite.load("evil_artifacts_wild_encounters_box_corner_4", "sprites/wildEncounters/corner4", 1, 0, 0)
local boxBorderH = Sprite.load("evil_artifacts_wild_encounters_box_border_h", "sprites/wildEncounters/borderH", 1, 0, 0)
local boxBorderV = Sprite.load("evil_artifacts_wild_encounters_box_border_v", "sprites/wildEncounters/borderV", 1, 0, 0)

local empty_sprite = Sprite.find("evil_artifacts_empty_sprite")
if empty_sprite == nil then
    empty_sprite = Sprite.load("evil_artifacts_empty_sprite", "sprites/empty", 0, 0, 0)
end

local fontSize = 23
local font = nil
local scale = nil

local inBattlePlayer = nil
local inBattleEnemy = nil

local function getEnemySound(enemy)
    local name = enemy:get("name")
    -- TODO: a lot of stuff
    -- make sure to always return a sound
    return Sound.find("LizardSpawn")
end

local function startBattle(handler, frame)
    local playerX = inBattlePlayer.x
    local playerY = inBattlePlayer.y
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
    if frame <= 1.5 * 60 then
        if frame <= 88 then -- highest number divided by 4
            local actualFrame = frame - 1.5 * 60
            if actualFrame % 11 ~= 0 then
                if actualFrame % 22 < 11 then
                    graphics.color(Color.WHITE)
                else
                    graphics.color(Color.BLACK)
                end
                if actualFrame % 11 <= 5 then
                    graphics.alpha(((actualFrame % 11) - 1) / 5)
                else
                    graphics.alpha((10 - (actualFrame % 11)) / 5)
                end
                graphics.rectangle(
                    drawX,
                    drawY,
                    drawX + cameraWidth,
                    drawY + cameraHeight,
                    false
                )
                graphics.alpha(1)
            end
        end
    elseif frame > 1.5 * 60 and frame <= 3 * 60 then
        if handler:get("encounterAnimation") == 1 then
            graphics.color(Color.BLACK)
            local angle = (frame - 1.5 * 60) * 180 / (1.5 * 60)
            if angle >= 90 then
                graphics.rectangle(
                    drawX + cameraWidth / 2,
                    drawY,
                    drawX + cameraWidth,
                    drawY + cameraHeight / 2,
                    false
                )
                graphics.rectangle(
                    drawX,
                    drawY + cameraHeight / 2,
                    drawX + cameraWidth / 2,
                    drawY + cameraHeight,
                    false
                )
            end
            if angle ~= 90 then
                local multiplier = 1
                if angle > 90 then
                    multiplier = -1
                end
                for y = 1/18, 1, 1/18 do
                    for x = math.min(1/20 * multiplier, 1 * multiplier), math.max(1/20 * multiplier, 1 * multiplier), 1/20 do
                        if (multiplier == 1 and math.tan(math.rad(angle)) * x >= y)
                          or (multiplier == -1 and math.tan(math.rad(angle)) * x <= y) then
                            graphics.rectangle(
                                drawX + cameraWidth * (1 + x - (1/20) * multiplier),
                                drawY + cameraHeight * (1 + y - (1/18) * multiplier),
                                drawX + cameraWidth * (1 + x),
                                drawY + cameraHeight * (1 + y),
                                false
                            )
                            graphics.rectangle(
                                drawX + cameraWidth * (1 - x + (1/20) * multiplier),
                                drawY + cameraHeight * (1 - y + (1/18) * multiplier),
                                drawX + cameraWidth * (1 - x),
                                drawY + cameraHeight * (1 - y),
                                false
                            )
                        end
                    end
                end
            end
        end
    elseif frame > 3 * 60 and frame < 4 * 60 then
        graphics.color(Color.BLACK)
        graphics.rectangle(
            drawX,
            drawY,
            drawX + cameraWidth,
            drawY + cameraHeight,
            false
        )
    elseif frame >= 4 * 60 and frame < 5 * 60 then
        local currentFrame = frame - 4 * 60
        graphics.color(Color.WHITE)
        graphics.rectangle(
            drawX,
            drawY,
            drawX + cameraWidth,
            drawY + cameraHeight,
            false
        )
        
        graphics.drawImage{
            image = inBattleEnemy:getAnimation("idle"),
            x = drawX + (currentFrame * cameraWidth) / 80,
            y = drawY + cameraHeight / 4,
            xscale = -9,
            yscale = 9,
            color = Color.BLACK
        }
        
        graphics.drawImage{
            image = inBattlePlayer:getAnimation("idle"),
            x = drawX + cameraWidth - (currentFrame * cameraWidth) / 80,
            y = drawY + cameraHeight / 2,
            xscale = 9,
            yscale = 9,
            color = Color.BLACK
        }
    else
        -- main logic
        
        -- draw background
        graphics.color(Color.WHITE)
        graphics.rectangle(
            drawX,
            drawY,
            drawX + cameraWidth,
            drawY + cameraHeight,
            false
        )
        
        -- draw characters
        graphics.drawImage{
            image = inBattleEnemy:getAnimation("idle"),
            x = drawX + cameraWidth * 4 / 5,
            y = drawY + cameraHeight / 4,
            xscale = -6,
            yscale = 6
        }
        
        graphics.drawImage{
            image = inBattlePlayer:getAnimation("idle"),
            x = drawX + cameraWidth - cameraWidth * 4 / 5,
            y = drawY + cameraHeight / 2,
            xscale = 6,
            yscale = 6
        }
        
        -- draw text box
        
        graphics.color(Color.BLACK)
        ---- corners
        for x = drawX, drawX + cameraWidth * 19 / 20, cameraWidth / 20 do
            for y = drawY + cameraHeight * 14 / 18, drawY + cameraHeight * 17 / 18, cameraHeight / 18 do
                if not (x ~= drawX and x ~= drawX + cameraWidth * 19 / 20 and y ~= drawY + cameraHeight * 14 / 18 and y ~= drawY + cameraHeight * 17 / 18) then
                    local spriteToDraw = boxBorderH
                    if x == drawX or x == drawX + cameraWidth * 19 / 20 then
                        spriteToDraw = boxBorderV
                        if y == drawY + cameraHeight * 14 / 18 then
                            if x == drawX then
                                spriteToDraw = boxCorner1
                            elseif x == drawX + cameraWidth * 19 / 20 then
                                spriteToDraw = boxCorner2
                            end
                        elseif y == drawY + cameraHeight * 17 / 18 then
                            if x == drawX then
                                spriteToDraw = boxCorner3
                            elseif x == drawX + cameraWidth * 19 / 20 then
                                spriteToDraw = boxCorner4
                            end
                        end
                    end
                    
                    -- -- hotfix
                    -- if x == drawX + cameraWidth * 19 / 20 then
                        -- x = x - 1
                    -- end
                    
                    graphics.drawImage{
                        image = spriteToDraw,
                        x = x,
                        y = y,
                        xscale = cameraWidth / (20 * 8),
                        yscale = cameraHeight / (18 * 8)
                    }
                end
            end
        end
        
        if handler:get("bossFight") == nil then
            if not wildBattleIntro:isPlaying() and not wildBattleLoop:isPlaying() then
                wildBattleLoop:loop()
            end
        else
            if not bossBattleIntro:isPlaying() and not bossBattleLoop:isPlaying() then
                bossBattleLoop:loop()
            end
        end
        
        local enemySound = getEnemySound(inBattleEnemy)
        
        if frame == 5 * 60 then
            if enemySound ~= nil then
                enemySound:play(1,1)
            end
            handler:set("introText", 1)
        end
        
        if handler:get("introText") ~= nil and not enemySound:isPlaying() then
            local text = "Wild " .. string.upper(inBattleEnemy:get("name"))
            local text2 = "appeared!"
            
            for x = 1, handler:get("introText") do
                graphics.print(
                    text:sub(x, x),
                    drawX + cameraWidth / 20 + (fontSize * scale) / 7 * 9 * x,
                    drawY + cameraHeight * 15 / 18,
                    font
                )
            end
            if handler:get("introText") > text:len() then
                for x = 1, handler:get("introText") - text:len() do
                    graphics.print(
                        text2:sub(x, x),
                        drawX + cameraWidth / 20 + (fontSize * scale)/ 7 * 9 * x,
                        drawY + cameraHeight * 16 / 18,
                        font
                    )
                end
            end
            
            if handler:get("introText") < text:len() + text2:len() then
                handler:set("introText", handler:get("introText") + 1)
            end
        end
    end
end

local battleBuffStuff = {}

local battleBuff = Buff.new("Battle!")
battleBuff.sprite = empty_sprite
battleBuff:addCallback("start", function(player)
    battleBuffStuff[player.id] = {
        player:get("pHmax"),
        player:get("pVmax"),
        player:get("pVspeed"),
        player:get("pGravity1"),
        player:get("pGravity2"),
        
        player.x,
        player.y
    }
    player:set("pHmax", 0)
    player:set("pVmax", 0)
    player:set("pVspeed", 0)
    player:set("pGravity1", 0)
    player:set("pGravity2", 0)
    
    if inBattlePlayer ~= nil then
        player.x = inBattlePlayer.x
        player.y = inBattlePlayer.y
    end
end)
battleBuff:addCallback("end", function(player)
    player:set("pHmax", battleBuffStuff[player.id][1])
    player:set("pVmax", battleBuffStuff[player.id][2])
    player:set("pVspeed", battleBuffStuff[player.id][3])
    player:set("pGravity1", battleBuffStuff[player.id][4])
    player:set("pGravity2", battleBuffStuff[player.id][5])
    
    player.x = battleBuffStuff[player.id][6]
    player.y = battleBuffStuff[player.id][7]
end)

registercallback("onStep", function()
    if artifact.active then
        if scale == nil then
            scale = misc.getOption("video.scale")
            font = graphics.fontFromFile("sprites/wildEncounters/PKMN_RBYGSC", fontSize * scale)
        else
            if misc.getOption("video.scale") ~= scale then
                graphics.fontDelete(font)
                scale = misc.getOption("video.scale")
                font = graphics.fontFromFile("sprites/wildEncounters/PKMN_RBYGSC", fontSize * scale)
            end
        end
    
        for _, actor in ipairs(ObjectGroup.find("actors"):findAll()) do
            actor:set("hp_regen", 0)
            for i=2,5 do
                actor:setAlarm(i, 1)
            end
        end
        
    
        if inBattlePlayer ~= nil then
            if ticking:isPlaying() then
                ticking:stop()
            end
        
            if misc.getTimeStop() == 1 then
                misc.setTimeStop(59)
            end
        end
    
        for _, player in ipairs(misc.players) do
            if inBattlePlayer == nil then
                for _, enemy in ipairs(ObjectGroup.find("enemies"):findAll()) do
                    if player:collidesWith(enemy, player.x, player.y) then
                        local handler = graphics.bindDepth(-10000, startBattle)
                        inBattlePlayer = player
                        inBattleEnemy = enemy
                        handler:set("encounterAnimation", 1)--math.random(3)) --TODO: more animations
                        if enemy:isBoss() then
                            bossBattleIntro:play(1, 1)
                            handler:set("bossFight", 1)
                        else
                            wildBattleIntro:play(1, 1)
                        end
                        misc.setTimeStop(59)
                        
                        break
                    end
                end
            elseif not player:hasBuff(battleBuff) then
                player:applyBuff(battleBuff, 60)
            end
        end
    end
end)