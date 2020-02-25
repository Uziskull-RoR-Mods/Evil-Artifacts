-- Made by Uziskull

--------------
-- Artifact --
--------------

local artifact = Artifact.new("Blinding")
artifact.displayName = "Blinding"
artifact.loadoutSprite = Sprite.load("evil_artifacts_blinding", "sprites/blind", 2, 9, 9)
artifact.loadoutText = "Make everything dark. Only entities emit light."
artifact.unlocked = true

local surf = nil

local function darkness(handler, frame)
    local stageW, stageH = Stage.getDimensions()
    if not Surface.isValid(surf) then
        surf:free()
        surf = Surface.new(stageW, stageH)
    end
    surf:draw(0,0)
    graphics.setTarget(surf)
    graphics.color(Color.BLACK)
    graphics.rectangle(0, 0, stageW, stageH)
    graphics.resetTarget()
end

local function surroundingLight(handler, frame)
    local t = ObjectGroup.find("actors"):findAll()
    if modloader.checkFlag("blinding_easy_mode") then
        for _, o in ipairs(ObjectGroup.find("mapObjects"):findAll()) do
            table.insert(t, o)
        end
    else
        table.insert(t, Object.find("Teleporter"):find(1))
    end
    for _, actor in ipairs(t) do
        if actor:isValid() then
            local stageW, stageH = Stage.getDimensions()
            if not Surface.isValid(surf) then
                surf:free()
                surf = Surface.new(stageW, stageH)
                surf:draw(0,0)
            end
            local useSprite = actor.sprite
            if isa(actor, "ActorInstance") then
                useSprite = actor:getAnimation("idle")
            end
            local leftX = actor.x - useSprite.xorigin
            local rightX = actor.x + (useSprite.width - useSprite.xorigin)
            if isa(actor, "ActorInstance") and actor:getFacingDirection() == 180 then
                leftX = actor.x + useSprite.xorigin
                rightX = actor.x - (useSprite.width - useSprite.xorigin)
            end
            local upY = actor.y - useSprite.yorigin
            local downY = actor.y + (useSprite.height - useSprite.yorigin)
            local x = (leftX + rightX) / 2
            local y = (upY + downY) / 2
            graphics.setTarget(surf)
            graphics.setBlendMode("subtract")
            graphics.color(Color.BLACK)
            graphics.alpha(0.5)
            -- graphics.ellipse(
                -- actor.x - actor.sprite.xorigin * 2,
                -- actor.y - actor.sprite.yorigin * 2,
                -- actor.x + (actor.sprite.width - actor.sprite.xorigin) * 2,
                -- actor.y + (actor.sprite.height - actor.sprite.yorigin) * 2
            -- )
            local actorLightRadius = 3
            if isa(actor, "PlayerInstance") then
                if modloader.checkFlag("blinding_easy_mode") then
                    actorLightRadius = 12
                else
                    actorLightRadius = 6
                end
            end
            graphics.circle(x, y, (x - leftX) * actorLightRadius)
            if frame % 60 >= 0 and frame % 60 < 15 then
                actorLightRadius = actorLightRadius - 0.25
            elseif frame % 60 >= 30 and frame % 60 < 45 then
                actorLightRadius = actorLightRadius - 0.75
            else
                actorLightRadius = actorLightRadius - 0.5
            end
            graphics.alpha(1)
            -- graphics.ellipse(
                -- actor.x - actor.sprite.xorigin * multiplier,
                -- actor.y - actor.sprite.yorigin * multiplier,
                -- actor.x + (actor.sprite.width - actor.sprite.xorigin) * multiplier,
                -- actor.y + (actor.sprite.height - actor.sprite.yorigin) * multiplier
            -- )
            graphics.circle(x, y, (x - leftX ) * actorLightRadius)
            graphics.setBlendMode("normal")
            graphics.resetTarget()
        end
    end
end

registercallback("onStageEntry", function()
    if artifact.active then
        if surf ~= nil and Surface.isValid(surf) then
            surf:free()
        end
        local stageW, stageH = Stage.getDimensions()
        surf = Surface.new(stageW, stageH)
        graphics.bindDepth(-100, darkness)
        graphics.bindDepth(-101, surroundingLight)
    end
end)