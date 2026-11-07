-- Verified That Tu Bang Tam Quyet v80 rotation for xMacro (No Giang Hai Ngung Quang).

local DEFAULT_THATTU_BANGTAM_MACRO = [[
#name ThatTu_BangTam_80
#tip Macro That Tu Bang Tam v80: Dai Huyen Cap Khuc tu no Cap Khuc (Khong dung Giang Hai Ngung Quang)

/config channel-on
/wpwatch U Nguyệt-Loạn Hoa|Phất Khởi Long Y|Thủy Thông Thiết|10|1.5|U Nguyệt-Loạn Hoa|4
/procwatch U Nguyệt-Loạn Hoa|Kiếm Khí Trường Giang|Đại Huyền Cấp Khúc

/config before:[xmnobuff:U Nguyệt-Loạn Hoa]
/usependant [xmtbuffstack:Cấp Khúc>=3]
/skill [xmtbuffstack:Cấp Khúc>=3] Phồn Âm Cấp Tiết

/skill [mana<0.85] Long Trì Nhạc
/skill [qidian<=2] Mãn Đường Thế
/skill [qidian>0,mana>0.15,distance<10] Kiếm Thần Vô Ngã

/skill [qidian>=7] Kiếm Phá Hư Không
/skill [qidian>=4,xmtbuffstack:Cấp Khúc>=3] Kiếm Khí Trường Giang

/skill [xmnobuff:Thủy Thông Thiết] Đại Huyền Cấp Khúc
/skill [xmbufftime:Thủy Thông Thiết>1.5] Đại Huyền Cấp Khúc
/config before:null
]]

local function CreateBangTam(deps)
    local H = xMacro.Schools.BuildCombatHelpers(deps)
    local ExecuteMacroCommand = _G.ExecuteMacroCommand
    local XMCore_UseEquipSlot = deps.XMCore_UseEquipSlot
    local XMCore_Sys = deps.XMCore_Sys
    local tSkillCastFrame = deps.tSkillCastFrame

    local ID_CAP_KHUC = {[2920] = true}
    local NAME_CAP_KHUC = {"Cấp Khúc", "Cap Khuc", "急曲"}
    local ID_KIEM_THAN = {[559] = true}
    local NAME_KIEM_THAN = {"Kiếm Thần Vô Ngã", "Kiem Than Vo Nga", "剑神无我"}

    local function Run(szName)
        local me = GetClientPlayer()
        if not me then return false end

        -- 1. Neu truyen truc tiep chuoi lenh Macro co '/'
        if szName and type(szName) == "string" and szName ~= "" and szName ~= "auto" and string.find(szName, "/") then
            if ExecuteMacroCommand then
                local ok, ret = pcall(ExecuteMacroCommand, szName)
                if ok and ret then return true end
            end
        end

        -- 2. Kiem tra bao ve channeling Dai Huyen Cap Khuc: khong ngat chieu
        if me.GetOTActionState and me.GetOTActionState() ~= 0 then
            return false
        end

        local tar = H.GetCurrentTargetObject()
        if not tar or tar.bDeathFlag or (tar.dwID and tar.dwID == me.dwID) then
            return false
        end

        local nQiDian = tonumber(me.nAccumulateValue or 0) or 0
        local nMana = (me.nMaxMana and me.nMaxMana > 0) and (me.nCurrentMana / me.nMaxMana) or 1
        
        -- Tinh toan khoang cach toi muc tieu (ho tro ca (me, tar) hoac (tar))
        local nDist = 999
        if tar and me then
            local d = H.GetDistanceByTarget(me, tar)
            if d and type(d) == "number" then
                nDist = d
            else
                local d2 = H.GetDistanceByTarget(tar)
                if d2 and type(d2) == "number" then
                    nDist = d2
                end
            end
        end

        local skDaiHuyen = H.ResolveSkill(545, "Đại Huyền Cấp Khúc", "Dai Huyen Cap Khuc")
        local skKiemPha = H.ResolveSkill(548, "Kiếm Phá Hư Không", "Kiem Pha Hu Khong")
        local skKiemKhi = H.ResolveSkill(550, "Kiếm Khí Trường Giang", "Kiem Khi Truong Giang")
        local skPhonAm = H.ResolveSkill(551, "Phồn Âm Cấp Tiết", "Phon Am Cap Tiet")
        local skLongTri = H.ResolveSkill(552, "Long Trì Nhạc", "Long Tri Nhac")
        local skManDuong = H.ResolveSkill(553, "Mãn Đường Thế", "Man Duong The")
        local skKiemThan = H.ResolveSkill(559, "Kiếm Thần Vô Ngã", "Kiem Than Vo Nga")

        -- Dem so tang Cap Khuc tren target
        local bCapKhuc = H.FindBuff(tar, me, ID_CAP_KHUC, NAME_CAP_KHUC, true)
        local nCapKhucStack = bCapKhuc and tonumber(bCapKhuc.nStackNum or 1) or 0

        -- A. Hoi Mana & Kiem Khi
        if nMana < 0.85 and H.IsSkillReady(me, skLongTri, 16) then
            return H.SendSkill(me, skLongTri, "Long Trì Nhạc", false)
        end
        if nQiDian <= 2 and H.IsSkillReady(me, skManDuong, 16) then
            return H.SendSkill(me, skManDuong, "Mãn Đường Thế", false)
        end

        -- B. Burst: Phon Am Cap Tiet + Day chuyen khi du 3 tang Cap Khuc
        if nCapKhucStack >= 3 and H.IsSkillReady(me, skPhonAm, 24) then
            return H.SendSkill(me, skPhonAm, "Phồn Âm Cấp Tiết", true)
        end

        -- C. Kiem Than Vo Nga (ID 559): duy tri xung quanh khi khoang cach <= 10m
        if nQiDian > 0 and nMana > 0.15 and nDist <= 10 and H.IsSkillReady(me, skKiemThan, 16) then
            local bHasKiemThan = H.FindBuff(me, me, ID_KIEM_THAN, NAME_KIEM_THAN, true)
            local nRemain = bHasKiemThan and H.BuffRemainingSec(bHasKiemThan) or 0
            if not bHasKiemThan or nRemain <= 1.0 then
                return H.SendSkill(me, skKiemThan, "Kiếm Thần Vô Ngã", false)
            end
        end

        -- D. Chieu sat thuong chinh: Kiem Pha Hu Khong (qidian >= 7)
        if nQiDian >= 7 and H.IsSkillReady(me, skKiemPha, 8) then
            return H.SendSkill(me, skKiemPha, "Kiếm Phá Hư Không", false)
        end

        -- E. Kiem Khi Truong Giang khi co 3 stack Cap Khuc (qidian >= 4)
        if nQiDian >= 4 and nCapKhucStack >= 3 and H.IsSkillReady(me, skKiemKhi, 8) then
            return H.SendSkill(me, skKiemKhi, "Kiếm Khí Trường Giang", false)
        end

        -- F. Dai Huyen Cap Khuc: Giu stack & tu kich no (khong dung Giang Hai Ngung Quang)
        if H.IsSkillReady(me, skDaiHuyen, 4) then
            return H.SendSkill(me, skDaiHuyen, "Đại Huyền Cấp Khúc", false)
        end

        -- G. Fallback text macro neu can
        if ExecuteMacroCommand then
            return ExecuteMacroCommand(DEFAULT_THATTU_BANGTAM_MACRO)
        end

        return false
    end

    return {run = Run, defaultScript = DEFAULT_THATTU_BANGTAM_MACRO}
end

xMacro = xMacro or {}
xMacro.SchoolFactories = xMacro.SchoolFactories or {}
xMacro.SchoolFactories.ThatTu = xMacro.SchoolFactories.ThatTu or {}
if xMacro.SchoolProfiles and xMacro.SchoolProfiles.ThatTu then
    xMacro.SchoolProfiles.ThatTu.BangTam = nil
end
xMacro.SchoolFactories.ThatTu.BangTam = CreateBangTam
