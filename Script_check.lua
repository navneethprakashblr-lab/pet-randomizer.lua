-- SIMPLE AUDIT: Teleport / Remote / Destroy logger
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local safe_print = function(...) pcall(print, ...) end

-- Hook TeleportService:Teleport via namecall fallback
do
    -- Try to wrap the method if it's accessible
    if TeleportService and typeof(TeleportService.Teleport) == "function" then
        local origTeleport = TeleportService.Teleport
        -- Use rawset if possible; some environments prevent direct assignment, so pcall
        pcall(function()
            TeleportService.Teleport = function(self, placeId, ...)
                safe_print("[AUDIT][TELEPORT] Teleport called to placeId:", placeId, ...)
                return origTeleport(self, placeId, ...)
            end
        end)
    end

    -- Fallback: catch TeleportService:Teleport via namecall
    local success, mt = pcall(getrawmetatable, game)
    if success and mt and mt.__namecall then
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if self == TeleportService and method == "Teleport" then
                safe_print("[AUDIT][TELEPORT][FALLBACK] Teleport namecall to:", ...)
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    end
end

-- Hook remotes and Destroy
do
    local success, mt = pcall(getrawmetatable, game)
    if success and mt and mt.__namecall then
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "Destroy" then
                safe_print("[AUDIT][HOOK] Destroy on:", self, "\nTrace:", debug.traceback())
            elseif method == "FireServer" or method == "InvokeServer" then
                local name = (self.Name and tostring(self.Name)) or tostring(self)
                safe_print("[AUDIT][HOOK] Remote call:", name, method, ...)
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    else
        safe_print("[AUDIT] Couldn't hook namecall.")
    end
end

-- Now load the obfuscated/randomizer script (on alt only)
local ok, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GrowDuper/EggRandomizer/refs/heads/main/BenGrowHub", true))()
end)
if not ok then
    safe_print("[AUDIT] Error loading payload:", err)
else
    safe_print("[AUDIT] Payload executed; watch logs for teleport/remote/destroy activity.")
end
