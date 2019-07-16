include('sh_init.lua')

warden = nil
roundPhase = "Waiting"
allowedGuardCount = 0

net.Receive('UpdateCommands', function()
    activeCommands = net.ReadTable()
end)

net.Receive('OnWardenSet', function()
    warden = player.GetBySteamID(net.ReadString())
end)

net.Receive("GuardCount", function()
    allowedGuardCount = #team.GetPlayers(Team.GUARDS) + net.ReadInt(32)
end)

function GM:OnSpawnMenuOpen()
    net.Start("DropWeapon")
    net.SendToServer()
end