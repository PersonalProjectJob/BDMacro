-- Vấn Thủy builds sword energy, Sơn Cư spends it. Skill 1656 is Khiếu Nhật.
-- Stance IDs and base skills cross-checked against DKMacro/TangKiem.lua.
local light = [[
/skill [distance<=4] 1646
/skill [distance<=8] 1579
]]
local heavy = [[
/skill [distance<=8,rage>=20] 1593
/skill [distance<=8,rage>=20] 1600
/skill [distance<=4] 1646
]]

local function LightSword(player)
    local energy = player.nCurrentRage or 0
    local maxEnergy = player.nMaxRage or 0
    if maxEnergy > 0 and energy >= maxEnergy * 0.95 then
        return "/skill [distance<=4] 1656\n" .. light
    end
    return light
end

local function HeavySword(player)
    if player.nCurrentRage and player.nCurrentRage < 20 then
        return "/skill [distance<=4] 1656\n" .. heavy
    end
    return heavy
end

xMacro.Schools.RegisterDamageScript("TangKiem", "DPS", {
    [10144] = LightSword,
    [10145] = HeavySword,
})
