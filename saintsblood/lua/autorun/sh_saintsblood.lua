
SaintsBloodTypes = {
    {
        name = "O-", -- blood type name
        bloodtype = "O",
        weight = 1, -- Chance to attain this blood type, RHFactor Negitive is rarer, O- is the rarest.
        antibody = "None", -- Means it doesn't give to those types
        antigens = "None", -- Means it takes from those types
        RHFactor = true -- Means is it - or +
    },
    {
        name = "O+",
        bloodtype = "O",
        weight = 29,
        antibody = "None",
        antigens = "None",
        RHFactor = false 
    },
    {
        name = "A+",
        bloodtype = "A",
        weight = 21,
        antibody = "B",
        antigens = "A",
        RHFactor = false 
    },
    {
        name = "A-",
        bloodtype = "A",
        weight = 7,
        antibody = "B",
        antigens = "A",
        RHFactor = true 
    },
    {
        name = "B+",
        bloodtype = "B",
        weight = 21,
        antibody = "A",
        antigens = "B",
        RHFactor = false 
    },
    {
        name = "B-",
        bloodtype = "B",
        weight = 7,
        antibody = "A",
        antigens = "B",
        RHFactor = true 
    },
    {
        name = "AB+",
        bloodtype = "AB",
        weight = 21,
        antibody = "All",
        antigens = "All",
        RHFactor = false 
    },
    {
        name = "AB-",
        bloodtype = "AB",
        weight = 7,
        antibody = "All",
        antigens = "All",
        RHFactor = true 
    },
    
}

concommand.Add("ResetSaintsBlood", function(ply)

    local id = ply:EntIndex()
    local nameToBloodTransferCheck = id.."ToBloodTransferCheck"
    local nameToBloodTransfer = id.."ToBloodTransfer"
    timer.Remove(nameToBloodTransferCheck)
    timer.Remove(nameToBloodTransfer)

    ply.GettingOrGivingBlood = nil
    ply.HasBloodTransfuer = false
    ply.IsInTransfusion = false

    net.Start("ToConveyBloodTransfusion")
    net.Broadcast()

end)