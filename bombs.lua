-- Made by Uziskull

--------------
-- Artifact --
--------------
local magicCircle = Object.find("BossSkill1")

local artifact = Artifact.new("Bombardment")
artifact.displayName = "Bombardment"
artifact.loadoutSprite = Sprite.load("evil_artifacts_bombardment", "sprites/bombs", 2, 9, 9)
artifact.loadoutText = "Get constantly pelted by death circles."
artifact.unlocked = true

local countdown = 10 * 60
local tp = nil
local coords = {}
local coordsInit = 1
local coordsEnd = 1

registercallback("onStageEntry", function()
    countdown = 10 * 60
    tp = Object.find("Teleporter"):find(1)
    coords = {}
end)

registercallback("onStep", function()
    if artifact.active then
        if countdown > 0 then
            countdown = countdown - 1
        else
            if tp:get("active") <= 3 then
                for _, player in ipairs(misc.players) do
                    if player:isValid() and player:get("dead") == 0 then
                        local bullet = magicCircle:create(player.x, player.y)
                        if not modloader.checkFlag("bombardment_easy_mode") then
                            coords[coordsEnd] = {
                                player.x - bullet.sprite.xorigin,
                                player.y - bullet.sprite.yorigin,
                                player.x + bullet.sprite.width - bullet.sprite.xorigin,
                                player.y + bullet.sprite.height - bullet.sprite.yorigin,
                                120
                            }
                            coordsEnd = coordsEnd + 1
                        end
                    end
                end
                local minute, _ = misc.getTime()
                countdown = math.max(60 - minute, 30)
            end
        end
        
        for i = coordsInit, coordsEnd - 1 do
            if coords[i][5] ~= 0 then
                coords[i][5] = coords[i][5] - 1
                if coords[i][5] == 0 then
                    for _, player in ipairs(misc.players) do
                        if player.x >= coords[i][1] and player.y >= coords[i][2]
                          and player.x <= coords[i][3] and player.y <= coords[i][4] then
                            player:kill()
                        end
                    end
                    coordsInit = coordsInit + 1
                end
            end
        end
    end
end)