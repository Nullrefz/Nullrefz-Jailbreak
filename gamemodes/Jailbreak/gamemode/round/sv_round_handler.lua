--[[---------------------------------------------------------
    Name: jailbreak:SetRoundWaiting()
    Desc: Setups Waiting Phase
-----------------------------------------------------------]]
function JB:SetRoundWaiting()
    self:SetRoundTime(GetConVar("jb_Round_Waiting"):GetInt() or -1)
    self.round.count = 0
    self:EnableRespawns()
    self:ResetMap(true)

    timer.Create("IntervalCleanup", 5, 0, function()
        for k, v in pairs(player.GetAll()) do
            if not v:Alive() then
                JB:ResetMap(true)
                v:Spawn()
                break
            end
        end
    end)
end

hook.Add("jb_round_waiting", "setup waiting", function()
    JB:SetRoundWaiting()
end)

--[[---------------------------------------------------------
    Name: jailbreak:SetRoundPreparing()
    Desc: Setups Preparing Phase
-----------------------------------------------------------]]
function JB:SetRoundPreparing()
    self.round.count = self.round.count + 1

    if self.round.count > GetConVar("jb_max_rounds"):GetInt() then
        hook.Run("ChangeMap")

        return
    end

    timer.Remove("IntervalCleanup")
    self:ResetMap()
    self:EnableRespawns()
    self:SpawnAllPlayers()
    self:SetSelfCollision(false)
    self:SetFriendlyFire(false)
    self:RemoveCloseButton()
    self:SetMicEnabled(false, Team.PRISONERS)
    --self:FreezePlayers(true)
end

hook.Add("jb_round_preparing", "setup preparing", function()
    JB:SetRoundPreparing()
end)

--[[---------------------------------------------------------
    Name: jailbreak:SetRoundActive()
    Desc: Setups Active Phase
-----------------------------------------------------------]]
function JB:SetRoundActive()
    self:SetRoundTime(GetConVar("jb_Round_Active"):GetInt() or 300)

    for k, v in pairs(player.GetAll()) do
        if IsValid(v) and not v:Alive() and v:Team() <= Team.GUARDS then
            self:PlayerSpawn(v)
        end
    end

    self:FreezePlayers(false)
    self:DisableRespawns()

    timer.Simple(GetConVar("jb_Prisoners_Mute_Time"):GetInt() or 15, function()
        JB:SetMicEnabled(true, Team.PRISONERS)
    end)
end

hook.Add("jb_round_active", "setup waiting", function()
    JB:SetRoundActive()
end)

--[[---------------------------------------------------------
    Name: jailbreak:SetRoundEnding()
    Desc: Setups Ending Phase
-----------------------------------------------------------]]
function JB:SetRoundEnding()
    self:SetRoundTime(GetConVar("jb_Round_Ending"):GetInt() or 10)
    self:RevokeWarden()
end

hook.Add("jb_round_ending", "setup ending", function()
    JB:SetRoundEnding()
end)

--[[---------------------------------------------------------
    Name: jailbreak:RounWaitingThink()
    Desc: Loop logic for round waiting
-----------------------------------------------------------]]
function JB:RounWaitingThink()
    if #team.GetPlayers(Team.PRISONERS) >= (GetConVar("jb_min_players"):GetInt() or 2) and #team.GetPlayers(Team.GUARDS) > 0 then
        self:SetRoundPhase(ROUND_PREPARING)
    end
end

hook.Add("jb_round_waiting_think", "round waiting think", function()
    JB:RounWaitingThink()
end)

--[[---------------------------------------------------------
    Name: jailbreak:RoundPreparingThink()
    Desc: Loop logic for round preparing
-----------------------------------------------------------]]
function JB:RoundPreparingThink()
    if (self:GetTimeLeft() <= 0 and self.round.count <= GetConVar("jb_max_rounds"):GetInt()) or self.warden then
        self:SetRoundPhase(ROUND_ACTIVE)
    end
end

hook.Add("jb_round_preparing_think", "round preparing think", function()
    JB:RoundPreparingThink()
end)

--[[---------------------------------------------------------
    Name: jailbreak:RoundActiveThink()
    Desc: Loop logic for round active
-----------------------------------------------------------]]
function JB:RoundActiveThink()
    if self:GetTimeLeft() <= 0 or #self:GetAlivePlayersByTeam(TEAM_GUARDS) <= 0 or #self:GetAlivePlayersByTeam(TEAM_PRISONERS) <= 0 then
        self:SetRoundPhase(ROUND_ENDING)

        return
    end
end

hook.Add("jb_round_active_think", "round active think", function()
    JB:RoundActiveThink()
end)

--[[---------------------------------------------------------
    Name: jailbreak:RoundEndingThink()
    Desc: Loop logic for round ending
-----------------------------------------------------------]]
function JB:RoundEndingThink()
    if self:GetTimeLeft() <= 0 then
        self:SetRoundPhase(ROUND_PREPARING)
    end
end

hook.Add("jb_round_ending_think", "round ending think", function()
    JB:RoundEndingThink()
end)