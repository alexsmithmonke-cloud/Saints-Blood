AddCSLuaFile()



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
