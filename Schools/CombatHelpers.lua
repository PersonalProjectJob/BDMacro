-- Shared combat utilities used by the Ngu Doc and That Tu factories.
function xMacro.Schools.BuildCombatHelpers(deps)
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
