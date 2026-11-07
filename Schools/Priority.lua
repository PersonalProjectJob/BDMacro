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
