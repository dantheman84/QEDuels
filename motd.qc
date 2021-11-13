
void()motd_print =
{	
	if (intermission_running)
		return;

	centerprint(self, motd_string);
};

void()motd_start =
{
	self.show_motd = TRUE;
};