AddCSLuaFile()

local function AssignBloodType(ent)

   -- if ent.bloodtype then return end
    for i = 0, 1, 0 do
        local ChoosingARandomBlood = math.random(1,7)
        local BloodTypeTable = SaintsBloodTypes
        local ChosenRandomBlood = BloodTypeTable[ChoosingARandomBlood]
        local weight = ChosenRandomBlood.weight
        if math.random(0,100) <= weight then
            ent.sbloodtype = ChosenRandomBlood
            break
        else
            ent.sbloodtype = ChosenRandomBlood
        end
    end
 
end

hook.Add("OnEntityCreated", "ToCheckIfPlayerOrNPC", function(ent)

    if not ent:IsValid() then return end

    if ent:IsPlayer() or ent:IsNPC() then
        AssignBloodType(ent)
    end

end)