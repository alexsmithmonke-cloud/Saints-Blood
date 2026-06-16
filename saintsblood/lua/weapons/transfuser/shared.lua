SWEP.PrintName = "Blood transfuser"
SWEP.Author = "SinningSaint"
SWEP.Purpose = "To share blood!"
SWEP.Category = "Blood - Types"
SWEP.DrawCrosshair = false 
SWEP.UseHands = true


SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:SetHoldType("pistol")
end 

function SWEP:Deploy()
    self:SetNextPrimaryFire(CurTime())
    self.target1 = nil
    self.target2 = nil
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    local ownereye = owner:GetEyeTrace()
    local target = ownereye.Entity
    if target:IsNPC() or target:IsPlayer() then
        if target:GetPos():DistToSqr(owner:GetPos()) > 8000 then return end
        if self.target1 and target != self.target1 then
            self.target2 = target
        else
            self.target1 = target
        end
    end
    if self.target2 then
        hook.Run("ToStartTransfusion", self.target1, self.target2)
        self.target1,self.target2 = nil
    end
end

function SWEP:SecondaryAttack()
    local owner = self:GetOwner()
    local target = owner
    if target:IsNPC() or target:IsPlayer() then
        if target:GetPos():DistToSqr(owner:GetPos()) > 8000 then return end
        if self.target1 and target != self.target1 then
            self.target2 = target
        else
            self.target1 = target
        end
    end
    if self.target2 then
        hook.Run("ToStartTransfusion", self.target1, self.target2)
        self.target1,self.target2 = nil
    end
end