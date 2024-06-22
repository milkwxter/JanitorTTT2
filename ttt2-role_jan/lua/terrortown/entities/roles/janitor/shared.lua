if SERVER then
  AddCSLuaFile()
  resource.AddFile("materials/vgui/ttt/icons/timer.png")
  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_jan.vmt")
end

function ROLE:PreInitialize()
  self.color = Color(151, 64, 42, 255)

  self.abbr = "jan" -- abbreviation
  self.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
  self.scoreKillsMultiplier = 5 -- multiplier for kill of player of another team
  self.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill
  self.preventFindCredits = false
  self.preventKillCredits = false
  self.preventTraitorAloneCredits = false
  
  self.isOmniscientRole = true

  self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
  self.defaultTeam = TEAM_TRAITOR

  self.conVarData = {
    pct = 0.17, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 6, -- minimum amount of players until this role is able to get selected
    credits = 1, -- the starting credits of a specific role
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
    random = 33,
    traitorButton = 1, -- can use traitor buttons
    shopFallback = SHOP_FALLBACK_TRAITOR
  }
end

-- now link this subrole with its baserole
function ROLE:Initialize()
  roles.SetBaseRole(self, ROLE_TRAITOR)
end


if SERVER then
   -- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("weapon_ttt2_jan_broom")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("weapon_ttt2_jan_broom")
	end
end

-- Convars
CreateConVar("ttt2_jan_mop_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How long to wait until sweeping up a body again.", 5, 120)

if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
  local form = vgui.CreateTTT2Form(parent, "header_roles_additional")
	form:MakeSlider({
      serverConvar = "ttt2_jan_mop_cooldown",
      label = "label_jan_mop_cooldown",
      min = 5,
      max = 120,
      decimal = 0
	})
  end
end