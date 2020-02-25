-- Made by Uziskull

--------------
-- Artifact --
--------------

local artifact = Artifact.new("Bad Manners")
artifact.displayName = "Bad Manners"
artifact.loadoutSprite = Sprite.load("evil_artifacts_bad_manners", "sprites/badManners", 2, 9, 9)
artifact.loadoutText = "Celebrate every kill you get."
artifact.unlocked = true

local empty_sprite = Sprite.find("evil_artifacts_empty_sprite")
if empty_sprite == nil then
    empty_sprite = Sprite.load("evil_artifacts_empty_sprite", "sprites/empty", 0, 0, 0)
end

local sprites = {
    commando = Sprite.load("evil_artifacts_bad_manners_commando", "sprites/badManners/commando", 23, 3, 5),
    -- enforcer = Sprite.load("evil_artifacts_bad_manners_enforcer", "sprites/badManners/enforcer", 23, 3, 5),
    -- bandit = Sprite.load("evil_artifacts_bad_manners_bandit", "sprites/badManners/bandit", 23, 3, 5),
    -- huntress = Sprite.load("evil_artifacts_bad_manners_huntress", "sprites/badManners/huntress", 23, 3, 5),
    -- han-d = Sprite.load("evil_artifacts_bad_manners_han-d", "sprites/badManners/han-d", 23, 3, 5),
    -- engineer = Sprite.load("evil_artifacts_bad_manners_engineer", "sprites/badManners/engineer", 23, 3, 5),
    -- miner = Sprite.load("evil_artifacts_bad_manners_miner", "sprites/badManners/miner", 23, 3, 5),
    -- sniper = Sprite.load("evil_artifacts_bad_manners_sniper", "sprites/badManners/sniper", 23, 3, 5),
    -- acrid = Sprite.load("evil_artifacts_bad_manners_acrid", "sprites/badManners/acrid", 23, 3, 5),
    -- mercenary = Sprite.load("evil_artifacts_bad_manners_mercenary", "sprites/badManners/mercenary", 23, 3, 5),
    -- loader = Sprite.load("evil_artifacts_bad_manners_loader", "sprites/badManners/loader", 23, 3, 5),
    -- chef = Sprite.load("evil_artifacts_bad_manners_chef", "sprites/badManners/chef", 23, 3, 5)
}

local bmBuffStuff = {}

local bmBuff = Buff.new("Celebrate Kill")
bmBuff.sprite = empty_sprite
bmBuff:addCallback("start", function(player)
    bmBuffStuff[player.id] = {
        player:get("pHmax"),
        player:get("pVmax"),
        player:get("pVspeed"),
        -- player:get("pGravity1"),
        -- player:get("pGravity2"),
        
    }
    player:set("pHmax", 0)
    player:set("pVmax", 0)
    player:set("pVspeed", 0)
    -- player:set("pGravity1", 0)
    -- player:set("pGravity2", 0)
    
    player.alpha = 0
    player:set("bmTime", 1)
end)
bmBuff:addCallback("step", function(player, timeRemaining)
    player:setAlarm(0, 1)
    for i=2,5 do
        player:setAlarm(i, 1)
    end
    
    if modloader.checkFlag("bad_manners_easy_mode") and timeRemaining % 9 == 0 then -- 150ms per frame
        player:set("bmTime", player:get("bmTime") + 1)
    elseif timeRemaining % 15 == 0 then -- 250ms per frame
        player:set("bmTime", player:get("bmTime") + 1)
    end
end)
bmBuff:addCallback("end", function(player)
    player:set("pHmax", bmBuffStuff[player.id][1])
    player:set("pVmax", bmBuffStuff[player.id][2])
    player:set("pVspeed", bmBuffStuff[player.id][3])
    -- player:set("pGravity1", bmBuffStuff[player.id][4])
    -- player:set("pGravity2", bmBuffStuff[player.id][5])
    
    player.alpha = 1
    player:set("bmTime", nil)
end)

registercallback("onNPCDeathProc", function(enemy, player)
    if artifact.active then
        if enemy:get("killedBy") ~= nil then
            if enemy:get("killedBy") == player.id and not player:hasBuff(bmBuff) then
                if modloader.checkFlag("bad_manners_easy_mode") then
                    player:applyBuff(bmBuff, 3.45 * 60)
                else
                    player:applyBuff(bmBuff, 5.75 * 60)
                end
            end
        end
    end
end)

registercallback("onPlayerDeath", function(player)
    if player:hasBuff(bmBuff) then
        player:removeBuff(bmBuff)
    end
end)

registercallback("onPlayerDraw", function(player)
    if artifact.active then
        local frame = player:get("bmTime")
        if frame ~= nil then
            local spriteToDraw = sprites[player:getSurvivor().displayName:lower()]
            if spriteToDraw ~= nil then
                graphics.drawImage{
                    image = spriteToDraw,
                    x = player.x,
                    y = player.y,
                    subimage = frame
                }
            else
                spriteToDraw = player:getAnimation("idle")
                local scale = (5 - math.abs((frame % 6) - 3)) / 5
                local dY = (1 - scale) / 2
                graphics.drawImage{
                    image = spriteToDraw,
                    x = player.x,
                    y = player.y + dY,
                    yscale = scale
                }
            end
        end
    end
end)

registercallback("preHit", function(damager, hit)
    local parent = damager:getParent()
    if parent ~= nil then
        if isa(parent, "PlayerInstance") then
            hit:set("killedBy", parent.id)
        end
    end
end)

registercallback("postStep", function()
    for _, enemy in ipairs(ObjectGroup.find("enemies"):findAll()) do
        if enemy:get("killedBy") ~= nil then
            enemy:set("killedBy", nil)
        end
    end
end)