if CLIENT then
    JB.activeMenu = {}
    menuTypes = {}

    function JB:RegisterMenu(slots, menuName)
        local menu = {}

        menu.Show = function()
            self.panel = vgui.Create("JailbreakOptionMenu")
            self.panel:SetSize(w, h)
            self.panel:SetPos(0, 0)

            for k, v in ipairs(slots) do
                self.panel:AddSlot(v.NAME, v.ACTION, v.COLOR, v.CLOSE)
            end

            menu.Hide = function()
                if self.panel:IsValid() then
                    self.panel:Exit()
                end
            end
        end

        menuTypes[menuName] = menu
        self.activeMenu = menu

        return self.activeMenu
    end

    function JB:OpenMenu(menuName)
        self.activeMenu = menuTypes[menuName]
        self.activeMenu:Show()
    end

    function JB:CloseMenu()
        if not self.activeMenu.Hide then return end
        self.activeMenu:Hide()
    end
end