local ENTRYLOG = {}

surface.CreateFont("Jailbreak_Font_36", {
    font = "Optimus",
    extended = false,
    size = 36,
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

function ENTRYLOG:Init()
    self.playerName = vgui.Create("Panel", self)
    self.playerImage = vgui.Create("AvatarImage", self)
    self.log = vgui.Create("JailbreakLogBar", self)
    self.TeamColor = Color(255, 255, 255)
    self.playerText = "Player Name"
    local panel = self

    function self.playerName:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
        draw.DrawText(panel.playerText, "Jailbreak_Font_32", width - 8, height / 4, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        draw.DrawRect(0, 0, 4, height, panel.TeamColor)
    end
end

function ENTRYLOG:PerformLayout(width, height)
    self.playerName:Dock(LEFT)
    self.playerName:DockMargin(0, 0, 2, 0)
    self.playerName:SetWide(1920 / 7 - 4 - height, 0, 2, 0)
    self.playerImage:Dock(LEFT)
    self.playerImage:DockMargin(0, 0, 2, 0)
    self.log:Dock(FILL)
end


function ENTRYLOG:SetPlayer(ply)
    self.player = ply
    self.playerImage:SetPlayer(self.player, 184)
    self.TeamColor = team.GetColor(self.player:Team())
    self.playerText = self.player:Name()
end

vgui.Register("JailbreakEntryLog", ENTRYLOG)