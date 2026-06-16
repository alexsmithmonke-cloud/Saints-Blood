AddCSLuaFile()

surface.CreateFont( "SaintsBloodText", {
            font = "Arial",
            extended = false,
            size = 25,
            weight = 500,
            blursize = 0,
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false,
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = false,
            additive = false,
            outline = false,
}   )


hook.Add("PostDrawTranslucentRenderables", "ToMakeHealthBars", function()
    local ply = LocalPlayer()
    local allents = ents.GetAll()
    if ply:Alive() and ply:IsValid() then
        for _, ent in pairs(allents) do
            local entname = ent:GetClass()
            if ent:IsPlayer() and not ent == ply or ent:IsNPC() then
                local entposabovehead = ent:GetPos() + ent:GetUp() * (ent:OBBMaxs().z + 5)
                local entang = ent:GetAngles()
                entang:RotateAroundAxis(ent:GetForward(), 90)
                entang:RotateAroundAxis(ent:GetUp(), 90)
                local playereyeangeles = ply:EyeAngles()
                cam.Start3D2D(entposabovehead,entang, 0.1)
                    draw.WordBox(4,0,0,ent:Health(), "NormalText", Color(0,0,0), Color(255,255,255))
                cam.End3D2D()
            end
        end
    end
end)

net.Receive("ToConveyBloodTransfusion", function()
    local target1 = net.ReadEntity()
    local GiveorGet1 = net.ReadString()
    local target2 = net.ReadEntity()
    local GiveorGet2 = net.ReadString()
    local ply = LocalPlayer()
    if target1 == ply then
        ply.IsInTransfusion = true
        ply.GettingOrGivingBlood = GiveorGet1
    elseif target2 == ply then
        ply.IsInTransfusion = true
        ply.GettingOrGivingBlood = GiveorGet2
    else 
        ply.IsInTransfusion = false
    end
end)

hook.Add("HUDPaint", "ToDrawBloodTransfusionStatus", function()

    local ply = LocalPlayer()
    local ScreenW = ScrW()
    local ScreenH = ScrH()
    local LengthOfBox = 250
    local HeightOfBox = 50
    local PosX = ScreenW / 2 - LengthOfBox / 2
    local PosY = ScreenH / 2 + 500
    local PlyInTransfusion =  ply.IsInTransfusion
    if PlyInTransfusion then
        draw.RoundedBox(10, PosX, PosY, LengthOfBox,HeightOfBox, Color(145,142,142,115))
        draw.DrawText("You are "..ply.GettingOrGivingBlood.." blood", "SaintsBloodText", PosX + LengthOfBox / 2, PosY + HeightOfBox / 4, Color(0,0,0), TEXT_ALIGN_CENTER )
    end

end)