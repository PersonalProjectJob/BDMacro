-- Vấn Thủy Quyết (10144 - Khinh Kiếm tích kiếm khí) & Sơn Cư Kiếm Ý (10145 - Trọng Kiếm xả kiếm khí).
-- Kỹ năng: Mai Ẩn Hương (1649), Khiếu Nhật (1656), Tuyết Đoạn Kiều (1609),
-- Vân Phi Ngọc Hoàng (1593), Tịch Chiếu Lôi Phong (1592), Thính Lôi (1646),
-- Đoạn Triều (1600), Cửu Khê Di Yên (1579).
local light = [[
/skill [distance<=8,xmtnobuff:1649] 1649
/skill [distance<=4] 1600
/skill [distance<=4] 1646
/skill [distance<=8] 1579
]]
local heavy = [[
/skill [distance<=8,xmtnobuff:1649] 1649
/skill [distance<=8,rage<20] 1609
/skill [distance<=4] 1600
/skill [distance<=8,rage>=20] 1593
/skill [distance<=8,rage>=20] 1592
/skill [distance<=4] 1646
]]

local function LightSword(player)
    local energy = player.nCurrentRage or 0
    local maxEnergy = player.nMaxRage or 0
    if maxEnergy > 0 and energy >= maxEnergy * 0.90 then
        return "/skill [distance<=4] 1656\n" .. light
    end
    return light
end

local function HeavySword(player)
    if player.nCurrentRage and player.nCurrentRage < 15 then
        return "/skill [distance<=4] 1656\n" .. heavy
    end
    return heavy
end

xMacro.Schools.RegisterDamageScript("TangKiem", "DPS", {
    [10144] = LightSword,
    [10145] = HeavySword,
})
