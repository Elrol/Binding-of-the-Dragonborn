local activations = {}
local Ids = {}
local Const = {}

function activations:init(const, ids)
    Const = const
    Ids = ids
end

--Called when Mehrune's Razor is picked up
function activations:GetMehrunesRazor(player)
    local luck = player.Luck
    local GameState = TBotD:GetGameState()

    if luck >= 0 then
        luck = luck +1
        GameState.Mehrunes_Razor.Enemy_Value = Const.Mehrunes_Razor.ENEMY_VALUE * luck
        GameState.Mehrunes_Razor.Boss_Value = Const.Mehrunes_Razor.BOSS_VALUE * luck
    else
        luck = player.luck * -1.0
        GameState.Mehrunes_Razor.Enemy_Value = Const.Mehrunes_Razor.ENEMY_VALUE / luck
        GameState.Mehrunes_Razor.Boss_Value = Const.Mehrunes_Razor.BOSS_VALUE / luck
    end
end

--Called when Oghma Infinium is picked up
function activations:GetOghmaInfinium(player)
    if not player:HasCollectible(Ids.Oghma_Infinium_Damage) then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Oghma_Infinium_Damage, Vector(240,280), Vector(0,0), nil)
    end
    if not player:HasCollectible(Ids.Oghma_Infinium_FireRate) then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Oghma_Infinium_FireRate, Vector(280,200), Vector(0,0), nil)
    end
    if not player:HasCollectible(Ids.Oghma_Infinium_ShotSpeed) then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Oghma_Infinium_ShotSpeed, Vector(360,200), Vector(0,0), nil)
    end
    if not player:HasCollectible(Ids.Oghma_Infinium_Luck) then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Oghma_Infinium_Luck, Vector(400,280), Vector(0,0), nil)
    end
    if not player:HasCollectible(Ids.Oghma_Infinium_Range) then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Oghma_Infinium_Range, Vector(280,360), Vector(0,0), nil)
    end
    if not player:HasCollectible(Ids.Oghma_Infinium_Speed) then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Ids.Oghma_Infinium_Speed, Vector(360,360), Vector(0,0), nil)
    end
end

function activations:ClearOghmaItems(player)
    local GameState = TBotD:GetGameState()
    for index, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            if entity.SubType == Ids.Oghma_Infinium_Damage or entity.SubType == Ids.Oghma_Infinium_FireRate or entity.SubType == Ids.Oghma_Infinium_Luck or entity.SubType == Ids.Oghma_Infinium_Range or entity.SubType == Ids.Oghma_Infinium_ShotSpeed or entity.SubType == Ids.Oghma_Infinium_Speed or entity.SubType == 0 then
                entity:Remove()
            end
        end
    end
    player:RemoveCollectible(Ids.Oghma_Infinium)
    GameState.Inventory.Oghma_Infinium = false
end

--Called when the Ebony Blade is used
function activations:UseEbonyBlade()
    local player = game:GetPlayer(0)
    local GameState = TBotD:GetGameState()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if(entity.Type == EntityType.ENTITY_FAMILIAR) then
            local familiar = entity:ToFamiliar()
            if familiar.Variant == FamiliarVariant.BLUE_FLY or familiar.Variant == FamiliarVariant.BLUE_SPIDER then
                --Spider stuff
            else
                f = GameState.Ebony_Blade.Followers
                table.insert(f, familiar.Variant)
                GameState.Ebony_Blade.Followers = f
                GameState.Ebony_Blade.Damage = GameState.Ebony_Blade.Damage + 2
                familiar:BloodExplode()
                familiar:Kill()
                familiar:Remove()
                familiar:RemoveFromFollowers()
                familiar:RemoveFromOrbit()
                familiar:RemoveFromDelayed()
                
                return 
            end
        end
    end
end

TBotD:AddCallback(ModCallbacks.MC_USE_ITEM, activations.UseEbonyBlade, Ids.Ebony_Blade)

return activations
