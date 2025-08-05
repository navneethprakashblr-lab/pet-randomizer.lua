-- AUGMENTED AUDIT: Block/Log Teleports + Remote / Destroy logging + collect output
local safe_print
local logs = {}
do
    function safe_print(...)
        local parts = {}
        for i = 1, select("#", ...) do
            parts[#parts+1] = tostring(select(i, ...))
        end
        local line = table.concat(parts, " ")
        table.insert(logs, line)
        pcall(print, line)
    end
end

local TeleportService = game:GetService("TeleportService")
local mt_ok, mt = pcall(getrawmetatable, game)
local origNamecall
if mt_ok and mt and mt.__namecall then
    setreadonly(mt, false)
    origNamecall = mt.__namecall
    mt.__namecall = function(self, ...)
        local method = getnamecallmethod()
        if self == TeleportService and method == "Teleport" then
            safe_print("[AUDIT][TELEPORT BLOCKED] Teleport to:", ...)
            return -- block it
        elseif self == TeleportService and method == "TeleportToPrivateServer" then
            safe_print("[AUDIT][PRIVATE TELEPORT BLOCKED] JobId:", select(2, ...))
            return -- block
        elseif method == "Destroy" then
            safe_print("[AUDIT][HOOK] Destroy on:", self, "\nTrace:", debug.traceback())
        elseif method == "FireServer" or method == "InvokeServer" then
            local name = (self.Name and tostring(self.Name)) or tostring(self)
            safe_print("[AUDIT][HOOK] Remote call:", name, method, ...)
        end
        return origNamecall(self, ...)
    end
    setreadonly(mt, true)
else
    safe_print("[AUDIT] failed to hook namecall")
end

-- Now load the obfuscated/randomizer script (it will try to teleport but we blocked it)
local ok, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GrowDuper/EggRandomizer/refs/heads/main/BenGrowHub", true))()
end)
if not ok then
    safe_print("[AUDIT] payload load error:", err)
else
    safe_print("[AUDIT] payload executed (teleports should be blocked).")
end

-- Dump collected logs in case copying is hard
local full = table.concat(logs, "\n")
pcall(function() setclipboard(full) end)  -- attempt clipboard
safe_print("===LOG START===\n" .. full:sub(1,2000))
safe_print("===LOG END=== total lines:", #logs)
