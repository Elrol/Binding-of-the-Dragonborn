local State = {}
local GameState = {}

function State:Init(initState)
    GameState = initState
    if GameState.Inventory == nil then
        local I = {}
        I.Mehrunes_Razor = false
        I.Masque_of_Clavicus_Vile = false
        I.Oghma_Infinium = false
        I.Oghma_Infinium_Damage = false
        I.Oghma_Infinium_FireRate = false
        I.Oghma_Infinium_ShotSpeed = false
        I.Oghma_Infinium_Speed = false
        I.Oghma_Infinium_Luck = false
        I.Oghma_Infinium_Range = false
        I.Ring_of_Namira = false
        I.Saviors_Hide = false
        I.Ebony_Blade = false
        GameState.Inventory = I
    end
    
    if GameState.Ebony_Blade == nil then 
        local EB = {}
        EB.Damage = 2
        EB.Followers = {}
        GameState.Ebony_Blade = EB
    end

    if GameState.Mehrunes_Razor == nil then 
        local MR = {}
        MR.Boss_Value = 1
        MR.Enemy_Value = 10
        GameState.Mehrunes_Razor = MR
    end

    return GameState
end

function State:ResetDefaults()
    local GS = {}
    return State:Init(GS)
end

return State