if SERVER then
  AddCSLuaFile()
end

SWEP.Base = "weapon_tttbase"

if CLIENT then
  SWEP.ViewModelFOV = 78
  SWEP.DrawCrosshair = false
  SWEP.ViewModelFlip = false

  SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "Janitor Broom",
    desc = "Clean up bodies or DNA!"
  }

  SWEP.Icon = "vgui/ttt/icon_broom"

  function SWEP:Initialize()
    self:AddTTT2HUDHelp("Clean up a body.", "Clean up DNA on a body.")
  end
end

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = nil

SWEP.UseHands = true
SWEP.ViewModel              = "models/weapons/c_arms.mdl"
SWEP.WorldModel             = "models/props_c17/pushbroom.mdl"

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "crowbar"
SWEP.LimitedStock = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.AllowDrop = false

-- Removes the Broom on death or drop
function SWEP:OnDrop()
	self:Remove()
end

-- Override original primary attack
function SWEP:PrimaryAttack()
  -- Melee attack code
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  
  if not IsValid(self:GetOwner()) then return end

  self:GetOwner():LagCompensation(true)

  local spos = self:GetOwner():GetShootPos()
  local sdest = spos + (self:GetOwner():GetAimVector() * 70)

  local kmins = Vector(1,1,1) * -10
  local kmaxs = Vector(1,1,1) * 10

  local tr = util.TraceHull({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

  -- Hull might hit environment stuff that line does not hit
  if not IsValid(tr.Entity) then
    tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
  end

  local hitEnt = tr.Entity

  -- Check if we just hit an entity
  if IsValid(hitEnt) then
    if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
      if hitEnt:GetClass() == "prop_ragdoll" then
        -- make sure the body is that of a player not a map ragdoll or whatever
        local corpsePlayer = CORPSE.GetPlayer(hitEnt)
		    if not IsValid(corpsePlayer) then
          LANG.Msg(owner, "That is not a player ragdoll! You cannot eat this one.", nil, MSG_MSTACK_WARN)
          return
        end
        
        -- then delete body cus he eats it
        hitEnt:Remove()
	   end
   end
   self:GetOwner():LagCompensation(false)
  end
  -- end of primary attack code
end

-- Override original primary attack
function SWEP:SecondaryAttack()
  -- Melee attack code
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  
  if not IsValid(self:GetOwner()) then return end

  self:GetOwner():LagCompensation(true)

  local spos = self:GetOwner():GetShootPos()
  local sdest = spos + (self:GetOwner():GetAimVector() * 70)

  local kmins = Vector(1,1,1) * -10
  local kmaxs = Vector(1,1,1) * 10

  local tr = util.TraceHull({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

  -- Hull might hit environment stuff that line does not hit
  if not IsValid(tr.Entity) then
    tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
  end

  local hitEnt = tr.Entity

  -- Check if we just hit an entity
  if IsValid(hitEnt) then
    if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
      if hitEnt:GetClass() == "prop_ragdoll" then
        -- make sure the body is that of a player not a map ragdoll or whatever
        local corpsePlayer = CORPSE.GetPlayer(hitEnt)
		    if not IsValid(corpsePlayer) then
          LANG.Msg(owner, "That is not a player ragdoll! You cannot eat this one.", nil, MSG_MSTACK_WARN)
          return
        end
        
        -- change DNA for the body
        hitEnt.killer_sample = { t = 0, killer = nil }
	   end
   end
   self:GetOwner():LagCompensation(false)
  end
  -- end of secondary attack code
end