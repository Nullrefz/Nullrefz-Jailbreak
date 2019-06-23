local SCOREBOARD = {}

function SCOREBOARD:Init()
    self:SetSize(w, h)
    self.panel = vgui.Create("Panel", self)
    self.panel:MakePopup()
    self.panel:Dock(FILL)

    function self.panel:Paint()
    end

    self.group = {}

    for i = 1, TEAM_SPECTATORS do
        if i == TEAM_SPECTATORS and #team.GetPlayers(i) == 0 then return end
        local playerGroup = vgui.Create("ScoreboardGroup", self.panel)
        playerGroup:Dock(TOP)
        playerGroup:DockMargin(toHRatio(40), 0, toHRatio(40), 0)
        playerGroup:SetGroup(i)
        playerGroup:InvalidateLayout(true)
        playerGroup:SizeToChildren(false, true)
        table.insert(self.group, playerGroup)
    end
end

function SCOREBOARD:PerformLayout(width, height)
    self.panel:DockMargin(0, toVRatio(64), 0, 0)
end

vgui.Register("JailbreakScoreboard", SCOREBOARD)
JB.scoreboard = {}

function JB.scoreboard:Show()
    self.scoreboardPanel = vgui.Create("JailbreakScoreboard")
    self.scoreboardPanel:SetSize(w, h)

    JB.scoreboard.Hide = function()
        self.scoreboardPanel:Remove()
        self.scoreboardPanel:Clear()
    end
end

function GM:ScoreboardShow()
    JB.scoreboard:Show()
end

function GM:ScoreboardHide()
    JB.scoreboard:Hide()
end