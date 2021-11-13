/*
	request.qc

	polling functions

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

	See file, 'gnu_gpl.txt', for details.
*/

void() Request_Poll_Cleanup =
{
	local entity trash_disco;	

	if (poll_entity)
	{
		// Reset these for completeness.
		poll_entity.owner = world;
		poll_entity.noise1 = "";
		poll_entity.noise2 = "";
		poll_entity.classname = "";
		poll_entity.nextthink = -99;
		poll_entity.think = SUB_Null;
		poll_entity.touch = SUB_Null;
		poll_entity = world;

		remove(poll_entity);
	}

	//Clear out the votes for this request.
	trash_disco = find(world, classname, "player");
	while (trash_disco)
	{
		trash_disco.vote = 0;
		trash_disco = find(trash_disco, classname, "player");
	}
};

void(float ballot) Request_Poll_Tally =
{
	local entity	bingo;
	local float	vcount, pcount;

	bingo = find(world, classname, "player");

	// What we are doing here is tallying up the votes pragmatically.
	// The vote will pass if there is a majority for yes, or no, immediately.
	// This way, we don't have to sit around for 45 seconds waiting for
	// the request to timeout if there is already a majority vote.
	// Although, it doesn't give players much time to change their vote...

	if (ballot == 1)		// yes vote
	{
		while (bingo)
		{
			pcount += 1;

			if (bingo.vote == ballot)
				vcount += 1;

			bingo = find(bingo, classname, "player");
		}

		if (vcount >= (pcount * 0.51))
		{
			poll_entity.touch();
			if (pcount > 1)//Only respond if there is more than one player on the server.
			{
				sound(self, CHAN_VOICE, "misc/baseuse.wav", 1, ATTN_NONE);
				bprint("The request was approved.\n");
			}
			if (poll_entity.classname != "changelevel")								// Changing the map will clear everything out anyways.
				Request_Poll_Cleanup();
		}
	}
	else
	{
		if (ballot == 2)	// no vote
		{
			while (bingo)
			{
				pcount += 1;

				if (bingo.vote == ballot)
					vcount += 1;

				bingo = find(bingo, classname, "player");
			}

			if (vcount >= (pcount * 0.51))
			{
				poll_entity.nextthink = -99;
				poll_entity.think = SUB_Null;

				sound(self, CHAN_VOICE, "misc/basetry.wav", 1, ATTN_NONE);
				bprint("The request was declined.\n");
				Request_Poll_Cleanup();
			}
		}
		else
			bprint("Request_Poll_Tally: Invalid Ballot\n");
	}
};

void(entity player, float cast) Request_Poll_Vote =
{
	if (poll_entity == world)
	{
		sprint(self, "There is nothing to vote on.\n");
		return;
	}

	if (player.vote)
	{
		if (player.vote != cast)											// They changed their mind...
		{
			if (player == poll_entity.owner)								// This person, who changed their mind, also started the request, so just cancel it.
			{
				poll_entity.nextthink = -99;
				poll_entity.think = SUB_Null;
				sound(self, CHAN_VOICE, "misc/basetry.wav", 1, ATTN_NONE);
				bprint("The request was cancelled.\n");
				Request_Poll_Cleanup();
				return;
			}
		}
		else
		{
			sprint(player, "You already voted.\n");
			return;
		}
	}
	player.vote = cast;

	if (player != poll_entity.owner)
		bprint(player.netname, " voted.\n");

	Request_Poll_Tally(cast);
};

void() Request_Poll_Announce =
{
	//self is the poll_entity
	
	self.health -= 10;

	if (self.health <= 0)
	{
		self.nextthink = -99;
		self.think = SUB_Null;

		sound(self, CHAN_VOICE, "misc/basetry.wav", 1, ATTN_NONE);
		bprint("The request has expired.\n");
		Request_Poll_Cleanup();
	}
	else
	{
		sound(self, CHAN_VOICE, "misc/basekey.wav", 1, ATTN_NONE);

		bprint(self.owner.netname, " requests to ", self.noise1, self.noise2, "\n");
		bprint("\nType \byes\b or \bno\b in console to cast your vote.\n\n");

		self.nextthink = time + 10;
		self.think = Request_Poll_Announce;										// Doubt we have to refresh this but...
	}
};

float (string pollname, void() passfunc, string captiona, string captionb) Request_Poll_Initialize =
{
	if (poll_entity.owner != world)
	{
		sound(self, CHAN_VOICE, "misc/basetry.wav", 1, ATTN_NONE);
		sprint(self, "A vote is already in progress.\n");		
		return FALSE;
	}

	poll_entity = spawn();
	poll_entity.owner = self;
	poll_entity.noise1 = captiona;
	poll_entity.noise2 = captionb;
	poll_entity.classname = pollname;										// We can use the classname to determine criteria for certain requests.
	poll_entity.nextthink = time + 10;										// Announce the request every 10 seconds.
	poll_entity.think = Request_Poll_Announce;
	poll_entity.health = 60;												// This will be the time-limit for how long to wait for everyone to cast a vote.
	poll_entity.touch = passfunc;											// Call this function if the poll is positive

	Request_Poll_Vote(self, 1);												//The person who starts the request votes yes. Let's tally votes now...
																			
	if (poll_entity)														//...if there is only one player on the server then there is no need to announce the vote. The tally above would have passed and removed the poll_entity.
	{
		sound(world, CHAN_VOICE, "misc/basekey.wav", 1, ATTN_NONE);
		bprint(poll_entity.owner.netname, " requests to ", poll_entity.noise1, poll_entity.noise2, "\n");
		bprint("\nType \byes\b or \bno\b in console to cast your vote.\n\n");
	}
	return TRUE;
};

void() Request_Test =
{
	sound(world, CHAN_ITEM, "misc/secret.wav", 1, ATTN_NONE);
	sound(world, CHAN_VOICE, "misc/power.wav", 1, ATTN_NONE);
	bprint("The test is complete.\n");		
};

void() Request_Impulse_Commands =
{
	if (self.impulse == 101)
		Request_Poll_Vote(self,1);//YES

	if (self.impulse == 102)
		Request_Poll_Vote(self,2);//NO

	if (self.impulse == 110)
		Request_Poll_Initialize("test", Request_Test, "test the ", "voting system.");

	self.impulse = 0;
};