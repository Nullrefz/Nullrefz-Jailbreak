contestMenu = {"jokeday", "foodday", "trivia", "salty spitoon", "american idol", "custom"}

if CLIENT then
    function JB:AddContestMenu()
        local slots = {}

        for k, v in pairs(contestMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            slot.ACTION = function()
                JB:SendContest(v)
            end

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots, "contest")
    end

    function JB:SendContest(name)
        net.Start("SendContest")
        net.WriteString(name)
        net.SendToServer()
    end

    hook.Add("Initialize", "AddContestMenu", function()
        JB:AddContestMenu()
    end)
end

if SERVER then
    util.AddNetworkString("SendContest")
    net.Receive("SendContest", function(ln, ply) end)
end