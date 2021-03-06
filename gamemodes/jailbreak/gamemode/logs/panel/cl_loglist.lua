local LOGSLIST = {}

surface.CreateFont("Jailbreak_Font_14", {
    font = "Optimus",
    extended = false,
    size = 16,
    weight = 5,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = true,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

function LOGSLIST:Init()
    self.playerLog = vgui.Create("JailbreakPlayerLog", self)
    self.header = vgui.Create("Panel", self)
    self.footer = vgui.Create("Panel", self.header)
    self.roundID = vgui.Create("DPanel", self.header)
    self.timeScale = vgui.Create("JailbreakTimeScale", self.header)
    self.playHead = vgui.Create("Panel", self.timeScale)
    self.panel = vgui.Create("Panel", self)
    self.entries = vgui.Create("Panel", self)
    local round = 0
    self.time = 300
    self.logs = {}

    net.Receive("SendLog", function()
        round = net.ReadInt(32)
        self.time = net.ReadFloat()
        self.logs = net.ReadTable()
        self:LayoutEntries()
    end)

    local panel = self
    local curPos = 0

    function self.playHead:Paint(width, height)
        curPos = math.Clamp(self:LocalCursorPos(), 0, self:LocalCursorPos())
        if (curPos < 0 or curPos > self:GetWide()) then return end
        curPos = self:GetParent():GetPos(curPos, self:GetWide())
        draw.DrawSkewedRect(curPos - 13, 0, 32, height, 4, Color(255, 255, 255))
        draw.DrawText(self:GetParent():GetMinute(curPos / self:GetWide()), "Jailbreak_Font_14", curPos, 0, Color(0, 0, 0), TEXT_ALIGN_CENTER)
    end

    function self.panel:Paint(width, height)
        if (curPos < 0 or curPos > panel.playHead:GetWide()) then return end
        surface.SetDrawColor(255, 255, 255)
        surface.DrawLine(curPos + width / 7, 18, curPos + width / 7, panel:GetTall())
    end

    function self.footer:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(15, 15, 15))
    end

    function self.roundID:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(40, 40, 40))
        draw.DrawRect(0, 0, width, height * 0.06, Color(15, 15, 15))
        draw.DrawRect(width - width * 0.005, 0, width * 0.005, height, Color(15, 15, 15))
        draw.DrawText("Round: " .. round, "Jailbreak_Font_32", width / 2, height / 6, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
    --	self.panel:MoveToFront()
end

function LOGSLIST:LayoutEntries()
    local offset = 2
    local count = 0
    local barHeight = 64
    self.panels = {}
    local inspectors = {}
    for k, v in pairs(self.logs) do
        local entryLog = vgui.Create("JailbreakEntryLog", self.entries)
        entryLog:SetSize(w, barHeight)
        table.insert(self.panels, entryLog)
        count = count + 1
        entryLog:SetPos(0, (k - 1) * (barHeight + offset))
        local inspector = vgui.Create("JailbreakLogInspector", self.entries)
        inspector:SetSize(w, 0)
        inspector:SetPos(0, (k - 1) * (barHeight + offset) + entryLog:GetTall())
        --inspector:SetInfo(barHeight, -1)
        table.insert(self.panels, inspector)
        table.insert(inspectors, inspector)
        entryLog:SetInfo(v.User, v.UserTeam, v.UserName, v.Logs, self.time, k, inspector)
    end

    self.timeScale:SetTime(self.time)
    hook.Add("LogClicked", "ToggleInspector", function(ind, plyInd, logs, minutes)
        for k, v in pairs(inspectors) do
            v:SetInfo(barHeight, ind, plyInd, logs, minutes)
        end
    end)
end

local totalPos = 0

function LOGSLIST:RepositionBars()
    if not self.panels then return end
    local x, y = self:LocalCursorPos()
    y = y - self.header:GetTall()
    y = math.Clamp(y - 64, 0, 99999)
    local pos = 0

    for k, v in pairs(self.panels) do
        if totalPos > self:GetTall() - self.header:GetTall() then
            v:SetPos(0, pos - ((y / (self:GetTall() - self.header:GetTall() - 64)) * (totalPos - (self:GetTall() - self.header:GetTall()))))
        else
            v:SetPos(0, pos)
        end

        pos = pos + v:GetTall() + 2
    end

    totalPos = pos
end

function LOGSLIST:Think()
    self:RepositionBars()
end

function LOGSLIST:PerformLayout(width, height)
    self.header:Dock(TOP)
    self.footer:Dock(BOTTOM)
    self.footer:SetTall(2)
    self.header:SetTall(toVRatio(44))
    self.roundID:Dock(LEFT)
    self.roundID:SetWide(width / 7)
    self.timeScale:Dock(FILL)
    self.timeScale:DockMargin(0, 2, 0, 0)
    self.timeScale:SetTall(toVRatio(32))
    self.panel:SetSize(width, height)
    self.playHead:SetSize(self.timeScale:GetWide(), 16)
    self.entries:Dock(FILL)
    self.playerLog:Dock(RIGHT)
    self.playerLog:SetWide(0)
    self.playerLog:DockMargin(2, 2, 0, 0)
end

vgui.Register("JailbreakLogsList", LOGSLIST)