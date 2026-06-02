
SaintsBloodTypes = {
    {
        name = "O-", -- blood type name
        weight = 1, -- Chance to attain this blood type, RHFactor Negitive is rarer, O- is the rarest.
        antibody = "None", -- Means it doesn't give to those types
        antigens = "None", -- Means it takes from those types
        RHFactor = true -- Means is it - or +
    },
    {
        name = "O+",
        weight = 29,
        antibody = "None",
        antigens = "None",
        RHFactor = false 
    },
    {
        name = "A+",
        weight = 21,
        antibody = "B",
        antigens = "A",
        RHFactor = false 
    },
    {
        name = "A-",
        weight = 7,
        antibody = "B",
        antigens = "A",
        RHFactor = true 
    },
    {
        name = "B+",
        weight = 21,
        antibody = "A",
        antigens = "B",
        RHFactor = false 
    },
    {
        name = "B-",
        weight = 7,
        antibody = "A",
        antigens = "B",
        RHFactor = true 
    },
    {
        name = "AB+",
        weight = 21,
        antibody = "None",
        antigens = "All",
        RHFactor = false 
    },
    {
        name = "AB-",
        weight = 7,
        antibody = "None",
        antigens = "All",
        RHFactor = true 
    },
    
}