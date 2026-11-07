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

$mock = @"
OutputMessage = function() end
RegisterEvent = function() end
GetClientPlayer = function()
    return {
        dwID = 1,
        bDeathFlag = false,
        nCurrentRage = 100,
        nMaxRage = 100,
        GetKungfuMount = function() return { dwSkillID = 10002 } end,
        GetSkillLevel = function(id) return 1 end,
        GetSkillCDProgress = function(id, lv) return false, 0, 0 end
    }
end
GetCurrentTargetObject = function()
    return { dwID = 2, bDeathFlag = false }
end
IsEnemy = function(a, b) return true end
GetLogicFrameCount = function() return 100 end
"@

$bytesMock = [System.Text.Encoding]::UTF8.GetBytes($mock)
[EngineLua]::luaL_loadbuffer($L, $bytesMock, [System.UIntPtr][uint32]$bytesMock.Length, "mock") | Out-Null
[EngineLua]::lua_pcall($L, 0, 0, 0) | Out-Null

$runtimeBytes = [System.IO.File]::ReadAllBytes("G:\JXOnline3VN-v2.5.2+launcher\JXOnline3VN-v2.5.2+launcher\interface\xMacro\Runtime.lua")
if ($runtimeBytes[0] -eq 0xEF -and $runtimeBytes[1] -eq 0xBB -and $runtimeBytes[2] -eq 0xBF) {
    $runtimeBytes = $runtimeBytes[3..($runtimeBytes.Length - 1)]
}

$res = [EngineLua]::luaL_loadbuffer($L, $runtimeBytes, [System.UIntPtr][uint32]$runtimeBytes.Length, "Runtime.lua")
if ($res -ne 0) {
    $len = [UIntPtr]::Zero
    $ptr = [EngineLua]::lua_tolstring($L, -1, [ref]$len)
    $err = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($ptr)
    Write-Host "[FAILED LOAD BUFFER] $err"
    exit 1
}

$resCall = [EngineLua]::lua_pcall($L, 0, 0, 0)
if ($resCall -ne 0) {
    $len = [UIntPtr]::Zero
    $ptr = [EngineLua]::lua_tolstring($L, -1, [ref]$len)
    $err = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($ptr)
    Write-Host "[FAILED PCALL] $err"
    exit 1
}

$testCall = @"
assert(xMacro.Runtime.ready == true, 'Runtime not ready')
local aliases = xMacro.Core.SchoolAliases
assert(aliases['TLTT'] ~= nil and aliases['TLTT'].school == 'ThieuLam' and aliases['TLTT'].profile == 'TayTuyKinh', 'TLTT failed')
assert(aliases['TL'] ~= nil and aliases['TL'].school == 'ThieuLam' and aliases['TL'].profile == 'DichCanKinh', 'TL failed')
assert(aliases['TSTL'] ~= nil and aliases['TSTL'].school == 'ThienSach' and aliases['TSTL'].profile == 'ThietLao', 'TSTL failed')
assert(aliases['TS'] ~= nil and aliases['TS'].school == 'ThienSach' and aliases['TS'].profile == 'DPS', 'TS failed')
assert(aliases['MGMT'] ~= nil and aliases['MGMT'].school == 'MinhGiao' and aliases['MGMT'].profile == 'MinhTon', 'MGMT failed')
assert(aliases['MG'] ~= nil and aliases['MG'].school == 'MinhGiao' and aliases['MG'].profile == 'PhanAnh', 'MG failed')
assert(aliases['TDTH'] ~= nil and aliases['TDTH'].school == 'ThuanDuong' and aliases['TDTH'].profile == 'TuHaCong', 'TDTH failed')
assert(aliases['TDTK'] ~= nil and aliases['TDTK'].school == 'ThuanDuong' and aliases['TDTK'].profile == 'ThaiHuKiemY', 'TDTK failed')
assert(aliases['DMKV'] ~= nil and aliases['DMKV'].school == 'DuongMon' and aliases['DMKV'].profile == 'KinhVu', 'DMKV failed')
assert(aliases['DMTL'] ~= nil and aliases['DMTL'].school == 'DuongMon' and aliases['DMTL'].profile == 'ThienLa', 'DMTL failed')
assert(aliases['TK'] ~= nil and aliases['TK'].school == 'TangKiem' and aliases['TK'].profile == 'DPS', 'TK failed')
assert(aliases['7T'] ~= nil and aliases['7T'].school == 'ThatTu' and aliases['7T'].profile == 'BangTam', '7T failed')
assert(aliases['ND'] ~= nil and aliases['ND'].school == 'NguDoc' and aliases['ND'].profile == 'DocKinh', 'ND failed')
assert(aliases['VH'] ~= nil and aliases['VH'].school == 'VanHoa' and aliases['VH'].profile == 'HoaGian', 'VH failed')

-- Test execution of both Kungfus
local selTLTT, idTLTT = xMacro.ActiveSelection({GetKungfuMount = function() return {dwSkillID=10002} end})
assert(selTLTT and selTLTT.profile == 'TayTuyKinh', 'ActiveSelection for TLTT 10002 failed')

local selTLDC, idTLDC = xMacro.ActiveSelection({GetKungfuMount = function() return {dwSkillID=10003} end})
assert(selTLDC and selTLDC.profile == 'DichCanKinh', 'ActiveSelection for TLDC 10003 failed')

local selTSTL, idTSTL = xMacro.ActiveSelection({GetKungfuMount = function() return {dwSkillID=10062} end})
assert(selTSTL and selTSTL.profile == 'ThietLao', 'ActiveSelection for TSTL 10062 failed')

local selTSNH, idTSNH = xMacro.ActiveSelection({GetKungfuMount = function() return {dwSkillID=10026} end})
assert(selTSNH and selTSNH.profile == 'DPS', 'ActiveSelection for TSNH 10026 failed')

local selMGMT, idMGMT = xMacro.ActiveSelection({GetKungfuMount = function() return {dwSkillID=10243} end})
assert(selMGMT and selMGMT.profile == 'MinhTon', 'ActiveSelection for MGMT 10243 failed')

local selMGPA, idMGPA = xMacro.ActiveSelection({GetKungfuMount = function() return {dwSkillID=10242} end})
assert(selMGPA and selMGPA.profile == 'PhanAnh', 'ActiveSelection for MGPA 10242 failed')

print('[LUA5 ENGINE PASSED] All schools and both internal kungfus verified in engine_lua5.dll!')
"@

$testBytes = [System.Text.Encoding]::UTF8.GetBytes($testCall)
[EngineLua]::luaL_loadbuffer($L, $testBytes, [System.UIntPtr][uint32]$testBytes.Length, "testCall") | Out-Null
$resTest = [EngineLua]::lua_pcall($L, 0, 0, 0)
if ($resTest -ne 0) {
    $len = [UIntPtr]::Zero
    $ptr = [EngineLua]::lua_tolstring($L, -1, [ref]$len)
    $err = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($ptr)
    Write-Host "[FAILED TEST] $err"
    exit 1
}
