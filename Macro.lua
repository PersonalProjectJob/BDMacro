-- Public bridge. Runtime.lua assembles all modules in the reviewed build order.
xMacro = xMacro or {}
local SCHOOL_CODES = xMacro.Core.SchoolAliases
-- Use the active inner kungfu, since one school can have multiple rotations.
local KUNGFU_CODES = {
-- @kungfu-codes
}
local lastFailure, initializedProfile = nil, nil
local function ReportFailure(failure)
    if failure ~= lastFailure and OutputMessage then
        OutputMessage("MSG_SYS", "[xMacro] " .. failure .. "\n")
        lastFailure = failure
    end
end
local function SelectedProfile(selection)
    local config = selection or xMacro.Config or {}
    local implementation, reason
    if xMacro.Schools and type(xMacro.Schools.Resolve) == "function" then
        implementation, reason = xMacro.Schools.Resolve(config.school, config.profile)
    else
        reason = "Schools/Registry.lua not ready"
    end
    if not implementation then
        ReportFailure("Profile unavailable: " .. tostring(config.school) .. "/" .. tostring(config.profile) .. ": " .. tostring(reason))
        return nil
    end
    lastFailure = nil
    if implementation ~= initializedProfile and type(SetActiveMacroScript) == "function" then
        SetActiveMacroScript(implementation.defaultScript)
        initializedProfile = implementation
    end
    return implementation
end
local function HasExtraArgument(first, ...)
    -- type() rejects a missing argument but accepts an explicit nil.
    return pcall(type, ...)
end
function xMacro.ActiveSelection(player)
    local mount = player and player.GetKungfuMount and player.GetKungfuMount()
    local kungfuID = mount and mount.dwSkillID
    return SCHOOL_CODES[KUNGFU_CODES[kungfuID]], kungfuID
end

local function Dispatch(...)
    local hasFirst, firstType = pcall(type, ...)
    local szName = ...
    local selection
    -- Reject undefined bare identifiers, e.g. macro(TS), rather than treating them as no argument.
    if (hasFirst and firstType ~= "string") or HasExtraArgument(...) then
        ReportFailure('Invalid macro code. Use macro() or a quoted alias such as macro("VH").')
        return false
    end

    local rawScript = szName and string.find(szName, "/", 1, true)
    if szName and not rawScript then
        local code = string.upper((string.gsub(szName, "^%s*(.-)%s*$", "%1")))
        if code == "" then
            szName = nil
        elseif code == "AUTO" then
            szName = "auto"
        else
            selection = SCHOOL_CODES[code]
            if not selection then
                ReportFailure("Unknown macro code: " .. code)
                return false
            end
            szName = nil
        end
    end

    local me = GetClientPlayer and GetClientPlayer()
    if not me then return false end
    if not selection and not rawScript then
        local kungfuID
        selection, kungfuID = xMacro.ActiveSelection(me)
        if not selection then
            ReportFailure("No automatic macro for active kungfu: " .. tostring(kungfuID))
            return false
        end
    end

    local implementation = SelectedProfile(selection)
    if not implementation then return false end
    if rawScript then
        local ok, ret = pcall(ExecuteMacroCommand, szName)
        if ok and ret then return true end
    end

    return implementation.run(szName)
end
local lastRuntimeError
function xMacro.Run(...)
    local status = xMacro.Runtime
    if status and status.ready == false then
        ReportFailure("Runtime NOT_READY; see LOAD_ERROR at addon startup.")
        return false
    end
    local ok, result = pcall(Dispatch, ...)
    if not ok then
        local message = "Macro runtime error: " .. tostring(result)
        if status then status.lastCallError = tostring(result) end
        if message ~= lastRuntimeError then
            ReportFailure(message)
            lastRuntimeError = message
        end
        return false
    end
    lastRuntimeError = nil
    if status then status.lastCallError = nil end
    return result
end

macro = xMacro.Run
xmacro = xMacro.Run

local nLastSyncCheckFrame = -999
local szLastReportedCommit = nil

local function CheckGitHubSyncNotification()
    local nCurFrame = (GetLogicFrameCount and GetLogicFrameCount()) or 0
    if nCurFrame - nLastSyncCheckFrame < 160 then return end
    nLastSyncCheckFrame = nCurFrame

    if not LoadLUAData then return end
    local statusFile = "interface\\xMacro\\github_sync_status.jx3dat"
    local ok, data = pcall(LoadLUAData, statusFile)
    if ok and type(data) == "table" and data.new_update == true then
        data.new_update = false
        if SaveLUAData then pcall(SaveLUAData, statusFile, data) end
        local sha = data.sha or ""
        local msg = data.message or ""
        if OutputMessage and sha ~= szLastReportedCommit then
            szLastReportedCommit = sha
            OutputMessage("MSG_SYS", string.format("[xMacro] GitHub Sync: Da tu dong cap nhat rotation moi tu GitHub (Commit: %s - %s)!\n", sha, msg))
        end
    end
end

local function OnXMacroCommand(szText)
    if szText and type(szText) == "string" then
        szText = string.gsub(szText, "^%s*(.-)%s*$", "%1")
        local upper = string.upper(szText)
        if upper == "SYNC" or upper == "UPDATE" then
            local reqFile = "interface\\xMacro\\github_sync_request.jx3dat"
            if SaveLUAData then
                pcall(SaveLUAData, reqFile, {action = "SYNC", time = (GetLogicFrameCount and GetLogicFrameCount()) or 0})
            end
            if OutputMessage then
                OutputMessage("MSG_SYS", "[xMacro] Da gui tin hieu dong bo toi GitHub API Bridge. Vui long cho 2-3 giay...\n")
            end
            return true
        elseif upper == "STATUS" or upper == "CHECK" then
            local statusFile = "interface\\xMacro\\github_sync_status.jx3dat"
            local ok, data = pcall(LoadLUAData, statusFile)
            if ok and type(data) == "table" and data.sha then
                if OutputMessage then
                    OutputMessage("MSG_SYS", string.format("[xMacro] GitHub Commit hien tai: %s (%s) - Trang thai: %s\n", data.sha, data.updated_at or "", data.status or "OK"))
                end
            else
                if OutputMessage then
                    OutputMessage("MSG_SYS", "[xMacro] Chua co thong tin dong bo. Hay mo start_xmacro.bat de bat Sync Bridge.\n")
                end
            end
            return true
        end

        if szText == "" or upper == "AUTO" then
            szText = nil
        end
    else
        szText = nil
    end

    pcall(CheckGitHubSyncNotification)
    return xMacro.Run(szText)
end

local function RegisterSlashCommands()
    if AppendCommand then
        pcall(AppendCommand, "xmacro", OnXMacroCommand)
        pcall(AppendCommand, "xm", OnXMacroCommand)
    end
end

RegisterSlashCommands()

-- Optional menu integration. The existing HUD also opens on its own.
local registeredPanels = {}
local function OpenKeySpamPanel()
    if not (xMacro.Runtime and xMacro.Runtime.ready) then return end
    local hold = xMacro.HoldKey
    if hold and hold.EnsureHUD then hold.EnsureHUD() end
end

local function RegisterAddonPanels()
    local function Register(api)
        if not api or registeredPanels[api] or type(api.RegisterPanel) ~= "function" then return end
        if pcall(api.RegisterPanel, "xMacro", 354, nil, {OnPanelActive = OpenKeySpamPanel}) then
            registeredPanels[api] = true
        end
    end
    Register(AIO)
    Register(HM)
    RegisterSlashCommands()
end

RegisterAddonPanels()
if RegisterEvent then pcall(RegisterEvent, "LOADING_END", RegisterAddonPanels) end
