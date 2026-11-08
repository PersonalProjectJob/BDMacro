Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class EngineLua {
    [DllImport(@"G:\JXOnline3VN-v2.5.2+launcher\JXOnline3VN-v2.5.2+launcher\engine_lua5.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr luaL_newstate();
    [DllImport(@"G:\JXOnline3VN-v2.5.2+launcher\JXOnline3VN-v2.5.2+launcher\engine_lua5.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern void luaL_openlibs(IntPtr L);
    [DllImport(@"G:\JXOnline3VN-v2.5.2+launcher\JXOnline3VN-v2.5.2+launcher\engine_lua5.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int luaL_loadbuffer(IntPtr L, byte[] buff, UIntPtr sz, string name);
    [DllImport(@"G:\JXOnline3VN-v2.5.2+launcher\JXOnline3VN-v2.5.2+launcher\engine_lua5.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int lua_pcall(IntPtr L, int nargs, int nresults, int errfunc);
    [DllImport(@"G:\JXOnline3VN-v2.5.2+launcher\JXOnline3VN-v2.5.2+launcher\engine_lua5.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr lua_tolstring(IntPtr L, int idx, out UIntPtr len);
}
'@

$L = [EngineLua]::luaL_newstate()
[EngineLua]::luaL_openlibs($L)

# Test with GetSkillLevel returning 0 (like in real client for many skills)
$mock = @"
OutputMessage = function(c, msg) print('[MSG] ' .. tostring(msg)) end
RegisterEvent = function() end
OnAddOnUseSkill = function(id, lv) print('[CAST ADDON] Skill ' .. tostring(id)) return true end
OnCastPlayerSkill = function(p, id, lv) print('[CAST PLAYER] Skill ' .. tostring(id)) return true end
UITestCast = function(id, lv, t) return true end
GetLogicFrameCount = function() return 100 end

local currentMount = 10014

GetClientPlayer = function()
    return {
        dwID = 1,
        bDeathFlag = false,
        bFightState = false,
        bOnHorse = false,
        nCurrentLife = 10000,
        nMaxLife = 10000,
        nCurrentMana = 8000,
        nMaxMana = 10000,
        nCurrentRage = 100,
        nMaxRage = 100,
        GetKungfuMount = function() return { dwSkillID = currentMount } end,
        GetSkillLevel = function(id) return 0 end, -- RETURNS 0!
        GetSkillCDProgress = function(id, lv) return false, 0, 0 end,
        GetTarget = function() return 1, 2 end,
        GetBuffList = function() return {} end
    }
end

GetCurrentTargetObject = function()
    return {
        dwID = 2,
        bDeathFlag = false,
        nCurrentLife = 10000,
        nMaxLife = 10000,
        nX = 100, nY = 100, nZ = 0,
        GetBuffList = function() return {} end
    }
end

GetDistanceByTarget = function(me, tar) return 3.8 end
IsEnemy = function(a, b) return false end
"@

$bytesMock = [System.Text.Encoding]::UTF8.GetBytes($mock)
[EngineLua]::luaL_loadbuffer($L, $bytesMock, [System.UIntPtr][uint32]$bytesMock.Length, "mock") | Out-Null
[EngineLua]::lua_pcall($L, 0, 0, 0) | Out-Null

$slots = 0..15 | ForEach-Object {
    $n = "{0:D2}" -f $_
    $file = Get-ChildItem "G:\JXOnline3VN-v2.5.2+launcher\JXOnline3VN-v2.5.2+launcher\interface\xMacro\Native\XM$n*.lua"
    $file.FullName
}

foreach ($path in $slots) {
    $bytes = [System.IO.File]::ReadAllBytes($path)
    if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $bytes = $bytes[3..($bytes.Length - 1)]
    }
    $res = [EngineLua]::luaL_loadbuffer($L, $bytes, [System.UIntPtr][uint32]$bytes.Length, [System.IO.Path]::GetFileName($path))
    if ($res -ne 0) { exit 1 }
    $resCall = [EngineLua]::lua_pcall($L, 0, 0, 0)
    if ($resCall -ne 0) { exit 1 }
}

$testCall = @"
print('--- TEST WITH GetSkillLevel = 0 ---')
local res = xMacro.Run()
print('Return value when GetSkillLevel returns 0: ' .. tostring(res))
"@

$testBytes = [System.Text.Encoding]::UTF8.GetBytes($testCall)
[EngineLua]::luaL_loadbuffer($L, $testBytes, [System.UIntPtr][uint32]$testBytes.Length, "testCall") | Out-Null
[EngineLua]::lua_pcall($L, 0, 0, 0) | Out-Null
