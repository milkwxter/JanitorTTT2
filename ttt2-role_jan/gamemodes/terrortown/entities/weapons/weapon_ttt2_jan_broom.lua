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
    name = "jan_broom_title",
    desc = "jan_broom_desc"
  }

  SWEP.Icon = "vgui/ttt/icon_broom"

  function SWEP:Initialize()
    self:AddTTT2HUDHelp("label_jan_help_m1", "label_jan_help_m2")
  end
end

SWEP.Kind = WEAPON_CLASS
SWEP.CanBuy = nil

SWEP.UseHands = true
SWEP.ViewModel              = "models/props_c17/pushbroom.mdl"
SWEP.WorldModel             = "models/props_c17/pushbroom.mdl"
SWEP.Pos = Vector(-3,-3,3) -- worldmodel
SWEP.Ang = Angle(70, 180, 0)

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "passive"
SWEP.LimitedStock = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.AllowDrop = false
SWEP.CanBuy = { }

-- Removes the Broom on death or drop
function SWEP:OnDrop()
	self:Remove()
end

--Add Cooldown Status
if CLIENT then
    hook.Add("Initialize", "ttt2_jan_init", function()
		STATUS:RegisterStatus("ttt2_jan_mop_cooldown_status", {
			hud = Material("vgui/ttt/icons/sweepTimer.png"),
			type = "bad",
			name = "jan_sweepCD_title",
			sidebarDescription = "jan_sweepCD_desc"
		})
	end)
end



-- Override original primary attack
function SWEP:PrimaryAttack()
if not timer.Exists("ttt2_jan_timer_cooldown") then
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
			  LANG.Msg(owner, "That is not a player ragdoll! You cannot sweep this one.", nil, MSG_MSTACK_WARN)
			  return
			end

			-- do special effects
	  		EmitSound( "janitorSounds/sweep.wav", hitEnt:GetPos() )
			-- sweepy viewpunch
			local sweepPitch = math.Rand(10, 10)
			local sweepYaw = math.Rand(-10, 10)
			self:GetOwner():ViewPunch(Angle( sweepPitch, sweepYaw, 0 ) )
			
			-- then delete body cus he sweeps it
			hitEnt:Remove()
			LANG.Msg(owner, "Successfully sweeped up the body.", nil, MSG_MSTACK_PLAIN)

			-- start the cooldown timer
			STATUS:AddTimedStatus(self:GetOwner(), "ttt2_jan_mop_cooldown_status", GetConVar("ttt2_jan_mop_cooldown"):GetInt() , true)
				timer.Create("ttt2_jan_timer_cooldown", GetConVar("ttt2_jan_mop_cooldown"):GetInt() , 1, function()
			end)
			
		   end
	   end
	   self:GetOwner():LagCompensation(false)
	  end
	  -- end of primary attack code
	end
end

-- Override original secondary attack
function SWEP:SecondaryAttack()
  -- Melee attack code
  self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
  
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
          LANG.Msg(owner, "That is not a player ragdoll! You cannot remove DNA from this one.", nil, MSG_MSTACK_WARN)
          return
        end

		-- do special effects
		EmitSound( "janitorSounds/sweep.wav", hitEnt:GetPos() )
		-- sweepy viewpunch
		local sweepPitch = math.Rand(10, 10)
		local sweepYaw = math.Rand(-10, 10)
		self:GetOwner():ViewPunch(Angle( sweepPitch, sweepYaw, 0 ) )
		-- make big dustcloud
		local cdata = EffectData()
		cdata:SetStart(spos)
		cdata:SetOrigin(tr.HitPos)
		cdata:SetNormal(tr.Normal)
		util.Effect("BloodImpact", cdata)
        
        -- change DNA for the body
        hitEnt.killer_sample = { t = 0, killer = nil }
		LANG.Msg(owner, "Successfully removed DNA from the body.", nil, MSG_MSTACK_PLAIN)
	   end
   end
   self:GetOwner():LagCompensation(false)
  end
  -- end of secondary attack code
end

function SWEP:CreateWorldModel()
	if !self.WModel then
		self.WModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
		self.WModel:SetNoDraw(true)
		self.WModel:SetBodygroup(1, 1)
	end
	return self.WModel
end

function SWEP:DrawWorldModel()
	local wm = self:CreateWorldModel()
	if self.Owner != NULL then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Hand")
		local pos, ang = self.Owner:GetBonePosition(bone)
			
		if bone then
			ang:RotateAroundAxis(ang:Right(), self.Ang.p)
			ang:RotateAroundAxis(ang:Forward(), self.Ang.y)
			ang:RotateAroundAxis(ang:Up(), self.Ang.r)
			wm:SetRenderOrigin(pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z)
			wm:SetRenderAngles(ang)
			wm:DrawModel()
			wm:SetModelScale( 0.8, 0 )
		end
	else
		wm:DrawModel()
	end
end