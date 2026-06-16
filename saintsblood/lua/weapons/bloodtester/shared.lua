SWEP.PrintName = "Blood Tester"
SWEP.Author = "SinningSaint"
SWEP.Purpose = "Used to give all information needed about a persons blood!"
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
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    local ownereye = owner:GetEyeTrace()
    local ent = ownereye.Entity
    if ent:IsValid() and ent:IsNPC() or ent:IsPlayer() then
        self:CheckingBlood(ent,owner)
        self:SetNextPrimaryFire(CurTime() + 10)
        ent:TakeDamage(1)
    end 
end

function SWEP:SecondaryAttack()
    local owner = self:GetOwner()
    if owner:IsValid() then
        self:CheckingBlood(owner,owner)
        self:SetNextPrimaryFire(CurTime() + 10)
        owner:TakeDamage(1)
    end 
end
function SWEP:CheckingBlood(ent,ply)
    local id = ent:EntIndex()
    local nameToPassTime = id.."ToPassTime"
    local nameToCheckIfStillActive = id.."ToCheckIfStillActive"
    local nameToShowBloodData = id.."ToShowBloodData"
    local bloodtype = ent.sbloodtype
    timer.Create(nameToCheckIfStillActive, 0.1, 0, function()
        if ply:GetActiveWeapon() != self or ply:GetPos():DistToSqr(ent:GetPos()) > 15000 then
            timer.Remove(nameToPassTime)
            timer.Remove(nameToCheckIfStillActive)
            timer.Remove(nameToShowBloodData)
            ply:ChatPrint("Blood analysis interrupted")
        end
    end)
    local TimeNeededToPass = 1
    local TimePassed = 1
    ply:ChatPrint("----------------\nINITIALIZING")
    timer.Create(nameToPassTime, 1, TimeNeededToPass, function()
        ply:ChatPrint("INITIALIZING . . . . . ".. TimePassed )
        TimePassed = TimePassed + 1
    end)
    timer.Create(nameToShowBloodData, TimeNeededToPass, 1, function()
        ply:ChatPrint("INITIALIZED\n----------------")
        ply:ChatPrint("Blood Type: ".. bloodtype.name)
        ply:ChatPrint("Antigenes: ".. bloodtype.antigens)
        ply:ChatPrint("Antibody: ".. bloodtype.antibody)
        timer.Remove(nameToCheckIfStillActive)

    end)
end