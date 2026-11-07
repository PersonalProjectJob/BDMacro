-- GENERATED native entry; edit canonical modules, then rebuild.
local runtimeStatus = type(xMacro)=="table" and xMacro.Runtime
if type(runtimeStatus)~="table" or runtimeStatus.nativeLayout~="ordered-v1" then
    macro=function() return false end
    error("xMacro native bootstrap missing; combo disabled")
end
if runtimeStatus.nextNative ~= 6 then
    runtimeStatus.ready=false
    macro=function() return false end
    error("xMacro native load order invalid; combo disabled")
end
runtimeStatus.nextNative = 7
local function ReportStartup(message)
    if OutputMessage then pcall(OutputMessage, "MSG_SYS", "[xMacro 0.9.7] " .. message .. "\n") end
end
local unavailableReported = false
local function UnavailableMacro()
    if not unavailableReported then
        ReportStartup("Runtime NOT_READY; see LOAD_ERROR at addon startup")
        unavailableReported = true
    end
    return false
end
-- BEGIN Schools/NguDoc/DocKinh.lua
do
local function InitializeModule()
-- Verified Ngu Doc (Doc Kinh & Bo Thien Quyet) v80 rotations for xMacro.
local DEFAULT_NGUDOC_DOCKINH_MACRO = [[
#name NguDoc_DocKinh_80
#tip Macro Ngu Doc Doc Kinh PVE v80: Uu tien Linh Xa (Ao Kich) > Ngoc Thiem > Thanh Hat + 3 DoT + Hat Tam

-- 0. Bao ve ky nang dan dao & chi ngat Hat Tam khi di chuyen
/config channel-on
/skill [ota:Hạt Tâm,moving] stopota

-- 1. Tu cuu & Sinh ton khi nguy cap
/skill [life<0.5,pet] Cổ Trùng Cuồng Bạo

-- 2. Dieu khien Pet Linh Xa tan cong & Ao Kich (off-GCD)
/skill [pet:Linh Xà] Ảo Kích
/skill [pet] Tấn công

-- 3. Quan ly Pet & Co Trung Hien Te: Uu tien Linh Xa > Ngoc Thiem > Thanh Hat, co pet nao hien te pet do
/skill [nopet,nocd:Linh Xà Dẫn] Linh Xà Dẫn
/skill [nopet,nocd:Ngọc Thiềm Dẫn] Ngọc Thiềm Dẫn
/skill [nopet,nocd:Thánh Hạt Dẫn] Thánh Hạt Dẫn
/skill [pet] Cổ Trùng Hiến Tế
/usependant [buff:Linh Xà Hiến Tế]

-- 4. Co Trung & Ngat chieu Boss (off-GCD)
/skill [tprepare,tnobuff:Mê Tâm Cổ,tnobuff:Đoạt Mệnh Cổ,tnobuff:Khô Tàn Cổ] Mê Tâm Cổ
/skill [tprepare,tbuff:Khô Tàn Cổ] Hạt Tâm
/skill [mana<0.35,nombuff:Khô Tàn Cổ,nombuff:Đoạt Mệnh Cổ] Khô Tàn Cổ
/skill [nombuff:Đoạt Mệnh Cổ,nombuff:Khô Tàn Cổ] Đoạt Mệnh Cổ

-- 5. Chu trinh 3 DoT & Ky nang chu luc Doc Kinh
-- Uu tien Bach Tuc ngay khi hoi chieu (sat thuong tuc thoi + DoT manh nhat)
/skill [nocd:Bách Túc] Bách Túc
-- Duy tri DoT Xa Anh (tranh danh lap khi vua niem Xa Anh)
/skill [nombuff:Xà Ảnh,nolastcast:Xà Ảnh] Xà Ảnh
/skill [mbufftime:Xà Ảnh<2,nolastcast:Xà Ảnh] Xà Ảnh
-- Duy tri DoT Thiem Khieu (hoi mana khi co Đoạt Mệnh Cổ)
/skill [nombuff:Thiềm Khiếu] Thiềm Khiếu

-- 6. Di chuyen (Instant Cast + hoi mana khi co Khô Tàn Cổ)
/skill [moving] Thiên Ti
/skill [mana<0.25,tbuff:Khô Tàn Cổ] Thiên Ti
/skill [moving] Xà Ảnh

-- 7. Filler DPS chinh khi dung yen (van cong 1.75s / 1.5s)
/skill [cd:Bách Túc] Hạt Tâm
]]

local DEFAULT_NGUDOC_BOTHIEN_MACRO = [[
#name NguDoc_BoThien_80
#tip Macro Ngu Doc Bo Thien Quyet v80: Bich Diep + Co Hoac Chung Sinh + Nu Oa + Tuy Vu / Bang Tam

-- 0. Bao ve ky nang dan dao (Thien Diep Tho Thuy 8s)
/config channel-on
/return [ota:Thiên Điệp Thổ Thụy]
/skill [ota:Băng Tàm Khiên Ti,moving] stopota

-- 1. Goi Bich Diep & Sinh ton ban than
/skill [nopet] Bích Điệp Dẫn
/skill [life<0.35] Nữ Oa Vá Trời
/skill [life<0.3,pet] Cổ Trùng Hiến Tế
/skill [mana<0.65,nocombat] Đỉnh Cổ Tiên Vương

-- 2. Cap cuu muc tieu nguy kich (Mau < 35%)
/skill [tlife<0.35] Thánh Thủ Chức Thiên
/skill [tlife<0.45] Thiên Điệp Thổ Thụy

-- 3. Buff Co Hoac Chung Sinh & Burst Nu Oa
/skill [tlife<0.85,tnobuff:Cổ Hoặc Chúng Sinh] Cổ Hoặc Chúng Sinh
/skill [tlife<0.6] Nữ Oa Vá Trời
/usependant [buff:Nữ Oa Vá Trời]

-- 4. Tri lieu khi di chuyen
/skill [moving,tlife<0.9] Thánh Thủ Chức Thiên
/skill [moving,tlife<0.95] Túy Vũ Cửu Thiên

-- 5. Tri lieu don muc tieu & nhom khi dung yen
/skill [tlife<0.75] Băng Tàm Khiên Ti
/skill [tlife<0.95] Túy Vũ Cửu Thiên
/skill Băng Tàm Khiên Ti
]]

local function BuildCommonHelpers(deps)
    local CheckPet = deps.CheckPet
    local CheckPrepare = deps.CheckPrepare
    local GetCurrentTargetObject = deps.GetCurrentTargetObject
    local GetPetSkill = deps.GetPetSkill
    local GetPlayerSkillInfo = deps.GetPlayerSkillInfo
    local GetDistanceByTarget = deps.GetDistanceByTarget
    local XMCore_Sys = deps.XMCore_Sys
    local XMCore_UseEquipSlot = deps.XMCore_UseEquipSlot
    local tSkillCastFrame = deps.tSkillCastFrame
    local DoSmartSelectPoint = deps.DoSmartSelectPoint or _G.DoSmartSelectPoint
    local PrepareGroundSkillOnTarget = deps.PrepareGroundSkillOnTarget or _G.PrepareGroundSkillOnTarget
    local GetMouseTargetXYZ = deps.GetMouseTargetXYZ or _G.GetMouseTargetXYZ
    local SyncAIOTLHelperBachTuc = deps.SyncAIOTLHelperBachTuc or _G.SyncAIOTLHelperBachTuc
    local tOffGCDSkills = {
        [2214] = true, [2215] = true, [2216] = true, [2226] = true, [2227] = true,
        [2230] = true, [2236] = true, [2472] = true, [2477] = true,
    }
    local tChannelSkills = {
        [2209] = true, [2231] = true, [2232] = true, [2235] = true,
    }
    local nLastGCDSkillFrame = -999
    local nChannelLockUntilFrame = -999
    local nGroundLockUntilFrame = -999

    local function ResolveSkill(defaultID, szCanonical, szAscii)
        if GetPlayerSkillInfo then
            local id, lv = GetPlayerSkillInfo(szCanonical)
            if id then return id, lv or 1 end
            if szAscii then
                id, lv = GetPlayerSkillInfo(szAscii)
                if id then return id, lv or 1 end
            end
        end
        local me = GetClientPlayer()
        local lv = (me and me.GetSkillLevel and me.GetSkillLevel(defaultID)) or 1
        if lv <= 0 then lv = 1 end
        return defaultID, lv
    end

    local function IsSkillReady(me, dwSkillID, nDebounceFrames)
        if not me or not dwSkillID or dwSkillID <= 0 then return false end
        local nLvl = 1
        if me.GetSkillLevel then
            local okL, lvl = pcall(function() return me.GetSkillLevel(dwSkillID) end)
            if okL and tonumber(lvl or 0) > 0 then
                nLvl = tonumber(lvl)
            elseif okL and tonumber(lvl or 0) <= 0 then
                return false
            end
        end
        local nCurFrame = (GetLogicFrameCount and GetLogicFrameCount()) or 0
        local last = tSkillCastFrame and tSkillCastFrame[dwSkillID]
        local debounce = nDebounceFrames or 4
        if last and nCurFrame >= last and (nCurFrame - last) < debounce then
            return false
        end
        if me.GetSkillCDProgress then
            local ok, bCool, nLeft = pcall(function() return me.GetSkillCDProgress(dwSkillID, nLvl) end)
            if ok and bCool and tonumber(nLeft or 0) > 0 then
                return false
            end
        end
        return true
    end

    local function IsGCD(me)
        local nCurFrame = (GetLogicFrameCount and GetLogicFrameCount()) or 0
        if nGroundLockUntilFrame > 0 and nCurFrame < nGroundLockUntilFrame then
            return true
        end
        if nLastGCDSkillFrame > 0 and nCurFrame >= nLastGCDSkillFrame and (nCurFrame - nLastGCDSkillFrame) < 8 then
            return true
        end
        if me and me.GetSkillCDProgress then
            local ok, bCool, nLeft = pcall(function() return me.GetSkillCDProgress(53, 1) end)
            if ok and bCool and tonumber(nLeft or 0) > 0 then
                return true
            end
        end
        return false
    end

    local function IsChannelLocked(nCurFrame)
        local f = nCurFrame or (GetLogicFrameCount and GetLogicFrameCount()) or 0
        return nChannelLockUntilFrame > 0 and f < nChannelLockUntilFrame
    end

    local function ClearChannelLock()
        nChannelLockUntilFrame = -999
    end

    local function ReadBuffList(obj)
        local buffs = {}
        if not obj then return buffs end
        if obj.GetBuffList then
            local ok, list = pcall(function() return obj.GetBuffList() end)
            if ok and type(list) == "table" then
                for _, b in pairs(list) do
                    if type(b) == "table" and b.dwID then
                        table.insert(buffs, b)
                    end
                end
                if #buffs > 0 or next(list) == nil then return buffs end
            end
        end
        if obj.GetBuffCount and obj.GetBuff then
            local okC, count = pcall(function() return obj.GetBuffCount() end)
            if okC and type(count) == "number" and count > 0 then
                for i = 0, count - 1 do
                    local okB, id, lv, cancel, ending, idx, stack, src, valid = pcall(function() return obj.GetBuff(i) end)
                    if okB and id then
                        if type(id) == "table" then
                            table.insert(buffs, id)
                        else
                            table.insert(buffs, {
                                dwID = id, nLevel = lv or 1, nEndFrame = ending or 0,
                                nStackNum = stack or 1, dwSkillSrcID = src, bValid = valid,
                            })
                        end
                    end
                end
            end
        end
        return buffs
    end

    local function FindBuff(obj, me, tIDs, tNames, bOwnOnly)
        local list = ReadBuffList(obj)
        local nCurFrame = (GetLogicFrameCount and GetLogicFrameCount()) or 0
        local myID = me and tonumber(me.dwID) or nil
        for _, b in ipairs(list) do
            if b.bValid ~= false then
                local bNotExpired = (not b.nEndFrame) or b.nEndFrame <= 0 or nCurFrame <= 0 or b.nEndFrame > nCurFrame
                local src = tonumber(b.dwSkillSrcID or 0) or 0
                local bOwn = (not bOwnOnly) or src == 0 or (not myID) or src == myID
                if bNotExpired and bOwn then
                    if tIDs and tIDs[b.dwID] then
                        return b
                    end
                    local szName = b.szName
                    if not szName and Table_GetBuffName then
                        local okN, n = pcall(Table_GetBuffName, b.dwID, b.nLevel or 1)
                        if okN then szName = n end
                    end
                    if szName and tNames then
                        for _, pattern in ipairs(tNames) do
                            if szName == pattern or string.find(szName, pattern, 1, true) then
                                return b
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    local function BuffRemainingSec(b)
        if not b or not b.nEndFrame or b.nEndFrame <= 0 then return 999 end
        local nCurFrame = (GetLogicFrameCount and GetLogicFrameCount()) or 0
        if nCurFrame <= 0 then return 999 end
        return math.max(0, (b.nEndFrame - nCurFrame) / 16.0)
    end

    local function SendSkill(me, dwSkillID, szLabel, bUsePendant)
        local nCurFrame = (GetLogicFrameCount and GetLogicFrameCount()) or 0
        if tSkillCastFrame then
            tSkillCastFrame[dwSkillID] = nCurFrame
        end
        if bUsePendant and XMCore_UseEquipSlot and EQUIPMENT_INVENTORY then
            pcall(XMCore_UseEquipSlot, EQUIPMENT_INVENTORY.PENDANT, false)
        end
        local groundMode = (xMacro and xMacro.GroundTargetMode) or "target"
        if dwSkillID == 2212 then
            if PrepareGroundSkillOnTarget then
                pcall(PrepareGroundSkillOnTarget, dwSkillID)
            end
            if AIO_TLHelper then
                local tlMode = (groundMode == "mouse" and 2) or (groundMode == "manual" and 0) or 3
                if type(AIO_TLHelper.tTrapList) == "table" then AIO_TLHelper.tTrapList[2212] = tlMode end
                if type(AIO_TLHelper.tTrapMode) == "table" then AIO_TLHelper.tTrapMode[2212] = tlMode end
                if tlMode > 0 and type(AIO_TLHelper.ForcePlace) == "function" then
                    pcall(AIO_TLHelper.ForcePlace, dwSkillID, tlMode)
                end
            end
        end
        local lv = (me.GetSkillLevel and me.GetSkillLevel(dwSkillID)) or 1
        if lv <= 0 then lv = 1 end
        local ok, ret = pcall(OnAddOnUseSkill, dwSkillID, lv)
        if not ok or ret == false then
            return false
        end
        if not tOffGCDSkills[dwSkillID] then
            nLastGCDSkillFrame = nCurFrame
            if tChannelSkills[dwSkillID] then
                nChannelLockUntilFrame = nCurFrame + 7
            end
            if dwSkillID == 2212 then
                nGroundLockUntilFrame = nCurFrame + 10
            end
        end
        if dwSkillID == 2212 then
            if groundMode == "target" then
                if DoSmartSelectPoint then
                    pcall(DoSmartSelectPoint)
                elseif UserSelect and UserSelect.DoSelectPoint then
                    local tar = (GetCurrentTargetObject and GetCurrentTargetObject())
                    if tar and tar.nX and tar.nY and tar.nZ then
                        pcall(UserSelect.DoSelectPoint, tar.nX, tar.nY, tar.nZ)
                    elseif me and me.nX and me.nY and me.nZ then
                        pcall(UserSelect.DoSelectPoint, me.nX, me.nY, me.nZ)
                    end
                end
            elseif groundMode == "mouse" then
                if DoSmartSelectPoint then
                    pcall(DoSmartSelectPoint)
                elseif GetMouseTargetXYZ and UserSelect and UserSelect.DoSelectPoint then
                    local mx, my, mz = GetMouseTargetXYZ()
                    if mx and my and mz then
                        pcall(UserSelect.DoSelectPoint, mx, my, mz)
                    end
                end
            end
        end
        if XMCore_Sys and szLabel then
            XMCore_Sys("[xMacro] -> " .. tostring(szLabel))
        end
        return true
    end

    return {
        CheckPet = CheckPet,
        CheckPrepare = CheckPrepare,
        GetCurrentTargetObject = GetCurrentTargetObject,
        GetPetSkill = GetPetSkill,
        ResolveSkill = ResolveSkill,
        IsSkillReady = IsSkillReady,
        IsGCD = IsGCD,
        IsChannelLocked = IsChannelLocked,
        ClearChannelLock = ClearChannelLock,
        FindBuff = FindBuff,
        BuffRemainingSec = BuffRemainingSec,
        SendSkill = SendSkill,
        GetDistanceByTarget = function(a, b)
            local me = GetClientPlayer()
            if not b then
                if GetDistanceByTarget and me and a then
                    local d = GetDistanceByTarget(me, a)
                    if d and type(d) == "number" then return d end
                end
                return 999
            else
                if GetDistanceByTarget and a and b then
                    local d = GetDistanceByTarget(a, b)
                    if d and type(d) == "number" then return d end
                end
                return 999
            end
        end,
        XMCore_Sys = XMCore_Sys,
        tSkillCastFrame = tSkillCastFrame,
    }
end

local function CreateDocKinh(deps)
    local H = BuildCommonHelpers(deps)
    local tDocKinhState = {
        lastXaAnhFrame = -999,
        lastPetAttackFrame = -999,
        lastAoKichFrame = -999,
        nPetSummonFrame = -999,
        nLastAoKichSuccessFrame = -999,
    }

    local ID_HAT_TAM = {[2209] = true}
    local ID_XA_ANH = {[2210] = true, [2486] = true}
    local ID_THIEM_KHIEU = {[2211] = true, [2490] = true}
    local ID_BACH_TUC = {[2212] = true, [2492] = true, [2496] = true, [5764] = true}
    local ID_DOAT_MENH = {[2214] = true, [2488] = true}
    local ID_ME_TAM = {[2215] = true, [2489] = true, [6247] = true}
    local ID_KHO_TAN = {[2216] = true, [2496] = true}
    local ID_LINH_XA_HIEN_TE = {[2543] = true}
    local ID_THANH_HAT_HIEN_TE = {[2541] = true}
    local ID_NGOC_THIEM_HIEN_TE = {[2542] = true}

    local NAME_XA_ANH = {"Xà Ảnh", "Xa Anh", "蛇影"}
    local NAME_THIEM_KHIEU = {"Thiềm Khiếu", "Thiem Khieu", "蟾啸"}
    local NAME_BACH_TUC = {"Bách Túc", "Bach Tuc", "百足"}
    local NAME_DOAT_MENH = {"Đoạt Mệnh Cổ", "Doat Menh Co", "夺命蛊"}
    local NAME_ME_TAM = {"Mê Tâm Cổ", "Me Tam Co", "迷心蛊"}
    local NAME_KHO_TAN = {"Khô Tàn Cổ", "Kho Tan Co", "枯残蛊"}
    local NAME_LINH_XA_HIEN_TE = {"Linh Xà Hiến Tế", "Linh Xa Hien Te", "灵蛇献祭"}
    local NAME_THANH_HAT_HIEN_TE = {"Thánh Hạt Hiến Tế", "Thanh Hat Hien Te", "圣蝎献祭"}
    local NAME_NGOC_THIEM_HIEN_TE = {"Ngọc Thiềm Hiến Tế", "Ngoc Thiem Hien Te", "玉蟾献祭"}

    local function Run()
        local me = GetClientPlayer()
        if not me then return false end

        local nCurFrame = (GetLogicFrameCount and GetLogicFrameCount()) or 0
        local nStand = (MOVE_STATE and MOVE_STATE.ON_STAND) or 0
        local bMoving = (me.nMoveState or 0) ~= nStand

        local skHatTam = H.ResolveSkill(2209, "Hạt Tâm", "Hat Tam")
        local skXaAnh = H.ResolveSkill(2210, "Xà Ảnh", "Xa Anh")
        local skThiemKhieu = H.ResolveSkill(2211, "Thiềm Khiếu", "Thiem Khieu")
        local skBachTuc = H.ResolveSkill(2212, "Bách Túc", "Bach Tuc")
        local skThienTi = H.ResolveSkill(2213, "Thiên Ti", "Thien Ti")
        local skDoatMenh = H.ResolveSkill(2214, "Đoạt Mệnh Cổ", "Doat Menh Co")
        local skMeTam = H.ResolveSkill(2215, "Mê Tâm Cổ", "Me Tam Co")
        local skKhoTan = H.ResolveSkill(2216, "Khô Tàn Cổ", "Kho Tan Co")
        local skHuyenCo = H.ResolveSkill(2217, "Huyễn Cổ", "Huyen Co")
        local skHuyenThuy = H.ResolveSkill(2220, "Huyền Thủy Cổ", "Huyen Thuy Co")
        local skThanhHat = H.ResolveSkill(2221, "Thánh Hạt Dẫn", "Thanh Hat Dan")
        local skNgocThiem = H.ResolveSkill(2222, "Ngọc Thiềm Dẫn", "Ngoc Thiem Dan")
        local skLinhXa = H.ResolveSkill(2223, "Linh Xà Dẫn", "Linh Xa Dan")
        local skHienTe = H.ResolveSkill(2226, "Cổ Trùng Hiến Tế", "Co Trung Hien Te")
        local skCuongBao = H.ResolveSkill(2227, "Cổ Trùng Cuồng Bạo", "Co Trung Cuong Bao")

        -- 1. Bao ve van cong Hat Tam: chi ngat khi di chuyen
        local bIsPreparing, dwPrepID = false, 0
        if me.GetSkillPrepareState then
            local okP, prep, pid = pcall(function() return me.GetSkillPrepareState() end)
            if okP and prep then bIsPreparing, dwPrepID = true, tonumber(pid) or 0 end
        end
        local okOT, nOT = pcall(function() return me.GetOTActionState() end)
        local bIsOT = okOT and tonumber(nOT or 0) ~= 0
        if bMoving then
            H.ClearChannelLock()
        end
        if bIsPreparing or bIsOT or (not bMoving and H.IsChannelLocked(nCurFrame)) then
            if bMoving and (dwPrepID == skHatTam or ID_HAT_TAM[dwPrepID]) and me.StopCurrentAction then
                pcall(function() return me.StopCurrentAction() end)
            end
            return false
        end

        -- 2. Sinh ton ban than
        local nLife = (me.nMaxLife and me.nMaxLife > 0) and (me.nCurrentLife / me.nMaxLife) or 1
        local nMana = (me.nMaxMana and me.nMaxMana > 0) and (me.nCurrentMana / me.nMaxMana) or 1
        local bHasPet = H.CheckPet and H.CheckPet() or false
        local bHasLinhXa = H.CheckPet and H.CheckPet("Linh Xà|Linh Xa|灵蛇") or false
        local bHasThanhHat = H.CheckPet and H.CheckPet("Thánh Hạt|Thanh Hat|圣蝎") or false
        local bHasNgocThiem = H.CheckPet and H.CheckPet("Ngọc Thiềm|Ngoc Thiem|玉蟾") or false

        if not bHasPet then
            tDocKinhState.lastAoKichFrame = -999
            tDocKinhState.nPetSummonFrame = -999
            tDocKinhState.nLastAoKichSuccessFrame = -999
        elseif tDocKinhState.nPetSummonFrame == -999 then
            tDocKinhState.nPetSummonFrame = nCurFrame
        end

        if nLife < 0.50 and bHasPet and H.IsSkillReady(me, skCuongBao, 24) then
            return H.SendSkill(me, skCuongBao, "Cổ Trùng Cuồng Bạo", false)
        end

        local bHasHienTeBuff = H.FindBuff(me, me, ID_LINH_XA_HIEN_TE, NAME_LINH_XA_HIEN_TE, false) ~= nil
        local bLinhXaReady = H.IsSkillReady(me, skLinhXa, 8)
        local bNgocThiemReady = H.IsSkillReady(me, skNgocThiem, 8)
        local bThanhHatReady = H.IsSkillReady(me, skThanhHat, 8)
        local bHienTeReady = H.IsSkillReady(me, skHienTe, 16)

        -- 3. Quan ly Pet: Uu tien Linh Xa > Ngoc Thiem > Thanh Hat
        if not bHasPet and not bMoving and not H.IsGCD(me) then
            -- a) Uu tien 1: Linh Xa khong CD -> Luon goi Linh Xa
            if bLinhXaReady then
                return H.SendSkill(me, skLinhXa, "Linh Xà Dẫn", bHasHienTeBuff)
            -- b) Uu tien 2: Linh Xa dang CD -> Goi Ngoc Thiem (ID 2222)
            elseif bNgocThiemReady then
                return H.SendSkill(me, skNgocThiem, "Ngọc Thiềm Dẫn", false)
            -- c) Uu tien 3: Ca Linh Xa & Ngoc Thiem deu CD -> Goi Thanh Hat (ID 2221)
            elseif bThanhHatReady then
                return H.SendSkill(me, skThanhHat, "Thánh Hạt Dẫn", false)
            end
        end

        local tar = H.GetCurrentTargetObject and H.GetCurrentTargetObject() or nil
        if tar and tar.nCurrentLife and tar.nCurrentLife <= 0 then tar = nil end

        -- 4. Dieu khien Pet Linh Xa: LUON O CHE DO SPAM (off-GCD, khong chen GCD nhan vat)
        if bHasLinhXa then
            local atkSkillID = (H.GetPetSkill and H.GetPetSkill("Tấn công")) or 2472
            pcall(OnAddOnUseSkill, atkSkillID, 1)

            local aoKichID = (H.GetPetSkill and (H.GetPetSkill("Ảo Kích") or H.GetPetSkill("Ao Kich") or H.GetPetSkill("Huyễn Kích"))) or 2477
            pcall(OnAddOnUseSkill, aoKichID, 1)
        elseif bHasPet then
            local atkSkillID = (H.GetPetSkill and H.GetPetSkill("Tấn công")) or 2472
            pcall(OnAddOnUseSkill, atkSkillID, 1)
        end

        -- 5. Co Trung Hien Te: Co bat ky pet nao thi hien te ngay khi Hien Te san sang (khong uu tien hay tri hoan rieng cho Linh Xa)
        if bHasPet and bHienTeReady and not bHasHienTeBuff then
            if H.SendSkill(me, skHienTe, "Cổ Trùng Hiến Tế", bHasLinhXa) then
                return true
            end
        end

        if not tar then return false end

        -- 4. Co Trung & Ngat chieu Boss (off-GCD)
        local bHasDoatMenh = H.FindBuff(tar, me, ID_DOAT_MENH, NAME_DOAT_MENH, true) ~= nil
        local bHasKhoTan = H.FindBuff(tar, me, ID_KHO_TAN, NAME_KHO_TAN, true) ~= nil
        local bHasMeTam = H.FindBuff(tar, me, ID_ME_TAM, NAME_ME_TAM, true) ~= nil
        local bTargetPreparing = H.CheckPrepare and H.CheckPrepare(tar) or false

        if bTargetPreparing and not bHasDoatMenh and not bHasKhoTan and not bHasMeTam and H.IsSkillReady(me, skMeTam, 24) then
            H.SendSkill(me, skMeTam, "Mê Tâm Cổ", false)
        elseif nMana < 0.35 and not bHasDoatMenh and not bHasKhoTan and H.IsSkillReady(me, skKhoTan, 24) then
            H.SendSkill(me, skKhoTan, "Khô Tàn Cổ", false)
        elseif not bHasDoatMenh and not bHasKhoTan and H.IsSkillReady(me, skDoatMenh, 24) then
            H.SendSkill(me, skDoatMenh, "Đoạt Mệnh Cổ", false)
        end

        if H.IsGCD(me) then return false end

        -- 5. Chu trinh 3 DoT & Ky nang chu luc Doc Kinh
        -- a) Bach Tuc: Uu tien so 1 ngay khi hoi chieu (luon dat thang vao target)
        if H.IsSkillReady(me, skBachTuc, 8) then
            return H.SendSkill(me, skBachTuc, "Bách Túc", bHasHienTeBuff)
        end

        -- b) Xa Anh: Duy tri DoT 12s (chong danh lap khi vua niem < 1.5s)
        local bXaAnh = H.FindBuff(tar, me, ID_XA_ANH, NAME_XA_ANH, true)
        local nXaAnhLeft = bXaAnh and H.BuffRemainingSec(bXaAnh) or 0
        local bRecentXaAnh = (lastcast and lastcast(skXaAnh)) or ((nCurFrame - tDocKinhState.lastXaAnhFrame) < 24)
        if (not bXaAnh or nXaAnhLeft < 2.0) and not bRecentXaAnh and H.IsSkillReady(me, skXaAnh, 8) then
            if H.SendSkill(me, skXaAnh, "Xà Ảnh", bHasHienTeBuff) then
                tDocKinhState.lastXaAnhFrame = nCurFrame
                return true
            end
        end

        -- c) Thiem Khieu: Duy tri DoT 12s & hoi mana khi co Doat Menh Co
        local bThiemKhieu = H.FindBuff(tar, me, ID_THIEM_KHIEU, NAME_THIEM_KHIEU, true)
        local nThiemKhieuLeft = bThiemKhieu and H.BuffRemainingSec(bThiemKhieu) or 0
        if (not bThiemKhieu or nThiemKhieuLeft < 2.0) and H.IsSkillReady(me, skThiemKhieu, 8) then
            return H.SendSkill(me, skThiemKhieu, "Thiềm Khiếu", bHasHienTeBuff)
        end

        -- d) Di chuyen hoac can hut mana voi Kho Tan Co -> Thien Ti / Xa Anh
        if (bMoving or (nMana < 0.25 and bHasKhoTan)) and H.IsSkillReady(me, skThienTi, 8) then
            return H.SendSkill(me, skThienTi, "Thiên Ti", false)
        end
        if bMoving and H.IsSkillReady(me, skXaAnh, 8) then
            return H.SendSkill(me, skXaAnh, "Xà Ảnh", false)
        end

        -- e) Filler dung yen: Hat Tam (1.75s / 1.5s)
        -- TUYET DOI khong dung Hat Tam neu Bach Tuc dang san sang (CD <= 0) hoac vua cast trong vong 625ms
        local bBachTucReady = false
        if me.GetSkillCDProgress then
            local okCD, bCool, nLeft = pcall(function() return me.GetSkillCDProgress(skBachTuc, 1) end)
            if okCD and (not bCool or tonumber(nLeft or 0) <= 0) then
                bBachTucReady = true
            end
        end
        local nLastBT = tSkillCastFrame and tSkillCastFrame[skBachTuc] or -999
        local bBTPending = (nCurFrame - nLastBT) >= 0 and (nCurFrame - nLastBT) < 10

        if not bMoving and not bBachTucReady and not bBTPending and H.IsSkillReady(me, skHatTam, 4) then
            return H.SendSkill(me, skHatTam, "Hạt Tâm", bHasHienTeBuff)
        end

        return false
    end

    return {run = Run, defaultScript = DEFAULT_NGUDOC_DOCKINH_MACRO}
end

local function CreateBoThien(deps)
    local H = BuildCommonHelpers(deps)

    local ID_CO_HOAC = {[2236] = true}
    local ID_NU_OA = {[2230] = true}
    local NAME_CO_HOAC = {"Cổ Hoặc Chúng Sinh", "Co Hoac Chung Sinh", "蛊惑众生"}
    local NAME_NU_OA = {"Nữ Oa Vá Trời", "Nu Oa Va Troi", "女娲补天"}

    local function Run()
        local me = GetClientPlayer()
        if not me then return false end

        local nStand = (MOVE_STATE and MOVE_STATE.ON_STAND) or 0
        local bMoving = (me.nMoveState or 0) ~= nStand

        local skBichDiep = H.ResolveSkill(2965, "Bích Điệp Dẫn", "Bich Diep Dan")
        local skNuOa = H.ResolveSkill(2230, "Nữ Oa Vá Trời", "Nu Oa Va Troi")
        local skBangTam = H.ResolveSkill(2231, "Băng Tàm Khiên Ti", "Bang Tam Khien Ti")
        local skTuyVu = H.ResolveSkill(2232, "Túy Vũ Cửu Thiên", "Tuy Vu Cuu Thien")
        local skThanhThu = H.ResolveSkill(2233, "Thánh Thủ Chức Thiên", "Thanh Thu Chuc Thien")
        local skDinhCo = H.ResolveSkill(2234, "Đỉnh Cổ Tiên Vương", "Dinh Co Tien Vuong")
        local skThienDiep = H.ResolveSkill(2235, "Thiên Điệp Thổ Thụy", "Thien Diep Tho Thuy")
        local skCoHoac = H.ResolveSkill(2236, "Cổ Hoặc Chúng Sinh", "Co Hoac Chung Sinh")
        local skHienTe = H.ResolveSkill(2226, "Cổ Trùng Hiến Tế", "Co Trung Hien Te")

        -- 1. Bao ve Thien Diep Tho Thuy & Bang Tam Khien Ti
        local bIsPreparing, dwPrepID = false, 0
        if me.GetSkillPrepareState then
            local okP, prep, pid = pcall(function() return me.GetSkillPrepareState() end)
            if okP and prep then bIsPreparing, dwPrepID = true, tonumber(pid) or 0 end
        end
        local okOT, nOT = pcall(function() return me.GetOTActionState() end)
        local bIsOT = okOT and tonumber(nOT or 0) ~= 0
        if bIsPreparing or bIsOT then
            if bMoving and dwPrepID == skBangTam and me.StopCurrentAction then
                pcall(function() return me.StopCurrentAction() end)
            end
            return false
        end

        local nLife = (me.nMaxLife and me.nMaxLife > 0) and (me.nCurrentLife / me.nMaxLife) or 1
        local nMana = (me.nMaxMana and me.nMaxMana > 0) and (me.nCurrentMana / me.nMaxMana) or 1
        local bHasPet = H.CheckPet and H.CheckPet() or false

        -- 2. Goi Bich Diep & Sinh ton
        if not bHasPet and not bMoving and not H.IsGCD(me) and H.IsSkillReady(me, skBichDiep, 16) then
            return H.SendSkill(me, skBichDiep, "Bích Điệp Dẫn", false)
        end
        if nLife < 0.30 and bHasPet and H.IsSkillReady(me, skHienTe, 24) then
            return H.SendSkill(me, skHienTe, "Cổ Trùng Hiến Tế", true)
        end
        if nLife < 0.40 and H.IsSkillReady(me, skNuOa, 24) then
            return H.SendSkill(me, skNuOa, "Nữ Oa Vá Trời", true)
        end

        local tar = (H.GetCurrentTargetObject and H.GetCurrentTargetObject()) or me
        local nTarLife = (tar and tar.nMaxLife and tar.nMaxLife > 0) and (tar.nCurrentLife / tar.nMaxLife) or nLife

        if H.IsGCD(me) then return false end

        -- 3. Cap cuu nguy kich
        if nTarLife < 0.40 and H.IsSkillReady(me, skThanhThu, 16) then
            return H.SendSkill(me, skThanhThu, "Thánh Thủ Chức Thiên", true)
        end
        if nTarLife < 0.45 and not bMoving and H.IsSkillReady(me, skThienDiep, 24) then
            return H.SendSkill(me, skThienDiep, "Thiên Điệp Thổ Thụy", true)
        end

        -- 4. Duy tri Co Hoac Chung Sinh & Nu Oa Va Troi
        local bHasCoHoac = H.FindBuff(tar, me, ID_CO_HOAC, NAME_CO_HOAC, false) ~= nil
        if nTarLife < 0.85 and not bHasCoHoac and H.IsSkillReady(me, skCoHoac, 24) then
            return H.SendSkill(me, skCoHoac, "Cổ Hoặc Chúng Sinh", false)
        end
        if nTarLife < 0.65 and H.IsSkillReady(me, skNuOa, 24) then
            return H.SendSkill(me, skNuOa, "Nữ Oa Vá Trời", true)
        end

        local bHasNuOa = H.FindBuff(me, me, ID_NU_OA, NAME_NU_OA, false) ~= nil

        -- 5. Tri lieu khi di chuyen
        if bMoving then
            if nTarLife < 0.85 and H.IsSkillReady(me, skThanhThu, 16) then
                return H.SendSkill(me, skThanhThu, "Thánh Thủ Chức Thiên", bHasNuOa)
            end
            if H.IsSkillReady(me, skTuyVu, 8) then
                return H.SendSkill(me, skTuyVu, "Túy Vũ Cửu Thiên", bHasNuOa)
            end
            return false
        end

        -- 6. Tri lieu khi dung yen
        if nMana < 0.65 and not me.bFightState and H.IsSkillReady(me, skDinhCo, 32) then
            return H.SendSkill(me, skDinhCo, "Đỉnh Cổ Tiên Vương", false)
        end
        if nTarLife < 0.75 and H.IsSkillReady(me, skBangTam, 4) then
            return H.SendSkill(me, skBangTam, "Băng Tàm Khiên Ti", bHasNuOa)
        end
        if nTarLife < 0.95 and H.IsSkillReady(me, skTuyVu, 8) then
            return H.SendSkill(me, skTuyVu, "Túy Vũ Cửu Thiên", bHasNuOa)
        end
        if H.IsSkillReady(me, skBangTam, 4) then
            return H.SendSkill(me, skBangTam, "Băng Tàm Khiên Ti", bHasNuOa)
        end

        return false
    end

    return {run = Run, defaultScript = DEFAULT_NGUDOC_BOTHIEN_MACRO}
end

-- Publish deferred factories; module loading does not require Core or Registry yet.
xMacro = xMacro or {}
xMacro.SchoolFactories = xMacro.SchoolFactories or {}
xMacro.SchoolFactories.NguDoc = xMacro.SchoolFactories.NguDoc or {}
if xMacro.SchoolProfiles and xMacro.SchoolProfiles.NguDoc then
    xMacro.SchoolProfiles.NguDoc.DocKinh = nil
    xMacro.SchoolProfiles.NguDoc.BoThien = nil
end
xMacro.SchoolFactories.NguDoc.DocKinh = CreateDocKinh
xMacro.SchoolFactories.NguDoc.BoThien = CreateBoThien

-- =====================================================================
-- That Tu: Bang Tam Quyet (v80 PVE - Cap Khuc Tu Kich No - No Giang Hai)
-- =====================================================================

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
    local H = BuildCommonHelpers(deps)
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

-- Schools/Priority.lua
do
-- Shared guard for PvE damage scripts in the Hoang Cung Nam Chieu client.
function xMacro.Schools.RegisterDamageScript(school, profile, scriptsByMount)
    local factories = xMacro.SchoolFactories
    factories[school] = factories[school] or {}
    factories[school][profile] = function(deps)
        local function Run()
            local player = GetClientPlayer and GetClientPlayer()
            if not player or not player.GetKungfuMount or not player.GetSkillLevel or player.bDeathFlag then
                return false
            end
            local mount = player.GetKungfuMount()
            local script = mount and scriptsByMount[mount.dwSkillID]
            if not script then return false end

            local target = deps.GetCurrentTargetObject()
            if not target or not target.dwID or target.dwID == player.dwID or target.bDeathFlag then
                return false
            end
            if IsEnemy and not IsEnemy(player.dwID, target.dwID) then return false end
            if type(script) == "function" then script = script(player) end
            -- The generic numeric /skill handler accepts unknown IDs at level 1.
            -- Skip unlearned skills so the client can fall through to the next priority.
            script = script:gsub("/skill [^\r\n]+", function(command)
                local skillID = tonumber(command:match(" (%d+)$"))
                if skillID and (player.GetSkillLevel(skillID) or 0) > 0 then return command end
                return ""
            end)
            -- A previous profile may have left its /config before filter active.
            return ExecuteMacroCommand("/config before:null\n" .. script)
        end
        return {run = Run}
    end
    if xMacro.SchoolProfiles[school] then xMacro.SchoolProfiles[school][profile] = nil end
end
end

-- Schools/ThienSach/DPS.lua
do
-- Ngạo Huyết Chiến Ý. IDs cross-checked against DKMacro/ThienSach.lua.
xMacro.Schools.RegisterDamageScript("ThienSach", "DPS", {[10026] = [[
#name ThienSach_NgaoHuyet_80
-- Phá Phong keeps Lưu Huyết active, then spend Trí Tàn on Long Nha.
/skill [distance<=4,xmtnobuff:3442] 401
/skill [distance<=4,xmtbuff:540] 415
/skill [distance<=4] 403
/skill [distance<=4,tlife<0.30] 423
/skill [distance<=4] 400
]]})
end

-- Schools/TangKiem/DPS.lua
do
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
end

-- Schools/DuongMon/KinhVu.lua
do
-- Kinh Vũ Quyết, damage priority for one selected target.
-- Hóa Huyết Tiêu (3087) applies debuff 2237. DKMacro/DuongMon.lua.
xMacro.Schools.RegisterDamageScript("DuongMon", "KinhVu", {[10224] = [[
#name DuongMon_KinhVu_80
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3098
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy>=30] 3095
/skill [distance<=25,energy>=15] 3088
/skill [energy<30] 3100
]]})
end

-- Schools/DuongMon/ThienLa.lua
do
-- Thiên La Quỷ Đạo, direct-target damage. Place traps and the turret manually.
-- Classic skill IDs from DKMacro/DuongMon.lua.
xMacro.Schools.RegisterDamageScript("DuongMon", "ThienLa", {[10225] = [[
#name DuongMon_ThienLa_80
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy>=30] 3105
/skill [distance<=25,energy>=15] 3088
/skill [energy<30] 3100
]]})
end

-- Schools/MinhGiao/PhanAnh.lua
do
-- Phần Ảnh Thánh Quyết. Base solar/lunar cycle, without level-90 talents.
-- IDs cross-checked against DKMacro/MinhGiao.lua.
xMacro.Schools.RegisterDamageScript("MinhGiao", "PhanAnh", {[10242] = [[
#name MinhGiao_PhanAnh_80
/skill [distance<=5,fullsun] 3967
/skill [distance<=5,fullmoon] 3967
/skill [distance<=5,xmbuff:4052] 3979
/skill [distance<=5] 3963
/skill [distance<=5] 3960
/skill [distance<=5,sun>=moon] 3962
/skill [distance<=5] 3959
]]})
end

-- Schools/ThieuLam/DichCanKinh.lua
do
-- Dịch Cân Kinh, three-point damage spenders and classic point builders.
-- IDs cross-checked against DKMacro/ThieuLam.lua.
xMacro.Schools.RegisterDamageScript("ThieuLam", "DichCanKinh", {[10003] = [[
#name ThieuLam_DichCanKinh_80
/skill [distance<=4,qidian>=3,tlife<0.30] 243
/skill [distance<=4,qidian>=3] 233
/skill [distance<=5] 235
/skill [distance<=8] 2572
/skill [distance<=4] 232
]]})
end

-- Schools/ThuanDuong/TuHaCong.lua
do
-- Tử Hà Công, build khí điểm then use Lưỡng Nghi Hóa Hình.
-- IDs cross-checked against DKMacro/ThuanDuong.lua.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "TuHaCong", {[10014] = [[
#name ThuanDuong_TuHaCong_80
/skill [distance<=20,qidian>=9] 301
/skill [distance<=20,qidian<=8] 367
/skill [distance<=20] 306
]]})
end

-- Schools/ThuanDuong/ThaiHuKiemY.lua
do
-- Thái Hư Kiếm Ý, direct melee priority with classical khí điểm thresholds.
-- IDs cross-checked against DKMacro/ThuanDuong.lua.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10015] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [distance<=4,qidian>=8] 365
/skill [distance<=4,qidian<=7] 2699
/skill [distance<=4] 364
]]})
end
end
local ok, result = pcall(InitializeModule)
runtimeStatus.modules["Schools/NguDoc/DocKinh.lua"] = ok
if not ok then
    runtimeStatus.errors["Schools/NguDoc/DocKinh.lua"] = tostring(result)
    ReportStartup("LOAD_ERROR Schools/NguDoc/DocKinh.lua: " .. tostring(result))
end
end
-- END Schools/NguDoc/DocKinh.lua
