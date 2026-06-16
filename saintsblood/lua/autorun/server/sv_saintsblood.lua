AddCSLuaFile()

util.AddNetworkString("ToConveyBloodTransfusion")

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

hook.Add("ToStartTransfusion", "SaintBloodTransfusion", function(target1 , target2)
    local boneName = "ValveBiped.Bip01_R_UpperArm" 
    local ArmBoneTarget1 = target1:LookupBone(boneName)
    local ArmBoneTarget2 = target1:LookupBone(boneName)
    local localPos1 = ArmBoneTarget1 and target1:GetBonePosition(ArmBoneTarget1) and target1:WorldToLocal(target1:GetBonePosition(ArmBoneTarget1)) or vector_origin
    local localPos2 = ArmBoneTarget2 and target2:GetBonePosition(ArmBoneTarget2) and target2:WorldToLocal(target2:GetBonePosition(ArmBoneTarget2)) or vector_origin

    local length = (target1:GetPos() - target2:GetPos()):Length()
    if length > 100 then return end
    length = length + 100
    local BloodTransfusionConstraint, BloodTransfusionRope = constraint.Rope(target1, target2, 0, 0, localPos1, localPos2, length, 0, 0, 1, "cable/cable2", false, Color(255,0,0,187))
    target1.HasBloodTransfuer = true
    target2.HasBloodTransfuer = true
    
    target1.GettingOrGivingBlood = "donating"
    target2.GettingOrGivingBlood = "receiving"

    net.Start("ToConveyBloodTransfusion")
        net.WriteEntity(target1)
        net.WriteString(target1.GettingOrGivingBlood)
        net.WriteEntity(target2)
        net.WriteString(target2.GettingOrGivingBlood)
    net.Broadcast()

    local id1 = target1:EntIndex()
    local nameToBloodTransferCheck = id1.."ToBloodTransferCheck"
    local nameToBloodTransfer = id1.."ToBloodTransfer"
    timer.Create(nameToBloodTransferCheck, 1, 0, function()
        local NoLongerValid = false
        if not target1.HasBloodTransfuer then NoLongerValid = true end
        if not target1:IsValid() or not target2:IsValid() then NoLongerValid = true end
        if not target1:Alive() or not target2:Alive() then  NoLongerValid = true end
        if (target1:GetPos():DistToSqr(target2:GetPos()) > 8000) then NoLongerValid = true end

        if NoLongerValid then
            timer.Remove(nameToBloodTransferCheck) 
            timer.Remove(nameToBloodTransfer)
            if BloodTransfusionRope then
                BloodTransfusionRope:Remove()
            end
            target1.HasBloodTransfuer = false 
            target2.HasBloodTransfuer = false
            net.Start("ToConveyBloodTransfusion")
            net.Broadcast()
        end
    end)
    timer.Create(nameToBloodTransfer, 1, 0, function()
        EffectsOfBloodTransfer(target1, target2)
    end)

end)

function EffectsOfBloodTransfer(Donate, Receive)
    if Donate.HasBloodTransfuer and Receive.HasBloodTransfuer then
        
        local DonateBlood = Donate.sbloodtype
        local ReceiveBlood = Receive.sbloodtype
        local compatible

        if ReceiveBlood.name == DonateBlood.name then compatible = true 
        elseif ReceiveBlood.bloodtype == DonateBlood.bloodtype and not DonateBlood.RHFactor then compatible = true 
        elseif not ReceiveBlood.bloodtype == DonateBlood.antibody or not DonateBlood.antibody == "All" then compatible = true 
        elseif ReceiveBlood.antigens == "All" and not ReceiveBlood.RHFactor then compatible = true 
        elseif ReceiveBlood.antigens == "All" and ReceiveBlood.RHFactor == DonateBlood.RHFactor then compatible = true 
        end
        
        if compatible then
            if Receive:Health() < Receive:GetMaxHealth() then
                Receive:SetHealth(Receive:Health() + 1)
            end
        else
            Receive:TakeDamage(5)
            if Receive:IsPlayer() then
                Receive:ChatPrint("It hurts...")
                Receive:SetRunSpeed(Receive:GetRunSpeed() / 2)
            end
            
        end
        Donate:TakeDamage(1)
        
    else
        return
    end
end

hook.Add("PlayerDeath", "ToResetEverything", function(ply)
    concommand.Run(ply, ResetSaintsBlood, ply)
end)