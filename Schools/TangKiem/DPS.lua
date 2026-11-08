-- Vấn Thủy Quyết (10144 - Khinh Kiếm tích kiếm khí) & Sơn Cư Kiếm Ý (10145 - Trọng Kiếm xả kiếm khí).
-- Kỹ năng: Mai Ẩn Hương, Khiếu Nhật, Tuyết Đoạn Kiều,
-- Vân Phi Ngọc Hoàng, Tịch Chiếu Lôi Phong, Thính Lôi,
-- Đoạn Triều, Cửu Khê Di Yên.
local light = [[
/skill [distance<=8,xmtnobuff:Mai Ẩn Hương] Mai Ẩn Hương
/skill [distance<=4] Đoạn Triều
/skill [distance<=4] Thính Lôi
/skill [distance<=8] Cửu Khê Di Yên
]]
local heavy = [[
/skill [distance<=8,xmtnobuff:Mai Ẩn Hương] Mai Ẩn Hương
/skill [distance<=8,rage<20] Tuyết Đoạn Kiều
/skill [distance<=4] Đoạn Triều
/skill [distance<=8,rage>=20] Vân Phi Ngọc Hoàng
/skill [distance<=8,rage>=20] Tịch Chiếu Lôi Phong
/skill [distance<=4] Thính Lôi
]]

local function LightSword(player)
    local energy = player.nCurrentRage or 0
    local maxEnergy = player.nMaxRage or 0
    if maxEnergy > 0 and energy >= maxEnergy * 0.90 then
        return "/skill [distance<=4] Khiếu Nhật\n" .. light
    end
    return light
end

local function HeavySword(player)
    if player.nCurrentRage and player.nCurrentRage < 15 then
        return "/skill [distance<=4] Khiếu Nhật\n" .. heavy
    end
    return heavy
end

xMacro.Schools.RegisterDamageScript("TangKiem", "DPS", {
    [10144] = LightSword,
    [10145] = HeavySword,
})
