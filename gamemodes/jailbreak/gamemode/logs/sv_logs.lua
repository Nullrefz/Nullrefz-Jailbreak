util.AddNetworkString("OpenLogs")

hook.Add("ShowTeam", "identifier", function(ply)
    JB:OpenLogs(ply)
end)

function JB:OpenLogs(ply)
    net.Start("OpenLogs")
    net.Send(ply)
end

local logs = {}
local roundLogs = {}
local session = 0
local roundNumber = 0
local dir = ""

function JB:RegisterLog(ply, entry)
    if self:GetActivePhase() ~= ROUND_ACTIVE then return end

    for k, v in pairs(roundLogs) do
        if v.User == ply:IsBot() and ply:Name() or ply:SteamID() then
            table.insert(v.Logs, entry)
            self:SaveLogs()

            return
        end
    end

    table.insert(roundLogs, {
        User = ply:IsBot() and ply:Name() or ply:SteamID(),
        UserTeam = ply:Team(),
        UserName = ply:Name(),
        Logs = {entry}
    })

    self:SaveLogs()
end

util.AddNetworkString("SendLog")
util.AddNetworkString("LogRequest")

function JB:SendLog(ply)
    if not ply then return end
    net.Start("SendLog")
    net.WriteInt(roundNumber, 32)
    net.WriteFloat(self:GetTimeElapsed())
    net.WriteTable(roundLogs)
    net.Send(ply)
end

function JB:HandleLogRequest(ply)
    --TODO: This is the section where I check if the player is allowed to get the logs
    self:SendLog(ply)
end

net.Receive("LogRequest", function(ln, ply)
    JB:HandleLogRequest(ply)
end)

function JB:SaveLogs()
    if roundLogs == {} then return end
    local json = util.TableToJSON(roundLogs)

    if not file.IsDir(dir, "DATA") then
        file.CreateDir(dir)
    end

    file.Write(dir .. "/round_" .. roundNumber .. ".txt", json)
end

function JB:LoadLogs(sessionID, round)
    logs = {}
    files = file.Find("*", dir, "nameasc")

    for k, v in pairs(files) do
        table.insert(logs, util.JSONToTable(v))
    end
end

function JB:SetupLogs()
    roundLogs = {}
    roundNumber = roundNumber + 1
end

hook.Add("jb_round_active", "SetupLogs", function()
    JB:SetupLogs()
end)

hook.Add("jb_round_ending", "SaveLogs", function()
    JB:SaveLogs()
end)

hook.Add("Initialize", "SetupLogsFolder", function()
    while (file.IsDir("jailbreak/logs/session_" .. session, "DATA")) do
        session = session + 1
    end

    session = session + 1
    dir = "jailbreak/logs/session_" .. session
end)