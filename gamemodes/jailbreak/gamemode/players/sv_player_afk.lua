local pl = FindMetaTable("Player")
local afkList = {}

function pl:SetAFK(isAFK)
    self.isAFK = isAFK

    if not table.HasValue(afkList, self) and isAFK then
        table.insert(afkList, self)
    elseif table.HasValue(afkList, self) and not isAFK then
        table.RemoveByValue(afkList, self)
    end

    if not isAFK then
        self.afkTimer = 0
    end

    local notification = {
        TEXT = self:GetName() .. (isAFK and " is now AFK" or " is no longer AFK"),
        TYPE = isAFK and 3 or 1,
        TIME = 5,
        COLOR = Color(25, 25, 25, 200)
    }

    JB:SendNotification(notification)
    local afkHighlight = {}

    for k, v in pairs(afkList) do
        table.insert(afkHighlight, {
            Player = v,
            Color = Color(255,0,0)
        })
    end

    JB:HighlightPlayers(afkHighlight, "afk")
    self:LimitAFK()
end

function pl:LimitAFK()
    if #player.GetAll() == game.MaxPlayers() - 1 and self.isAFK then
        self:Kick("Disconnected for being AFK")
    end
end

function pl:isAFKFrozen()
    local notification = {
        TEXT = self:GetName() .. (isAFK and " is now AFK Frozen" or " is no longer AFK Frozen"),
        TYPE = 1,
        TIME = 5,
        COLOR = Color(255, 175, 0, 200)
    }

    JB:SendNotification(notification)

    return self.afkTimer > GetConVar("jb_afkFrozen_threshold"):GetInt()
end

hook.Add("PlayerInitialSpawn", "CreateTimer", function(ply)
    ply.afkTimer = 0
    ply.isAFK = false

    for k, v in pairs(player.GetAll()) do
        v:LimitAFK()
    end
end)

hook.Add("PlayerButtonDown", "ResetTimer", function(ply, key)
    ply.afkTimer = 0

    if ply.isAFK then
        ply:SetAFK(false)
    end
end)

hook.Add("SetupMove", "HandleAFK", function(ply, mv, cmd)
    if not ply.afkTimer then
        ply.afkTimer = 0
    end

    if ply:Alive() then
        ply.afkTimer = ply.afkTimer + FrameTime()
    end

    if ply.afkTimer >= GetConVar("jb_afk_threshold"):GetInt() and not ply.isAFK then
        ply:SetAFK(true)
    end

    if ply.mouse ~= cmd:GetMouseX() + cmd:GetMouseY() then
        ply.afkTimer = 0

        if ply.isAFK then
            ply:SetAFK(false)
        end
    end

    ply.mouse = cmd:GetMouseX() + cmd:GetMouseY()
end)