AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "Deagle"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.IconLetter = "f"

end

SWEP.HoldType = "pistol"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_Deagle.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 60
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.002
SWEP.Primary.ClipSize = 8
SWEP.Primary.Delay = 0.3
SWEP.Primary.DefaultClip = 48
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(5.15, -2, 2.6)