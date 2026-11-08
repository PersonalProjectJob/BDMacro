-- Shared guard for PvE damage scripts in the Hoang Cung Nam Chieu client.
function xMacro.Schools.RegisterDamageScript(school, profile, scriptsByMount)
    local factories = xMacro.SchoolFactories
    factories[school] = factories[school] or {}
    factories[school][profile] = function(deps)
        local function Run()
            local player = GetClientPlayer and GetClientPlayer()
            if not player or not player.GetKungfuMount or player.bDeathFlag then
                return false
            end
            local mount = player.GetKungfuMount and player.GetKungfuMount()
            local kungfuID = mount and (mount.dwSkillID or mount.dwMountKungfuID) or (type(mount) == "number" and mount)
            if kungfuID then kungfuID = tonumber(kungfuID) or kungfuID end
            local script = kungfuID and (scriptsByMount[kungfuID] or (type(kungfuID) == "number" and scriptsByMount[tostring(kungfuID)]))
            if not script then
                for _, s in pairs(scriptsByMount) do
                    if type(s) == "string" or type(s) == "function" then
                        script = s
                        break
                    end
                end
            end
            if not script then return false end

            if type(script) == "function" then script = script(player) end
            -- Execute macro script cleanly through xMacro core engine
            return ExecuteMacroCommand("/config before:null\n" .. script)
        end
        return {run = Run}
    end
    if xMacro.SchoolProfiles[school] then xMacro.SchoolProfiles[school][profile] = nil end
end
