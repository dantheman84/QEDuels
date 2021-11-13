/*
	spawns.qc

	creates dynamic spawns for maps that need them

	Copyright (C) 1996-2030  Old Software, Inc.

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to:

		Free Software Foundation, Inc.
		59 Temple Place - Suite 330
		Boston, MA  02111-1307, USA

*/

//This creates a temporary entity with the classname at origin/angles provided.

void (string cname, vector sorg, vector sang) spawn_temp_ent =
{
	local entity tent;

	tent = spawn ();
	tent.owner = world;
	tent.solid = SOLID_NOT;
	tent.movetype = MOVETYPE_NONE;
	tent.takedamage = DAMAGE_NO;
	tent.fixangle = TRUE;
	tent.classname = cname;
	tent.origin = sorg;
	tent.angles = sang;
	tent.angles_x = 0;
	tent.think = SUB_NULL;
	tent.nextthink = 0;
};
