void() monster_weapon_touch =
{
	local float	best;
	local entity	stemp;
	
	if (pointcontents(self.origin) == CONTENT_LAVA)	// oops it fell in lava.. it's gone.
	{	//explode?
		remove (self);
		return;
	}

	if (!(other.flags & FL_CLIENT)) return;

	if (other.health <= 0) return;

	if (other.classname != "player") return;

	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	if (self.weapon == IT_NAILGUN)
	{
		other.ammo_nails = (other.ammo_nails + 30);
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		other.ammo_nails = (other.ammo_nails + 30);
	}

	else if  (self.weapon == IT_SUPER_SHOTGUN)
	{
		other.ammo_shells = (other.ammo_shells + 5);
	}

	else if  (self.weapon == IT_ROCKET_LAUNCHER)
	{
		other.ammo_rockets = (other.ammo_rockets + 5);
	}

	else if  (self.weapon == IT_GRENADE_LAUNCHER)
	{
		other.ammo_rockets = (other.ammo_rockets + 5);
	}

	else if  (self.weapon == IT_LIGHTNING)
	{
		other.ammo_cells = (other.ammo_cells + 30);
	}
	else
	{
		remove(self);			//something went wrong
		activator = other;
		SUB_UseTargets();
		return;
	}
	
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	bound_other_ammo();

	Deathmatch_Weapon (other, self.weapon);

	other.items = other.items | self.weapon;

	if ( other.weapon == best )
	{
		other.weapon = W_BestWeapon();
	}
	
	stemp = self;
	self = other;

	W_SetCurrentAmmo();

	self = stemp;

	remove(self);		//remove the weapon
	activator = other;
	SUB_UseTargets();	
};

void (string weaponstring, float weaponnumber, entity monster) monster_drop_weapon =
{
	local entity gun;
	
	gun = spawn();
	
	setmodel (gun, weaponstring);
	makevectors(monster.v_angle);
	setsize(gun, '-16 -16 0', '16 16 56');
	setorigin(gun, monster.origin + '0 0 16');
	
	gun.owner		= monster;
	gun.velocity 	= aim(monster, 16);
	gun.velocity 	= gun.velocity * 320;
	gun.flags 		= FL_ITEM;
	gun.solid 		= SOLID_TRIGGER;		// so we can touch it.
	gun.movetype 	= MOVETYPE_BOUNCE;		// can be MOVETYPE_TOSS if you want it not to fall too far.
	gun.weapon 		= weaponnumber;			// this is like IT_ROCKET_LAUNCHER so we can handle our inventory later on.
	gun.touch 		= monster_weapon_touch;	// this function will be called when the weapon is picked up
	gun.think 		= SUB_Remove;			// this function will be called if the weapon is not picked up
	gun.nextthink 	= time + 20;			// and this is how long until it is removed.
};
};