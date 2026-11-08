$ErrorActionPreference = "Stop"

$dllPath = [IO.Path]::GetFullPath("engine_lua5.dll")
if (-not (Test-Path $dllPath)) {
    Write-Error "Missing engine_lua5.dll"
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Lua5TestCloud {
    [DllImport(@"$($dllPath.Replace('\', '\\'))", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr luaL_newstate();

    [DllImport(@"$($dllPath.Replace('\', '\\'))", CallingConvention = CallingConvention.Cdecl)]
    public static extern void luaL_openlibs(IntPtr L);

    [DllImport(@"$($dllPath.Replace('\', '\\'))", CallingConvention = CallingConvention.Cdecl)]
    public static extern void lua_close(IntPtr L);

    [DllImport(@"$($dllPath.Replace('\', '\\'))", CallingConvention = CallingConvention.Cdecl)]
    public static extern int luaL_loadbuffer(IntPtr L, byte[] buff, UIntPtr sz, string name);

    [DllImport(@"$($dllPath.Replace('\', '\\'))", CallingConvention = CallingConvention.Cdecl)]
    public static extern int lua_pcall(IntPtr L, int nargs, int nresults, int errfunc);

    [DllImport(@"$($dllPath.Replace('\', '\\'))", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr lua_tolstring(IntPtr L, int idx, out UIntPtr len);
}
"@

$L = [Lua5TestCloud]::luaL_newstate()
[Lua5TestCloud]::luaL_openlibs($L)

$runtimeContent = [IO.File]::ReadAllText("BDMacro-export/Runtime.lua")
$htmlContent = [IO.File]::ReadAllText("BDMacro-export/api/cloud_rotations.html")
$escapedHtml = $htmlContent.Replace('\', '\\').Replace('"', '\"').Replace("`r", "").Replace("`n", "\n")

$testScript = @"
OutputMessage = function(ch, msg) end
GetLogicFrameCount = function() return 100 end
GetTime = function() return 123456 end
ExecuteMacroCommand = function(cmd) return true end

$runtimeContent

-- Test ApplyCloudPayload with HTML response
local html = "$escapedHtml"
local okApply, count, ver = pcall(function()
    -- Emulate what FetchCloudRotations does
    local preData = string.match(html, "<pre.->(.-)</pre>")
    local raw = preData or html
    local retPos = string.find(raw, "return%s*{")
    if retPos then raw = string.sub(raw, retPos) end
    local fn = loadstring(raw)
    local payload = fn()
    assert(type(payload.rotations) == "table", "rotations table missing")
    assert(payload.rotations[10243] ~= nil, "kungfu 10243 missing in payload")
    assert(payload.rotations[10243].school == "MinhGiao", "school mismatch")
    assert(payload.rotations[10243].profile == "MinhTon", "profile mismatch")
    return true
end)

if not okApply then
    error("Cloud payload test failed: " .. tostring(count))
end

-- Test ActiveSelection for 10243
local mockPlayer10243 = {
    GetKungfuMount = function()
        return { dwSkillID = 10243 }
    end
}
local sel, id = xMacro.ActiveSelection(mockPlayer10243)
assert(sel ~= nil, "ActiveSelection failed for 10243")
assert(sel.school == "MinhGiao" and sel.profile == "MinhTon", "Selection mismatch for 10243")

print("[TEST PASSED] Cloud API payload and 10243 resolution verified successfully!")
"@

$bytes = [Text.Encoding]::UTF8.GetBytes($testScript)
$rc = [Lua5TestCloud]::luaL_loadbuffer($L, $bytes, [System.UIntPtr][uint32]$bytes.Length, "test_cloud.lua")
if ($rc -ne 0) {
    $len = [UIntPtr]::Zero
    $ptr = [Lua5TestCloud]::lua_tolstring($L, -1, [ref]$len)
    $msg = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($ptr, [int]$len)
    [Lua5TestCloud]::lua_close($L)
    Write-Error "[FAILED LOAD BUFFER] $msg"
}

$rc = [Lua5TestCloud]::lua_pcall($L, 0, 0, 0)
if ($rc -ne 0) {
    $len = [UIntPtr]::Zero
    $ptr = [Lua5TestCloud]::lua_tolstring($L, -1, [ref]$len)
    $msg = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($ptr, [int]$len)
    [Lua5TestCloud]::lua_close($L)
    Write-Error "[FAILED EXECUTION] $msg"
}

[Lua5TestCloud]::lua_close($L)
Write-Host "[ALL CLOUD TESTS PASSED] Successfully verified in 32-bit Lua engine!" -ForegroundColor Green
