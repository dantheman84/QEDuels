/*  Copyright (C) 1996-1997  Id Software, Inc.

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

    See file, 'COPYING', for details.
*/
float startingserverflags;
float reset_flag;
float IDEAL_DIST_FROM_DM_SPAWN_POINT    = 384;
float MIN_DIST_FROM_DM_SPAWN_POINT    = 84;
entity(float forceSpawn) SelectSpawnPoint;
//
// Elodefs.qc
//
// Constants and global variables used in the Elohim mod.
//
// All code by J.P. Grossman unless otherwise commented.
//
// See Elohim.qc for a list of standard fields used.
//

// constants
float ELOHIM_SUICIDE_OK = 0;
float ELOHIM_TOO_MANY_SUICIDES = 1;
float ELOHIM_NEGINF = -9999999;

// client styles
float ELOHIM_NEW_CLIENT = 1;           // set when a client first connects
float ELOHIM_ADMINISTRATOR = 2;        // set if the client is an admin
float CRMOD_DETECTING_QSMACK = 4;    // set when detecting if client is a qsmack bot
float ELOHIM_POP_FORWARD = 8;       // used to walk through doors
float ELOHIM_READY = 16;             // ready to play in match
float ELOHIM_YES = 32;               // used for voting
float ELOHIM_HEADS_UP = 64;          // enable heads up display
float ELOHIM_SETTING_OPTIONS = 128;  // set when setting options
float ELOHIM_MOTD = 256;             // showing MOTD
float ELOHIM_OK_TO_SHOOT = 512;      // don't fire after options/respawn
float ELOHIM_KICK_CONFIRM = 1024;    // used to confirm a kick
float ELOHIM_CONFIRM_LEAVE = 2048;   // confirmation for leaving match
float ELOHIM_CONNECTED = 4096;       // client has been put in server
float ELOHIM_FOUND_BINDINGS = 8192; // used to check for bindings
float CRMOD_SMART_WEAPON = 16384;    // whether or not to use `smart' weapon switching
float ELOHIM_OBSERVER = 32768;		 // set if the client is an observer
float CRMOD_QSMACK = 65536;			// set for qsmack bots
float ELOHIM_SCOREBOARD = 131072;	// player is looking at teamscores
float ELOHIM_NO_POST_THINK = 262144;// don't do post think (optimization)
float ELOHIM_WINQUAKE = 524288;     // player is using winquake
float ELOHIM_GLQUAKE = 1048576;     // player is using glquake
float ELOHIM_AUTOSTATS = 2097152;   // autostats enabled

// observer flags  (/me kills jp)
float OBSERVER_WALK = 1;        // set in walk mode
float OBSERVER_FLY = 2;        // set in fly mode
float OBSERVER_CHASE = 4;      // set in chase mode
float OBSERVER_DEMO = 8;       // see through chasetargets eyes
float OBSERVER_CAMERA = 16;		// set to camera mode
float OBSERVER_AUTO = 32;	   // view autoswitching
float OBSERVER_TOURNEY = 64;	   // set tournement mode for chasecam
float OBSERVER_GO_AUTO = 128;  // player entering an auto mode
float OBSERVER_COMMENTARY = 256; // see running commentary

// CRMOD qsmack variables
.float qsmack_level;
.float qsmack_trylevel;
float qsmack_statusokay;				// True if qsmack bot just did a status

// server mode - stored in cvar 'samelevel' and preserved across levels
float ELOHIM_SAME_LEVEL = 1;
float ELOHIM_MATCH_MODE = 2;
float ELOHIM_PRACTICE_MODE = 4;
float ELOHIM_SERVER_INITIALIZED = 8;
float ELOHIM_NO_GIBS = 16;
float ELOHIM_LOW_GIBS = 32;
float ELOHIM_NO_QUAD = 64;
float ELOHIM_NO_PENT = 128;
float ELOHIM_NO_RING = 256;
float ELOHIM_MODE_VOTE = 512;
float ELOHIM_DEDICATED_SERVER = 1024; 
float ELOHIM_NO_SPOOGE = 2048;			// disable spooging in practice mode
float CRMOD_QSMACK_ON = 4096;			// CRMOD is server using Qsmack?
float ELOHIM_EXTENDED_OBITS = 8192;
float ELOHIM_CONSOLE_INITIALIZED = 16384;
float ELOHIM_FAST_START = 32768;
float ELOHIM_FRESH_SPAWNS = 65536;
float ELOHIM_AUTO_PAUSE = 131072;

// server state - not preserved across level changes
float ELOHIM_TIMER_STARTED = 1;
float ELOHIM_MATCH_STARTED = 2;
float ELOHIM_MATCH_PAUSED = 4;
float ELOHIM_MATCH_OVER = 8;
float ELOHIM_MATCH_WAIT = 16;   // 5 second delay after match ends
float ELOHIM_KICKING = 32;
float ELOHIM_IGNORE_CONSOLE = 64;
// muddle counts :)
float ELOHIM_SETQUAD_COUNT = 128;
float ELOHIM_SETPENT_COUNT = 1024;
float ELOHIM_SETRING_COUNT = 8192;
// end muddle (eats bits up to 65536)
float ELOHIM_NO_PRACTICE = 131072;
float ELOHIM_ELOSTART = 262144;
float ELOHIM_UNPAUSING = 524288;
float ELOHIM_AUTO_PAUSED = 1048576;
float ELOHIM_DELAYED_AUTOSS = 2097152;
float ELOHIM_TAKING_AUTOSS = 4194304;

// admin constants
float ADMIN_NORMAL_MODE = 0;
float ADMIN_PRACTICE_MODE = 1;
float ADMIN_MATCH_MODE = 2;
float ADMIN_INDIVIDUAL_MODE = 3;

// entity constants
float ELOHIM_MANUAL_SPAWN = 1;

// elohim global variables
float elohim_player_ids;    // used for assigning unique player ID's
float elohim_password;      // used to store the administrator password
float elohim_devparam;      // used for development
float elohim_playmode;      // current play mode (non volatile flags)
float elohim_state;         // server state (volatile flags)
float elohim_timelimit;     // timelimit for matches (default 20 minutes)
float elohim_overtime;      // length of auto-overtime; 0 if none
float elohim_nextcheck;     // used for periodic checks
float elohim_nextcheck2;	// used for frequent periodic checks
entity elohim_request;      // used to control voting
float elohim_level;         // number of current level in user level order
float elohim_levelcount;    // used to scan through list in levels.cfg
float elohim_lastcount;     // used to detect end-of-file in levels.cfg
float elohim_num_spawns;    // number of deathmatch spawn points
float elohim_num_starts;    // number of match extra start points
float elohim_num_cameras;   // number of cameras
string elohim_version;      // used for motd and help-server
string elohim_version_info; // text info including rev. and compile time
string crmod_version_number; // text info storing version number (ie "4.0")
entity elohim_debug_client; // used for debugging
float elohim_arena_health;  // used for rocket arena practice mode
entity elohim_quad;			// pointer to quad for quick reference
entity elohim_pent;			// pointer to pent for quick reference

// match global variables
float elohim_match_pause_time;  // records time that match was paused
float elohim_maxteams;			// maximum number of teams
float elohim_numteams;			// number of teams
float elohim_maxsize;           // maximum allowed team size
entity elohim_match_timer;      // used to time match
entity elohim_sentinel;			// head of linked lists
string elohim_szthe;			// hack - = "The " for teamplay, "" for individual
string elohim_szteam;			// hack - = "team" for teamplay, "player" for individual

// score global variables
string elohim_winning_teamname;	// name of winning team (as returned by strings_get_teamname)
float elohim_score_number;		// either difference in score or tied score
string ELOHIM_STRING_TIED;		// initialized to "   Tied at "
float elohim_score_count;		// number of clients looking at score
entity elohim_first_place;
entity elohim_second_place;

// console global variables
float console_deathmatch;
float console_timelimit;
float console_fraglimit;
float console_pausable;
float console_noexit;

// auto parameters
float auto_parm1;	// 
float auto_parm2;	// 
float auto_parm3;	// 
float auto_parm4;	// 

// other global variables
string nextmap;  // moved here from Client.qc
float timelimit; // this used to be local in CheckRules in Client.qc        
float fraglimit; // this used to be local in CheckRules in Client.qc        
float intermission_running;  // moved here from Client.qc
float intermission_exittime; // moved here from Client.qc

entity crmod_best_chase_target; // calculated every second who is the best target to chase // CRMOD - auto
entity crmod_current_chase_target;
float crmod_chase_delay;
entity crmod_best_camera;       // set after each camera's think
entity crmod_current_camera;
float crmod_camera_delay;

vector crmod_angle;	// used for both autoss and intermission

// client variables
.vector crmod_qdwep;  // vector to keep track of quad weapon stats	// CRMOD - stats
.vector crmod_qdkill; // vector to keep track of quad kill stats	// CRMOD - stats
.vector crmod_badstats; // keep track of RL paks and damage done to team
.entity crmod_othertarget; // entity to focus on in tourneycam		// CRMOD - tourneycam
.entity crmod_inflicted;   // stores entity last attacked			// CRMOD - combat
.float crmod_chase_score;  // same as above, also used by cameras
.float crmod_did_damage;   // last time person did damage
.float oflags;				// CRMOD observer flags
.float crmod_cam_delay;    // keep autocam from overswitching
.vector crmod_oldangle;    // set by angles_fixangle
.float delayed_impulse;		// saves self.impulse so it doesn't get nuked by a ping
.float timeslot;			// records which scoreboard slot is used for time
.entity next_player;		// used to point to first/next player in team
.entity next_team;			// used to point to next team
.entity next_camera;		// used to point to next camera
.vector crmod_old_velocity; // used for pausing/unpausing
.float crmod_hack_count;	// used to count admin hacking attempts

float CRMOD_ANGLE_SMOOTHING = 0.6; // CRMOD use this instead of typing the number a billion times
//END


//
// Strings.qc
//
// A bunch of routines for returning various strings.
// Several routines were inspired by the clanring server mod.
//
// All code by J.P. Grossman unless otherwise commented.
//

//
//  F T O S
//
//  Some numbers have been hard-coded to avoid the problems associated with
//  a single ftos buffer.
//
string (float n) strings_ftos =
{
    if (n == 1)
        return "1 ";
    if (n == 2)
        return "2 ";
    if (n == 3)
        return "3 ";
    if (n == 4)
        return "4 ";
    if (n == 5)
        return "5 ";
    if (n == 6)
        return "6 ";
    if (n == 7)
        return "7 ";
    if (n == 8)
        return "8 ";
    if (n == 9)
        return "9 ";
    if (n == 10)
        return "10";
    if (n == 11)
        return "11";
    if (n == 12)
        return "12";
    if (n == 13)
        return "13";
    if (n == 14)
        return "14";
    if (n == 15)
        return "15";
    if (n == 20)
        return "20";
    if (n == 25)
        return "25";
    if (n == 30)
        return "30";
    return "???";
};

//
//  F T O S  G O L D
//
//  Return some gold number strings.
//
string (float n) strings_ftos_gold =
{
    if (n == 0)
        return "�";
    if (n == 1)
        return "�";
    if (n == 2)
        return "�";
    if (n == 3)
        return "�";
    if (n == 4)
        return "�";
    if (n == 5)
        return "�";
    if (n == 6)
        return "�";
    if (n == 7)
        return "�";
    if (n == 8)
        return "�";
    if (n == 9)
        return "�";
    return "?";
};

//
//  G E T  A R M O U R  V A L
//
//  Returns a string containing the amount of armour the player has.
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_armour_val =
{
    if (e.items & IT_INVULNERABILITY)
        return "�����";
    if (e.armorvalue <= 100)
    {
        if (e.armorvalue <= 0) return "None ";
        if (e.armorvalue <= 5) return "5  ";
        if (e.armorvalue <= 10) return "10 ";
        if (e.armorvalue <= 20) return "20 ";
        if (e.armorvalue <= 30) return "30 ";
        if (e.armorvalue <= 40) return "40 ";
        if (e.armorvalue <= 50) return "50 ";
        if (e.armorvalue <= 60) return "60 ";
        if (e.armorvalue <= 70) return "70 ";
        if (e.armorvalue <= 80) return "80 ";
        if (e.armorvalue <= 90) return "90 ";
        return "100";
    }
    else
    {
        if (e.armorvalue <= 110) return "110";
        if (e.armorvalue <= 120) return "120";
        if (e.armorvalue <= 130) return "130";
        if (e.armorvalue <= 140) return "140";
        if (e.armorvalue <= 150) return "150";
        if (e.armorvalue <= 160) return "160";
        if (e.armorvalue <= 170) return "170";
        if (e.armorvalue <= 180) return "180";
        if (e.armorvalue <= 190) return "190";
        if (e.armorvalue <= 200) return "200";
        return "???";
    }
};

//
//  G E T  A R M O U R  T Y P E
//
//  Returns one of
//
//     "Armour: R "
//     "Armour: Y "
//     "Armour: G "
//     "Armour: "
//
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_armour_type =
{

    if (e.items & IT_INVULNERABILITY) return "����� ";
    if (e.armortype == 0.8) return "����� R ";
    if (e.armortype == 0.6) return "����� Y ";
    if (e.armortype == 0.3) return "����� G ";
    return "����� ";
};

//
//  G E T  W E A P O N
//
//  Returns "[QOR] <weapon>\n" where [QOR] are the quad, ring and
//  suit flags (either present or absent) and <weapon> is the player's
//  weapon (I'm sure you were having trouble figuring that one out).
//  Used for observer mode heads-up display.
//
string (entity e) strings_get_weapon =
{
    if (e.items & IT_SUIT)
    {
        if (e.items & IT_QUAD)
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " �Q��� Rocket Launcher\n";
                if (e.weapon == 64) return " �Q��� Lightning Gun\n";
                if (e.weapon == 16) return " �Q��� Grenade Launcher\n";
                if (e.weapon == 8) return " �Q��� Super Nailgun\n";
                if (e.weapon == 2) return " �Q��� Super Shotgun\n";
                if (e.weapon == 4) return " �Q��� Nailgun\n";
                if (e.weapon == 1) return " �Q��� Shotgun\n";
                if (e.weapon == 4096) return " �Q��� Axe\n";
                return " �Q��� No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " �Q �� Rocket Launcher\n";
                if (e.weapon == 64) return " �Q �� Lightning Gun\n";
                if (e.weapon == 16) return " �Q �� Grenade Launcher\n";
                if (e.weapon == 8) return " �Q �� Super Nailgun\n";
                if (e.weapon == 2) return " �Q �� Super Shotgun\n";
                if (e.weapon == 4) return " �Q �� Nailgun\n";
                if (e.weapon == 1) return " �Q �� Shotgun\n";
                if (e.weapon == 4096) return " �Q �� Axe\n";
                return " �Q �� No Weapon\n";
            }
        }
        else
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " � ��� Rocket Launcher\n";
                if (e.weapon == 64) return " � ��� Lightning Gun\n";
                if (e.weapon == 16) return " � ��� Grenade Launcher\n";
                if (e.weapon == 8) return " � ��� Super Nailgun\n";
                if (e.weapon == 2) return " � ��� Super Shotgun\n";
                if (e.weapon == 4) return " � ��� Nailgun\n";
                if (e.weapon == 1) return " � ��� Shotgun\n";
                if (e.weapon == 4096) return " � ��� Axe\n";
                return "   � ��� No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " �  �� Rocket Launcher\n";
                if (e.weapon == 64) return " �  �� Lightning Gun\n";
                if (e.weapon == 16) return " �  �� Grenade Launcher\n";
                if (e.weapon == 8) return " �  �� Super Nailgun\n";
                if (e.weapon == 2) return " �  �� Super Shotgun\n";
                if (e.weapon == 4) return " �  �� Nailgun\n";
                if (e.weapon == 1) return " �  �� Shotgun\n";
                if (e.weapon == 4096) return " �  �� Axe\n";
                return "   �  �� No Weapon\n";
            }
        }
    }
    else
    {
        if (e.items & IT_QUAD)
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " �Q� � Rocket Launcher\n";
                if (e.weapon == 64) return " �Q� � Lightning Gun\n";
                if (e.weapon == 16) return " �Q� � Grenade Launcher\n";
                if (e.weapon == 8) return " �Q� � Super Nailgun\n";
                if (e.weapon == 2) return " �Q� � Super Shotgun\n";
                if (e.weapon == 4) return " �Q� � Nailgun\n";
                if (e.weapon == 1) return " �Q� � Shotgun\n";
                if (e.weapon == 4096) return " �Q� � Axe\n";
                return " �Q� � No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " �Q  � Rocket Launcher\n";
                if (e.weapon == 64) return " �Q  � Lightning Gun\n";
                if (e.weapon == 16) return " �Q  � Grenade Launcher\n";
                if (e.weapon == 8) return " �Q  � Super Nailgun\n";
                if (e.weapon == 2) return " �Q  � Super Shotgun\n";
                if (e.weapon == 4) return " �Q  � Nailgun\n";
                if (e.weapon == 1) return " �Q  � Shotgun\n";
                if (e.weapon == 4096) return " �Q  � Axe\n";
                return " �Q  � No Weapon\n";
            }
        }
        else
        {
            if (e.items & IT_INVISIBILITY)
            {
                if (e.weapon == 32) return " � � � Rocket Launcher\n";
                if (e.weapon == 64) return " � � � Lightning Gun\n";
                if (e.weapon == 16) return " � � � Grenade Launcher\n";
                if (e.weapon == 8) return " � � � Super Nailgun\n";
                if (e.weapon == 2) return " � � � Super Shotgun\n";
                if (e.weapon == 4) return " � � � Nailgun\n";
                if (e.weapon == 1) return " � � � Shotgun\n";
                if (e.weapon == 4096) return " � � � Axe\n";
                return "   � � � No Weapon\n";
            }
            else
            {
                if (e.weapon == 32) return " �   � Rocket Launcher\n";
                if (e.weapon == 64) return " �   � Lightning Gun\n";
                if (e.weapon == 16) return " �   � Grenade Launcher\n";
                if (e.weapon == 8) return " �   � Super Nailgun\n";
                if (e.weapon == 2) return " �   � Super Shotgun\n";
                if (e.weapon == 4) return " �   � Nailgun\n";
                if (e.weapon == 1) return " �   � Shotgun\n";
                if (e.weapon == 4096) return " �   � Axe\n";
                return "   �   � No Weapon\n";
            }
        }
    }
};

//
//  G E T  H E A L T H  A M M O
//
//  Returns "  Health: <amount>   Ammo: "
//
//  The nested ifs are to speed things up.  Used for observer mode
//  heads-up display.
//
string (entity e) strings_get_health_ammo =
{
    if (e.health <= 125)
    {
        if (e.health <= 65)
        {
            if (e.health <= 30)
            {
                if (e.health <= 0)
                    return "  ������ 0    ���� ";
                if (e.health <= 5)
                    return "  ������ 5    ���� ";
                if (e.health <= 10)
                    return "  ������ 10   ���� ";
                if (e.health <= 15)
                    return "  ������ 15   ���� ";
                if (e.health <= 20)
                    return "  ������ 20   ���� ";
                if (e.health <= 25)
                    return "  ������ 25   ���� ";
                return "  ������ 30   ���� ";
            }
            else
            {
                if (e.health <= 35)
                    return "  ������ 35   ���� ";
                if (e.health <= 40)
                    return "  ������ 40   ���� ";
                if (e.health <= 45)
                    return "  ������ 45   ���� ";
                if (e.health <= 50)
                    return "  ������ 50   ���� ";
                if (e.health <= 55)
                    return "  ������ 55   ���� ";
                if (e.health <= 60)
                    return "  ������ 60   ���� ";
                return "  ������ 65   ���� ";
            }
        }
        else
        {
            if (e.health <= 95)
            {
                if (e.health <= 70)
                    return "  ������ 70   ���� ";
                if (e.health <= 75)
                    return "  ������ 75   ���� ";
                if (e.health <= 80)
                    return "  ������ 80   ���� ";
                if (e.health <= 85)
                    return "  ������ 85   ���� ";
                if (e.health <= 90)
                    return "  ������ 90   ���� ";
                return "  ������ 95   ���� ";
            }
            else
            {
                if (e.health <= 100)
                    return "  ������ 100  ���� ";
                if (e.health <= 105)
                    return "  ������ 105  ���� ";
                if (e.health <= 110)
                    return "  ������ 110  ���� ";
                if (e.health <= 115)
                    return "  ������ 115  ���� ";
                if (e.health <= 120)
                    return "  ������ 120  ���� ";
                return "  ������ 125  ���� ";
            }
        }
    }
    else
    {
        if (e.health <= 195)
        {
            if (e.health <= 160)
            {
                if (e.health <= 130)
                    return "  ������ 130  ���� ";
                if (e.health <= 135)
                    return "  ������ 135  ���� ";
                if (e.health <= 140)
                    return "  ������ 140  ���� ";
                if (e.health <= 145)
                    return "  ������ 145  ���� ";
                if (e.health <= 150)
                    return "  ������ 150  ���� ";
                if (e.health <= 155)
                    return "  ������ 155  ���� ";
                return "  ������ 160  ���� ";
            }
            else
            {
                if (e.health <= 165)
                    return "  ������ 165  ���� ";
                if (e.health <= 170)
                    return "  ������ 170  ���� ";
                if (e.health <= 175)
                    return "  ������ 175  ���� ";
                if (e.health <= 180)
                    return "  ������ 180  ���� ";
                if (e.health <= 185)
                    return "  ������ 185  ���� ";
                if (e.health <= 190)
                    return "  ������ 190  ���� ";
                return "  ������ 195  ���� ";
            }
        }
        else
        {
            if (e.health <= 225)
            {
                if (e.health <= 200)
                    return "  ������ 200  ���� ";
                if (e.health <= 205)
                    return "  ������ 205  ���� ";
                if (e.health <= 210)
                    return "  ������ 210  ���� ";
                if (e.health <= 215)
                    return "  ������ 215  ���� ";
                if (e.health <= 220)
                    return "  ������ 220  ���� ";
                return "  ������ 225  ���� ";
            }
            else
            {
                if (e.health <= 230)
                    return "  ������ 230  ���� ";
                if (e.health <= 235)
                    return "  ������ 235  ���� ";
                if (e.health <= 240)
                    return "  ������ 240  ���� ";
                if (e.health <= 245)
                    return "  ������ 245  ���� ";
                if (e.health <= 600)
                    return "  ������ 250  ���� ";
                return "  ������ 666  ���� ";
            }
        }
    }
};

//
//  G E T  T E A M N A M E
//
//  Return the colour string corresponding to a given team.
//
string (float num) strings_get_teamname =
{
    if (num == 1)
        return "Brown team";
    if (num == 2)
        return "Light Blue team";
    if (num == 3)
        return "Green team";
    if (num == 4)
        return "Red team";
    if (num == 5)
        return "Olive team";
    if (num == 6)
        return "Gold team";
    if (num == 7)
        return "Flesh team";
    if (num == 8)
        return "Lavender team";
    if (num == 9)
        return "Purple team";
    if (num == 10)
        return "Beige team";
    if (num == 11)
        return "Aqua team";
    if (num == 12)
        return "Yellow team";
    if (num == 13)
        return "Blue team";
    return "???? team"; // shouldn't happen
};

//
//  G E T  T E A M N A M E  B R O N Z E
//
//  Same as above, but in bronze letters.
//  My God, I've gone insane.
//
string (float num) strings_get_teamname_bronze =
{
    if (num == 1)
        return "����� ����";
    if (num == 2)
        return "����� ���� ����";
    if (num == 3)
        return "����� ����";
    if (num == 4)
        return "��� ����";
    if (num == 5)
        return "����� ����";
    if (num == 6)
        return "���� ����";
    if (num == 7)
        return "����� ����";
    if (num == 8)
        return "�������� ����";
    if (num == 9)
        return "������ ����";
    if (num == 10)
        return "����� ����";
    if (num == 11)
        return "���� ����";
    if (num == 12)
        return "������ ����";
    if (num == 13)
        return "���� ����";
    return "���� ����"; // shouldn't happen
};

//
//  G E T  T E A M N A M E 2
//
//  Return the colour string corresponding to a given team.
//  The string contains EXACTLY 10 characters.
//
string (float num) strings_get_teamname2 =
{
    if (num == 1)
        return "Brown     ";
    if (num == 2)
        return "Light Blue";
    if (num == 3)
        return "Green     ";
    if (num == 4)
        return "Red       ";
    if (num == 5)
        return "Olive     ";
    if (num == 6)
        return "Gold      ";
    if (num == 7)
        return "Flesh     ";
    if (num == 8)
        return "Lavender  ";
    if (num == 9)
        return "Purple    ";
    if (num == 10)
        return "Beige     ";
    if (num == 11)
        return "Aqua      ";
    if (num == 12)
        return "Yellow    ";
    if (num == 13)
        return "Blue      ";
    return "????      "; // shouldn't happen
};

//
//  G E T  T E A M N A M E 3
//
//  For when 10 characters is too many.. I can't believe I'm doing this.
//
string (float num) strings_get_teamname3 =
{
    if (num == 1)
        return "Brown    ";
    if (num == 2)
        return "Lite Blue";
    if (num == 3)
        return "Green    ";
    if (num == 4)
        return "Red      ";
    if (num == 5)
        return "Olive    ";
    if (num == 6)
        return "Gold     ";
    if (num == 7)
        return "Flesh    ";
    if (num == 8)
        return "Lavender ";
    if (num == 9)
        return "Purple   ";
    if (num == 10)
        return "Beige    ";
    if (num == 11)
        return "Aqua     ";
    if (num == 12)
        return "Yellow   ";
    if (num == 13)
        return "Blue     ";
    return "????     "; // shouldn't happen
};

//
//  G E T  T E A M N A M E  U P  B Y
//
//  Return the "colour up by " string corresponding to a given team.
//
string (float num) strings_get_teamname_up_by =
{
    if (num == 1)
        return "        Brown up by ";
    if (num == 2)
        return "   Light Blue up by ";
    if (num == 3)
        return "        Green up by ";
    if (num == 4)
        return "          Red up by ";
    if (num == 5)
        return "        Olive up by ";
    if (num == 6)
        return "         Gold up by ";
    if (num == 7)
        return "        Flesh up by ";
    if (num == 8)
        return "     Lavender up by ";
    if (num == 9)
        return "       Purple up by ";
    if (num == 10)
        return "        Beige up by ";
    if (num == 11)
        return "         Aqua up by ";
    if (num == 12)
        return "       Yellow up by ";
    if (num == 13)
        return "         Blue up by ";
    return "         ???? up by "; // shouldn't happen
};


//
//  G E T  M O D E
//
//  Returns "Normal", "Practice", or "Match".
//
string (float mode) strings_get_mode =
{
    if (mode == 0)
        return "Normal";
    if (mode == 1)
        return "Practice";
	if (mode == 2)
		return "Match";
	return "Individual";
};

//
//  S Z P L U R A L
//
//  Helper string for printing.
//
string (float n) strings_szplural =
{
    if (n == 1)
        return "\n";
    return "s\n";
};



void() SUB_Null = {};

void() SUB_Remove = {remove(self);};


/*QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.*/
void() SetMovedir =
{
	if (self.angles == '0 -1 0')
		self.movedir = '0 0 1';

	else if (self.angles == '0 -2 0')
		self.movedir = '0 0 -1';

	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	
	self.angles = '0 0 0';
};

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
	// trigger angles are used for one-way touches.  An angle of 0 is assumed
	// to mean no restrictions, so use a yaw of 360 instead.
	if (self.angles != '0 0 0')
		SetMovedir ();

	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};

/*
=============
SUB_CalcMove

calculate self.velocity and self.nextthink to reach dest from
self.origin traveling at speed
===============
*/
void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
	local vector	vdestdelta;
	local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
		
	// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
	// calculate length of vector
	len = vlen (vdestdelta);
	
	// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
	
	// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

	// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float	
};

void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
	local entity	stemp;
	stemp = self;
	self = ent;

	SUB_CalcMove (tdest, tspeed, func);
	self = stemp;
};

/*
============
After moving, set origin to exact final destination
============
*/
void()  SUB_CalcMoveDone =
{
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;

	if (self.think1)
		self.think1();
};


/*
=============
SUB_CalcAngleMove

calculate self.avelocity and self.nextthink to reach destangle from
self.angles rotating 

The calling function should make sure self.think is valid
===============
*/
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt =
{
	local entity		stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove (destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
	local vector	destdelta;
	local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");
		
	// set destdelta to the vector needed to move
	destdelta = destangle - self.angles;
	
	// calculate length of vector
	len = vlen (destdelta);
	
	// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

	// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);
	
	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

/*
============
After rotating, set angle to exact final angle
============
*/
void() SUB_CalcAngleMoveDone =
{
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;

	if (self.think1)
		self.think1();
};


//=============================================================================

void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets ();
	remove(self);
};

/*
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
and removes them, so some events can remove other triggers.

Search for (string)targetname in all entities that
match (string)self.target and call their .use function

==============================
*/
void() SUB_UseTargets =
{
	local entity t, act, stemp, otemp;

//
// check for a delay
//
	if (self.delay)
	{
		// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;

		return;
	}
	
	
//
// print the message
//
	if (activator.classname == "player" && self.message != "")
	{
		centerprint (activator, self.message);

		if (!self.noise)
			sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

//
// kill the killtagets
//
	if (self.killtarget != "")
	{
		t = world;

		do
		{
			t = find (t, targetname, self.killtarget);

			if (!t)
				return;

			remove (t);
		} while ( 1 );
	}
	
//
// fire targets
//
	if (self.target != "")
	{
		act = activator;
		t = world;

		do
		{
			t = find (t, targetname, self.target);
			if (!t)
			{
				return;
			}

			stemp = self;
			otemp = other;
			self = t;
			other = stemp;

			if (self.use != SUB_Null)
			{
				if (self.use)
					self.use ();
			}
			self = stemp;
			other = otemp;
			activator = act;
		} while ( 1 );
	}	

};

/*in nightmare mode, all attack_finished times become 0
some monsters refire twice automatically*/

void(float normal) SUB_AttackFinished =
{
	self.cnt = 0;		// refire count for nightmare

	if (skill != 3)
		self.attack_finished = time + normal;
};

float (entity targ) visible;

void (void() thinkst) SUB_CheckRefire =
{
	if (skill != 3)
		return;

	if (self.cnt == 1)
		return;

	if (!visible (self.enemy))
		return;

	self.cnt = 1;
	self.think = thinkst;
};




//Duels MOD BEGIN
//
// Utils.qc
//
// This file contains a bunch of useful definitions and utilities.
//
// All code by J.P. Grossman unless otherwise commented.
//

// Overloaded centerprints
void (entity client, string s1, string s2) centerprint2 = #73;
void (entity client, string s1, string s2, string s3) centerprint3 = #73;
void (entity client, string s1, string s2, string s3, string s4) centerprint4 = #73;
void (entity client, string s1, string s2, string s3, string s4, string s5) centerprint5 = #73;
void (entity client, string s1, string s2, string s3, string s4, string s5, string s6) centerprint6 = #73;
void (entity client, string s1, string s2, string s3, string s4, string s5, string s6, string s7) centerprint7 = #73;

// Overloaded sprints
void (entity client, string s1, string s2) sprint2 = #24;
void (entity client, string s1, string s2, string s3) sprint3 = #24;
void (entity client, string s1, string s2, string s3, string s4) sprint4 = #24;
void (entity client, string s1, string s2, string s3, string s4, string s5) sprint5 = #24;
void (entity client, string s1, string s2, string s3, string s4, string s5, string s6) sprint6 = #24;

// Overloaded bprints
void (string s1, string s2) bprint2 = #23;
void (string s1, string s2, string s3) bprint3 = #23;
void (string s1, string s2, string s3, string s4) bprint4 = #23;
void (string s1, string s2, string s3, string s4, string s5) bprint5 = #23;
void (string s1, string s2, string s3, string s4, string s5, string s6) bprint6 = #23;

//
// Functions for printing to console
//
// Caution:  when printing multiple strings to the same line, use cprint
//           for the first string(s) and localcmd for subsequent strings.
//
// example:
//
// cprint3("my ", "name ", "is ");
// localcmd2("bob", "\n");
//
void (string s1, string s2) localcmd2 =
{
    localcmd(s1);
    localcmd(s2);
};

void (string s1, string s2, string s3) localcmd3 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
};

void (string s1, string s2, string s3, string s4) localcmd4 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
};

void (string s1, string s2, string s3, string s4, string s5) localcmd5 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
};

void (string s1, string s2, string s3, string s4, string s5, string s6) localcmd6 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
    localcmd(s6);
};

void (string s1, string s2, string s3, string s4, string s5, string s6, string s7) localcmd7 =
{
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
    localcmd(s6);
    localcmd(s7);
};

void (string s1) cprint =
{
    localcmd("echo ");
    localcmd(s1);  
};

void (string s1, string s2) cprint2 =
{
    localcmd("echo ");
    localcmd(s1);
    localcmd(s2);
};

void (string s1, string s2, string s3) cprint3 =
{
    localcmd("echo ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
};

void (string s1, string s2, string s3, string s4) cprint4 =
{
    localcmd("echo ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
};

void (string s1, string s2, string s3, string s4, string s5) cprint5 =
{
    localcmd("echo ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
};

void (string s1, string s2, string s3, string s4, string s5, string s6) cprint6 =
{
    localcmd("echo ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
    localcmd(s6);
};

void (string s1, string s2, string s3, string s4, string s5, string s6, string s7) cprint7 =
{
    localcmd("echo ");
    localcmd(s1);
    localcmd(s2);
    localcmd(s3);
    localcmd(s4);
    localcmd(s5);
    localcmd(s6);
    localcmd(s7);
};

//
//  B P R I N T  F L O A T
//
//  Broadcasts a float followed by a CR.
//
void (float f) utils_bprint_float =
{
    local string s;

    s = ftos(f);
    bprint2(s, "\n");
};

//
//  P R I N T  F L O A T
//
//  Prints a float followed by CR to 'self'.
//
void (float f) utils_print_float =
{
    local string s;

    s = ftos(f);
    sprint2(self, s, "\n");
};

//
//  P R I N T  F L O A T N
//
//  Prints a float with up to n decimal digits followed by CR to self
//
void (float f, float n) utils_print_floatn = 
{
	local string s;
	local float temp;
	local float factor;

	temp = floor(f);
	if (f == temp)
	{
		utils_print_float(f);
		return;
	}
	s = ftos(temp);
	sprint2(self, s, ".");
	f = f - temp;

	factor = 1;
	while (n)
	{
		factor = 10 * factor;
		n = n - 1;
	}
	f = floor(factor * f + 0.5);

	while (factor)
	{
		factor = floor(factor / 10);
		temp = floor(f / factor);
		f = f - temp * factor;
		if (!f)
			factor = 0;
		s = ftos(temp);
		sprint(self, s);
	}
	sprint(self, "\n");
};

//
//  P R I N T  I N T 3
//
//  Prints a 3 character integer to 'self'.
//
void (float f) utils_print_int3 =
{
    local float n;
    local string s;

    n = rint(f);
    if (n < 0)
    {
        if (n < -99)
            sprint(self, "-99");
        else if (n > -10)
            sprint(self, " ");
    }
    else
    {
        if (n < 100)
            sprint(self, " ");
        if (n < 10)
            sprint(self, " ");
    }
    s = ftos(n);
    sprint(self, s);
};

//
//  P R I N T  I N T 3  G O L D
//
//  Prints a gold 3 character integer to 'self'.
//
void (float f) utils_print_int3_gold = 
{
	local float n, d, temp;
	local string s;

	n = rint(f);
	temp = d = floor(n / 100);
	n = n - d * 100;
	if (d)
		s = strings_ftos_gold(d);
	else
		s = " ";
	sprint(self, s);

	d = floor(n / 10);
	n = n - d * 10;
	if (temp || d)
		s = strings_ftos_gold(d);
	else 
		s = " ";
	sprint(self, s);

	s = strings_ftos_gold(n);
	sprint(self, s);
};

//
//  C P R I N T  I N T 3
//
//  Prints a 3 character integer to the console.
//
void (float f) utils_cprint_int3 =
{
    local float n;
    local string s;

    n = rint(f);
    if (n < 0)
    {
        if (n < -99)
            localcmd("-99");
        else if (n > -10)
            localcmd(" ");
    }
    else
    {
        if (n < 100)
            localcmd(" ");
        if (n < 10)
            localcmd(" ");
    }
    s = ftos(n);
    localcmd(s);
};

//
//  P R I N T  V E C
//
//  Prints a vector followed by CR to 'self'.
//  Used for debugging.
//
void (vector v) utils_print_vec =
{
    local string s;

    s = vtos(v);
    sprint2(self, s, "\n");
};

//
//  P R I N T  B I T
//
//  Prints a single bit to 'self'.
//  Used for debugging.
//
void (float b) utils_print_bit =
{
    if (b)
        sprint(self, "1");
    else
        sprint(self, "0");
};

//
//  P R I N T  B I N
//
//  Prints a binary number followed by CR to 'self'.
//  Used for debugging.
//
void (float n) utils_print_bin =
{
    local float bit;

    if (!n)
    {
        sprint(self, "0\n");
        return;
    }

    bit = 32768 * 32768 * 2;
    while (bit > 0.5)
    {
        if (n & bit)
        {
            while (bit > 0.5)
            {
                utils_print_bit(n & bit);
                bit = bit / 2;
            }
        }
        bit = bit / 2;
    }
    sprint(self, "\n");
};

//
//  D U M P  P O S I T I O N
//
//  Dumps all 3d position information for an entity to 'self'.
//  Used for debugging.
//
void (entity e) utils_dump_position =
{
    sprint(self, "origin = ");
    utils_print_vec(e.origin);
    sprint(self, "mins = ");
    utils_print_vec(e.mins);
    sprint(self, "maxs = ");
    utils_print_vec(e.maxs);
    sprint(self, "size = ");
    utils_print_vec(e.size);
    sprint(self, "absmin = ");
    utils_print_vec(e.absmin);
    sprint(self, "absmax = ");
    utils_print_vec(e.absmax);
};

//
//  M I N
//
float (float a, float b) utils_min =
{
    if (a < b)
        return a;
    return b;
};

//
//  M A X
//
float (float a, float b) utils_max =
{
    if (a > b)
        return a;
    return b;
};

//
//  M I N 3
//
float (float a, float b, float c) utils_min3 =
{
    local float d;
    if (a < b)
        d = a;
    else
        d = b;
    if (d < c)
        return d;
    return c;
};

//
//  M A X 3
//
float (float a, float b, float c) utils_max3 =
{
    local float d;
    if (a > b)
        d = a;
    else
        d = b;
    if (d > c)
        return d;
    return c;
};

//
//  M A K E  S C H E D U L E D  E V E N T
//
//  Creates a new dynamic entity which will call the given
//  think function after the given amout of time; the entity's
//  owner is 'self'.
//
entity (void() think_function, float think_time) utils_make_scheduled_event =
{
    local entity temp;
    temp = spawn();
    temp.classname = "elohim_temp";
    temp.owner = self;
    temp.nextthink = time + think_time;
    temp.think = think_function;
    return temp;
};

//
//  S E T  C V A R
//
//  Set the console variable 'var' to 'value'.
//
void (string var, float value) utils_set_cvar =
{
    local string temp;

    temp = ftos(value);
    cvar_set(var, temp);
};

//
//  D O  I T E M
//
//  Do something to all items of the given type.  For each item,
//  'dofunc()' is called with 'self' pointing to the item.
//
void (void () dofunc, string item_name) utils_do_item =
{
    local entity oldself;

    oldself = self;
    self = find(world, classname, item_name);
    while (self)
    {
        dofunc();
        self = find(self, classname, item_name);
    }
    self = oldself;
};

//
//  D O  I T E M S
//
//  Do the same thing to all respawnable items.
//
void (void () dofunc) utils_do_items =
{
    utils_do_item(dofunc, "item_health");
    utils_do_item(dofunc, "item_armor1");
    utils_do_item(dofunc, "item_armor2");
    utils_do_item(dofunc, "item_armorInv");
    utils_do_item(dofunc, "item_shells");
    utils_do_item(dofunc, "item_spikes");
    utils_do_item(dofunc, "item_rockets");
    utils_do_item(dofunc, "item_cells");
    utils_do_item(dofunc, "weapon_nailgun");
    utils_do_item(dofunc, "weapon_supernailgun");
    utils_do_item(dofunc, "weapon_supershotgun");
    utils_do_item(dofunc, "weapon_rocketlauncher");
    utils_do_item(dofunc, "weapon_grenadelauncher");
    utils_do_item(dofunc, "weapon_lightning");
    utils_do_item(dofunc, "item_sigil");
    utils_do_item(dofunc, "item_artifact_invulnerability");
    utils_do_item(dofunc, "item_artifact_envirosuit");
    utils_do_item(dofunc, "item_artifact_invisibility");
    utils_do_item(dofunc, "item_artifact_super_damage");
};

//
//  D O  P R O J E C T I L E S
//
//  Do the same thing to all rockets, grenades and nails.
//
void (void () dofunc) utils_do_projectiles = 
{
	utils_do_item(dofunc, "missile");
	utils_do_item(dofunc, "grenade");
	utils_do_item(dofunc, "spike");
};

//
//  D O  P L A Y E R S
//
//  Do the same thing to all connected players.  For each player,
//  'dofunc()' is called with 'self' pointing to the player.
//
void (void () dofunc) utils_do_players =
{
    local entity oldself;

    oldself = self;
    self = find(world, classname, "player");
    while (self)
    {

            dofunc();
        self = find(self, classname, "player");
    }
    self = oldself;
};

//
//  S T O F
//
//  Convert a string to a float.
//
float (string s) utils_stof =
{
    local float f, temp;

    temp = cvar("v_kickpitch");
    cvar_set("v_kickpitch", s);
    f = cvar("v_kickpitch");
    utils_set_cvar("v_kickpitch", temp);
    return f;
};

// CRMOD
//  V I S I B L E
//    by Paul Baker
//
//    returns 1 if the entity a can see entity b.
//
float (entity a, entity b) utils_visible =
{
	traceline (a.origin, b.origin, TRUE, a);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

//
//  N E W  V I S I B L E
//     by Paul Baker
//
//  Corrected and optimized by J.P.
//
//  Return TRUE if entity a can 'see' entity b.
//
float (entity a, entity b) utils_new_visible =
{
	local float dist;
	local float crosswater;

	// First trace as far as we can, keeping track of crosswater
	crosswater = 0;
	trace_ent = a;
	trace_fraction = 0;
	while ((trace_ent != world) && (trace_fraction < 1.0))
	{
		traceline(trace_ent.origin, b.origin, TRUE, trace_ent);
		if (trace_inopen && trace_inwater)
			crosswater = 1;
	}

	// If we can see all the way to the player, return 4 - crosswater
	if (trace_fraction == 1.0)
		return (4 - crosswater);

	// If the player is right on the other side of the wall, return 2 - crosswater
    dist = vlen(trace_endpos - b.origin);
	if (dist < 200)
		return (2 - crosswater);

	// Otherwise, player is not visible at all
	return 0;
};


// CRMOD
//  T O G G L E  O F L A G
//    by Paul Baker
//
//  Toggles the specified flag in self.oflags
//
void (float flag, string name) utils_toggle_oflag = 
{
	if (self.oflags & flag)
	{
		self.oflags = self.oflags - flag;
		sprint2(self, name, " disabled\n");
	}
	else
	{
		self.oflags = self.oflags | flag;
		sprint2(self, name, " enabled\n");
	}
};

//
//  T O G G L E  F L A G
//
//  Toggles the specified flag in self.style
//
void (float flag, string name) utils_toggle_flag = 
{
	if (self.style & flag)
	{
		self.style = self.style - flag;
		sprint2(self, name, " disabled\n");
	}
	else
	{
		self.style = self.style | flag;
		sprint2(self, name, " enabled\n");
	}
};

//
//  T O G G L E  S F L A G
//
//  Toggles the specified flag in elohim_playmode
//
void (float flag, string name) utils_toggle_sflag = 
{
	if (elohim_playmode & flag)
	{
		elohim_playmode = elohim_playmode - flag;
		bprint2(name, " disabled\n");
		cprint2(name, " disabled\n");
	}
	else
	{
		elohim_playmode = elohim_playmode | flag;
		bprint2(name, " enabled\n");
		cprint2(name, " enabled\n");
	}
    utils_set_cvar("samelevel", elohim_playmode);
};

// CRMOD
// S T U F F  T O  P L A Y E R
//      by Paul Baker
//
//   stuffcmd's a message to the player by their entity number (status number).
//   this is used primarily to tell a person they've been kicked.
//

void (float i, string txt) utils_stuff_to_player =
{
	local entity e;
	e = find(world, classname, "player");
	while (e != world)
	{
		if (e.colormap == i)
		{
			stuffcmd(e, txt);
			return;
		}
		e = find(e, classname, "player");
	}
};

//
//  G E T  B I T
//
//  Returns 1 << index
//
float (float index) utils_get_bit =
{
	local float bit;

	if (index & 8)
		bit = 256;
	else
		bit = 1;
	if (index & 4)
		bit = bit * 16;
	if (index & 2)
		bit = bit * 4;
	if (index & 1)
		bit = bit * 2;
	return bit;
};

//
//  F I N D  Z E R O
//
//  Returns the index of the first zero in a binary number
//
float (float num) utils_find_zero = 
{
	local float bit, index;

	index = 0;
	bit = 1;
	while (num & bit)
	{
		bit = bit * 2;
		index = index + 1;
	}
	return index;
};

//
//  I L L E G A L  N A M E
//
//  Returns TRUE if the client name is illegal, FALSE otherwise.
//
float (string cname) utils_illegal_name = 
{
    if (cname == "" || cname == "unconnected")
		return TRUE;
	return FALSE;
};

//
//  S O U N D
//
//  Play a sound for a single client
//
//  NOT CURRENTLY USED - replaced by stuffcmd(play ...)
//
void (entity player, float soundnum) utils_sound = 
{
	msg_entity = player;
	WriteByte(MSG_ONE, SVC_SOUND);
	WriteByte(MSG_ONE, 2);
	WriteByte(MSG_ONE, 0);
	WriteShort(MSG_ONE, 0);
	WriteByte(MSG_ONE, soundnum);
	WriteCoord(MSG_ONE, 0);
	WriteCoord(MSG_ONE, 0);
	WriteCoord(MSG_ONE, 0);
};
