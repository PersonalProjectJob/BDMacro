-- Native game panel and typed file bridge. Combat rotation stays in Macro.lua.
xMacro = xMacro or {}
xMacro.HoldKey = xMacro.HoldKey or {}
local hold = xMacro.HoldKey
local controlFile = "interface\\xMacro\\hold_key_control.jx3dat"
local statusFile = "interface\\xMacro\\hold_key_status.jx3dat"
local uiFile = "interface\\xMacro\\hold_key_ui.jx3dat"
local frame, enabled, runId = nil, false, 0
local uiX, uiY, mini = 260, 180, false
local interval_ms = 50
local groundMode = "target"
local keys = {"1", "", "", ""}
local notice = "Mo start_xmacro.bat mot lan."
local status, lastSeq, lastPid, seenAt = {}, nil, nil, -10000
local nextPoll, dragging = 0, nil
local nextDiagnostic = 0
local function Now() return (GetTime and GetTime()) or 0 end
local function Read(path)
    if not LoadLUAData then return nil end
    local ok, data = pcall(LoadLUAData, path)
    if ok and type(data) == "table" then return data end
end
local MOD_SHIFT, MOD_CTRL, MOD_ALT = 256, 512, 1024
local names = {
    LBUTTON=1, MOUSE1=1, LMB=1,
    RBUTTON=2, MOUSE2=2, RMB=2,
    CANCEL=3,
    MBUTTON=4, MOUSE3=4, MMB=4,
    MOUSE4=5, XBUTTON1=5, MB4=5, M4=5,
    MOUSE5=6, XBUTTON2=6, MB5=6, M5=6,
    BACKSPACE=8, BS=8, BKSP=8, BACK=8,
    TAB=9,
    CLEAR=12,
    ENTER=13, RETURN=13, RET=13,
    SHIFT=16, LSHIFT=160, RSHIFT=161,
    CTRL=17, CONTROL=17, CTL=17, LCTRL=162, LCONTROL=162, RCTRL=163, RCONTROL=163,
    ALT=18, MENU=18, LALT=164, LMENU=164, RALT=165, RMENU=165,
    PAUSE=19, BREAK=19,
    CAPS=20, CAPSLOCK=20, CAPITAL=20,
    ESC=27, ESCAPE=27,
    SPACE=32, SPC=32, SPACEBAR=32,
    PGUP=33, PAGEUP=33, PRIOR=33,
    PGDN=34, PAGEDOWN=34, NEXT=34,
    END=35, HOME=36,
    LEFT=37, UP=38, RIGHT=39, DOWN=40,
    SELECT=41, PRINT=44, PRINTSCREEN=44, PRTSC=44, SYSRQ=44, SNAPSHOT=44,
    INSERT=45, INS=45, DELETE=46, DEL=46, HELP=47,
    LWIN=91, WIN=91, RWIN=92, APPS=93, MENUKEY=93, CONTEXT=93,
    ["NUM*"]=106, ["NUMPAD*"]=106, MULTIPLY=106, NUMMUL=106, ["*"]=106,
    ["NUM+"]=107, ["NUMPAD+"]=107, ADD=107, NUMADD=107, NUMPLUS=107,
    NUMENTER=108, NUMSEP=108, SEPARATOR=108,
    ["NUM-"]=109, ["NUMPAD-"]=109, SUBTRACT=109, NUMSUB=109, NUMMINUS=109,
    ["NUM."]=110, ["NUMPAD."]=110, DECIMAL=110, NUMDEC=110, NUMDOT=110, NUMDEL=110,
    ["NUM/"]=111, ["NUMPAD/"]=111, DIVIDE=111, NUMDIV=111,
    NUMLOCK=144, NUMLK=144, SCROLL=145, SCROLLLOCK=145, SCRLK=145,
    MUTE=173, VOLDOWN=174, VOLUP=175, NEXTTRACK=176, PREVTRACK=177, STOPMEDIA=178, PLAYPAUSE=179,
    [";"]=186, [":"]=186, SEMICOLON=186, COLON=186, OEM1=186,
    ["="]=187, ["+"]=187, EQUAL=187, EQUALS=187, PLUS=187, OEMPLUS=187,
    [","]=188, ["<"]=188, COMMA=188, OEMCOMMA=188,
    ["-"]=189, ["_"]=189, MINUS=189, DASH=189, HYPHEN=189, OEMMINUS=189,
    ["."]=190, [">"]=190, DOT=190, PERIOD=190, OEMPERIOD=190,
    ["/"]=191, ["?"]=191, SLASH=191, QUESTION=191, OEM2=191,
    ["~"]=192, ["`"]=192, TILDE=192, GRAVE=192, OEM3=192,
    ["["]=219, ["{"]=219, LBRACKET=219, OPENBRACKET=219, OEM4=219,
    ["\\"]=220, ["|"]=220, BACKSLASH=220, PIPE=220, OEM5=220,
    ["]"]=221, ["}"]=221, RBRACKET=221, CLOSEBRACKET=221, OEM6=221,
    ["'"]=222, ["\""]=222, QUOTE=222, APOSTROPHE=222, OEM7=222,
    OEM8=223, OEM102=226, OEM_102=226,
    WHEELDOWN=253, MWHEELDOWN=253, WD=253,
    WHEELUP=254, MWHEELUP=254, WU=254,
}
local canonicalName = {
    [1]="MOUSE1", [2]="MOUSE2", [3]="CANCEL", [4]="MOUSE3", [5]="MOUSE4", [6]="MOUSE5",
    [8]="BACKSPACE", [9]="TAB", [12]="CLEAR", [13]="ENTER", [16]="SHIFT", [17]="CTRL", [18]="ALT",
    [19]="PAUSE", [20]="CAPSLOCK", [27]="ESC", [32]="SPACE", [33]="PGUP", [34]="PGDN",
    [35]="END", [36]="HOME", [37]="LEFT", [38]="UP", [39]="RIGHT", [40]="DOWN",
    [44]="PRINT", [45]="INSERT", [46]="DELETE", [91]="LWIN", [92]="RWIN", [93]="APPS",
    [106]="NUM*", [107]="NUM+", [108]="NUMENTER", [109]="NUM-", [110]="NUM.", [111]="NUM/",
    [144]="NUMLOCK", [145]="SCROLL", [160]="LSHIFT", [161]="RSHIFT", [162]="LCTRL", [163]="RCTRL",
    [164]="LALT", [165]="RALT", [173]="MUTE", [174]="VOLDOWN", [175]="VOLUP",
    [176]="NEXTTRACK", [177]="PREVTRACK", [178]="STOPMEDIA", [179]="PLAYPAUSE",
    [186]=";", [187]="=", [188]=",", [189]="-", [190]=".", [191]="/", [192]="~",
    [219]="[", [220]="\\", [221]="]", [222]="'", [226]="OEM102", [253]="WHEELDOWN", [254]="WHEELUP",
}
for i=48,57 do local ch=string.char(i); names[ch]=i; canonicalName[i]=ch end
for i=65,90 do local ch=string.char(i); names[ch]=i; canonicalName[i]=ch end
for i=0,9 do
    local vk = 96 + i
    local k = "NUM"..i
    names[k]=vk; names["NUMPAD"..i]=vk; names["NP"..i]=vk
    canonicalName[vk]=k
end
for i=1,24 do local k="F"..i; names[k]=111+i; canonicalName[111+i]=k end
for i=1,254 do
    local vkKey = "VK"..i
    if not names[vkKey] then names[vkKey]=i end
    if not names["VK_"..i] then names["VK_"..i]=i end
    local hexKey = string.format("0X%02X", i)
    if not names[hexKey] then names[hexKey]=i end
    if not canonicalName[i] then canonicalName[i]=vkKey end
end
local modTokens = {
    CTRL = MOD_CTRL, CONTROL = MOD_CTRL, CTL = MOD_CTRL, LCTRL = MOD_CTRL, RCTRL = MOD_CTRL, LCONTROL = MOD_CTRL, RCONTROL = MOD_CTRL, C = MOD_CTRL,
    SHIFT = MOD_SHIFT, SHF = MOD_SHIFT, LSHIFT = MOD_SHIFT, RSHIFT = MOD_SHIFT, S = MOD_SHIFT,
    ALT = MOD_ALT, MENU = MOD_ALT, LALT = MOD_ALT, RALT = MOD_ALT, LMENU = MOD_ALT, RMENU = MOD_ALT, A = MOD_ALT,
    CS = MOD_CTRL + MOD_SHIFT, SC = MOD_CTRL + MOD_SHIFT,
    CA = MOD_CTRL + MOD_ALT, AC = MOD_CTRL + MOD_ALT,
    AS = MOD_ALT + MOD_SHIFT, SA = MOD_ALT + MOD_SHIFT,
    CAS = MOD_CTRL + MOD_ALT + MOD_SHIFT, CSA = MOD_CTRL + MOD_ALT + MOD_SHIFT,
    ACS = MOD_CTRL + MOD_ALT + MOD_SHIFT, ASC = MOD_CTRL + MOD_ALT + MOD_SHIFT,
    SCA = MOD_CTRL + MOD_ALT + MOD_SHIFT, SAC = MOD_CTRL + MOD_ALT + MOD_SHIFT,
}
local function FormatKeyCode(code)
    code = tonumber(code) or 0
    if code <= 0 then return "" end
    local vk = code % 256
    if vk <= 0 or vk > 254 then return "" end
    local flags = math.floor(code / 256)
    local hasShift = (flags % 2) == 1
    local hasCtrl = (math.floor(flags / 2) % 2) == 1
    local hasAlt = (math.floor(flags / 4) % 2) == 1
    local base = canonicalName[vk] or ("VK"..vk)
    return (hasCtrl and "CTRL+" or "") .. (hasAlt and "ALT+" or "") .. (hasShift and "SHIFT+" or "") .. base
end
local function ParseKeySpec(raw)
    local s = string.upper(string.match(tostring(raw or ""), "^%s*(.-)%s*$"))
    if s == "" then return 0, "" end
    if names[s] then
        local vk = names[s]
        return vk, canonicalName[vk] or s
    end
    local rest = s
    local hasShift, hasCtrl, hasAlt = false, false, false
    for _ = 1, 4 do
        local prefix, rem = string.match(rest, "^([A-Z]+)%s*[+%-%s]%s*(.+)$")
        local mod = prefix and modTokens[prefix]
        if not mod or not rem or rem == "" then break end
        if (mod % 512) >= 256 then hasShift = true end
        if (mod % 1024) >= 512 then hasCtrl = true end
        if mod >= 1024 then hasAlt = true end
        rest = string.match(rem, "^%s*(.-)%s*$")
        if names[rest] then break end
    end
    local vk = names[rest]
    if not vk then return nil end
    if (vk == 16 or vk == 160 or vk == 161) then hasShift = false end
    if (vk == 17 or vk == 162 or vk == 163) then hasCtrl = false end
    if (vk == 18 or vk == 164 or vk == 165) then hasAlt = false end
    local code = vk + (hasShift and MOD_SHIFT or 0) + (hasCtrl and MOD_CTRL or 0) + (hasAlt and MOD_ALT or 0)
    return code, FormatKeyCode(code)
end
hold.ParseKeySpec = ParseKeySpec
hold.FormatKeyCode = FormatKeyCode
local old = Read(controlFile)
if old and old.version == 2 then
    runId = tonumber(old.run_id) or 0
    if old.interval_ms and type(old.interval_ms) == "number" then
        interval_ms = math.max(20, math.min(1000, math.floor(old.interval_ms)))
    end
    for i=1,4 do
        keys[i] = FormatKeyCode(old["key_"..i])
    end
end
local pos=Read(uiFile)
if pos and type(pos.x)=="number" and type(pos.y)=="number"
    and math.abs(pos.x)<10000 and math.abs(pos.y)<10000 then
    uiX,uiY,mini=pos.x,pos.y,pos.mini==true
    if pos.interval_ms and type(pos.interval_ms) == "number" then
        interval_ms = math.max(20, math.min(1000, math.floor(pos.interval_ms)))
    end
    if pos.ground_mode and (pos.ground_mode == "target" or pos.ground_mode == "mouse" or pos.ground_mode == "manual") then
        groundMode = pos.ground_mode
    end
end
xMacro.GroundTargetMode = groundMode

local function Item(name) return frame and frame:Lookup("",name) end
local function Child(name) return frame and frame:Lookup(name) end
local function Text(name,text)
    local item=Item(name)
    if item then item:SetText(text) end
end
local function ButtonText(name,text)
    local button=Child(name)
    local handle=button and button:Lookup("","")
    local label=handle and handle:Lookup("Text_"..name)
    if label then label:SetText(text) end
end
local function Online() return Now()-seenAt<2000 end
local function Write(want, values, newRun)
    if not SaveLUAData then notice="Client thieu SaveLUAData."; return false end
    if newRun == nil then newRun = want and not enabled end
    local nextRunId = runId + (newRun and 1 or 0)
    local data={version=2,enabled=want,interval_ms=interval_ms,run_id=nextRunId}
    for i=1,4 do data["key_"..i]=values[i] or 0 end
    local ok,result=pcall(SaveLUAData,controlFile,data)
    if not ok or result==false then notice="Loi luu lenh. Kiem tra quyen ghi."; return false end
    enabled,runId=want,data.run_id
    return true
end
local function CurrentValues()
    local values, used, count={},{},0
    for i=1,4 do
        local edit=Child("Edit_"..i)
        local text=(edit and edit:GetText()) or keys[i]
        local vk, label = ParseKeySpec(text)
        if not vk then return nil,"Phim "..i.." khong hop le." end
        if vk~=0 and used[vk] then return nil,"Khong gan trung phim." end
        if vk~=0 then used[vk]=true;count=count+1 end
        values[i]=vk;keys[i]=label
        if edit and edit:GetText() ~= label then edit:SetText(label) end
    end
    if count==0 then return nil,"Hay gan it nhat 1 phim." end
    return values
end
function hold.SavePosition()
    if not frame then return false end
    uiX,uiY=frame:GetRelPos()
    if SaveLUAData then
        local ok,result=pcall(SaveLUAData,uiFile,{
            x=uiX,
            y=uiY,
            mini=mini,
            interval_ms=interval_ms,
            ground_mode=groundMode,
        })
        return ok and result~=false
    end
    return false
end
function hold.SetInterval(val)
    val = tonumber(val)
    if not val then return end
    val = math.floor(val)
    if val < 20 then val = 20 end
    if val > 1000 then val = 1000 end
    interval_ms = val
    local edit = Child("Edit_Speed")
    if edit then edit:SetText(tostring(interval_ms)) end
    hold.SavePosition()
    if enabled then
        local values = CurrentValues()
        if not values then
            values = {}
            for i = 1, 4 do values[i] = (ParseKeySpec(keys[i])) or 0 end
        end
        Write(true, values)
    else
        local values = {}
        for i = 1, 4 do
            local editKey = Child("Edit_"..i)
            local txt = (editKey and editKey:GetText()) or keys[i]
            values[i] = (ParseKeySpec(txt)) or 0
        end
        Write(false, values)
    end
    hold.UpdateHUD()
end
function hold.SetGroundMode(mode)
    if mode ~= "target" and mode ~= "mouse" and mode ~= "manual" then return end
    groundMode = mode
    xMacro.GroundTargetMode = mode
    if SyncAIOTLHelperBachTuc then
        pcall(SyncAIOTLHelperBachTuc)
    elseif _G.SyncAIOTLHelperBachTuc then
        pcall(_G.SyncAIOTLHelperBachTuc)
    end
    hold.SavePosition()
    hold.UpdateHUD()
    if OutputMessage then
        local names = {
            target = "Muc tieu (Tu dong danh vao Boss)",
            mouse = "Theo chuot (Dat tai vi tri con tro chuot)",
            manual = "Chon vung (Mac dinh game / Lam nhiem vu)",
        }
        pcall(OutputMessage, "MSG_SYS", "[xMacro] Che do cast vung: " .. (names[mode] or mode) .. "\n")
    end
end
function hold.SetEnabled(want)
    local values,err=CurrentValues()
    if want and not values then notice=err
    elseif want and not Online() then notice="Helper OFFLINE: mo start_xmacro.bat."
    else
        if not values then
            values={}
            for i=1,4 do values[i]=(ParseKeySpec(keys[i])) or 0 end
        end
        if Write(want,values) then notice=want and "Da gui lenh. Dang cho helper..." or "Da gui lenh DUNG." end
    end
    hold.UpdateHUD()
    return enabled==want
end
function hold.Start()
    -- Holding the Start hotkey must not restart the run on keyboard repeat.
    if enabled then return true end
    return hold.SetEnabled(true)
end
function hold.Stop() return hold.SetEnabled(false) end
function hold.Toggle() return hold.SetEnabled(not enabled) end
-- One toggle per physical press; OS key repeat must not flip the state again.
local toggleKeyDown = false
if Hotkey and Hotkey.AddBinding then
    pcall(Hotkey.AddBinding, "XMACRO_KEY_SPAM_TOGGLE", "xMacro: Key Spam - Bat/Tat", "xMacro - Key Spam BAT/TAT",
        function()
            if toggleKeyDown then return end
            toggleKeyDown = true
            return hold.Toggle()
        end,
        function() toggleKeyDown = false end)
end
function hold.UpdateHUD()
    if not frame then return end
    local live=Online()
    local label="DUNG"
    if enabled then
        label="CHO HELPER"
        if live and status.run_id==runId then
            if status.state==2 then label="DANG SPAM"
            elseif status.state==1 then label="CHO GAME"
            elseif status.state==3 then label="LOI - DUNG/BAT LAI"
            elseif status.state==5 then label="GAME THU NHO"
            elseif status.state==6 then label="GUI PHIM NEN"
            elseif status.state==7 then label="CHO DOI CUA SO" end
        end
    end
    Text("Text_Title","xMacro - Key Spam | Keo")
    Text("Text_Status",label.." | "..interval_ms.." ms")
    Text("Text_Helper",live and "Helper: ONLINE" or "Helper: OFFLINE - mo launcher")
    Text("Text_Notice",notice)
    Text("Text_Help","Moi phim & to hop: ALT+1, CTRL+Q, SHIFT+F1, -, =...")
    Text("Text_Background","Alt+Tab: de game o che do cua so.")
    Text("Text_Speed","Toc do:")
    ButtonText("Btn_On","BAT DAU")
    ButtonText("Btn_Off","DUNG")
    ButtonText("Btn_Mini",mini and "+" or "-")
    ButtonText("Btn_SpeedSub","-")
    ButtonText("Btn_SpeedAdd","+")
    ButtonText("Btn_Spd30","30")
    ButtonText("Btn_Spd50","50")
    ButtonText("Btn_Spd100","100")

    Text("Text_GroundMode","Vung:")
    ButtonText("Btn_ModeTarget", groundMode == "target" and "[M.Tieu]" or "Muc tieu")
    ButtonText("Btn_ModeMouse", groundMode == "mouse" and "[Chuot]" or "Chuot")
    ButtonText("Btn_ModeManual", groundMode == "manual" and "[Vung]" or "Chon vung")

    for i=1,4 do
        Text("Text_Key"..i,"Phim "..i)
        local edit=Child("Edit_"..i)
        if edit then edit:Enable(enabled and 0 or 1) end
    end
    local on,off=Child("Btn_On"),Child("Btn_Off")
    if on then on:Enable(enabled and 0 or 1) end
    -- Stop remains usable even when the helper disconnects.
    if off then off:Enable(1) end
    local h=mini and 76 or 360
    frame:SetSize(320,h)
    local bg=Item("Image_Background")
    if bg and bg.SetSize then bg:SetSize(320,h) end
    for _,name in ipairs({"Text_Helper","Text_Notice","Text_Help","Text_Background",
        "Text_Key1","Text_Key2","Text_Key3","Text_Key4",
        "Image_Edit1","Image_Edit2","Image_Edit3","Image_Edit4",
        "Text_Speed","Image_EditSpeed","Text_GroundMode"}) do
        local item=Item(name)
        if item then if mini then item:Hide() else item:Show() end end
    end
    for i=1,4 do
        local edit=Child("Edit_"..i)
        if edit then if mini then edit:Hide() else edit:Show() end end
    end
    for _,name in ipairs({"Edit_Speed","Btn_SpeedSub","Btn_SpeedAdd","Btn_Spd30","Btn_Spd50","Btn_Spd100",
        "Btn_ModeTarget","Btn_ModeMouse","Btn_ModeManual"}) do
        local wnd=Child(name)
        if wnd then if mini then wnd:Hide() else wnd:Show() end end
    end
    if mini then on:Hide(); off:SetRelPos(222,39);off:SetSize(86,28)
    else on:Show();off:SetRelPos(166,260);off:SetSize(142,30) end
end
function hold.ToggleMini()
    mini=not mini
    hold.UpdateHUD()
    hold.SavePosition()
end
local function Mouse()
    if Cursor and Cursor.GetPos then
        local ok,x,y=pcall(Cursor.GetPos)
        if ok and type(x)=="number" and type(y)=="number" then return x,y end
        ok,x,y=pcall(Cursor.GetPos,Cursor)
        if ok and type(x)=="number" and type(y)=="number" then return x,y end
    end
    for _,name in ipairs({"GetMessagePos","GetMousePos"}) do
        if Station and Station[name] then
            local ok,x,y=pcall(Station[name],Station)
            if ok and type(x)=="number" and type(y)=="number" then return x,y end
        end
    end
end
function hold.EndDrag()
    if dragging then dragging=nil;hold.SavePosition() end
end
function hold.BeginDrag()
    local x,y=Mouse()
    if not frame or not x then return end
    local ax,ay=frame:GetAbsPos()
    if x<ax or x>ax+276 or y<ay or y>ay+34 then return end
    local fx,fy=frame:GetRelPos()
    dragging={x=x,y=y,fx=fx,fy=fy}
end
function hold.DragTick()
    if not dragging or not frame then return end
    local fn=Station and (Station.IsLButtonPressed or Station.IsLButtonDown)
    if fn then
        local ok,down=pcall(fn,Station)
        if ok and down==false then hold.EndDrag();return end
    end
    local x,y=Mouse()
    if x then
        frame:SetRelPos(dragging.fx+x-dragging.x,dragging.fy+y-dragging.y)
        if frame.CorrectPos then frame:CorrectPos() end
    end
end
function hold.EnsureHUD()
    if not (Wnd and Wnd.OpenWindow) then return false end
    if GetClientPlayer and not GetClientPlayer() then return false end
    local current=Station and Station.Lookup and Station.Lookup("Normal/XMacroHoldKeyHUD")
    if frame and current==frame then return true end
    if current and (not current:Lookup("Btn_Mini") or not current:Lookup("Edit_Speed") or not current:Lookup("Btn_ModeTarget")) and Wnd.CloseWindow then
        pcall(Wnd.CloseWindow,current)
        current=nil
    end
    frame=current or Wnd.OpenWindow("interface/xMacro/HoldKey.ini","XMacroHoldKeyHUD")
    if not frame then return false end
    frame:SetRelPos(uiX,uiY)
    if frame.SetDummyWnd then frame:SetDummyWnd(false) end
    if frame.EnableDrag then frame:EnableDrag(true) end
    if frame.SetDragArea then
        pcall(frame.SetDragArea,frame,0,0,276,34)
        pcall(frame.SetDragArea,frame,276,34)
    end
    local on,off,small=Child("Btn_On"),Child("Btn_Off"),Child("Btn_Mini")
    if not on or not off or not small then frame=nil;return false end
    on.OnLButtonClick=function() hold.Start() end
    off.OnLButtonClick=function() hold.Stop() end
    small.OnLButtonClick=hold.ToggleMini
    for i=1,4 do
        local edit=Child("Edit_"..i)
        if not edit then frame=nil;return false end
        edit:SetText(keys[i])
    end
    local editSpeed=Child("Edit_Speed")
    if editSpeed then
        editSpeed:SetText(tostring(interval_ms))
        editSpeed.OnKillFocus=function()
            local text=editSpeed:GetText()
            local num=tonumber(text)
            if num then
                hold.SetInterval(num)
            else
                editSpeed:SetText(tostring(interval_ms))
            end
        end
        editSpeed.OnEditSpecialKeyDown=function()
            local text=editSpeed:GetText()
            local num=tonumber(text)
            if num then hold.SetInterval(num) end
        end
    end
    local btnSub=Child("Btn_SpeedSub")
    if btnSub then btnSub.OnLButtonClick=function() hold.SetInterval(interval_ms-10) end end
    local btnAdd=Child("Btn_SpeedAdd")
    if btnAdd then btnAdd.OnLButtonClick=function() hold.SetInterval(interval_ms+10) end end
    local spd30=Child("Btn_Spd30")
    if spd30 then spd30.OnLButtonClick=function() hold.SetInterval(30) end end
    local spd50=Child("Btn_Spd50")
    if spd50 then spd50.OnLButtonClick=function() hold.SetInterval(50) end end
    local spd100=Child("Btn_Spd100")
    if spd100 then spd100.OnLButtonClick=function() hold.SetInterval(100) end end

    local btnTar=Child("Btn_ModeTarget")
    if btnTar then btnTar.OnLButtonClick=function() hold.SetGroundMode("target") end end
    local btnMouse=Child("Btn_ModeMouse")
    if btnMouse then btnMouse.OnLButtonClick=function() hold.SetGroundMode("mouse") end end
    local btnManual=Child("Btn_ModeManual")
    if btnManual then btnManual.OnLButtonClick=function() hold.SetGroundMode("manual") end end

    for _,wnd in ipairs({frame,Child("Drag_Title")}) do
        wnd.OnLButtonDown=hold.BeginDrag
        wnd.OnLButtonUp=hold.EndDrag
        wnd.OnMouseMove=hold.DragTick
        wnd.OnFrameDrag=hold.DragTick
        wnd.OnFrameDragEnd=function() dragging=nil;hold.SavePosition() end
    end
    frame:Show()
    hold.UpdateHUD()
    return true
end
function hold.Tick()
    hold.DragTick()
    local now=Now()
    if now<nextPoll then return end
    nextPoll=now+250
    if now>=nextDiagnostic and SaveLUAData and xMacro.VanHoaDiagnostics then
        nextDiagnostic=now+1000
        pcall(SaveLUAData,"interface\\xMacro\\vanhoa_status.jx3dat",xMacro.VanHoaDiagnostics)
    end
    local data=Read(statusFile)
    if data and type(data.seq)=="number" and type(data.pid)=="number" then
        if lastPid==data.pid and lastSeq~=nil and lastSeq~=data.seq then seenAt=now end
        if lastPid~=data.pid then seenAt=-10000 end
        lastSeq,lastPid,status=data.seq,data.pid,data
    end
    local ok, result=pcall(hold.EnsureHUD)
    if not ok and not hold.uiError then
        hold.uiError=tostring(result)
        if OutputMessage then
            pcall(OutputMessage,"MSG_SYS","[xMacro Key Spam] UI_ERROR: "..hold.uiError.."\n")
        end
    elseif ok and result then
        hold.uiError=nil
        hold.UpdateHUD()
    end
end
-- Breathe already runs on the addon's existing frame; render callbacks vary by client.
if not xMacro._HoldBreatheInstalled then
    xMacro._HoldOriginalBreathe=xMacro.OnFrameBreathe
    xMacro._HoldBreatheInstalled=true
end
function xMacro.OnFrameBreathe(...)
    if xMacro._HoldOriginalBreathe then xMacro._HoldOriginalBreathe(...) end
    hold.Tick()
end
if RegisterEvent then
    for _,event in ipairs({"PLAYER_ENTER_GAME","PLAYER_ENTER_SCENE","LOADING_END","RENDER_FRAME_UPDATE"}) do
        pcall(RegisterEvent,event,hold.Tick)
    end
end
-- Reload always stops the old run; saved bindings are preserved.
local initial={}
for i=1,4 do initial[i]=(ParseKeySpec(keys[i])) or 0 end
Write(false,initial)
