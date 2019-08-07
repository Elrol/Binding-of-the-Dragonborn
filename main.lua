--Global Files
TBotD = RegisterMod("The Binding of the Dragonborn", 1);
game = Game()

--Constnat list of values for the module
local Const = {
    Mehrunes_Razor = {
        MAX_RANGE = 1000,
        BOSS_VALUE = 1,
        ENEMY_VALUE = 10
    },
    Ebony_Blade = {
        MAX_FOLLOWERS = 1
    },
    Oghma_Infinium = {
        DAMAGE = 5,
        RANGE = 2.5,
        SHOTSPEED = 1,
        LUCK = 2.5,
        TEARDELAY = 5,
        SPEED = 5
    },
    Values = {
        MIN_TEAR_DELAY = 5
    }
}

--Constant list of item ids in the current game
local Ids = {
    Mehrunes_Razor = Isaac.GetItemIdByName("Mehrune's Razor"),
    Masque_of_Clavicus_Vile = Isaac.GetItemIdByName("Masque of Clavicus Vile"),
    Oghma_Infinium = Isaac.GetItemIdByName("Oghma Infinium"),
    Oghma_Infinium_Damage = Isaac.GetItemIdByName("Oghma Infinium - Damage"),
    Oghma_Infinium_FireRate = Isaac.GetItemIdByName("Oghma Infinium - Fire Rate"),
    Oghma_Infinium_ShotSpeed = Isaac.GetItemIdByName("Oghma Infinium - Shot Speed"),
    Oghma_Infinium_Speed = Isaac.GetItemIdByName("Oghma Infinium - Speed"),
    Oghma_Infinium_Luck = Isaac.GetItemIdByName("Oghma Infinium - Luck"),
    Oghma_Infinium_Range = Isaac.GetItemIdByName("Oghma Infinium - Range"),
    Ring_of_Namira = Isaac.GetItemIdByName("Ring of Namira"),
    Saviors_Hide = Isaac.GetItemIdByName("Savior's Hide"),
    Ebony_Blade = Isaac.GetItemIdByName("Ebony Blade")
}

--External Files
local json = require("json")
local activations = require("itemActivations")
local stateFunc = require("state")

local GameState = {}

activations:init(Const, Ids)
--activations:SetIds(Ids)
--activations:SetConstants(Const)

--[[                     ]]--
--[[  Functions Section  ]]--
--[[                     ]]--

function TBotD:UpdatePlayer(player)
    if player:HasCollectible(Ids.Mehrunes_Razor) and not GameState.Inventory.Mehrunes_Razor then
        GameState.Inventory.Mehrunes_Razor = true
        activations:GetMehrunesRazor(player)
    end
    
    if player:HasCollectible(Ids.Oghma_Infinium) and not GameState.Inventory.Oghma_Infinium then
            GameState.Inventory.Oghma_Infinium = true
            activations:GetOghmaInfinium(player)
    end
    
    if player:HasCollectible(Ids.Oghma_Infinium_Damage) and not GameState.Inventory.Oghma_Infinium_Damage then
        GameState.Inventory.Oghma_Infinium_Damage = true
        activations:ClearOghmaItems(player)
    end
    
    if player:HasCollectible(Ids.Oghma_Infinium_ShotSpeed) and not GameState.Inventory.Oghma_Infinium_ShotSpeed then
        GameState.Inventory.Oghma_Infinium_ShotSpeed = true
        activations:ClearOghmaItems(player)
    end
    
    if player:HasCollectible(Ids.Oghma_Infinium_FireRate) and not GameState.Inventory.Oghma_Infinium_FireRate then
        GameState.Inventory.Oghma_Infinium_FireRate = true
        activations:ClearOghmaItems(player)
    end
    
    if player:HasCollectible(Ids.Oghma_Infinium_Luck) and not GameState.Inventory.Oghma_Infinium_Luck then
        GameState.Inventory.Oghma_Infinium_Luck = true
        activations:ClearOghmaItems(player)
    end
    
    if player:HasCollectible(Ids.Oghma_Infinium_Range) and not GameState.Inventory.Oghma_Infinium_Range then
        GameState.Inventory.Oghma_Infinium_Range = true
        activations:ClearOghmaItems(player)
    end
    
    if player:HasCollectible(Ids.Oghma_Infinium_Speed) and not GameState.Inventory.Oghma_Infinium_Speed then
        GameState.Inventory.Oghma_Infinium_Speed = true
        activations:ClearOghmaItems(player)
    end
end

function TBotD.GetGameState()
    return GameState
end

function TBotD.SetGameState(gs)
    GameState = gs
end

function TBotD.GetIds()
    return Ids
end

function TBotD.GetConst()
    return Const
end

--[[                     ]]--
--[[  CallBacks Section  ]]--
--[[                     ]]--


Isaac.DebugString("TBotD: Starting Callbacks")

--Update Cache Event
function TBotD:OnCache(player, cacheFlag)
    --[[Damage Cache]]--
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(Ids.Ebony_Blade) then
            if GameState.Inventory.Ebony_Blade then
                player.Damage = player.Damage + GameState.Ebony_Blade.Damage
            end
        else
            if GameState.Inventory.Ebony_Blade then
                GameState.Inventory.Ebony_Blade = false
            end
        end
        if player:HasCollectible(Ids.Oghma_Infinium_Damage) then
            player.Damage = player.Damage + Const.Oghma_Infinium.DAMAGE
        end
    end
    
    --[[Shot Speed Cache]]--
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        if player:HasCollectible(Ids.Oghma_Infinium_ShotSpeed) then
            player.ShotSpeed = player.ShotSpeed + Const.Oghma_Infinium.SHOTSPEED
        end
    end
    
    --[[Fire Delay Cache]]--
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        if player:HasCollectible(Ids.Oghma_Infinium_FireRate) then
            if player.MaxFireDelay >= Const.Values.MIN_TEAR_DELAY + Const.Oghma_Infinium.TEARDELAY then
                player.MaxFireDelay = player.MaxFireDelay - Const.Oghma_Infinium.TEARDELAY
            else
                player.MaxFireDelay = Const.Values.MIN_TEAR_DELAY
            end
        end
    end
    
    --[[Range Cache]]--
    if cacheFlag == CacheFlag.CACHE_RANGE then
        if player:HasCollectible(Ids.Oghma_Infinium_Range) then
            player.TearFallingSpeed = player.TearFallingSpeed + Const.Oghma_Infinium.RANGE
        end
    end
    
    --[[Speed Cache]]--
    if cacheFlag == CacheFlag.CACHE_SPEED then
        if player:HasCollectible(Ids.Oghma_Infinium_Speed) then
            player.MoveSpeed = player.MoveSpeed + Const.Oghma_Infinium.SPEED
        end
    end
    
    --[[Luck Cache]]--
    if cacheFlag == CacheFlag.CACHE_LUCK then
        --Mehrune's Razor
        if player:HasCollectible(Ids.Mehrunes_Razor) then 
            activations:GetMehrunesRazor(player)
        end
        --Oghma Infinium - Luck
        if player:HasCollectible(Ids.Oghma_Infinium_Luck) then
            player.Luck = player.Luck + Const.Oghma_Infinium.LUCK
        end
    end
    
    --[[Familiar Cache]]--
    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
        if player:HasCollectible(Ids.Ebony_Blade) then
            for index, entity in pairs(Isaac.GetRoomEntities()) do
                if entity.Type == EntityType.ENTITY_FAMILIAR then
                    if entity.Variant == FamiliarVariant.BLUE_FLY or entity.Variant == FamiliarVariant.BLUE_SPIDER then
                        Isaac.DebugString("Was Bluefly or Bluespider")
                    else
                        local familiar = entity:ToFamiliar()
                        for index, variant in pairs(GameState.Ebony_Blade.Followers) do
                            if familiar.Variant == variant then
                                familiar:BloodExplode()
                                familiar:Kill()
                                familiar:Remove()
                                familiar:RemoveFromFollowers()
                                familiar:RemoveFromOrbit()
                                familiar:RemoveFromDelayed()
                                Isaac.DebugString("TBotD: Attempting to kill the follower")
                            else
                                Isaac.DebugString("TBotD: Variant was different")
                            end
                        end
                    end
                end
            end
        end
    end
    
    
end
TBotD:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TBotD.OnCache)

--On Game Start Event
function TBotD:OnPlayerInit()
    GameState = stateFunc:Init(json.decode(TBotD:LoadData()))
end
TBotD:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, TBotD.OnPlayerInit)

--On Game Exit Event
function TBotD:OnExit()
    TBotD:SaveData(json.encode(GameState))
end
TBotD:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, TBotD.OnExit)
TBotD:AddCallback(ModCallbacks.MC_POST_GAME_END, TBotD.OnExit)

--On Update Event
function TBotD:UpdateEvent()
    local player = game:GetPlayer(0)
    if game:GetFrameCount() == 1 then
		--Resets the Default GameState
        GameState = stateFunc.ResetDefaults()
        
        --Validates the Item Ids
        for index, id in pairs(Ids) do
            Isaac.DebugString("TBotD: ID Validated as " .. tostring(id))
        end
        
        Isaac.DebugString("TBotD: Spawning Razor")
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetItemIdByName("Lucky Foot"), Vector(80,160), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Mehrunes_Razor, Vector(120,160), Vector(0,0), nil)
        
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetItemIdByName("Brother Bobby"), Vector(240,160), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Ebony_Blade, Vector(200,160), Vector(0,0), nil)
        
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Masque_of_Clavicus_Vile, Vector(160,160), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Oghma_Infinium, Vector(280,160), Vector(0,0), nil)
    end
        
    TBotD:UpdatePlayer(player)
end
TBotD:AddCallback(ModCallbacks.MC_POST_UPDATE, TBotD.UpdateEvent)

--On Pickup Event
function TBotD:PickupEvent()
end
TBotD:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, TBotD.PickupEvent)

--Caled when an entity is damaged
function TBotD:TakeDamageEvent(damaged, amount, damageFlag, source, countdownFrames)
    Isaac.DebugString("TBotD: Damaged Entity Event Fired")    
    if damaged:IsActiveEnemy(false) then
        if source.Type == EntityType.ENTITY_TEAR then
            Isaac.DebugString("TBotD: Getting Entity")
            local entity = source.Entity
            if entity.SpawnerType == EntityType.ENTITY_PLAYER then
                Isaac.DebugString("TBotD: Getting Tear")
                local tear = entity:ToTear()
                Isaac.DebugString("TBotD: Getting Player")
                local player = game:GetPlayer(0)
                if player:HasCollectible(Ids.Mehrunes_Razor) then
                    Isaac.DebugString("Parent of the Source has the Razor!")
                    if damaged:IsVulnerableEnemy() then
                        local rand = math.random(Const.Mehrunes_Razor.MAX_RANGE)
                        if damaged:IsBoss() then
                            if rand <= GameState.Mehrunes_Razor.Boss_Value then
                                damaged:BloodExplode()
                                damaged:AddHealth(damaged.HitPoints * -1)
                            end
                        else
                            if rand <= GameState.Mehrunes_Razor.Enemy_Value then
                                damaged:BloodExplode()
                                damaged:AddHealth(damaged.HitPoints * -1)
                            end
                        end
                    end
                end
            end
        end
    end
end
TBotD:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, TBotD.TakeDamageEvent)

function TBotD:NewRoomEvent()
    local player = game:GetPlayer(0)
    if player:HasCollectible(Ids.Masque_of_Clavicus_Vile) then
        local count = 0
        for index, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy() and not entity:IsBoss() then
                if entity:HasEntityFlags(EntityFlag.FLAG_CHARM) then
                    count = count + 1
                end
            end
        end
        for index, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy() and not entity:IsBoss() then
                if not entity:HasEntityFlags(EntityFlag.FLAG_CHARM) and count < Const.Ebony_Blade.MAX_FOLLOWERS then
                    entity:AddCharmed(-1)
                    return
                end
            end
        end
    end
end
TBotD:AddCallback(ModCallbacks.MC_POST_NEW_ROOM , TBotD.NewRoomEvent)