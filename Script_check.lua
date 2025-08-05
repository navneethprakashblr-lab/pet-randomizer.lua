-- === AUDIT WRAPPER for the obfuscated script ===
local function safe_print(...) pcall(print, ...) end
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- Hook teleports
do
    local origTeleport = TeleportService.Teleport
    TeleportService.Teleport = function(self, placeId, ...)
        safe_print("[AUDIT][TELEPORT] Teleport called to place:", placeId, ...)
        return origTeleport(self, placeId, ...)
    end
    local origPrivate = TeleportService.TeleportToPrivateServer
    TeleportService.TeleportToPrivateServer = function(self, placeId, jobId, ...)
        safe_print("[AUDIT][TELEPORT] Private teleport to job:", jobId)
        return origPrivate(self, placeId, jobId, ...)
    end
end

-- Hook namecalls for Destroy / remotes
do
    local success, mt = pcall(getrawmetatable, game)
    if success and mt and mt.__namecall then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "Destroy" then
                safe_print("[AUDIT][HOOK] Destroy called on:", self, "\nTrace:", debug.traceback())
            elseif method == "FireServer" or method == "InvokeServer" then
                local name = (self.Name and tostring(self.Name)) or tostring(self)
                safe_print("[AUDIT][HOOK] Remote call:", name, method, ...)
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    else
        safe_print("[AUDIT] Failed to hook __namecall (executor may restrict).")
    end
end

-- Temporary loader to intercept the obfuscated script’s 'u' table and decoder
-- We'll override print to tag its dumps so we can separate them.
do
    -- Fetch the obfuscated script as text
    local url = "https://raw.githubusercontent.com/GrowDuper/EggRandomizer/refs/heads/main/BenGrowHub"
    local ok, scriptText = pcall(function()
        return game:HttpGet(url, true)
    end)
    if not ok or type(scriptText) ~= "string" then
        safe_print("[AUDIT] Failed to fetch obfuscated script:", scriptText)
        return
    end

    -- Wrap the script to inject string-table dump before execution of its payload.
    -- We try to locate the `local u={...}` and function C definitions, then append dump logic.
    local injected = scriptText

    -- Insert dump after the table `u` and decoder function C
    -- This is heuristic: find the start of `local u={` and the end of function C definition.
    local pattern_u = "local u=%b{}"
    local u_block = injected:match(pattern_u)
    if not u_block then
        safe_print("[AUDIT] Could not locate 'u' table in script.")
    else
        -- find decoder function definition
        local after_u = injected:sub(#u_block + injected:find(u_block))
        -- assume function C is shortly after
        local funcC_start, funcC_end = after_u:find("local function C%(C%)return u")
        if not funcC_start then
            -- fallback: dump anyway by prepending a custom wrapper later
            safe_print("[AUDIT] Could not locate decoder function; proceeding without auto dump injection.")
        else
            -- locate end of C function (the first 'end' after its start)
            local rest = after_u:sub(funcC_end + 1)
            local end_pos = rest:find("end")
            if end_pos then
                local insert_pos = injected:find(u_block) + #u_block + funcC_end + end_pos
                -- injection snippet to dump decoded strings
                local dump_code = [[

-- === STRING TABLE DUMP INJECTION ===
pcall(function()
    safe_print("[AUDIT][STRING TABLE] Dumping decoded strings via C:")
    for i = 1, #u do
        local ok2, decoded_raw = pcall(function() return u[i] end)
        local ok3, mapped = pcall(function() return C(i) end)
        safe_print(string.format("[STRING #%d] raw=%s  decoded=%s", i, tostring(decoded_raw), tostring(mapped)))
    end
end)
-- === END DUMP ===

]]
                -- insert dump_code before the end of function C block
                injected = injected:sub(1, insert_pos) .. dump_code .. injected:sub(insert_pos + 1)
                safe_print("[AUDIT] Injected string-table dump into script.")
            else
                safe_print("[AUDIT] Could not find end of decoder function for injection.")
            end
        end
    end

    -- Execute the modified/augmented obfuscated script
    local exec_ok, exec_err = pcall(function()
        loadstring(injected)()
    end)
    if not exec_ok then
        safe_print("[AUDIT] Execution error from obfuscated script:", exec_err)
    else
        safe_print("[AUDIT] Finished executing obfuscated script (watch logs above).")
    end
end
