#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <colors>

#if SOURCEMOD_V_MINOR < 7
#error Old version sourcemod!
#endif
#pragma newdecls required

#define VERSION "7.0.0"

#define ZC_ZOMBIE 0
#define ZC_SMOKER 1
#define ZC_BOOMER 2
#define ZC_HUNTER 3
#define ZC_SPITTER 4
#define ZC_JOCKEY 5
#define ZC_CHARGER 6 
#define ZC_WITCH 7
#define ZC_TANK 8


#define INT_COLOR_WHITE 8553090

// Original boxes from ASC
#define BOOMERBITCHSLAP true
#define HEALRESPAWN true

#define DEFAULT_IP "coop.l4d.dev:27015"

// ====================================================================

char DeathBoxSounds[3][64] = {
  "ambient/overhead/plane1.wav",
  "ambient/wind/wind_hit2.wav",
  "ambient/wind/windgust_strong.wav"
};

char JackInTheBoxSounds[5][64] = {
  "player/survivor/voice/mechanic/laughter13a.wav",
  "player/survivor/voice/mechanic/laughter13b.wav",
  "player/survivor/voice/mechanic/laughter13c.wav",
  "player/survivor/voice/mechanic/laughter13d.wav",
  "player/survivor/voice/mechanic/laughter13e.wav"
};

#define JACKPOTBOX "level/bell_normal.wav"

// ====================================================================
#define MIDNIGHTRIDE "music/flu/concert/midnightride.wav"
#define ONEBADMAN "music/flu/concert/onebadman.wav"
#define BLAZEMUSIC "music/flu/jukebox/all_i_want_for_xmas.wav"
#define BLOOD_SOUND "ui/survival_medal.wav"
#define BONUS_SOUND "ui/beep22.wav"
#define BOOMER_SOUND "player/boomer/vomit/attack/bv1.wav"
#define BRIDE_SOUND "npc/witch/voice/attack/female_distantscream1.wav"
#define CHARGER_SOUND "player/charger/voice/attack/charger_charge_02.wav"
#define EXPLOSION_SOUND "ambient/explosions/explode_1.wav"
#define EXPLOSION_SOUND2 "ambient/explosions/explode_2.wav"
#define HARD_SOUND "plats/piano.wav"
#define HEAL_SOUND "items/suitchargeok1.wav"
#define HUNTER_SOUND "player/hunter/voice/attack/hunter_attackmix_01.wav"
#define LASER_SOUND "player/laser_on.wav"
#define LINGHNING2 "ambient/energy/zap1.wav"
#define MULTIPLE_SOUND "level/gnomeftw.wav"
#define PANIC_SOUND "npc/mega_mob/mega_mob_incoming.wav"
#define POINTS_SOUND "level/loud/climber.wav"
#define PUNCH_SOUND "player/survivor/hit/int/Punch_Boxing_FaceHit1.wav"
#define REALISM_SOUND "player/orch_hit_csharp_short.wav"
#define SOUND_BLIP "buttons/blip1.wav"
#define SOUND_DEFROST "physics/glass/glass_sheet_break1.wav"
#define SOUND_FREEZE "physics/glass/glass_impact_bullet4.wav"
#define SOUND_IMPACT01	 "animation/van_inside_hit_wall.wav"
#define SOUND_IMPACT02 "ambient/explosions/explode_3.wav"
#define SOUND_IMPACT03  "ui/bigreward.wav"
#define SOUND_JAR "weapons/ceda_jar/ceda_jar_explode.wav"
#define SPITTER_SOUND "player/spitter/voice/idle/spitter_lurk_03.wav"
#define TANK_SOUND "player/tank/voice/growl/tank_fail_02.wav"
#define TINY_SOUND "plats/churchbell_end.wav"
#define VOMIT_SOUND "player/boomer/fall/boomer_dive_01.wav"
#define JOCKEY_SOUND "player/jockey/voice/warn/jockey_06.wav"
#define SMOKER_SOUND "player/smoker/voice/warn/smoker_warn_05.wav"
#define KNIFE_SOUND "level/loud/gallery_win.wav"
#define WITCH_SOUND "npc/witch/voice/attack/female_distantscream2.wav"
#define ALARM_SOUND "ambient/alarms/klaxon1.wav"

#define EXPLODE_SOUND_3 "weapons/hegrenade/explode3.wav"
#define EXPLODE_SOUND_4 "weapons/hegrenade/explode4.wav"
#define EXPLODE_SOUND_5 "weapons/hegrenade/explode5.wav"

#define EXPLOSION_PARTICLE "FluidExplosion_fps"
#define EXPLOSION_PARTICLE2 "weapon_grenade_explosion"
#define EXPLOSION_PARTICLE3 "explosion_huge_b"

#define FIRESMALL_PARTICLE "fire_small_01"
#define FIRESMALL_PARTICLE1 "fire_small_02"
#define FIRESMALL_PARTICLE2 "fire_small_03"

#define PARTICLE_CLOUD "smoker_smokecloud"
//#define PARTICLE_CLOUD "minigun_overheat_smoke"
//#define PARTICLE_CLOUD "smoke_burning_engine_01"

#define SPRITE_BEAM "materials/sprites/laserbeam.vmt"
#define SPRITE_HALO "materials/sprites/halo01.vmt"

#define DMG_GENERIC		0
#define DMG_EXPLOSIVE	-2122317758

#define MAX_ENTITIES		8

char F18_Sounds[6][128] = 
{
  "animation/jets/jet_by_01_lr.wav", 
  "animation/jets/jet_by_02_lr.wav", 
  "animation/jets/jet_by_03_lr.wav", 
  "animation/jets/jet_by_04_lr.wav", 
  "animation/jets/jet_by_05_lr.wav", 
  "animation/jets/jet_by_05_rl.wav"
};

static const char g_sVocalize[][] = 
{
  "scenes/Coach/WorldC5M4B04.vcd",  //Damn! That one was close!
  "scenes/Coach/WorldC5M4B05.vcd",  //Shit. Damn, that one was close!
  "scenes/Coach/WorldC5M4B02.vcd",  //STOP BOMBING US.
  "scenes/Gambler/WorldC5M4B09.vcd",  //Well, it's official: They're trying to kill US now.
  "scenes/Gambler/WorldC5M4B05.vcd",  //Christ, those guys are such assholes.
  "scenes/Gambler/World220.vcd",  //WHAT THE HELL ARE THEY DOING?  (reaction to bombing)
  "scenes/Gambler/WorldC5M4B03.vcd",  //STOP BOMBING US!
  "scenes/Mechanic/WorldC5M4B02.vcd",  //They nailed that.
  "scenes/Mechanic/WorldC5M4B03.vcd",  //What are they even aiming at?
  "scenes/Mechanic/WorldC5M4B04.vcd",  //We need to get the hell out of here.
  "scenes/Mechanic/WorldC5M4B05.vcd",  //They must not see us.
  "scenes/Mechanic/WorldC5M103.vcd",  //HEY, STOP WITH THE BOMBING!
  "scenes/Mechanic/WorldC5M104.vcd",  //PLEASE DO NOT BOMB US
  "scenes/Producer/WorldC5M4B04.vcd",  //Something tells me they're not checking for survivors anymore.
  "scenes/Producer/WorldC5M4B01.vcd",  //We need to keep moving.
  "scenes/Producer/WorldC5M4B03.vcd" //That was close.
};

#if BOOMERBITCHSLAP
static float lastSlapTime[MAXPLAYERS + 1] = 0.0;
#endif

int ClientsCount = 0;
int freeze[MAXPLAYERS + 1];
int icolor[MAXPLAYERS + 1][3];
int g_GlowSprite;
int g_BeamSprite;
int g_HaloSprite;

float l4d2_freeze_radius = 300.0;
float l4d2_freeze_time = 15.0;
float l4d2_vomit_radius = 300.0;
float l4d2_healbox_radius = 250.0;
float l4d2_explosion_radius = 300.0;

float g_l4d2_ammo_chance = 0.0;

int g_cvarRadius = 350;
int g_cvarPower = 60; // 450
int g_cvarDuration = 15;

int g_iHardLevel = 0;

int LastInfoTIME[MAXPLAYERS + 1];
bool g_bPoints = false;
bool g_bRank = false;

ConVar Cvar_ConfigName;
ConVar Cvar_ServerIP;
ConVar Cvar_Steam_Group_Name;

ConVar l4d2_ammo_count;
ConVar l4d2_ammo_count_bonus;
ConVar l4d2_ammo_medbox_count;
ConVar l4d2_ammo_nextbox;
ConVar l4d2_ammochance_nothing;
ConVar l4d2_ammochance_firebox;
ConVar l4d2_ammochance_boombox;
ConVar l4d2_ammochance_freezebox;
ConVar l4d2_ammochance_laserbox;
ConVar l4d2_ammochance_medbox;
ConVar l4d2_ammochance_nextbox;
ConVar l4d2_ammochance_healbox;
ConVar l4d2_ammochance_panicbox;
ConVar l4d2_ammochance_witchbox;
ConVar l4d2_ammochance_tankbox;
ConVar l4d2_ammochance_bonusbox;
ConVar l4d2_ammo_loot_bonus;
ConVar l4d2_ammochance_hardbox;
ConVar l4d2_ammochance_vomitbox;
ConVar l4d2_ammochance_explosionbox;
ConVar l4d2_ammochance_realismbox;
ConVar l4d2_ammochance_bloodbox;
ConVar l4d2_ammochance_icebox;
ConVar l4d2_ammochance_expiredbox;

ConVar l4d2_ammochance_deathbox;
ConVar l4d2_ammochance_jackinthebox;
ConVar l4d2_ammochance_jackpotbox;

ConVar l4d2_ammochance_matrixbox;
ConVar l4d2_ammo_matrix_ts;
ConVar l4d2_ammo_matrix_timer2;
ConVar l4d2_ammo_matrix_glowon;
ConVar l4d2_ammo_matrix_colormobs;
ConVar l4d2_ammo_matrix_colorwitch;
ConVar l4d2_ammo_matrix_colorbosses;
bool MatrixOn = false;
bool g_bGlow = false;
int PropGhost;

ConVar l4d2_ammochance_grenadebox;
ConVar l4d2_ammochance_luckybox;
ConVar l4d2_ammochance_weaponbox;
ConVar l4d2_ammochance_lifebox;
ConVar l4d2_ammochance_jockeybox;
ConVar l4d2_ammochance_smokerbox;
ConVar l4d2_ammochance_knifebox;

ConVar l4d2_ammochance_barrelbox;
ConVar l4d2_ammo_barrel_duration;
ConVar l4d2_ammo_barrel_radius;
bool g_bBarrelRain;

ConVar l4d2_ammochance_airstrikebox;
ConVar l4d2_ammo_airstrike_duration;
ConVar l4d2_ammo_airstrike_radius;
bool g_bAirstrike;
static int g_iEntities[MAX_ENTITIES];

ConVar l4d2_ammochance_meteorbox;
ConVar l4d2_ammo_meteor_duration;
ConVar l4d2_ammo_meteor_radius;
ConVar l4d2_ammo_meteor_explode_damage;
ConVar l4d2_ammo_meteor_explode_radius;
int g_ExplosionSprite;
bool g_bMeterRain = false;
int g_iMeteorTick;

ConVar l4d2_ammochance_hellbox;
bool g_bRing = true;
bool g_bStrike2 = false;
float g_cvarExplosionRadius = 200.0;

ConVar l4d2_ammochance_respawnbox;

ConVar l4d2_ammochance_lightningbox;
ConVar l4d2_ammo_lightning_damage1;
ConVar l4d2_ammo_lightning_damage2;
ConVar l4d2_ammo_lightning_todeath;
ConVar l4d2_ammo_lightning_range;
ConVar l4d2_ammo_lightning_life;
//int g_LightningSprite;
int g_SteamSprite;

int whiteColor[4] =  { 255, 255, 255, 255 };
// int g_sprite;
int iLightning[MAXPLAYERS + 1][MAXPLAYERS + 1];
float AttackerTime[MAXPLAYERS + 1];
int Victim[MAXPLAYERS + 1];

ConVar l4d2_ammochance_cloudbox;

static const float TRACE_TOLERANCE = 25.0;

ConVar l4d2_ammo_cloudbox_duration;
ConVar l4d2_ammo_cloudbox_radius;
ConVar l4d2_ammo_cloudbox_damage;
ConVar l4d2_ammo_cloudbox_shake;
ConVar l4d2_ammo_cloudbox_blocks_revive;
ConVar l4d2_ammo_cloudbox_sound_path;
ConVar l4d2_ammo_cloudbox_damage_message;
ConVar l4d2_ammo_cloudbox_color;
ConVar l4d2_ammo_cloudbox_transparency;
ConVar l4d2_ammo_cloudbox_density;

ConVar l4d2_ammochance_bridebox;
ConVar l4d2_ammochance_failbox;
ConVar l4d2_ammochance_pointsbox;
ConVar l4d2_ammochance_bingobox;
ConVar l4d2_ammochance_acidbox;

ConVar l4d2_ammochance_flamebox;
//static g_flLagMovement = 0;

ConVar l4d2_ammochance_bwbox;
ConVar l4d2_ammochance_whitebox;
ConVar l4d2_ammochance_multiplebox;
ConVar l4d2_ammochance_bossbox;
ConVar l4d2_ammochance_huntingbox;
ConVar l4d2_ammochance_spitterbox;
ConVar l4d2_ammochance_chargerbox;
ConVar l4d2_ammochance_boomerbox;



ConVar l4d2_ammochance_blazebox;
ConVar l4d2_ammo_blaze_life;
ConVar l4d2_ammo_blaze_type;
ConVar l4d2_ammo_blazeDmg;
float g_BlazeLife[MAXPLAYERS + 1] =  { 0.0, ... };

ConVar l4d2_ammochance_tinybox;
ConVar l4d2_ammo_tiny_scale_infected;
ConVar l4d2_ammo_tiny_scale_witch;
ConVar l4d2_ammo_tiny_scale_infected_min;
ConVar l4d2_ammo_tiny_scale_infected_max;
ConVar l4d2_ammo_tiny_scale_witch_min;
ConVar l4d2_ammo_tiny_scale_witch_max;

ConVar l4d2_ammo_multipleboxes;
ConVar l4d2_ammo_witches;
ConVar l4d2_ammo_bridewitches;

ConVar l4d2_z_difficulty;

bool g_bIsBloodBox;
bool g_bIsRealismBox;
bool g_bIsTinyBox;

bool l4d2_plugin_uncommons = true;
bool l4d2_plugin_keyman = true;

GameData g_hGameConf = null;
Handle sdkVomitInfected = null;
Handle sdkVomitSurvivor = null;
Handle sdkCallPushPlayer = null;
Handle sdkDetonateAcid = null;
Handle sdkRoundRespawn = null;
Handle sdkRevive = null;
Handle sdkStaggerPlayer = null;

ConVar g_cvarIsMapFinished;
ConVar g_cvarIsHardBox;
ConVar g_cvarIsBloodBox;

ConVar sv_disable_glow_survivors;
ConVar g_hAmmoSmg;
ConVar g_hAmmoRifle;
ConVar g_hAmmoShotgun;
ConVar g_hAmmoAutoShot;
ConVar g_hAmmoHunting;
ConVar g_hAmmoChainsaw;
ConVar g_hAmmoSniper;

char Server_UpTime[20];
int UpTime = 0;

public Plugin myinfo = 
{
  name = "[L4D2] Super Coop for ASC", 
  author = "Aleexxx [Based on the plugin of Acelerattor74]",
  description = "Playing the increased complexity for ASC", 
  version = VERSION, 
  url = "http://www.americasectorcoop.org"
};

public void OnPluginStart() {
  
  UpTime = GetTime();
  LoadTranslations("common.phrases");
  LoadTranslations("l4d2_supercoop.phrases");
  
  HookEvent("round_start", Event_RoundStart);
  // HookEvent("player_changename", Event_PlayerChangeName, EventHookMode_Pre);
  HookEvent("upgrade_pack_used", onEventUpgradePackUsed);
  HookEvent("upgrade_pack_added", onEventUpgradePackAdded);
  HookEvent("revive_success", EventwhiteReviveSuccess);
  HookEvent("player_death", EventwhitePlayerDeath);
  HookEvent("player_spawn", EventPlayerSpawn);
  HookEvent("round_end", Event_RoundEnd);
  HookEvent("heal_success", Event_whiteHealSuccess);
  HookEvent("defibrillator_used", Event_PlayerDefibed);
  HookEvent("player_entered_checkpoint", Event_CheckPoint);
  HookEvent("player_now_it", Event_PlayerNowIt);
  HookEvent("witch_spawn", onEventWitchSpawn);
  HookEvent("difficulty_changed", onEventDifficultyChange);

  #if BOOMERBITCHSLAP
  HookEvent("player_hurt", onEventPlayerHurt);
  #endif
  RegConsoleCmd("sm_info", onCommandInfo);
  RegConsoleCmd("sm_serverinfo", onCommandServerInfo);
  RegConsoleCmd("sm_suicide", onCommandSuicide);
  RegConsoleCmd("sm_kill", onCommandSuicide);
  RegConsoleCmd("sm_cfs", onCommandSuicide);
  RegConsoleCmd("sm_ping", onCommandPing);
  RegConsoleCmd("vocalize", onCommandVocalize);
  // RegAdminCmd("sm_fire", Command_Fire, ADMFLAG_ROOT, "sm_fire");
  // RegAdminCmd("sm_boom", Command_Boom, ADMFLAG_ROOT, "sm_boom");
  // RegAdminCmd("sm_healbox", Command_Heal, ADMFLAG_ROOT, "sm_healbox");
  // RegAdminCmd("sm_barrelbox", Command_Barrel, ADMFLAG_ROOT, "sm_barrelbox");
  // RegAdminCmd("sm_airstrikebox", Command_Airstrike, ADMFLAG_ROOT, "sm_airstrikebox");
  // RegAdminCmd("sm_lightningbox", Command_Lightningbox, ADMFLAG_ROOT, "sm_lightningbox");
  // RegAdminCmd("sm_meteorbox", Command_Meteor, ADMFLAG_ROOT, "sm_meteorbox");
  // RegAdminCmd("sm_explodebox", Command_Explode, ADMFLAG_ROOT, "sm_explodebox");
  // RegAdminCmd("sm_glowfire", Command_GlowFire, ADMFLAG_ROOT, "sm_glowfire");
  // RegAdminCmd("sm_flying", Command_Flying, ADMFLAG_ROOT, "sm_flying");
  // RegAdminCmd("sm_vomitbox", Command_Vomit, ADMFLAG_ROOT, "sm_vomitbox");
  // RegAdminCmd("sm_null", Command_Null, ADMFLAG_ROOT, "sm_null");
  RegAdminCmd("sm_spawnitem", Command_SpawnItem, ADMFLAG_ROOT, "sm_spawnitem <parameters>");
  RegAdminCmd("sm_spawnitemnew", Command_SpawnItemNew, ADMFLAG_ROOT, "sm_spawnitemnew <parameters>");
  RegAdminCmd("sm_spawnnewitem", Command_SpawnNewItem, ADMFLAG_ROOT, "sm_spawnnewitem <parameters>");
  RegAdminCmd("sm_sni", Command_SpawnNewItem, ADMFLAG_ROOT, "sm_sni <parameters>");
  RegAdminCmd("sm_sninew", Command_SpawnNewItemNew, ADMFLAG_ROOT, "sm_sninew <parameters>");
  RegAdminCmd("sm_sniold", Command_SpawnNewItemOld, ADMFLAG_ROOT, "sm_sniold <parameters>");
  // RegAdminCmd("sm_killallfreezes", Command_KillAllFreezes, ADMFLAG_ROOT, "sm_killallfreezes");
  // RegAdminCmd("sm_freezebox", Command_FreezeBox, ADMFLAG_ROOT, "sm_killallfreezes");
  RegAdminCmd("sm_cmd", Command_Cmd, ADMFLAG_ROOT, "sm_cmd <command> <parameter>");
  RegAdminCmd("sm_cmdall", Command_CmdAll, ADMFLAG_ROOT, "sm_cmdall <command> <parameter>");
  RegAdminCmd("sm_cmdclient", Command_CheatCmdPlayer, ADMFLAG_KICK, "sm_cmdclient <#userid|name> <cmd>");
  RegAdminCmd("sm_kickfakeclients", Command_KickFakeClients, ADMFLAG_ROOT, "sm_kickfakeclients (1 - spectators, 2 - survivors, 3 - infected)");
  RegAdminCmd("sm_kickextrabots", Command_KickExtraBots, ADMFLAG_ROOT, "sm_kickextrabots");
  RegAdminCmd("sm_kickteam", Command_KickTeam, ADMFLAG_ROOT, "sm_kickteam (1 - spectators, 2 - survivors, 3 - infected)");
  RegAdminCmd("sm_veto", Command_Veto, ADMFLAG_ROOT, "sm_veto");
  RegAdminCmd("sm_pass", Command_Pass, ADMFLAG_ROOT, "sm_pass");
  RegAdminCmd("sm_screen", Command_Screen, ADMFLAG_ROOT, "sm_screen R G B A duration");
  RegAdminCmd("sm_colorscreen", Command_ColorScreen, ADMFLAG_ROOT, "sm_colorscreen <type> <duration>");
  RegAdminCmd("sm_spas", Command_SpasAll, ADMFLAG_GENERIC, "sm_spas"); //switched to ADMFLAG_GENERIC for Mod access
  // RegAdminCmd("sm_melee", Command_Melee, ADMFLAG_GENERIC, "sm_melee"); //switched to ADMFLAG_GENERIC for Mod access
  
  Cvar_ConfigName = CreateConVar("l4d2_config_name", "AMERICA SECTOR COOP", "");
  Cvar_ServerIP = CreateConVar("l4d2_server_ip", DEFAULT_IP, "");
  Cvar_Steam_Group_Name = CreateConVar("l4d2_steam_group_name", "AMERICA SECTOR COOP", "");
  

  registerConvarsBoxes();
  
  
  g_cvarIsMapFinished = CreateConVar("hm_mapfinished", "0", "");
  g_cvarIsHardBox = CreateConVar("l4d2_hardbox", "0", "");
  g_cvarIsBloodBox = CreateConVar("l4d2_bloodbox", "0", "");
  
  g_cvarIsMapFinished.AddChangeHook(IsMapFinishedChanged);
  
  l4d2_z_difficulty = FindConVar("z_difficulty");
  sv_disable_glow_survivors = FindConVar("sv_disable_glow_survivors");
  g_hAmmoSmg = FindConVar("ammo_smg_max");
  g_hAmmoRifle = FindConVar("ammo_assaultrifle_max");
  g_hAmmoShotgun = FindConVar("ammo_shotgun_max");
  g_hAmmoAutoShot = FindConVar("ammo_autoshotgun_max");
  g_hAmmoHunting = FindConVar("ammo_huntingrifle_max");
  g_hAmmoChainsaw = FindConVar("ammo_chainsaw_max");
  g_hAmmoSniper = FindConVar("ammo_sniperrifle_max");
  
  g_hGameConf = new GameData("l4d2_supercoop");
  if (g_hGameConf == null)
  {
    SetFailState("Couldn't find the offsets and signatures file. Please, check that it is installed correctly.");
  }
  
  StartPrepSDKCall(SDKCall_Player);
  PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CTerrorPlayer_OnVomitedUpon");
  PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
  PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
  sdkVomitSurvivor = EndPrepSDKCall();
  if (sdkVomitSurvivor == null)
  {
    SetFailState("Unable to find the \"CTerrorPlayer_OnVomitedUpon\" signature, check the file version!");
  }
  
  StartPrepSDKCall(SDKCall_Player);
  PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CTerrorPlayer_OnHitByVomitJar");
  PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
  PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
  sdkVomitInfected = EndPrepSDKCall();
  if (sdkVomitInfected == null)
  {
    SetFailState("Unable to find the \"CTerrorPlayer_OnHitByVomitJar\" signature, check the file version!");
  }
  
  StartPrepSDKCall(SDKCall_Player);
  PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CTerrorPlayer_Fling");
  PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
  PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
  PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
  PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
  sdkCallPushPlayer = EndPrepSDKCall();
  if (sdkCallPushPlayer == null)
  {
    SetFailState("Unable to find the 'CTerrorPlayer_Fling' signature, check the file version!");
  }
  
  StartPrepSDKCall(SDKCall_Player);
  PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CTerrorPlayer_OnRevived");
  sdkRevive = EndPrepSDKCall();
  if (sdkRevive == null)
  {
    SetFailState("Unable to find the \"CTerrorPlayer::OnRevived(void)\" signature, check the file version!");
  }
  
  StartPrepSDKCall(SDKCall_Entity);
  PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CSpitterProjectile_Detonate");
  sdkDetonateAcid = EndPrepSDKCall();
  if (sdkDetonateAcid == null)
  {
    SetFailState("Unable to find the \"CSpitterProjectile::Detonate(void)\" signature, check the file version!");
  }
  
  StartPrepSDKCall(SDKCall_Player);
  PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "RoundRespawn");
  sdkRoundRespawn = EndPrepSDKCall();
  if (sdkRoundRespawn == null)
  {
    SetFailState("L4D_SM_Respawn: RoundRespawn Signature broken");
  }
  
  StartPrepSDKCall(SDKCall_Player);
  if (PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CTerrorPlayer::OnStaggered") == false)
  {
    SetFailState("Could not load the 'CTerrorPlayer::OnStaggered' gamedata signature.");
  }
  PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
  PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
  sdkStaggerPlayer = EndPrepSDKCall();
  if (sdkStaggerPlayer == null)
  {
    SetFailState("Could not prep the 'CTerrorPlayer::OnStaggered' function.");
  }
  
  PrintToServer("[L4D2 Supercoop] exec l4d2_supercoop/start.cfg");
  ServerCommand("exec l4d2_supercoop/start");
  
  CreateTimer(1.0, MapStart);
}

public void registerConvarsBoxes() {
  // Config convars
  l4d2_ammo_count = CreateConVar("l4d2_ammo_count", "15", "");
  l4d2_ammo_count_bonus = CreateConVar("l4d2_ammo_count_bonus", "50", "");
  l4d2_ammo_medbox_count = CreateConVar("l4d2_ammo_medbox_count", "10", "");
  l4d2_ammo_nextbox = CreateConVar("l4d2_ammo_nextbox", "random", "");
  // Config for matrixbox
  l4d2_ammo_matrix_ts = CreateConVar("l4d2_ammo_matrix_ts", "0.35", "Matrix timescale multiplier");
  l4d2_ammo_matrix_timer2 = CreateConVar("l4d2_ammo_matrix_timer2", "5", "Matrix time duration, multiplied by resulting timescale modification");
  l4d2_ammo_matrix_glowon = CreateConVar("l4d2_ammo_matrix_glowon", "1", "Should infected glow during matrix time?");
  l4d2_ammo_matrix_colormobs = CreateConVar("l4d2_ammo_matrix_colormobs", "16724223", "Zombie glow color");
  l4d2_ammo_matrix_colorwitch = CreateConVar("l4d2_ammo_matrix_colorwitch", "16711910", "Witch glow color");
  l4d2_ammo_matrix_colorbosses = CreateConVar("l4d2_ammo_matrix_colorbosses", "255", "Infected bosses glow color");
  // Config for tinybox
  l4d2_ammo_tiny_scale_infected = CreateConVar("l4d2_ammo_tiny_scale_infected", "75.0", "chance of common infected [0.0, 100.0]");
  l4d2_ammo_tiny_scale_witch = CreateConVar("l4d2_ammo_tiny_scale_witch", "80.0", "chance of witch [0.0, 100.0]");
  l4d2_ammo_tiny_scale_infected_min = CreateConVar("l4d2_ammo_tiny_scale_infected_min", "0.4", "min size for common infected [0.1, 10.0] ");
  l4d2_ammo_tiny_scale_infected_max = CreateConVar("l4d2_ammo_tiny_scale_infected_max", "0.9", "max size for common infected [min, 10.0]");
  l4d2_ammo_tiny_scale_witch_min = CreateConVar("l4d2_ammo_tiny_scale_witch_min", "0.4", "min size for witch [0.1, 10.0]");
  l4d2_ammo_tiny_scale_witch_max = CreateConVar("l4d2_ammo_tiny_scale_witch_max", "2.0", "max size for witch [min, 10.0]");
  // Config for blazebox
  l4d2_ammo_blaze_life = CreateConVar("l4d2_ammo_blaze_life", "211", "How long our blaze remaind on.. Min: 1 sec, Max:60 sec.");
  l4d2_ammo_blaze_type = CreateConVar("l4d2_ammo_blaze_type", "0", "The type of blaze");
  l4d2_ammo_blazeDmg = CreateConVar("l4d2_ammo_blazeDmg", "20", "How much damage our blaze done");
  // Config box bonuxbox
  l4d2_ammo_loot_bonus = CreateConVar("l4d2_ammo_loot_bonus", "2", "");
  // Config for lightningbox
  l4d2_ammo_lightning_damage1 = CreateConVar("l4d2_ammo_lightning_damage1", "20", "damage at first,[1, 100]int");
  l4d2_ammo_lightning_damage2 = CreateConVar("l4d2_ammo_lightning_damage2", "5", "damage per second,[1, 10]int");
  l4d2_ammo_lightning_todeath = CreateConVar("l4d2_ammo_lightning_todeath", "0", "0, do not damage palyer if icapped, 1, always damage to palyer");
  l4d2_ammo_lightning_range = CreateConVar("l4d2_ammo_lightning_range", "500.0", "lightning transfer range [300.0, -]");
  l4d2_ammo_lightning_life = CreateConVar("l4d2_ammo_lightning_life", "30", "lightning's life [30.0 -]");
  // config for barrelbox
  l4d2_ammo_barrel_duration = CreateConVar("l4d2_ammo_barrel_duration", "20", "Time out for the barrel rain");
  l4d2_ammo_barrel_radius = CreateConVar("l4d2_ammo_barrel_radius", "350", "Maximum radius of the barrel rain");
  // config for airstrike box
  l4d2_ammo_airstrike_duration = CreateConVar("l4d2_ammo_airstrike_duration", "25", "Time out for the barrel rain");
  l4d2_ammo_airstrike_radius = CreateConVar("l4d2_ammo_airstrike_radius", "1200", "Maximum radius of the barrel rain");
  // Config for meteorbox
  l4d2_ammo_meteor_radius = CreateConVar("l4d2_ammo_meteor_radius", "2500", "Radius fall of rocks");
  l4d2_ammo_meteor_explode_damage = CreateConVar("l4d2_ammo_meteor_explode_damage", "60", "explode damage of rock");
  l4d2_ammo_meteor_explode_radius = CreateConVar("l4d2_ammo_meteor_explode_radius", "300", "explosion radius of rock");
  l4d2_ammo_meteor_duration = CreateConVar("l4d2_ammo_meteor_duration", "40", "starfall duration (s)");
  // Config for cloudbox
  l4d2_ammo_cloudbox_damage = CreateConVar("l4d2_ammo_cloudbox_damage", "4.0", " Amount of damage the cloud deals every 2 seconds ");
  l4d2_ammo_cloudbox_duration = CreateConVar("l4d2_ammo_cloudbox_duration", "20.0", "How long the cloud damage persists ");
  l4d2_ammo_cloudbox_radius = CreateConVar("l4d2_ammo_cloudbox_radius", "300", " Radius of gas cloud damage ");
  l4d2_ammo_cloudbox_sound_path = CreateConVar("l4d2_ammo_cloudbox_sound_path", "player/survivor/voice/choke_5.wav", "Path to the Soundfile being played on each damaging Interval");
  l4d2_ammo_cloudbox_damage_message = CreateConVar("l4d2_ammo_cloudbox_damage_message", "3", " 0 - Disabled; 1 - small HUD Hint; 2 - big HUD Hint; 3 - Chat Notification ");
  l4d2_ammo_cloudbox_shake = CreateConVar("l4d2_ammo_cloudbox_shake", "1", " Enable/Disable the Cloud Damage Shake ");
  l4d2_ammo_cloudbox_blocks_revive = CreateConVar("l4d2_ammo_cloudbox_blocks_revive", "1", " Enable/Disable the Cloud Damage Stopping Reviving ");
  l4d2_ammo_cloudbox_color = CreateConVar("l4d2_ammo_cloudbox_color", "16 122 0", "<Red> <Green> <Blue> (0-255)");
  l4d2_ammo_cloudbox_transparency = CreateConVar("l4d2_ammo_cloudbox_transparency", "155", "Smoke Transparency (0-255)");
  l4d2_ammo_cloudbox_density = CreateConVar("l4d2_ammo_cloudbox_density", "30", "How thick the smoke is");
  // Config for multiplebox
  l4d2_ammo_multipleboxes = CreateConVar("l4d2_ammo_multipleboxes", "8", "");
  // Config for Witchbox
  l4d2_ammo_witches = CreateConVar("l4d2_ammo_witches", "8", "");
  l4d2_ammo_bridewitches = CreateConVar("l4d2_ammo_bridewitches", "4", "");
  // Box chance
  l4d2_ammochance_nothing = CreateConVar("l4d2_ammochance_nothing", "100", "");
  l4d2_ammochance_firebox = CreateConVar("l4d2_ammochance_firebox", "2", "");
  l4d2_ammochance_boombox = CreateConVar("l4d2_ammochance_boombox", "5", "");
  l4d2_ammochance_freezebox = CreateConVar("l4d2_ammochance_freezebox", "6", "");
  l4d2_ammochance_laserbox = CreateConVar("l4d2_ammochance_laserbox", "5", "");
  l4d2_ammochance_medbox = CreateConVar("l4d2_ammochance_medbox", "2", "");
  l4d2_ammochance_nextbox = CreateConVar("l4d2_ammochance_nextbox", "5", "");
  l4d2_ammochance_panicbox = CreateConVar("l4d2_ammochance_panicbox", "5", "");
  l4d2_ammochance_witchbox = CreateConVar("l4d2_ammochance_witchbox", "3", "");
  l4d2_ammochance_healbox = CreateConVar("l4d2_ammochance_healbox", "3", "");
  l4d2_ammochance_tankbox = CreateConVar("l4d2_ammochance_tankbox", "2", "");
  l4d2_ammochance_bonusbox = CreateConVar("l4d2_ammochance_bonusbox", "5", "");
  l4d2_ammochance_hardbox = CreateConVar("l4d2_ammochance_hardbox", "2", "");
  l4d2_ammochance_vomitbox = CreateConVar("l4d2_ammochance_vomitbox", "6", "");
  l4d2_ammochance_explosionbox = CreateConVar("l4d2_ammochance_explosionbox", "1", "");
  l4d2_ammochance_realismbox = CreateConVar("l4d2_ammochance_realismbox", "1", "");
  l4d2_ammochance_bloodbox = CreateConVar("l4d2_ammochance_bloodbox", "2", "");
  l4d2_ammochance_icebox = CreateConVar("l4d2_ammochance_icebox", "10", "");
  l4d2_ammochance_expiredbox = CreateConVar("l4d2_ammochance_expiredbox", "1", "");
  l4d2_ammochance_jackinthebox = CreateConVar("l4d2_ammochance_jackinthebox", "2", "");
  l4d2_ammochance_jackpotbox = CreateConVar("l4d2_ammochance_jackpotbox", "1", "");
  l4d2_ammochance_deathbox = CreateConVar("l4d2_ammochance_deathbox", "1", "");
  l4d2_ammochance_matrixbox = CreateConVar("l4d2_ammochance_matrixbox", "2", "");
  l4d2_ammochance_grenadebox = CreateConVar("l4d2_ammochance_grenadebox", "1", "");
  l4d2_ammochance_luckybox = CreateConVar("l4d2_ammochance_luckybox", "1", "");
  l4d2_ammochance_weaponbox = CreateConVar("l4d2_ammochance_weaponbox", "1", "");
  l4d2_ammochance_lifebox = CreateConVar("l4d2_ammochance_lifebox", "2", "");
  l4d2_ammochance_jockeybox = CreateConVar("l4d2_ammochance_jockeybox", "1", "");
  l4d2_ammochance_smokerbox = CreateConVar("l4d2_ammochance_smokerbox", "1", "");
  l4d2_ammochance_knifebox = CreateConVar("l4d2_ammochance_knifebox", "1", "");
  l4d2_ammochance_barrelbox = CreateConVar("l4d2_ammochance_barrelbox", "2", "");
  l4d2_ammochance_airstrikebox = CreateConVar("l4d2_ammochance_airstrikebox", "0", "");
  l4d2_ammochance_meteorbox = CreateConVar("l4d2_ammochance_meteorbox", "2", "");
  l4d2_ammochance_hellbox = CreateConVar("l4d2_ammochance_hellbox", "1", "");
  l4d2_ammochance_respawnbox = CreateConVar("l4d2_ammochance_respawnbox", "2", "");
  l4d2_ammochance_lightningbox = CreateConVar("l4d2_ammochance_lightningbox", "0", "");
  l4d2_ammochance_cloudbox = CreateConVar("l4d2_ammochance_cloudbox", "6", "");
  l4d2_ammochance_bridebox = CreateConVar("l4d2_ammochance_bridebox", "4", "");
  l4d2_ammochance_failbox = CreateConVar("l4d2_ammochance_failbox", "1", "");
  l4d2_ammochance_pointsbox = CreateConVar("l4d2_ammochance_pointsbox", "2", "");
  l4d2_ammochance_bingobox = CreateConVar("l4d2_ammochance_bingobox", "4", "");
  l4d2_ammochance_acidbox = CreateConVar("l4d2_ammochance_acidbox", "8", "");
  l4d2_ammochance_flamebox = CreateConVar("l4d2_ammochance_flamebox", "5", "");
  l4d2_ammochance_bwbox = CreateConVar("l4d2_ammochance_bwbox", "2", "");
  l4d2_ammochance_whitebox = CreateConVar("l4d2_ammochance_whitebox", "2", "");
  l4d2_ammochance_multiplebox = CreateConVar("l4d2_ammochance_multiplebox", "5", "");
  l4d2_ammochance_bossbox = CreateConVar("l4d2_ammochance_bossbox", "3", "");
  l4d2_ammochance_huntingbox = CreateConVar("l4d2_ammochance_huntingbox", "3", "");
  l4d2_ammochance_spitterbox = CreateConVar("l4d2_ammochance_spitterbox", "3", "");
  l4d2_ammochance_chargerbox = CreateConVar("l4d2_ammochance_chargerbox", "3", "");
  l4d2_ammochance_boomerbox = CreateConVar("l4d2_ammochance_boomerbox", "3", "");
  l4d2_ammochance_blazebox = CreateConVar("l4d2_ammochance_blazebox", "1", "");
  l4d2_ammochance_tinybox = CreateConVar("l4d2_ammochance_tinybox", "3", "");
  g_l4d2_ammo_chance += l4d2_ammochance_nothing.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_firebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_boombox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_freezebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_laserbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_medbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_nextbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_panicbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_witchbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_healbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_tankbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_bonusbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_hardbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_vomitbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_explosionbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_realismbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_bloodbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_icebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_expiredbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_jackinthebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_jackpotbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_deathbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_matrixbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_grenadebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_luckybox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_weaponbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_lifebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_jockeybox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_smokerbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_knifebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_barrelbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_airstrikebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_meteorbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_hellbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_respawnbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_lightningbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_cloudbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_bridebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_failbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_pointsbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_bingobox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_acidbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_flamebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_bwbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_whitebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_multiplebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_bossbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_huntingbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_spitterbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_chargerbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_boomerbox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_blazebox.FloatValue;
  g_l4d2_ammo_chance += l4d2_ammochance_tinybox.FloatValue;
  l4d2_ammochance_nothing.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_firebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_boombox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_freezebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_laserbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_medbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_nextbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_panicbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_witchbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_healbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_tankbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_bonusbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_hardbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_vomitbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_explosionbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_realismbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_bloodbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_icebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_expiredbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_jackinthebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_jackpotbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_deathbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_matrixbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_grenadebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_luckybox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_weaponbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_lifebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_jockeybox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_smokerbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_knifebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_barrelbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_airstrikebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_meteorbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_hellbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_respawnbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_lightningbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_cloudbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_bridebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_failbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_pointsbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_bingobox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_acidbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_flamebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_bwbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_whitebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_multiplebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_bossbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_huntingbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_spitterbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_chargerbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_boomerbox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_blazebox.AddChangeHook(OnBoxChanceChange);
  l4d2_ammochance_tinybox.AddChangeHook(OnBoxChanceChange);
}

public void OnBoxChanceChange(ConVar convar, const char[] oldValue, const char[] newValue) {
  g_l4d2_ammo_chance = g_l4d2_ammo_chance - StringToFloat(oldValue) + StringToFloat(newValue);
}

native int TYSTATS_GetPoints(int client);
native int TYSTATS_GetRank(int client);

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
  MarkNativeAsOptional("TYSTATS_GetPoints");
  MarkNativeAsOptional("TYSTATS_GetRank");
  return APLRes_Success;
}

public void OnAllPluginsLoaded()
{
  g_bPoints = GetFeatureStatus(FeatureType_Native, "TYSTATS_GetPoints") == FeatureStatus_Available;
  g_bRank = GetFeatureStatus(FeatureType_Native, "TYSTATS_GetRank") == FeatureStatus_Available;
}

public Action onCommandVocalize(int client, int args) {
  return Plugin_Handled;
}

public Action MapStart(Handle timer)
{
  OnMapStart();
}

public void OnMapStart()
{

  l4d2_z_difficulty = FindConVar("z_difficulty");
  char difficulty[12];
  l4d2_z_difficulty.GetString(difficulty, 12);

  if(!StrEqual(difficulty, "impossible")) {
    l4d2_z_difficulty.SetString("impossible");
  }

  PrecacheAllItems();
  
  if (FindConVar("l4d2_spawn_uncommons_version") == null)
  {
    l4d2_plugin_uncommons = false;
  }
  else
  {
    l4d2_plugin_uncommons = true;
  }
  
  if (FindConVar("sm_ar_doorlock_sec") == null)
  {
    l4d2_plugin_keyman = false;
  }
  else
  {
    l4d2_plugin_keyman = true;
  }
  
  return;
}

public void PrecacheAllItems()
{
  PrecacheSurvivors();
  PrecacheHealth();
  PrecacheMeleeWeapons();
  PrecacheWeapons();
  PrecacheThrowWeapons();
  PrecacheAmmoPacks();
  PrecacheMisc();
  PrecacheSounds();
  PrecacheOther();
  Precache_Particle();
}

public void CheckPrecacheModel(const char[] Model)
{
  if (!IsModelPrecached(Model))
  {
    PrecacheModel(Model);
  }
}

public void PrecacheSurvivors()
{
  CheckPrecacheModel("models/survivors/survivor_gambler.mdl");
  CheckPrecacheModel("models/survivors/survivor_manager.mdl");
  CheckPrecacheModel("models/survivors/survivor_coach.mdl");
  CheckPrecacheModel("models/survivors/survivor_producer.mdl");
  CheckPrecacheModel("models/survivors/survivor_teenangst.mdl");
  CheckPrecacheModel("models/survivors/survivor_biker.mdl");
  CheckPrecacheModel("models/survivors/survivor_namvet.mdl");
  CheckPrecacheModel("models/survivors/survivor_mechanic.mdl");
}

public void PrecacheHealth()
{
  CheckPrecacheModel("models/w_models/weapons/w_eq_Medkit.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_eq_defibrillator.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_eq_painpills.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_eq_adrenaline.mdl");
}

public void PrecacheMeleeWeapons()
{
  CheckPrecacheModel("models/weapons/melee/w_cricket_bat.mdl");
  CheckPrecacheModel("models/weapons/melee/w_crowbar.mdl");
  CheckPrecacheModel("models/weapons/melee/w_electric_guitar.mdl");
  CheckPrecacheModel("models/weapons/melee/w_chainsaw.mdl");
  CheckPrecacheModel("models/weapons/melee/w_katana.mdl");
  CheckPrecacheModel("models/weapons/melee/w_machete.mdl");
  CheckPrecacheModel("models/weapons/melee/w_tonfa.mdl");
  CheckPrecacheModel("models/weapons/melee/w_frying_pan.mdl");
  CheckPrecacheModel("models/weapons/melee/w_fireaxe.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_bat.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_knife_t.mdl");
  CheckPrecacheModel("models/weapons/melee/w_golfclub.mdl");
  //	CheckPrecacheModel("models/weapons/melee/w_riotshield.mdl");
}

public void PrecacheWeapons()
{
  CheckPrecacheModel("models/w_models/weapons/w_pistol_B.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_desert_eagle.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_smg_uzi.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_smg_a.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_shotgun.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_pumpshotgun_A.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_shotgun_spas.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_autoshot_m4super.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_sniper_military.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_sniper_mini14.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_rifle_m16a2.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_desert_rifle.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_rifle_ak47.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_m60.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_smg_mp5.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_sniper_scout.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_sniper_awp.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_rifle_sg552.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_grenade_launcher.mdl");
}

public void PrecacheThrowWeapons()
{
  CheckPrecacheModel("models/w_models/weapons/w_eq_pipebomb.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_eq_molotov.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_eq_bile_flask.mdl");
}

public void PrecacheAmmoPacks()
{
  CheckPrecacheModel("models/w_models/weapons/w_eq_explosive_ammopack.mdl");
  CheckPrecacheModel("models/w_models/weapons/w_eq_incendiary_ammopack.mdl");
}

public void PrecacheMisc()
{
  CheckPrecacheModel("models/props_junk/explosive_box001.mdl");
  CheckPrecacheModel("models/props_junk/gascan001a.mdl");
  CheckPrecacheModel("models/props_equipment/oxygentank01.mdl");
  CheckPrecacheModel("models/props_junk/propanecanister001a.mdl");
  CheckPrecacheModel("models/props_industrial/barrel_fuel.mdl");
  CheckPrecacheModel("models/props_industrial/barrel_fuel_partb.mdl");
  CheckPrecacheModel("models/props_industrial/barrel_fuel_parta.mdl");
}

public void PrecacheSounds()
{
  //	PrecacheSound("ambient/atmosphere/firewerks_launch_04.wav", true);
  PrecacheSound(SOUND_FREEZE, true);
  PrecacheSound(SOUND_DEFROST, true);
  PrecacheSound(SOUND_IMPACT01, true);
  PrecacheSound(SOUND_IMPACT02, true);
  PrecacheSound(SOUND_IMPACT03, true);
  PrecacheSound(SOUND_JAR, true);
  PrecacheSound(WITCH_SOUND, true);
  PrecacheSound(BRIDE_SOUND, true);
  PrecacheSound(TANK_SOUND, true);
  PrecacheSound(HEAL_SOUND, true);
  PrecacheSound(POINTS_SOUND, true);
  PrecacheSound(BLOOD_SOUND, true);
  PrecacheSound(LASER_SOUND, true);
  PrecacheSound(HARD_SOUND, true);
  PrecacheSound(BONUS_SOUND, true);
  PrecacheSound(MULTIPLE_SOUND, true);
  PrecacheSound(REALISM_SOUND, true);
  PrecacheSound(VOMIT_SOUND, true);
  PrecacheSound(EXPLOSION_SOUND, true);
  PrecacheSound(EXPLOSION_SOUND2, true);
  PrecacheSound(PANIC_SOUND, true);
  PrecacheSound(TINY_SOUND, true);
  PrecacheSound(ONEBADMAN, true);
  PrecacheSound(MIDNIGHTRIDE, true);
  PrecacheSound(BLAZEMUSIC, true);
  PrecacheSound(PUNCH_SOUND, true);
  PrecacheSound(LINGHNING2, true);
  PrecacheSound(BOOMER_SOUND, true);
  PrecacheSound(CHARGER_SOUND, true);
  PrecacheSound(HUNTER_SOUND, true);
  PrecacheSound(SPITTER_SOUND, true);
  PrecacheSound(JOCKEY_SOUND, true);
  PrecacheSound(SMOKER_SOUND, true);
  PrecacheSound(KNIFE_SOUND, true);
  PrecacheSound(ALARM_SOUND, true);
  PrecacheSound(EXPLODE_SOUND_3, true);
  PrecacheSound(EXPLODE_SOUND_4, true);
  PrecacheSound(EXPLODE_SOUND_5, true);


  PrecacheSound(JACKPOTBOX, true);

  precacheArraySounds(DeathBoxSounds, 5);
  precacheArraySounds(JackInTheBoxSounds, 5);
  precacheArraySounds(F18_Sounds, 6);
}


public void precacheArraySounds(char[][] list, int length) {
  for( int i = 0; i < length; i++ ) {
    PrecacheSound(list[i], true);
  }
}

public void PrecacheOther()
{
  if (!IsModelPrecached("models/infected/witch.mdl"))
  {
    PrecacheModel("models/infected/witch.mdl");
  }
  if (!IsModelPrecached("models/infected/witch_bride.mdl"))
  {
    PrecacheModel("models/infected/witch_bride.mdl");
  }
  PrecacheModel("models/f18/f18_sb.mdl", true);
  PrecacheModel("models/missiles/f18_agm65maverick.mdl", true);
  
  g_BeamSprite = PrecacheModel(SPRITE_BEAM);
  g_HaloSprite = PrecacheModel(SPRITE_HALO);
  //g_LightningSprite = PrecacheModel("materials/sprites/sprites/lgtning.vmt");
  g_SteamSprite = PrecacheModel("materials/sprites/steam1.vmt");
  g_ExplosionSprite = PrecacheModel("materials/sprites/sprite_fire01.vmt");
}

void Precache_Particle()
{
  PrecacheParticle(EXPLOSION_PARTICLE);
  PrecacheParticle(EXPLOSION_PARTICLE2);
  PrecacheParticle(EXPLOSION_PARTICLE3);
  PrecacheParticle(FIRESMALL_PARTICLE);
  PrecacheParticle(FIRESMALL_PARTICLE1);
  PrecacheParticle(FIRESMALL_PARTICLE2);
  PrecacheParticle("electrical_arc_01_system");
  PrecacheParticle(PARTICLE_CLOUD);
  PrecacheParticle("flame_blue");
  PrecacheParticle("fire_medium_01");
  PrecacheParticle("rpg_smoke");
  PrecacheParticle("fireworks_sparkshower_01e");
  PrecacheParticle("missile_hit1");
  PrecacheParticle("gas_explosion_main");
  PrecacheParticle("explosion_huge");
  PrecacheParticle("barrel_fly");
}

void PrecacheParticle(char[] ParticleName)
{
  int Particle = CreateEntityByName("info_particle_system");
  if (IsValidEntity(Particle) && IsValidEdict(Particle))
  {
    DispatchKeyValue(Particle, "effect_name", ParticleName);
    DispatchSpawn(Particle);
    ActivateEntity(Particle);
    AcceptEntityInput(Particle, "start");
    CreateTimer(0.3, timerRemovePrecacheParticle, Particle);
  }
}

public Action timerRemovePrecacheParticle(Handle timer, any Particle)
{
  if (Particle > 0 && IsValidEntity(Particle) && IsValidEdict(Particle))
  {
    AcceptEntityInput(Particle, "Kill");
  }
  return Plugin_Stop;
}

public Action onCommandPing(int client, int args)
{
  PrintToChat(client, "%t", "Ping (Current / Average):\nOutgouing: %d / %d | Incoming: %d / %d | Both: %d / %d", RoundToZero(GetClientLatency(client, NetFlow_Outgoing) * 1000.0), 
  RoundToZero(GetClientAvgLatency(client, NetFlow_Outgoing) * 1000.0), RoundToZero(GetClientLatency(client, NetFlow_Incoming) * 1000.0), RoundToZero(GetClientAvgLatency(client, NetFlow_Incoming) * 1000.0), 
  RoundToZero(GetClientLatency(client, NetFlow_Both) * 1000.0), RoundToZero(GetClientAvgLatency(client, NetFlow_Both) * 1000.0));
}

public Action onCommandSuicide(int client, int args)
{
  if (!IsValidClient(client))
  {
    return Plugin_Handled;
  }
  ForcePlayerSuicide(client);
  PrintHintText(client, "Command for Suicide");
  return Plugin_Continue;
}

public Action Command_KickFakeClients(int client, int args)
{
  if (args < 1)
  {
    ReplyToCommand(client, "[SM] Usage: sm_kickfakeclients (1 - spectators, 2 - survivors, 3 - infected)");
    return Plugin_Handled;
  }
  char arg[8];
  GetCmdArg(1, arg, sizeof(arg));
  KickFakeClients(StringToInt(arg));
  return Plugin_Continue;
}

public Action Command_KickExtraBots(int client, int args)
{
  int clients = 0;
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i))
    {
      if (GetClientTeam(i) == 2)
      {
        if (clients > 4)
        {
          if (IsFakeClient(i))
          {
            ServerKickClient(i);
          }
        }
        else
        {
          clients++;
        }
      }
    }
  }
  return Plugin_Continue;
}

public Action Command_KickTeam(int client, int args)
{
  if (args < 1)
  {
    ReplyToCommand(client, "[SM] Usage: sm_kickteam (1 - spectators, 2 - survivors, 3 - infected)");
    return Plugin_Handled;
  }
  char arg[8];
  GetCmdArg(1, arg, sizeof(arg));
  KickTeam(StringToInt(arg));
  
  return Plugin_Continue;
}

public Action Command_Veto(int client, int args)
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsValidEntity(i) && IsClientInGame(i) && !IsFakeClient(i))
    {
      FakeClientCommand(i, "Vote No");
    }
  }
  
  // LogAction(client, -1, "%N use the command sm_veto", client);
}

public Action Command_Pass(int client, int args)
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsValidEntity(i))
    {
      if(IsClientInGame(i))
      {
        if(!IsFakeClient(i))
        {
          FakeClientCommand(i, "Vote Yes");
        }
      }
    }
  }
}

public Action Command_Screen(int client, int args)
{
  if (!client)return Plugin_Handled;
  
  if (args != 5)
  {
    PrintToChat(client, "Incorrect usage! Usage: sm_screen R G B A duration, where R G B - color, A - alpha.");
    return Plugin_Handled;
  }
  
  char Arg1[8],
     Arg2[8],
     Arg3[8],
     Arg4[8],
     Arg5[8];
  
  GetCmdArg(1, Arg1, sizeof(Arg1));
  GetCmdArg(2, Arg2, sizeof(Arg2));
  GetCmdArg(3, Arg3, sizeof(Arg3));
  GetCmdArg(4, Arg4, sizeof(Arg4));
  GetCmdArg(5, Arg5, sizeof(Arg5));
  
  int R = StringToInt(Arg1);
  int G = StringToInt(Arg2);
  int B = StringToInt(Arg3);
  int A = StringToInt(Arg4);
  int D = StringToInt(Arg5);
  
  if (R < 0)
  {
    R = 0;
  }
  else if (R > 255)
  {
    R = 255;
  }

  if (G < 0)
  {
    G = 0;
  }
  else if (G > 255)
  {
    G = 255;
  }
  
  if (B < 0)
  {
    B = 0;
  }
  else if (B > 255)
  {
    B = 255;
  }
  
  if (A < 0)
  {
    A = 0;
  }
  else if (A > 255)
  {
    A = 255;
  }

  if (D < 5)
  {
    D = 5;
  }
  else if (D > 50)
  {
    D = 50;
  }
  
  ScreenFade(client, R, G, B, A, RoundToZero(D * 1000.0), 1);
  
  return Plugin_Handled;
}

// public Action Command_FreezeBox(int client, int args)
// {
// 	if (!client)
// 	{
// 		return Plugin_Handled;
// 	}
  
// 	float position[3];
// 	GetClientAbsOrigin(client, position);
// 	Blizzard(client, position);
  
// 	return Plugin_Handled;
// }

// public Action Command_Vomit(int client, int args)
// {
// 	if (!client)
// 	{
// 		return Plugin_Handled;
// 	}
  
// 	float position[3];
// 	GetClientAbsOrigin(client, position);
// 	Vomit(client, position);
  
// 	return Plugin_Handled;
// }

// public Action Command_Explode(int client, int args)
// {
// 	if (!client)
// 	{
// 		return Plugin_Handled;
// 	}
  
// 	float position[3];
// 	GetClientAbsOrigin(client, position);
// 	CreateExplosion(position);
  
// 	return Plugin_Handled;
// }

// public Action Command_GlowFire(int client, int args)
// {
// 	if (!client)
// 	{
// 		return Plugin_Handled;
// 	}
  
// 	if (args < 3)
// 	{
// 		ReplyToCommand(client, "[SM] Usage: sm_glowfire <seconds> <0|1> <#userid|name>");
// 		return Plugin_Handled;
// 	}
  
// 	char time[11];
// 	char parent[24];
// 	char player[65];
  
// 	GetCmdArg(1, time, sizeof(time));
// 	GetCmdArg(2, parent, sizeof(parent));
// 	GetCmdArg(3, player, sizeof(player));
  
// 	int target = FindTarget(client, player, true);
// 	if (target == -1)return Plugin_Handled;
  
// 	bool ParentOpt = true;
  
// 	if (StringToInt(parent))ParentOpt = true;
// 	else ParentOpt = false;
  
// 	int seconds = (StringToInt(time) > 30) ? 30 : StringToInt(time);
  
// 	/*if (seconds > 30)
// 	{
// 		seconds = 30;
// 	}*/
  
// 	CreateParticle(target, FIRESMALL_PARTICLE, ParentOpt, float(seconds));
  
// 	return Plugin_Continue;
// }

// public Action Command_Flying(int client, int args)
// {
// 	if (!client)
// 	{
// 		return Plugin_Handled;
// 	}
  
// 	if (args < 1)
// 	{
// 		ReplyToCommand(client, "[SM] Usage: sm_flying <#userid|name>");
// 		return Plugin_Handled;
// 	}
  
// 	char player[65];
// 	GetCmdArg(1, player, sizeof(player));
  
// 	int target = FindTarget(client, player, true);
// 	if (target == -1)return Plugin_Handled;
  
// 	if (!IsValidEntity(target) || !IsClientInGame(target) || !IsPlayerAlive(target))return Plugin_Handled;
// 	if (GetClientTeam(target) != 2)return Plugin_Handled;
  
// 	float position[3];
// 	GetClientAbsOrigin(target, position);
// 	float power = g_cvarPower * 1.0;
// 	float tpos[3];
// 	float traceVec[3];
// 	float resultingFling[3];
// 	float currentVelVec[3];
// 	MakeVectorFromPoints(position, tpos, traceVec); // draw a line from car to Survivor
// 	GetVectorAngles(traceVec, resultingFling); // get the angles of that line
  
// 	resultingFling[0] = Cosine(DegToRad(resultingFling[1])) * power; // use trigonometric magic
// 	resultingFling[1] = Sine(DegToRad(resultingFling[1])) * power;
// 	resultingFling[2] = power;
  
// 	GetEntPropVector(target, Prop_Data, "m_vecVelocity", currentVelVec); // add whatever the Survivor had before
// 	resultingFling[0] += currentVelVec[0];
// 	resultingFling[1] += currentVelVec[1];
// 	resultingFling[2] += currentVelVec[2];
  
// 	FlingPlayer(target, resultingFling, client);
  
// 	return Plugin_Continue;
// }

// public Action Command_Heal(int client, int args)
// {
// 	if (!client)return Plugin_Handled;
  
// 	float position[3];
// 	GetClientAbsOrigin(client, position);
// 	HealBox(client, true, position);
// 	// LogAction(client, -1, "\"%L\" использовал команду sm_healbox", client);
  
// 	return Plugin_Handled;
// }

// public Action Command_Barrel(int client, int args)
// {
// 	if (!client)return Plugin_Handled;
  
// 	StartBarrel(client);
// 	// LogAction(client, -1, "\"%L\" использовал команду sm_barrelbox", client);
  
// 	return Plugin_Handled;
// }

// public Action Command_Airstrike(int client, int args)
// {
// 	if (!client)return Plugin_Handled;
  
// 	StartAirstrike(client);
// 	// LogAction(client, -1, "\"%L\" использовал команду sm_airstrikebox", client);
  
// 	return Plugin_Handled;
// }

// public Action Command_Lightningbox(int client, int args)
// {
// 	if (!client)
// 	{
// 		return Plugin_Handled;
// 	}
// 	if (GetClientTeam(client) != 2)
// 	{
// 		return Plugin_Handled;
// 	}
// 	if (!IsPlayerAlive(client))
// 	{
// 		return Plugin_Handled;
// 	}
  
// 	Lightning(client);
// 	// LogAction(client, -1, "\"%L\" использовал команду sm_lightningbox", client);
  
// 	return Plugin_Handled;
// }

// public Action Command_Meteor(int client, int args)
// {
// 	if (!client)return Plugin_Handled;
  
// 	StartMeteorFall(client);
// 	// LogAction(client, -1, "\"%L\" использовал команду sm_meteorbox", client);
  
// 	return Plugin_Handled;
// }

public Action Command_SpawnItem(int client, int args)
{
  if (args < 8)
  {
    ReplyToCommand(client, "[SM] Usage: sm_spawnitem <parameters>");
    return Plugin_Handled;
  }
  
  float VecDirection[3];
  float VecOrigin[3];
  float VecAngles[3];
  char modelname[64];
  GetCmdArg(1, modelname, sizeof(modelname));
  
  char TempString[20];
  GetCmdArg(2, TempString, sizeof(TempString));
  VecDirection[0] = StringToFloat(TempString);
  GetCmdArg(3, TempString, sizeof(TempString));
  VecDirection[1] = StringToFloat(TempString);
  GetCmdArg(4, TempString, sizeof(TempString));
  VecDirection[2] = StringToFloat(TempString);
  GetCmdArg(5, TempString, sizeof(TempString));
  VecOrigin[0] = StringToFloat(TempString);
  GetCmdArg(6, TempString, sizeof(TempString));
  VecOrigin[1] = StringToFloat(TempString);
  GetCmdArg(7, TempString, sizeof(TempString));
  VecOrigin[2] = StringToFloat(TempString);
  GetCmdArg(8, TempString, sizeof(TempString));
  VecAngles[0] = 0.0;
  VecAngles[1] = StringToFloat(TempString);
  VecAngles[2] = 0.0;
  
  int spawned_item = CreateEntityByName(modelname);
  
  DispatchKeyValue(spawned_item, "model", "Custom_Spawn");
  DispatchKeyValueFloat(spawned_item, "MaxPitch", 360.00);
  DispatchKeyValueFloat(spawned_item, "MinPitch", -360.00);
  DispatchKeyValueFloat(spawned_item, "MaxYaw", 90.00);
  DispatchSpawn(spawned_item);
  
  DispatchKeyValueVector(spawned_item, "Angles", VecAngles);
  DispatchSpawn(spawned_item);
  TeleportEntity(spawned_item, VecOrigin, NULL_VECTOR, NULL_VECTOR);
  //SetEntityMoveType(spawned_item, MOVETYPE_NONE);
  
  return Plugin_Continue;
}

public Action Command_SpawnItemNew(int client, int args)
{
  if (args < 7)
  {
    ReplyToCommand(client, "[SM] Usage: sm_spawnitemnew <parameters>");
    return Plugin_Handled;
  }
  
  float vPos[3];
  float vAng[3];
  char modelname[64];
  GetCmdArg(1, modelname, sizeof(modelname));
  
  char TempString[20];
  GetCmdArg(2, TempString, sizeof(TempString));
  vPos[0] = StringToFloat(TempString);
  GetCmdArg(3, TempString, sizeof(TempString));
  vPos[1] = StringToFloat(TempString);
  GetCmdArg(4, TempString, sizeof(TempString));
  vPos[2] = StringToFloat(TempString);
  GetCmdArg(5, TempString, sizeof(TempString));
  vAng[0] = StringToFloat(TempString);
  GetCmdArg(6, TempString, sizeof(TempString));
  vAng[1] = StringToFloat(TempString);
  GetCmdArg(7, TempString, sizeof(TempString));
  vAng[2] = StringToFloat(TempString);
  
  int spawned_item = CreateEntityByName(modelname);
  
  DispatchKeyValue(spawned_item, "solid", "6");
  DispatchKeyValue(spawned_item, "rendermode", "3");
  DispatchKeyValue(spawned_item, "disableshadows", "1");
  
  DispatchKeyValue(spawned_item, "model", "Custom_Spawn");
  DispatchKeyValueFloat(spawned_item, "MaxPitch", 360.00);
  DispatchKeyValueFloat(spawned_item, "MinPitch", -360.00);
  DispatchKeyValueFloat(spawned_item, "MaxYaw", 90.00);
  DispatchSpawn(spawned_item);
  
  if (StrContains(modelname, "first_aid_kit", true) > -1) // First aid
  {
    vAng[0] += 90.0;
    vPos[2] += 1.0;
  }
  else if (StrContains(modelname, "adrenaline", true) > -1) // Adrenaline
  {
    vAng[1] -= 90.0;
    vAng[2] -= 90.0;
    vPos[2] += 1.0;
  }
  else if (StrContains(modelname, "defibrillator", true) > -1 || StrContains(modelname, "upgradepack", true) > -1) // Defib + Upgrades
  {
    vAng[1] -= 90.0;
    vAng[2] += 90.0;
  }
  else if (StrContains(modelname, "chainsaw", true) > -1) // Chainsaw
  {
    vPos[2] += 3.0;
  }
  
  TeleportEntity(spawned_item, vPos, vAng, NULL_VECTOR);
  DispatchSpawn(spawned_item);
  
  int ammo;
  
  if (StrContains(modelname, "weapon_smg", true) > -1)
  {
    ammo = g_hAmmoSmg.IntValue;
    SetEntProp(spawned_item, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(modelname, "weapon_rifle", true) > -1)
  {
    if (StrContains(modelname, "weapon_rifle_m60", true) > -1)ammo = 250;
    else ammo = g_hAmmoRifle.IntValue;
    SetEntProp(spawned_item, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(modelname, "weapon_pumpshotgun", true) > -1 || StrContains(modelname, "weapon_shotgun_chrome", true) > -1)
  {
    ammo = g_hAmmoShotgun.IntValue;
    SetEntProp(spawned_item, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(modelname, "weapon_autoshotgun", true) > -1 || StrContains(modelname, "weapon_shotgun_spas", true) > -1)
  {
    ammo = g_hAmmoAutoShot.IntValue;
    SetEntProp(spawned_item, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(modelname, "weapon_hunting_rifle", true) > -1)
  {
    ammo = g_hAmmoHunting.IntValue;
    SetEntProp(spawned_item, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(modelname, "chainsaw", true) > -1)
  {
    ammo = g_hAmmoChainsaw.IntValue;
    SetEntProp(spawned_item, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(modelname, "weapon_grenade_launcher", true) > -1)
  {
    //ammo = "ammo_grenadelauncher_max".IntValue;
    ammo = 1;
    SetEntProp(spawned_item, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(modelname, "weapon_sniper", true) > -1)
  {
    ammo = g_hAmmoSniper.IntValue;
    SetEntProp(spawned_item, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  
  SetEntityMoveType(spawned_item, MOVETYPE_NONE);
  
  return Plugin_Continue;
}

float g_Vpos[3];

public Action Command_SpawnNewItem(int client, int args)
{
  float VecAngles[3];
  float VecDirection[3];
  
  char text[192];
  
  if (!GetCmdArgString(text, sizeof(text)))return Plugin_Continue;
  
  if (!SetTeleportEndPoint(client))
  {
    ReplyToCommand(client, "[SM] SpawnError");
    return Plugin_Continue;
  }
  
  int startidx = 0;
  
  if (text[strlen(text) - 1] == '"')
  {
    text[strlen(text) - 1] = '\0';
    startidx = 1;
  }
  
  int NewItem = CreateEntityByName(text[startidx]);
  
  if (NewItem == -1 || NewItem == 0)ReplyToCommand(client, "[SM] Spawn Failed: %s", text[startidx]);
  
  DispatchKeyValue(NewItem, "model", "newitem");
  DispatchKeyValueFloat(NewItem, "MaxPitch", 360.00);
  DispatchKeyValueFloat(NewItem, "MinPitch", -360.00);
  DispatchKeyValueFloat(NewItem, "MaxYaw", 90.00);
  DispatchSpawn(NewItem);
  
  GetClientEyeAngles(client, VecAngles);
  GetAngleVectors(VecAngles, VecDirection, NULL_VECTOR, NULL_VECTOR);
  g_Vpos[2] -= 8.0;
  VecAngles[0] = 0.0;
  VecAngles[2] = 0.0;
  
  PrintToChat(client, "\x03sm_spawnitem %s %f %f %f %f %f %f %f", text[startidx], VecDirection[0], VecDirection[1], VecDirection[2], g_Vpos[0], g_Vpos[1], g_Vpos[2], VecAngles[1]);
  
  DispatchKeyValueVector(NewItem, "Angles", VecAngles);
  DispatchSpawn(NewItem);
  TeleportEntity(NewItem, g_Vpos, NULL_VECTOR, NULL_VECTOR);
  
  // LogAction(client, -1, "\"%L\" заспавнил предмет <%s>", client, text[startidx]);
  
  return Plugin_Continue;
}

public Action Command_SpawnNewItemNew(int client, int args)
{
  float vPos[3];
  float vAng[3];
  
  char text[192];
  
  if (!GetCmdArgString(text, sizeof(text)))return Plugin_Continue;
  
  if (!SetTeleportEndPointNew(client, vPos, vAng))
  {
    ReplyToCommand(client, "[SM] SpawnError");
    return Plugin_Continue;
  }
  
  int startidx = 0;
  
  if (text[strlen(text) - 1] == '"')
  {
    text[strlen(text) - 1] = '\0';
    startidx = 1;
  }
  
  int NewItem = CreateEntityByName(text[startidx]);
  
  if (NewItem == -1 || NewItem == 0) 
  {
    ReplyToCommand(client, "[SM] Spawn Failed: %s", text[startidx]);
  }
  
  DispatchKeyValue(NewItem, "solid", "6");
  DispatchKeyValue(NewItem, "rendermode", "3");
  DispatchKeyValue(NewItem, "disableshadows", "1");
  
  DispatchKeyValue(NewItem, "model", "newitem");
  DispatchKeyValueFloat(NewItem, "MaxPitch", 360.00);
  DispatchKeyValueFloat(NewItem, "MinPitch", -360.00);
  DispatchKeyValueFloat(NewItem, "MaxYaw", 90.00);
  DispatchSpawn(NewItem);
  
  if (StrContains(text[startidx], "first_aid_kit", true) > -1) // First aid
  {
    vAng[0] += 90.0;
    vPos[2] += 1.0;
  }
  else if (StrContains(text[startidx], "adrenaline", true) > -1) // Adrenaline
  {
    vAng[1] -= 90.0;
    vAng[2] -= 90.0;
    vPos[2] += 1.0;
  }
  else if (StrContains(text[startidx], "defibrillator", true) > -1 || StrContains(text[startidx], "upgradepack", true) > -1) // Defib + Upgrades
  {
    vAng[1] -= 90.0;
    vAng[2] += 90.0;
  }
  else if (StrContains(text[startidx], "chainsaw", true) > -1) // Chainsaw
  {
    vPos[2] += 3.0;
  }
  
  PrintToChat(client, "\x03sm_spawnitemnew %s %f %f %f %f %f %f", text[startidx], vPos[0], vPos[1], vPos[2], vAng[0], vAng[1], vAng[2]);
  
  TeleportEntity(NewItem, vPos, vAng, NULL_VECTOR);
  DispatchSpawn(NewItem);
  
  int ammo;
  
  if (StrContains(text[startidx], "weapon_smg", true) > -1)
  {
    ammo = g_hAmmoSmg.IntValue;
    SetEntProp(NewItem, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(text[startidx], "weapon_rifle", true) > -1)
  {
    if (StrContains(text[startidx], "weapon_rifle_m60", true) > -1)
    {
      ammo = 250;
    }
    else
    {
      ammo = g_hAmmoRifle.IntValue;
    }
    SetEntProp(NewItem, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(text[startidx], "weapon_pumpshotgun", true) > -1 || StrContains(text[startidx], "weapon_shotgun_chrome", true) > -1)
  {
    ammo = g_hAmmoShotgun.IntValue;
    SetEntProp(NewItem, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(text[startidx], "weapon_autoshotgun", true) > -1 || StrContains(text[startidx], "weapon_shotgun_spas", true) > -1)
  {
    ammo = g_hAmmoAutoShot.IntValue;
    SetEntProp(NewItem, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(text[startidx], "weapon_hunting_rifle", true) > -1)
  {
    ammo = g_hAmmoHunting.IntValue;
    SetEntProp(NewItem, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(text[startidx], "chainsaw", true) > -1)
  {
    ammo = g_hAmmoChainsaw.IntValue;
    SetEntProp(NewItem, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(text[startidx], "weapon_grenade_launcher", true) > -1)
  {
    //ammo = "ammo_grenadelauncher_max".IntValue;
    ammo = 1;
    SetEntProp(NewItem, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  else if (StrContains(text[startidx], "weapon_sniper", true) > -1)
  {
    ammo = g_hAmmoSniper.IntValue;
    SetEntProp(NewItem, Prop_Send, "m_iExtraPrimaryAmmo", ammo, 4);
  }
  
  SetEntityMoveType(NewItem, MOVETYPE_NONE);
  
  // LogAction(client, -1, "\"%L\" заспавнил предмет <%s>", client, text[startidx]);
  
  return Plugin_Continue;
}

bool SetTeleportEndPoint(int client)
{
  float vAngles[3];
  float vOrigin[3];
  float vBuffer[3];
  float vStart[3];
  float Distance;
  
  GetClientEyePosition(client, vOrigin);
  GetClientEyeAngles(client, vAngles);
  
  Handle g_trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, Player_TraceFilter);
  
  if (TR_DidHit(g_trace))
  {
    TR_GetEndPosition(vStart, g_trace);
    GetVectorDistance(vOrigin, vStart, false);
    Distance = -35.0;
    GetAngleVectors(vAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
    g_Vpos[0] = vStart[0] + (vBuffer[0] * Distance);
    g_Vpos[1] = vStart[1] + (vBuffer[1] * Distance);
    g_Vpos[2] = vStart[2] + (vBuffer[2] * Distance);
  }
  else
  {
    g_trace.Close();
    return false;
  }
  g_trace.Close();
  return true;
}

bool SetTeleportEndPointNew(int client, float vPos[3], float vAng[3])
{
  GetClientEyePosition(client, vPos);
  GetClientEyeAngles(client, vAng);
  
  Handle h_trace = TR_TraceRayFilterEx(vPos, vAng, MASK_SHOT, RayType_Infinite, Player_TraceFilter);
  
  if (TR_DidHit(h_trace))
  {
    float vNorm[3];
    float degrees = vAng[1];
    TR_GetEndPosition(vPos, h_trace);
    GetGroundHeight(vPos);
    vPos[2] += 1.0;
    TR_GetPlaneNormal(h_trace, vNorm);
    GetVectorAngles(vNorm, vAng);
    if (vNorm[2] == 1.0)
    {
      vAng[0] = 0.0;
      vAng[1] = degrees + 180;
    }
    else
    {
      if (degrees > vAng[1])
      {
        degrees = vAng[1] - degrees;
      }
      else
      {
        degrees = degrees - vAng[1];
      }
      vAng[0] += 90.0;
      RotateYaw(vAng, degrees + 180);
    }
  }
  else
  {
    h_trace.Close();
    return false;
  }
  h_trace.Close();
  
  vAng[1] += 90.0;
  vAng[2] -= 90.0;
  return true;
}

float GetAngleBetweenVectors(const float vector1[3], const float vector2[3], const float direction[3])
{
  float vector1_n[3];
  float vector2_n[3];
  float direction_n[3];
  float cross[3];
  NormalizeVector(direction, direction_n);
  NormalizeVector(vector1, vector1_n);
  NormalizeVector(vector2, vector2_n);
  float degree = ArcCosine(GetVectorDotProduct(vector1_n, vector2_n)) * 57.29577951; // 180/Pi
  GetVectorCrossProduct(vector1_n, vector2_n, cross);
  
  if (GetVectorDotProduct(cross, direction_n) < 0.0)
  {
    degree *= -1.0;
  }
  
  return degree;
}

float GetGroundHeight(float vPos[3])
{
  float vAng[3];
  float vTmp[3];
  vTmp[0] = 90.0;
  vTmp[1] = 0.0;
  vTmp[2] = 0.0;
  
  Handle trace = TR_TraceRayFilterEx(vPos, vTmp, MASK_ALL, RayType_Infinite, TraceFilter);
  if (TR_DidHit(trace))
  {
    TR_GetEndPosition(vAng, trace);
  }
  
  trace.Close();
  return vAng[2];
}

void RotateYaw(float angles[3], float degree)
{
  float direction[3];
  float normal[3];
  GetAngleVectors(angles, direction, NULL_VECTOR, normal);
  
  float sin = Sine(degree * 0.01745328); // Pi/180
  float cos = Cosine(degree * 0.01745328);
  float a = normal[0] * sin;
  float b = normal[1] * sin;
  float c = normal[2] * sin;
  float x = direction[2] * b + direction[0] * cos - direction[1] * c;
  float y = direction[0] * c + direction[1] * cos - direction[2] * a;
  float z = direction[1] * a + direction[2] * cos - direction[0] * b;
  direction[0] = x;
  direction[1] = y;
  direction[2] = z;
  
  GetVectorAngles(direction, angles);
  
  float up[3];
  GetVectorVectors(direction, NULL_VECTOR, up);
  
  float roll = GetAngleBetweenVectors(up, normal, direction);
  angles[2] += roll;
}

public Action Command_SpawnNewItemOld(int client, int args)
{
  if (!client)
  {
    return Plugin_Continue;
  }
  
  float VecOrigin[3];
  float VecAngles[3];
  float VecDirection[3];
  
  char text[192];
  
  if (!GetCmdArgString(text, sizeof(text)))
  {
    return Plugin_Continue;
  }
  
  int startidx = 0;
  
  if (text[strlen(text) - 1] == '"')
  {
    text[strlen(text) - 1] = '\0';
    startidx = 1;
  }
  
  int NewItem = CreateEntityByName(text[startidx]);
  
  if (NewItem == -1 || NewItem == 0)
  {
    ReplyToCommand(client, "[SM] Spawn Failed: %s", text[startidx]);
  }
  
  DispatchKeyValue(NewItem, "model", "newitem");
  DispatchKeyValueFloat(NewItem, "MaxPitch", 360.00);
  DispatchKeyValueFloat(NewItem, "MinPitch", -360.00);
  DispatchKeyValueFloat(NewItem, "MaxYaw", 90.00);
  DispatchSpawn(NewItem);
  
  GetClientAbsOrigin(client, VecOrigin);
  GetClientEyeAngles(client, VecAngles);
  GetAngleVectors(VecAngles, VecDirection, NULL_VECTOR, NULL_VECTOR);
  VecOrigin[0] += VecDirection[0] * 32;
  VecOrigin[1] += VecDirection[1] * 32;
  VecOrigin[2] += VecDirection[2] * 1;
  VecAngles[0] = 0.0;
  VecAngles[2] = 0.0;
  
  PrintToChat(client, "\x03sm_spawnitem %s %f %f %f %f %f %f %f", text[startidx], VecDirection[0], VecDirection[1], VecDirection[2], VecOrigin[0], VecOrigin[1], VecOrigin[2], VecAngles[1]);
  
  DispatchKeyValueVector(NewItem, "Angles", VecAngles);
  DispatchSpawn(NewItem);
  TeleportEntity(NewItem, VecOrigin, NULL_VECTOR, NULL_VECTOR);
  
  return Plugin_Continue;
}

// public Action Command_Fire(int client, int args)
// {
// 	if (!client)
// 	{
// 		return Plugin_Handled;
// 	}
  
// 	float position[3];
// 	GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);
// 	FireRndm(position);
  
// 	return Plugin_Handled;
// }

// public Action Command_Boom(int client, int args)
// {
// 	if (!client)
// 	{
// 		return Plugin_Handled;
// 	}
  
// 	float position[3];
// 	GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);
// 	Boom(position);
  
// 	return Plugin_Handled;
// }

public Action Command_SpasAll(int client, int args)
{
  if((GetTime() - UpTime) > 1800 || ClientsCount <= 12)
  {
    for (int i = 1; i <= MaxClients; i++)
    {
      if (IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i))
      {
        CheatCMD(i, "give", "health");
        SetEntProp(i, Prop_Send, "m_iHealth", 100, 1);
        SetEntProp(i, Prop_Send, "m_isGoingToDie", 0);
        SetEntProp(i, Prop_Send, "m_currentReviveCount", 0);
        CleanAura(i);
        CheatCMD(i, "give", "shotgun_spas");
        CheatCMD(i, "give", "crowbar");
        CheatCMD(i, "give", "pipe_bomb");
        CheatCMD(i, "give", "first_aid_kit");
        CheatCMD(i, "give", "pain_pills");
      }
    }
  }
}

public Action Command_Null(int client, int args)
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i))
    {
      SetNullWeapon(i);
      CheatCMD(i, "give", "health");
      SetEntProp(i, Prop_Send, "m_iHealth", 100, 1);
      SetEntProp(i, Prop_Send, "m_isGoingToDie", 0);
      SetEntProp(i, Prop_Send, "m_currentReviveCount", 0);
      CleanAura(i);
      CheatCMD(i, "give", "pistol");
    }
  }
}

public Action Command_Melee(int client, int args)
{
  if (!client || !IsClientInGame(client) || !IsPlayerAlive(client))return Plugin_Handled;
  
  static char g_Melees[11][] =  { "fireaxe", "crowbar", "cricket_bat", "katana", "baseball_bat", "knife", "electric_guitar", "frying_pan", "machete", "golfclub", "tonfa" };
  
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i))
    {
      int Random;
      Random = GetRandomInt(0, (sizeof(g_Melees) - 1));
      
      //SetNullWeapon(i);
      CheatCMD(i, "give", "health");
      SetEntProp(i, Prop_Send, "m_iHealth", 100, 1);
      SetEntProp(i, Prop_Send, "m_isGoingToDie", 0);
      SetEntProp(i, Prop_Send, "m_currentReviveCount", 0);
      CleanAura(i);
      CheatCMD(i, "give", g_Melees[Random]);
      CheatCMD(i, "give", "pipe_bomb");
      CheatCMD(i, "give", "first_aid_kit");
      CheatCMD(i, "give", "adrenaline");
    }
  }
  return Plugin_Handled;
}

public Action Command_Cmd(int client, int args)
{
  if (args < 1)
  {
    ReplyToCommand(client, "[SM] Usage: sm_cmd <command> <parameter>");
    return Plugin_Handled;
  }
  
  char command_text[192];
  GetCmdArg(1, command_text, sizeof(command_text));
  
  if (args > 1)
  {
    char parameters_text[192];
    parameters_text = "";
    char temp_text[40];
    for (int i = 2; i <= args; i++)
    {
      GetCmdArg(i, temp_text, sizeof(temp_text));
      StrCat(parameters_text, sizeof(parameters_text), temp_text);
    }
    
    CheatCommand(client, command_text, parameters_text);
    return Plugin_Continue;
  }
  
  CheatCommand(client, command_text, "");
  return Plugin_Continue;
  
}

public void CheatCommand(int client, char[] Command, char[] Parameters)
{
  if (!client)client = GetAnyClient();
  
  if (!client)
  {
    int bot = CreateFakeClient("z_modbot");
    if (bot > 0)
    {
      CheatCMD(bot, Command, Parameters);
      CreateTimer(0.1, Kickbot, bot);
    }
    return;
  }
  
  if (!client)
  {
    ServerCommand("%s %s", Command, Parameters);
  }
  else
  {
    CheatCMD(client, Command, Parameters);
  }
}

public Action Command_CmdAll(int client, int args)
{
  if (args < 2)
  {
    ReplyToCommand(client, "[SM] Usage: sm_cmdall <command> <parameter>");
    return;
  }
  
  char cmd[256];
  char arg[256];
  GetCmdArg(1, cmd, sizeof(cmd));
  GetCmdArg(2, arg, sizeof(arg));
  
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i) && !IsFakeClient(i))CheatCMD(i, cmd, arg);
  }
}

public Action Command_CheatCmdPlayer(int client, int args)
{
  if (args < 2)
  {
    ReplyToCommand(client, "[SM] Usage: sm_cmdclient <#userid|name> <cmd>");
    return Plugin_Handled;
  }
  
  char arg[65];
  char cmd[192];
  GetCmdArg(1, arg, sizeof(arg));
  GetCmdArg(2, cmd, sizeof(cmd));
  
  char target_name[MAX_TARGET_LENGTH];
  int target_list[MAXPLAYERS];
  int target_count;
  bool tn_is_ml;
  
  if ((target_count = ProcessTargetString(arg, client, target_list, MAXPLAYERS, 0, target_name, sizeof(target_name), tn_is_ml)) <= 0)
  {
    ReplyToTargetError(client, target_count);
    return Plugin_Handled;
  }
  
  for (int i = 0; i < target_count; i++)
  {
    PerformFakeExec(target_list[i], cmd);
  }
  
  return Plugin_Handled;
}

void PerformFakeExec(int target, const char[] cmd)
{
  FakeClientCommandEx(target, cmd);
  // LogAction(client, target, "\"%L\" executed command %s on \"%L\".", client, cmd, target);
}

int SetNullWeapon(int client)
{
  if (!client)
  {
    return 0;
  }
  
  for (int i = 0; i < 5; i++)
  {
    if (GetPlayerWeaponSlot(client, i) > -1)RemovePlayerItem(client, GetPlayerWeaponSlot(client, i));
  }
  
  SetEntProp(client, Prop_Send, "m_iHealth", 100);
  SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
  SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
  
  return 0;
}


public void OnClientPutInServer(int client)
{
  if (!IsFakeClient(client))
  {
    CleanAura(client);
  }
  
  ClientsCount = GetClientCount(false);
  
  int survivors = 0;
  int realsurvivors = 0;
  int infected = 0;
  int spec = 0;
  int realspec = 0;
  int fake = 0;
  int connected = 0;
  
  if (ClientsCount > 30)
  {
    for (int i = 1; i <= MaxClients; i++)
    {
      if (IsClientConnected(i))
      {
        if (IsClientInGame(i))
        {
          int team = GetClientTeam(i);
          if (team == 1)
          {
            if (!IsFakeClient(i))
            {
              realspec++;
            }
            spec++;
          }
          else if (team == 2)
          {
            if (!IsFakeClient(i))
            {
              realsurvivors++;
            }
            survivors++;
          }
          else if (team == 3)
          {
            infected++;
          }
          else
          {
            fake++;
          }
        }
        else
        {
          connected++;
        }
      }
    }
    
    if (ClientsCount == 31)
    {
      KickFakeClients(1);
      KickFakeClients(2);
    }
    else if (ClientsCount > 31)
    {
      //LogError("hardmod/OnClientPutInServer()/Warning!Clients count %i(spec:%i/rspec:%i/surv:%i/rsurv:%i/inf:%i/fake:%i/connect:%i", ClientsCount, spec, realspec, survivors, realsurvivors, infected, fake, connected);
      KickFakeClients(1);
      KickFakeClients(2);
      CreateTimer(0.1, CycleKickRandomInfected, client);
    }
  }
}

public Action CycleKickRandomInfected(Handle timer, any client)
{
  int target = GetRandomClient(true, true, 3);
  if (target > 0)
  {
    if (iGetZombieClass(target) == ZC_TANK)
    {
      CreateTimer(0.1, CycleKickRandomInfected, client);
      return;
    }
    else
    {
      ServerKickClient(target);
    }
  }
}

public Action onEventDifficultyChange(Event event, const char[] name, bool dontBroadcast) {
  char current_difficulty[32];
  event.GetString("newDifficulty", current_difficulty, 32);
  if(!StrEqual(current_difficulty, "impossible")) {
    return Plugin_Handled;
  }
  return Plugin_Continue;
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
  g_bAirstrike = false;
  g_bBarrelRain = false;
  g_bMeterRain = false;
  g_bIsBloodBox = false;
  g_bIsRealismBox = false;
  g_bIsTinyBox = false;
  g_iHardLevel = 0;
  g_iMeteorTick = 0;
  
  CreateTimer(5.0, Timercleancoloring, _);
  
  g_cvarIsBloodBox.SetInt(0, false, false);
  g_cvarIsHardBox.SetInt(0, false, false);
  g_cvarIsMapFinished.SetInt(0, false, false);
  
  return Plugin_Continue;
}

public Action Timercleancoloring(Handle timer)
{
  FuncCleanAura();
  KillAllFreezes();
  
  return Plugin_Stop;
}

public void FuncCleanAura()
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i))
    {
      if (GetClientTeam(i) == 2)
      {
        CleanAura(i);
      }
    }
  }
}

public void RestoreBW()
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i))
    {
      if (GetClientTeam(i) == 2 && IsPlayerAlive(i))
      {
        if (IsGoingToDie(i))BWaura(i);
      }
    }
  }
}

bool IsGoingToDie(int client)
{
  if (GetEntProp(client, Prop_Send, "m_currentReviveCount") == FindConVar("survivor_max_incapacitated_count").IntValue)
  {
    return true;
  }
  return false;
}

int GetAnyClient()
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientConnected(i))return i;
  }
  return 0;
}

public Action Kickbot(Handle timer, any client)
{
  if (IsClientInGame(client))
  {
    if (IsFakeClient(client))
    {
      KickClient(client, "Supercoop: kicking Fake Client");
    }
  }
  return Plugin_Stop;
}

void CheatCMD(int client, char[] command, char[] arguments = "")
{
  if (client)
  {
    int flags = GetCommandFlags(command);
    SetCommandFlags(command, flags & ~FCVAR_CHEAT);
    FakeClientCommand(client, "%s %s", command, arguments);
    SetCommandFlags(command, flags);
  }
}

bool IsIncapacitated(int client)
{
  if (GetEntProp(client, Prop_Send, "m_isIncapacitated", 1))
  {
    return true;
  }
  return false;
}

public Action onCommandInfo(int client, int args)
{
  if (client == 0)
  {
    onCommandServerInfo(client, 0);
    return Plugin_Continue;
  }
  if (LastInfoTIME[client] + 1 >= GetTime())
  {
    LastInfoTIME[client] = GetTime();
    onCommandServerInfo(client, 0);
    return Plugin_Continue;
  }
  LastInfoTIME[client] = GetTime();
  
  int Target;
  
  if (args > 0)
  {
    char temp_text[40];
    GetCmdArg(1, temp_text, sizeof(temp_text));
    if (StrEqual(temp_text, "@me", false))Target = client;
    else
    {
      int Player;
      char Name[32];
      
      Player = -1;
      
      for (int i = 1; i <= MaxClients; i++)
      {
        if (!IsClientInGame(i))continue;
        
        GetClientName(i, Name, sizeof(Name));
        if (StrContains(Name, temp_text, false) != -1)Player = i;
      }
      
      if (Player != -1)Target = Player;
    }
  }
  else
  {
    if (!Target)
    {
      Target = GetClientAimTarget(client, false);
    }
    
    if (Target == -1)
    {
      FakeClientCommand(client, "say /info2");
      return Plugin_Continue;
    }
    
    if (IsValidClient(Target) && IsClientInGame(Target) && GetClientTeam(Target) == 3)
    {
      switch (iGetZombieClass(Target))
      {
        case ZC_SMOKER: CPrintToChat(client, "%t", "Smoker health: %d", GetClientHealth(Target));
        case ZC_BOOMER: CPrintToChat(client, "%t", "Boomer health: %d", GetClientHealth(Target));
        case ZC_JOCKEY: CPrintToChat(client, "%t", "Jockey health: %d", GetClientHealth(Target));
        case ZC_HUNTER: CPrintToChat(client, "%t", "Hunter health: %d", GetClientHealth(Target));
        case ZC_SPITTER: CPrintToChat(client, "%t", "Spitter health: %d", GetClientHealth(Target));
        case ZC_CHARGER: CPrintToChat(client, "%t", "Charger health: %d", GetClientHealth(Target));
        case ZC_TANK: CPrintToChat(client, "%t", "Tank health: %d", GetClientHealth(Target));
      }
      return Plugin_Continue;
    }
  }
  
  if (IsValidClient(Target))
  {
    char Message[256];
    char line_user_admin[10];
    
    if(CheckCommandAccess(Target, "sm_fk", ADMFLAG_KICK, true))
    {
      line_user_admin = "Admin";
    }
    else if(CheckCommandAccess(Target, "sm_fk", ADMFLAG_GENERIC, true))
    {
      line_user_admin = "Moderator";
    }
    else
    {
      line_user_admin = "player";
    } 

    CPrintToChat(client, "%t", "Name: %N | Status: %s", Target, line_user_admin);
    
    if (g_bPoints && g_bRank)
    {
      Format(Message, sizeof(Message), "%t", "Rank: %d | Points: %d", TYSTATS_GetRank(Target), TYSTATS_GetPoints(Target));
    }

    CPrintToChat(client, "%s", Message);
    
    Format(Message, sizeof(Message), "%t", "Health: %d", GetClientHealthTotal(Target));
    CPrintToChat(client, "%s", Message);
  
    if(CheckCommandAccess(client, "sm_fk", ADMFLAG_GENERIC, true))
    {
      char steamId[32];
      GetClientAuthId(client, AuthId_Steam2, steamId, sizeof(steamId));
      Format(Message, sizeof(Message), "\x01| \x05ID: \x04%s", steamId);
      CPrintToChat(client, "%s", Message);
    }
  }
  return Plugin_Continue;
}

public int iGetZombieClass(int client)
{
  if (!IsValidEntity(client) || !IsValidEdict(client))
  {
    return 0;
  }
  return GetEntProp(client, Prop_Send, "m_zombieClass");
}

public Action onCommandServerInfo(int client, int args)
{
  char HostName[96];
  FindConVar("hostname").GetString(HostName, sizeof(HostName));
  char ConfigName[96];
  Cvar_ConfigName.GetString(ConfigName, sizeof(ConfigName));
  char ServerIP[96];
  Cvar_ServerIP.GetString(ServerIP, sizeof(ServerIP));
  char SteamGroupName[96];
  Cvar_Steam_Group_Name.GetString(SteamGroupName, sizeof(SteamGroupName));
  
  UpdateServerUpTime();
  
  int total_ping = 0;
  int total_players = 0;
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsValidClient(i) && IsClientInGame(i) && !IsFakeClient(i))
    {
      total_ping += RoundToZero(GetClientAvgLatency(i, NetFlow_Both) * 1000.0);
      total_players++;
    }
  }
  
  if (total_players) {
    total_ping = RoundToZero(total_ping / total_players * 1.0);
  }
  if (client > 0)
  {
    PrintToChat(client, "%t", "Server Informantion:");
    PrintToChat(client, "%t", "Host: %s | SteamGroup: %s", HostName, SteamGroupName);
    PrintToChat(client, "%t", "Server IP: %s | Config: %s", ServerIP, ConfigName);
    PrintToChat(client, "%t", "Host FPS: %d | Average ping: %d | UpTime: %s", FindConVar("fps_max").IntValue, total_ping, Server_UpTime);
  }
  else
  {
    PrintToServer("Server Informantion:");
    PrintToServer("Host: %s | SteamGroup: %s", HostName, SteamGroupName);
    PrintToServer("Config: %s", ConfigName);
    PrintToServer("Host FPS: %d | Average ping: %d | UpTime: %s", FindConVar("fps_max").IntValue, total_ping, Server_UpTime);
  }
}

void UpdateServerUpTime()
{
  char tmpTime[8];
  int Current_UpTime = GetTime() - UpTime;
  int Days = RoundToFloor(Current_UpTime / 86400.0);
  Current_UpTime -= Days * 86400;
  if (Days > 0)
  {
    if (Days > 1)
    {
      Format(Server_UpTime, sizeof(Server_UpTime), "%d days ", Days);
    }
    else
    {
      Format(Server_UpTime, sizeof(Server_UpTime), "1 day ");
    }
  }
  else
  {
    Server_UpTime = "";
  }
  int Hours = RoundToFloor(Current_UpTime / 3600.0);
  if (Hours < 10)
  {
    Format(Server_UpTime, sizeof(Server_UpTime), "%s0%d:", Server_UpTime, Hours);
  }
  else Format(Server_UpTime, sizeof(Server_UpTime), "%s%d:", Server_UpTime, Hours);
  Current_UpTime -= Hours * 3600;
  FormatTime(tmpTime, sizeof(tmpTime), "%M:%S", Current_UpTime);
  Format(Server_UpTime, sizeof(Server_UpTime), "%s%s", Server_UpTime, tmpTime);
}

int SetSpecialAmmoInPlayerGun(int client, int amount)
{
  if (!client)
  {
    return;
  }
  int gunent = GetPlayerWeaponSlot(client, 0);
  if (IsValidEdict(gunent))
  {
    SetEntProp(gunent, Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", amount, 1);
  }
}

void WitchBox(int client)
{
  for (int i = 1; i <= l4d2_ammo_witches.IntValue; i++)
  {
    CheatCMD(client, "z_spawn_old", "witch auto");
  }
  CreateTimer(0.3, Timer_Witch);
}

public Action Timer_Witch(Handle timer)
{
  if (CountWitches() < 3)
  {
    SpawnWitch();
    return Plugin_Stop;
  }
  
  return Plugin_Stop;
}

int CountWitches()
{
  int count;
  int entity = -1;
  while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
  {
    count++;
  }
  return count;
}

void SpawnWitch()
{
  int count;
  
  int iMaxEntities = GetMaxEntities();
  for (int iEntity = MaxClients + 1; iEntity < iMaxEntities; iEntity++)
  {
    if (IsCommonInfected(iEntity))
    {
      if (count <= l4d2_ammo_witches.IntValue)
      {
        float InfectedPos[3];
        float InfectedAng[3];
        GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", InfectedPos);
        GetEntPropVector(iEntity, Prop_Send, "m_angRotation", InfectedAng);
        AcceptEntityInput(iEntity, "Kill");
        int witch = CreateEntityByName("witch");
        DispatchSpawn(witch);
        ActivateEntity(witch);
        TeleportEntity(witch, InfectedPos, InfectedAng, NULL_VECTOR);
        SetEntProp(witch, Prop_Send, "m_hOwnerEntity", 255200255);
        count++;
      }
    }
  }
}

public void MedBox(int client)
{
  int ItemNumber;
  char ItemName[36];
  for (int i = 0; i < l4d2_ammo_medbox_count.IntValue; i++)
  {
    ItemNumber = GetRandomInt(1, 4);
    switch (ItemNumber)
    {
      case 1: ItemName = "weapon_defibrillator";
      case 2: ItemName = "weapon_first_aid_kit";
      case 3: ItemName = "weapon_pain_pills";
      case 4: ItemName = "weapon_adrenaline";
    }
    SpawnItem(client, ItemName);
  }
}

public void ReplaceAmmoWithLaser(int entity)
{
  int LaserEntity = CreateEntityByName("upgrade_laser_sight");
  if (LaserEntity == -1)
  {
    return;
  }
  float vecOrigin[3];
  float angRotation[3];
  GetEntPropVector(entity, Prop_Send, "m_vecOrigin", vecOrigin);
  GetEntPropVector(entity, Prop_Send, "m_angRotation", angRotation);
  RemoveEdict(entity);
  TeleportEntity(LaserEntity, vecOrigin, angRotation, NULL_VECTOR);
  DispatchSpawn(LaserEntity);
}

public void SpawnItem(int client, const char[] ItemName)
{
  float VecOrigin[3];
  float VecAngles[3];
  float VecDirection[3];
  
  int SpawnItemEntity = CreateEntityByName(ItemName);
  
  if (SpawnItemEntity == -1)
  {
    ReplyToCommand(client, "\x05[SM] \x03 Spawn Failed (\x01%s\x03)", ItemName);
  }
  
  DispatchKeyValue(SpawnItemEntity, "model", "spawn_entity_1");
  DispatchKeyValueFloat(SpawnItemEntity, "MaxPitch", 360.00);
  DispatchKeyValueFloat(SpawnItemEntity, "MinPitch", -360.00);
  DispatchKeyValueFloat(SpawnItemEntity, "MaxYaw", 90.00);
  DispatchSpawn(SpawnItemEntity);
  
  GetClientAbsOrigin(client, VecOrigin);
  GetClientEyeAngles(client, VecAngles);
  GetAngleVectors(VecAngles, VecDirection, NULL_VECTOR, NULL_VECTOR);
  VecOrigin[0] += VecDirection[0] * 32;
  VecOrigin[1] += VecDirection[1] * 32;
  VecOrigin[2] += VecDirection[2] * 1;
  VecAngles[0] = 0.0;
  VecAngles[2] = 0.0;
  
  DispatchKeyValueVector(SpawnItemEntity, "Angles", VecAngles);
  DispatchSpawn(SpawnItemEntity);
  TeleportEntity(SpawnItemEntity, VecOrigin, NULL_VECTOR, NULL_VECTOR);
}

public void Boom(float position[3])
{
  for (int i = 1; i <= 3; i++)
  {
    int entity = CreateEntityByName("prop_physics");
    if (!IsValidEntity(entity))
    {
      return;
    }
    
    DispatchKeyValue(entity, "model", "models/props_junk/propanecanister001a.mdl");
    DispatchSpawn(entity);
    SetEntData(entity, GetEntSendPropOffs(entity, "m_CollisionGroup"), 1, 1, true);
    TeleportEntity(entity, position, NULL_VECTOR, NULL_VECTOR);
    AcceptEntityInput(entity, "break");
  }
}

public void Boom2(float position[3])
{
  int entity = CreateEntityByName("prop_physics");
  if (!IsValidEntity(entity))return;
  
  DispatchKeyValue(entity, "model", "models/props_equipment/oxygentank01.mdl");
  DispatchSpawn(entity);
  SetEntData(entity, GetEntSendPropOffs(entity, "m_CollisionGroup"), 1, 1, true);
  TeleportEntity(entity, position, NULL_VECTOR, NULL_VECTOR);
  AcceptEntityInput(entity, "break");
}

public void FireRndm(float position[3])
{
  int entity = CreateEntityByName("prop_physics");
  
  if (IsValidEntity(entity))
  {
    if (GetRandomInt(1, 2) == 1)
    {
      DispatchKeyValue(entity, "model", "models/props_junk/gascan001a.mdl"); //Fire
    }
    else
    {
      DispatchKeyValue(entity, "model", "models/props_junk/explosive_box001.mdl"); //Fireworks
    }
    
    DispatchSpawn(entity);
    SetEntData(entity, GetEntSendPropOffs(entity, "m_CollisionGroup"), 1, 1, true);
    TeleportEntity(entity, position, NULL_VECTOR, NULL_VECTOR);
    AcceptEntityInput(entity, "break");
  }
}

public void Fire(float position[3])
{
  int entity = CreateEntityByName("prop_physics");
  if (IsValidEntity(entity))
  {
    DispatchKeyValue(entity, "model", "models/props_junk/gascan001a.mdl");
    DispatchSpawn(entity);
    SetEntData(entity, GetEntSendPropOffs(entity, "m_CollisionGroup"), 1, 1, true);
    TeleportEntity(entity, position, NULL_VECTOR, NULL_VECTOR);
    AcceptEntityInput(entity, "break");
  }
  
}

// public Action Event_PlayerChangeName(Event event, const char[] name, bool dontBroadcast)
// {
// 	int client = GetClientOfUserId(event.GetInt("userid"));
    
// 	if (!CheckCommandAccess(client, "sm_fk", ADMFLAG_GENERIC, true))
// 	{
// 		KickClient(client, "Nick change is prohibited!");
// 	}
// 	return Plugin_Stop;
// }

public Action onEventUpgradePackUsed(Event event, const char[] name, bool dontBroadcast) {
  int client = GetClientOfUserId(event.GetInt("userid"));
  int upgradeid = event.GetInt("upgradeid");
  
  float position[3];
  GetEntPropVector(upgradeid, Prop_Send, "m_vecOrigin", position);
  
  float g_pos[3];
  GetClientEyePosition(client, g_pos);
  
  char current_ammobox[24];
  l4d2_ammo_nextbox.GetString(current_ammobox, sizeof(current_ammobox));
  
  if (StrEqual(current_ammobox, "random", false))
  {	
    if (g_l4d2_ammo_chance > 0)
    {
      float X = 1000.0 / g_l4d2_ammo_chance;
      float Y = GetRandomFloat(0.0, 1000.0);
      float A = 0.0;
      float B = l4d2_ammochance_nothing.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "nothing";
      }
      A = A + B;
      B = l4d2_ammochance_firebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "firebox";
      }
      A = A + B;
      B = l4d2_ammochance_boombox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "boombox";
      }
      A = A + B;
      B = l4d2_ammochance_freezebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "freezebox";
      }
      A = A + B;
      B = l4d2_ammochance_laserbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "laserbox";
      }
      A = A + B;
      B = l4d2_ammochance_medbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "medbox";
      }
      A = A + B;
      B = l4d2_ammochance_nextbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "nextbox";
      }
      A = A + B;
      B = l4d2_ammochance_panicbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "panicbox";
      }
      A = A + B;
      B = l4d2_ammochance_witchbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "witchbox";
      }
      A = A + B;
      B = l4d2_ammochance_tankbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "tankbox";
      }
      A = A + B;
      B = l4d2_ammochance_bonusbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "bonusbox";
      }
      A = A + B;
      B = l4d2_ammochance_hardbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "hardbox";
      }
      A = A + B;
      B = l4d2_ammochance_healbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "healbox";
      }
      A = A + B;
      B = l4d2_ammochance_vomitbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "vomitbox";
      }
      A = A + B;
      B = l4d2_ammochance_explosionbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "explosionbox";
      }
      A = A + B;
      B = l4d2_ammochance_realismbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "realismbox";
      }
      A = A + B;
      B = l4d2_ammochance_bloodbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "bloodbox";
      }
      A = A + B;
      B = l4d2_ammochance_icebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "icebox";
      }
      A = A + B;
      B = l4d2_ammochance_expiredbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "expiredbox";
      }
      A = A + B;
      B = l4d2_ammochance_deathbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "deathbox";
      }
      A = A + B;
      B = l4d2_ammochance_jackinthebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "jackinthebox";
      }
      A = A + B;
      B = l4d2_ammochance_jackpotbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "jackpotbox";
      }
      A = A + B;
      B = l4d2_ammochance_matrixbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "matrixbox";
      }
      A = A + B;
      B = l4d2_ammochance_grenadebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "grenadebox";
      }
      A = A + B;
      B = l4d2_ammochance_luckybox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "luckybox";
      }
      A = A + B;
      B = l4d2_ammochance_weaponbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "weaponbox";
      }
      A = A + B;
      B = l4d2_ammochance_lifebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "lifebox";
      }
      A = A + B;
      B = l4d2_ammochance_jockeybox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "jockeybox";
      }
      A = A + B;
      B = l4d2_ammochance_smokerbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "smokerbox";
      }
      A = A + B;
      B = l4d2_ammochance_knifebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "knifebox";
      }
      A = A + B;
      B = l4d2_ammochance_barrelbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "barrelbox";
      }
      A = A + B;
      B = l4d2_ammochance_airstrikebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "airstrikebox";
      }
      A = A + B;
      B = l4d2_ammochance_meteorbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "meteorbox";
      }
      A = A + B;
      B = l4d2_ammochance_hellbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "hellbox";
      }
      A = A + B;
      B = l4d2_ammochance_respawnbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "respawnbox";
      }
      A = A + B;
      B = l4d2_ammochance_lightningbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "lightningbox";
      }
      A = A + B;
      B = l4d2_ammochance_cloudbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "cloudbox";
      }
      A = A + B;
      B = l4d2_ammochance_bridebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "bridebox";
      }
      A = A + B;
      B = l4d2_ammochance_failbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "failbox";
      }
      A = A + B;
      B = l4d2_ammochance_pointsbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "pointsbox";
      }
      A = A + B;
      B = l4d2_ammochance_bingobox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "bingobox";
      }
      A = A + B;
      B = l4d2_ammochance_acidbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "acidbox";
      }
      A = A + B;
      B = l4d2_ammochance_flamebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "flamebox";
      }
      A = A + B;
      B = l4d2_ammochance_bwbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "bwbox";
      }
      A = A + B;
      B = l4d2_ammochance_whitebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "whitebox";
      }
      A = A + B;
      B = l4d2_ammochance_multiplebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "multiplebox";
      }
      A = A + B;
      B = l4d2_ammochance_bossbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "bossbox";
      }
      A = A + B;
      B = l4d2_ammochance_huntingbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "huntingbox";
      }
      A = A + B;
      B = l4d2_ammochance_spitterbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "spitterbox";
      }
      A = A + B;
      B = l4d2_ammochance_chargerbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "chargerbox";
      }
      A = A + B;
      B = l4d2_ammochance_boomerbox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "boomerbox";
      }
      A = A + B;
      B = l4d2_ammochance_blazebox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "blazebox";
      }
      A = A + B;
      B = l4d2_ammochance_tinybox.IntValue * X;
      if (Y >= A && Y < A + B)
      {
        current_ammobox = "tinybox";
      }
    }
  }
  else if (StrEqual(current_ammobox, "nothing", false))
  {
    current_ammobox = "random";
  }
  else if (StrEqual(current_ammobox, "firebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    FireRndm(position);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "boombox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    Boom(position);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "freezebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    if (GetRandomInt(1, 2) == 1)Blizzard(client, position);
    else
    {
      if (freeze[client] == 0)FreezePlayer(client, position);
    }
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "laserbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(LASER_SOUND, client, SNDCHAN_AUTO, SNDLEVEL_RAIDSIREN);
    ReplaceAmmoWithLaser(upgradeid);
  }
  else if (StrEqual(current_ammobox, "medbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    MedBox(client);
    Cyl(position);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "witchbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(WITCH_SOUND);
    WitchBox(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "panicbox", false))
  {
    current_ammobox = "random";
    if (l4d2_plugin_uncommons)
    {
      EmitSoundToAll(PANIC_SOUND);
      
      int PanicRnd;
      PanicRnd = GetRandomInt(1, 6);
      
      switch (PanicRnd)
      {
        case 1:
        {
          ServerCommand("sm_spawnuncommonhorde riot");
          PrintHintTextToAll("%t panicbox (riot infected)!", "%N have found a", client);
        }
        case 2:
        {
          ServerCommand("sm_spawnuncommonhorde ceda");
          PrintHintTextToAll("%t panicbox (ceda infected)!", "%N have found a", client);
        }
        case 3:
        {
          ServerCommand("sm_spawnuncommonhorde clown");
          PrintHintTextToAll("%t panicbox (clown infected)!", "%N have found a", client);
        }
        case 4:
        {
          ServerCommand("sm_spawnuncommonhorde mud");
          PrintHintTextToAll("%t panicbox (mud infected)!", "%N have found a", client);
        }
        case 5:
        {
          ServerCommand("sm_spawnuncommonhorde roadcrew");
          PrintHintTextToAll("%t panicbox (worker infected)!", "%N have found a", client);
        }
        case 6:
        {
          ServerCommand("sm_spawnuncommonhorde jimmy");
          PrintHintTextToAll("%t panicbox (Jimmy Gibbs infected)!", "%N have found a", client);
        }
      }
    }
    else
    {
      PrintHintTextToAll("%t panicbox!", "%N have found a", client);
      PrintToChatAll("%t", "%N has opened a panicbox", client);
      CreateTimer(1.5, PanicEvent);
    }
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "tankbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(TANK_SOUND);
    CheatCMD(client, "z_spawn_old", "tank auto");
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "bonusbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(BONUS_SOUND);
    ChangeCvar("l4d2_loot_g_bonus", l4d2_ammo_loot_bonus.IntValue, 0, 10);
    ServerCommand("exec l4d2_supercoop/bonusbox.cfg");
    g_bIsRealismBox = false;
    sv_disable_glow_survivors.SetInt(0, false, false);
    RestoreBW();
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "hardbox", false)) {
    EmitSoundToAll(HARD_SOUND);
    current_ammobox = "random";
    g_cvarIsHardBox.SetInt(1, false, false);
    g_iHardLevel = g_iHardLevel + 1;
    char buffer[64];
    if (g_iHardLevel == 1)
    {
      ServerCommand("exec l4d2_supercoop/hardbox1.cfg");
      Format(buffer, 64, "hardbox x1");
    }
    else if (g_iHardLevel == 2)
    {
      ServerCommand("exec l4d2_supercoop/hardbox2.cfg");
      Format(buffer, 64, "hardbox x2");
    }
    else if (g_iHardLevel == 3)
    {
      ServerCommand("exec l4d2_supercoop/hardbox3.cfg");
      Format(buffer, 64, "hardbox x3");
    }
    AnnounceOpenBox(client, buffer);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "healbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    HealBox(client, false, position);
    #if HEALRESPAWN
    int target = GetRandomClient(false, false, 2);
    if (target > 0)
    {
      RespawnWithMelee(client, target);
    }
    #endif
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "vomitbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(VOMIT_SOUND, client, SNDCHAN_AUTO, SNDLEVEL_RAIDSIREN);
    Vomit(client, position);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "explosionbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    CreateExplosion(position);
    Fire(position);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "realismbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(REALISM_SOUND);
    ChangeCvar("l4d2_ammochance_realismbox", 0, 0, 0);
    RealismBox();
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "bloodbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(BLOOD_SOUND);
    ChangeCvar("l4d2_ammochance_bloodbox", 0, 0, 0);
    g_cvarIsBloodBox.SetInt(1, false, false);
    BloodBox();
    ServerCommand("exec l4d2_supercoop/bloodbox.cfg");
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "icebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    FreezePlayer(client, position);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "expiredbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    switch (GetRandomInt(1, 10)) {
      case 5: {
        ForcePlayerSuicide(client);
      }
      default: {
        if (IsGoingToDie(client)) {
          ForcePlayerSuicide(client);
        } else {
          BlackAndWhite(client, 1);
        }
      }
    }
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "deathbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(DeathBoxSounds[0]);
    EmitSoundToAll(DeathBoxSounds[2]);
    CreateTimer(6.0, Deathbox);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "jackpotbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(POINTS_SOUND);
    CreateTimer(1.0, Jackpotbox);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "jackinthebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    CreateTimer(1.0, JackInTheBox);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "matrixbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    DoMatrix();
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "grenadebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(ALARM_SOUND);
    Gren(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "luckybox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(ALARM_SOUND);
    lucky(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "weaponbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(ALARM_SOUND);
    weap(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "lifebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(ALARM_SOUND);
    lifes(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "knifebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(KNIFE_SOUND);
    knifes(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "jockeybox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    RemoveEdict(upgradeid);
    EmitSoundToAll(JOCKEY_SOUND);
    ServerCommand("exec l4d2_supercoop/jockeybox.cfg");
    ChangeCvar("l4d2_ammochance_jockeybox", 0, 0, 0);
  }
  else if (StrEqual(current_ammobox, "smokerbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    RemoveEdict(upgradeid);
    EmitSoundToAll(SMOKER_SOUND);
    ServerCommand("exec l4d2_supercoop/smokerbox.cfg");
    ChangeCvar("l4d2_ammochance_smokerbox", 0, 0, 0);
  }
  else if (StrEqual(current_ammobox, "barrelbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    StartBarrel(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "airstrikebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    StartAirstrike(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "meteorbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    StartMeteorFall(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "hellbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    TimedAirStrike(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "respawnbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    for (int i = 1; i < MaxClients; i++)
    {
      if (IsClientInGame(i) && GetClientTeam(i) == 2 && !IsPlayerAlive(i))
      {
        RespawnWithMelee(client, i);
      }
    }
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "lightningbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    Lightning(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "cloudbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    CreateGasCloud(client, g_pos);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "bridebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(BRIDE_SOUND);
    BrideBox(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "failbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    FindConVar("l4d2_loot_g_chance_nodrop").SetInt(105, false, false);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "pointsbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    l4d2_ammochance_pointsbox.SetFloat(0.0);
    EmitSoundToAll(POINTS_SOUND);
    ServerCommand("sm_givepoints #%d 500", GetClientUserId(client));
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "bingobox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(POINTS_SOUND);
    
    int x = 50;
    switch (GetRandomInt(1, 22))
    {
      case 1: x = -10;
      case 2: x = 20;
      case 3: x = -15;
      case 4: x = 25;
      case 5: x = -5;
      case 6: x = -30;
      case 7: x = 40;
      case 8: x = -50;
      case 9: x = 100;
      case 10: x = -55;
      case 11: x = 60;
      case 12: x = -65;
      case 13: x = 70;
      case 14: x = -75;
      case 15: x = 80;
      case 16: x = -85;
      case 17: x = 18;
      case 18: x = -35;
      case 19: x = 90;
      case 20: x = -95;
      case 21: x = 22;
      case 22: x = -45;
    }
    // if (x > 0)
    // {
    // 	CPrintToChatAll("%t\x05 %d %t", "[Bingobox] %N got", client, x, "points");
    // }
    // else
    // {
    // 	CPrintToChatAll("%t\x04 %d %t", "[Bingobox] %N got", client, x, "points");
    // }
    ServerCommand("sm_givepoints #%d %d", GetClientUserId(client), x);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "acidbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    CreateAcid(client);
    CreateAcid(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "flamebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    IgnitePlayer(client, 30.0, true);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "bwbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    if (!IsGoingToDie(client))BlackAndWhite(client);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "whitebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    
    for (int i = 1; i <= MaxClients; i++)
    {
      if (IsClientInGame(i))
      {
        if (IsValidEntity(i) && IsValidEdict(i))
        {
          if (GetClientTeam(i) == 2 && IsPlayerAlive(i) && !IsGoingToDie(i))
          {
            BlackAndWhite(i);
          }
        }
      }
    }
    
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "multiplebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(MULTIPLE_SOUND, client, SNDCHAN_AUTO, SNDLEVEL_RAIDSIREN);
    MultipleBox(client);
    Cyl(position);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "bossbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    RemoveEdict(upgradeid);
    ServerCommand("exec l4d2_supercoop/bossbox.cfg");
    ChangeCvar("l4d2_ammochance_bossbox", 0, 0, 0);
  }
  else if (StrEqual(current_ammobox, "huntingbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    RemoveEdict(upgradeid);
    EmitSoundToAll(HUNTER_SOUND);
    ServerCommand("exec l4d2_supercoop/huntingbox.cfg");
    ChangeCvar("l4d2_ammochance_huntingbox", 0, 0, 0);
  }
  else if (StrEqual(current_ammobox, "spitterbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    RemoveEdict(upgradeid);
    EmitSoundToAll(SPITTER_SOUND);
    ServerCommand("exec l4d2_supercoop/spitterbox.cfg");
    ChangeCvar("l4d2_ammochance_spitterbox", 0, 0, 0);
  }
  else if (StrEqual(current_ammobox, "chargerbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    RemoveEdict(upgradeid);
    EmitSoundToAll(CHARGER_SOUND);
    ServerCommand("exec l4d2_supercoop/chargerbox.cfg");
    ChangeCvar("l4d2_ammochance_chargerbox", 0, 0, 0);
  }
  else if (StrEqual(current_ammobox, "boomerbox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    RemoveEdict(upgradeid);
    EmitSoundToAll(BOOMER_SOUND);
    ServerCommand("exec l4d2_supercoop/boomerbox.cfg");
    ChangeCvar("l4d2_ammochance_boomerbox", 0, 0, 0);
  }
  else if (StrEqual(current_ammobox, "blazebox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    Blaze(client);
    ChangeCvar("l4d2_ammochance_blazebox", 0, 0, 0);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "tinybox", false))
  {
    AnnounceOpenBox(client, current_ammobox);
    current_ammobox = "random";
    EmitSoundToAll(TINY_SOUND);
    g_bIsTinyBox = true;
    ChangeCvar("l4d2_ammochance_tinybox", 0, 0, 0);
    RemoveEdict(upgradeid);
  }
  else if (StrEqual(current_ammobox, "nextbox", false))
  {
    int NextBoxRnd;
    NextBoxRnd = GetRandomInt(1, 32);
    
    switch (NextBoxRnd)
    {
      case 1:current_ammobox = "firebox";
      case 2:current_ammobox = "vomitbox";
      case 3:current_ammobox = "expiredbox";
      case 4:current_ammobox = "laserbox";
      case 5:current_ammobox = "medbox";
      case 6:current_ammobox = "tankbox";
      case 7:current_ammobox = "witchbox";
      case 8:current_ammobox = "panicbox";
      case 9:current_ammobox = "freezebox";
      case 10:
      {
        if (l4d2_ammochance_bloodbox.IntValue > 0)current_ammobox = "bloodbox";
        else current_ammobox = "firebox";
      }
      case 11:
      {
        if (g_iHardLevel < 3)current_ammobox = "hardbox";
        else current_ammobox = "bridebox";
      }
      case 12:current_ammobox = "healbox";
      case 13:current_ammobox = "tankbox";
      case 14:current_ammobox = "explosionbox";
      case 15:current_ammobox = "multiplebox";
      case 16:current_ammobox = "bingobox";
      case 17:current_ammobox = "firebox";
      case 18:current_ammobox = "vomitbox";
      case 19:
      {
        if (l4d2_ammochance_realismbox.IntValue > 0)current_ammobox = "realismbox";
        else current_ammobox = "meteorbox";
      }
      case 20:current_ammobox = "medbox";
      case 21:current_ammobox = "laserbox";
      case 22:current_ammobox = "witchbox";
      case 23:current_ammobox = "panicbox";
      case 24:current_ammobox = "freezebox";
      case 25:current_ammobox = "bridebox";
      case 26:current_ammobox = "healbox";
      case 27:
      {
        if (l4d2_ammochance_bossbox.IntValue > 0)current_ammobox = "bossbox";
        else current_ammobox = "panicbox";
      }
      case 28:current_ammobox = "multiplebox";
      case 29:current_ammobox = "barrelbox";
      case 30:current_ammobox = "lifebox";
      case 31:current_ammobox = "bingobox";
      case 32:current_ammobox = "meteorbox";
    }
    char buffer[64];
    Format(buffer, 64, "nextbox (%s)!", current_ammobox);
    AnnounceOpenBox(client, buffer);
    RemoveEdict(upgradeid);
  }
  else
  {
    current_ammobox = "random";
  }
  l4d2_ammo_nextbox.SetString(current_ammobox);
}

int GetSpecialAmmoInPlayerGun(int client)
{
  if (!client)return 0;
  
  int gunent = GetPlayerWeaponSlot(client, 0);
  if (IsValidEdict(gunent))return GetEntProp(gunent, Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 1);
  else return 0;
}

public void ChangeCvar(const char[] CvarName, int CvaValue, int CvarValueMin, int CvarValueMax)
{
  ConVar GameCvar = FindConVar(CvarName);
  if (GameCvar == null)
    return;
  int GameCvarValue = GameCvar.IntValue;
  if (GameCvarValue + CvaValue < CvarValueMin)
    GameCvarValue = CvarValueMin;
  else if (GameCvarValue + CvaValue > CvarValueMax)
    GameCvarValue = CvarValueMax;
  else
    GameCvarValue = GameCvarValue + CvaValue;
  GameCvar.SetInt(GameCvarValue, false, false);
}

public Action PanicEvent(Handle timer)
{
  EmitSoundToAll(PANIC_SOUND);
  
  int bot = CreateFakeClient("mob");
  if (bot > 0)
  {
    if (IsFakeClient(bot))
    {
      CheatCMD(bot, "z_spawn_old", "mob auto");
      KickClient(bot);
    }
  }
  return Plugin_Stop;
}

public Action onEventUpgradePackAdded(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  int upgradeid = event.GetInt("upgradeid");
  
  if (!IsValidEdict(upgradeid))
    return;
  
  char class[256];
  GetEdictClassname(upgradeid, class, 256);
  if (StrEqual(class, "upgrade_laser_sight", true))
  {
    if (GetRandomInt(1, 2) == 1)RemoveEdict(upgradeid);
    return;
  }
  
  char PrimaryWeaponName[64];
  GetEdictClassname(GetPlayerWeaponSlot(client, 0), PrimaryWeaponName, sizeof(PrimaryWeaponName));
  if (StrEqual(PrimaryWeaponName, "weapon_grenade_launcher", false))
  {
    RemoveEdict(upgradeid);
    
    if (GetRandomInt(1, 10) == 1)
    {
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", l4d2_ammo_count_bonus.IntValue);
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", l4d2_ammo_count_bonus.IntValue, 1);
    }
    else
    {
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", l4d2_ammo_count.IntValue);
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", l4d2_ammo_count.IntValue, 1);
    }
    return;
  }
  if (StrEqual(PrimaryWeaponName, "weapon_rifle_m60", false))
  {
    int ammo = GetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", 4);
    int ammoupgrade = GetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 4);
    
    if (4 <= ammoupgrade)
      ammoupgrade = 4;
    else
      ammoupgrade = 0;
    
    if (ammo < 0)
    {
      ammo += 356;
      if (ammo > 250)ammo = 250;
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", ammo);
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 0);
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", ammoupgrade);
    }
    else if (ammo <= 150)
    {
      ammo += 100;
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", ammo);
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 0);
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", ammoupgrade);
    }
    else if (ammo > 150 && ammo < 250)
    {
      ammo = 250;
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", ammo);
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 0);
      SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", ammoupgrade);
    }
    else if (ammo > 249)
    {
    }
    RemoveEdict(upgradeid);
    return;
  }
  else if (GetSpecialAmmoInPlayerGun(client) > 1)
  {
    int AMMORND = GetRandomInt(1, 3);
    SetSpecialAmmoInPlayerGun(client, AMMORND * GetSpecialAmmoInPlayerGun(client));
  }
  RemoveEdict(upgradeid);
}

public Action EventwhiteReviveSuccess(Event event, const char[] name, bool dontBroadcast)
{
  if (!g_bIsRealismBox)
  {
    if (event.GetBool("lastlife")) {
      int client = GetClientOfUserId(event.GetInt("subject"));
      BWaura(client);
    }
  }	
}

public Action EventwhitePlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  CleanAura(client);
}

public Action Event_whiteHealSuccess(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("subject"));
  
  SetEntProp(client, Prop_Send, "m_iHealth", 100);
  SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
  SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
  
  if (g_bIsBloodBox)
  {
    SetBlood(client);
  }
  CleanAura(client);
}

public Action EventPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  
  if (client)
  {
    if (IsValidEntity(client))
    {
      CreateTimer(1.9, TimerSetWhiteAura, client);
      if (g_bIsBloodBox)
      {
        CreateTimer(2.0, TimerSetBlood, client);
      }
    }
  }
}

public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
  g_bIsBloodBox = false;
  g_bMeterRain = false;
  g_iMeteorTick = 0;
  g_bBarrelRain = false;
  g_bAirstrike = false;
  
  if (MatrixOn)
  {
    int i_Ent;
    i_Ent = CreateEntityByName("func_timescale");
    DispatchKeyValue(i_Ent, "desiredTimescale", "1.0");
    DispatchKeyValue(i_Ent, "acceleration", "1.0");
    DispatchKeyValue(i_Ent, "minBlendRate", "0.1");
    DispatchKeyValue(i_Ent, "blendDeltaMultiplier", "1.0");
    DispatchSpawn(i_Ent);
    AcceptEntityInput(i_Ent, "Start");
    AcceptEntityInput(i_Ent, "Stop");
    MatrixOn = false;
    if (l4d2_ammo_matrix_glowon.IntValue)
    {
      RemoveGlow();
      RestoreBW();
    }
  }
}

public Action TimerSetWhiteAura(Handle timer, any client)
{
  if (IsClientInGame(client))
  {
    if(IsPlayerAlive(client))
    {
      if(GetClientTeam(client) == 2)
      {
        if (IsGoingToDie(client))
        {
          BWaura(client);
        }
      }
    }
  }
  return Plugin_Stop;
}

public Action TimerSetBlood(Handle timer, any client)
{
  if (IsClientInGame(client))
  {
    if(IsPlayerAlive(client))
    {
      if(GetClientTeam(client) == 2)
      {
        if(GetEntProp(client, Prop_Send, "m_currentReviveCount") == 0)
        {
          SetBlood(client);
        }
      }
    }
  }
  return Plugin_Stop;
}

public void SetBlood(int client)
{
  ScreenFade(client, 255, 15, 15, 100, RoundToZero(0.8 * 1000.0), 1);
  SwitchHealth(client);
}

public void CleanAura(int client)
{
  if (client)
  {
    if(IsValidEntity(client))
    {
      if(IsClientInGame(client))
      {
        if(GetClientTeam(client) == 2)
        {
          SetEntProp(client, Prop_Send, "m_iGlowType", 0);
          SetEntProp(client, Prop_Send, "m_glowColorOverride", 0);
        }
      }
    }		
  }
}

public void BWaura(int client)
{
  if (client < 1)
    return;
  if (!IsValidEntity(client))
    return;
  if (!IsClientInGame(client))
    return;
  if (GetClientTeam(client) != 2)
    return;
  if (!IsPlayerAlive(client))
    return;
  if (FindConVar("sv_disable_glow_survivors").IntValue == 1)
    return;
  
  SetEntProp(client, Prop_Send, "m_iGlowType", 3);
  SetEntProp(client, Prop_Send, "m_glowColorOverride", INT_COLOR_WHITE);
}

// int RGB_TO_INT(int red, int green, int blue)
// {
// 	return (blue * 65536) + (green * 256) + red;
// }

public void BloodBox()
{
  g_bIsBloodBox = true;
  
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i))
    {
      if (IsPlayerAlive(i))
      {
        if (GetClientTeam(i) == 2)
        {
          SetBlood(i);
        }
      }
    }
  }
}

public void RealismBox()
{
  g_bIsRealismBox = true;
  sv_disable_glow_survivors.SetInt(1, false, false);
  FuncCleanAura();
}

public Action Event_PlayerDefibed(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("subject"));
  
  if (client)
  {
    SetEntProp(client, Prop_Send, "m_currentReviveCount", 2);
    SetEntProp(client, Prop_Send, "m_isGoingToDie", 1);
    SetEntProp(client, Prop_Send, "m_iHealth", 1);
    SetTempHealth(client, 50);
    BWaura(client);
    CreateTimer(3.6, BlackWhite, client);
  }
  return Plugin_Continue;
}

public Action BlackWhite(Handle timer, any client)
{
  if (IsClientInGame(client))
  {
    if(IsPlayerAlive(client))
    {
      if(GetClientTeam(client) == 2)
      {
        BWaura(client);
        BlackAndWhite(client, 70);
      }
    }
  }
}

void BlackAndWhite(int client, int hp = 99)
{
  if (client)
  {
    if(IsValidEntity(client))
    {
      if(IsClientInGame(client))
      {
        if(IsPlayerAlive(client))
        {
          if(GetClientTeam(client) == 2)
          {
            SetEntProp(client, Prop_Send, "m_currentReviveCount", FindConVar("survivor_max_incapacitated_count").IntValue - 1);
            SetEntProp(client, Prop_Send, "m_isIncapacitated", 1);
            SDKCall(sdkRevive, client);
            SetEntityHealth(client, 1);
            SetTempHealth(client, hp);
          }
        }
      }
    }
  }
}

void SetTempHealth(int client, int hp)
{
  SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
  float newOverheal = hp * 1.0;
  SetEntPropFloat(client, Prop_Send, "m_healthBuffer", newOverheal);
}

public void HealBox(int client, bool multiply, float trspos[3])
{
  if ((GetRandomInt(1, 10) == 1) || multiply)
  {
    TE_SetupBeamRingPoint(trspos, 10.0, l4d2_healbox_radius, g_BeamSprite, g_HaloSprite, 0, 10, 0.3, 10.0, 0.5, { 255, 255, 255, 230 }, 400, 0);
    TE_SendToAll();
    
    float position[3];
    for (int i = 1; i <= MaxClients; i++)
    {
      if (!IsClientInGame(i) || !IsPlayerAlive(i) || GetClientTeam(i) != 2)continue;
      
      GetClientEyePosition(i, position);
      if (GetVectorDistance(position, trspos) < l4d2_healbox_radius)
      {
        EmitAmbientSound(HEAL_SOUND, position, i, SNDLEVEL_RAIDSIREN);
        HealPlayer(i);
        CleanAura(i);
        ScreenFade(i, 192, 238, 39, 140, RoundToZero(0.6 * 1000.0), 1);
      }
    }
    
    #if HEALRESPAWN
    for (int i = 1; i <= MaxClients; i++)
    {
      if (!IsClientInGame(i) || IsPlayerAlive(i) || GetClientTeam(i) != 2 || IsFakeClient(i))
      {
        continue;
      }
      
      GetClientEyePosition(i, position);
      
      if (GetVectorDistance(position, trspos) < l4d2_healbox_radius)
      {
        RespawnWithMelee(client, i);
      }
    }
    #endif
  }
  else
  {
    EmitAmbientSound(HEAL_SOUND, trspos, client, SNDLEVEL_RAIDSIREN);
    if (IsClientInGame(client))
    {
      if(!IsFakeClient(client))
      {
        if(IsPlayerAlive(client))
        {
          HealPlayer(client);
          CleanAura(client);
          ScreenFade(client, 192, 238, 39, 140, RoundToZero(0.6 * 1000.0), 1);
        }
      }
    }
  }
}

public void HealPlayer(int entity)
{
  CheatCMD(entity, "give", "health");
  SetTempHealth(entity, 0);
  
  if (g_bIsBloodBox)
  {
    SwitchHealth(entity);
  }
}

void SwitchHealth(int client)
{
  float iTempHealth = GetClientTempHealth(client) * 1.0;
  float iPermHealth = GetClientHealth(client) * 1.0;
  float flTotal = iTempHealth + iPermHealth;
  SetEntityHealth(client, 1);
  RemoveTempHealth(client);
  SetTempHealth(client, RoundToZero(flTotal));
}

public int GetClientTempHealth(int client)
{
  if (!client || !IsValidEntity(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || IsClientObserver(client) || GetClientTeam(client) != 2)
  {
    return -1;
  }
  
  float buffer = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
  float TempHealth;
  if (buffer <= 0.0)
  {
    TempHealth = 0.0;
  }
  else
  {
    float difference = GetGameTime() - GetEntPropFloat(client, Prop_Send, "m_healthBufferTime");
    float decay = FindConVar("pain_pills_decay_rate").FloatValue;
    float constant = 1.0 / decay;
    TempHealth = buffer - (difference / constant);
  }
  
  if (TempHealth < 0.0)
  {
    TempHealth = 0.0;
  }
  
  return RoundToFloor(TempHealth);
}

void RemoveTempHealth(int client)
{
  if (!client || !IsValidEntity(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || IsClientObserver(client) || GetClientTeam(client) != 2)
    return;
  SetTempHealth(client, 0);
}



public void IsMapFinishedChanged(ConVar hVariable, const char[] strOldValue, const char[] strNewValue)
{
  if (g_cvarIsMapFinished.IntValue == 0) {
    ServerCommand("exec l4d2_supercoop/PlayerLeavesRescueZone.cfg");
    
  } else {
    ServerCommand("exec l4d2_supercoop/PlayerEnterRescueZone.cfg");
    if (!l4d2_plugin_keyman) {
      CreateTimer(5.0, TimerLoadOnEnd);
      CreateTimer(15.0, PanicEvent);
    }
  }
}

public Action TimerLoadOnEnd(Handle timer, any client)
{
  LoadCFG();
  return Plugin_Stop;
}

public void LoadCFG()
{
  ServerCommand("exec l4d2_supercoop/PlayerEnterRescueZone.cfg");
  CreateTimer(1.0, PanicEvent);
}

public Action Event_CheckPoint(Event event, const char[] name, bool dontBroadcast)
{
  if (g_cvarIsMapFinished.IntValue > 0)return Plugin_Continue;
  
  int Target = GetClientOfUserId(event.GetInt("userid"));
  char strBuffer[128];
  event.GetString("doorname", strBuffer, sizeof(strBuffer));
  
  if (Target && (GetClientTeam(Target)) == 2)
  {
    if (StrEqual(strBuffer, "checkpoint_entrance", false))CheckPointReached(Target);
    else
    {
      int area = event.GetInt("area");
      
      char current_map[55];
      GetCurrentMap(current_map, 54);
      
      if (StrEqual(current_map, "c2m1_highway", false))
        if (area == 89583)CheckPointReached(Target);
      if (StrEqual(current_map, "c4m4_milltown_b", false))
        if (area == 502575)CheckPointReached(Target);
      if (StrEqual(current_map, "c5m1_waterfront", false))
        if (area == 54867)CheckPointReached(Target);
      if (StrEqual(current_map, "c5m2_park", false))
        if (area == 196623)CheckPointReached(Target);
      if (StrEqual(current_map, "c7m1_docks", false))
        if (area == 4475)CheckPointReached(Target);
      if (StrEqual(current_map, "c7m2_barge", false))
        if (area == 52626)CheckPointReached(Target);
      if (StrEqual(current_map, "c9m1_alleys", false))
        if (area == 21211)CheckPointReached(Target);
      if (StrEqual(current_map, "c10m4_mainstreet", false))
      {
        if (area == 85038)CheckPointReached(Target);
        else if (area == 85093)CheckPointReached(Target);
      }
      if (StrEqual(current_map, "C12m1_hilltop", false))
        if (area == 60481)CheckPointReached(Target);
      if (StrEqual(current_map, "c13m1_alpinecreek", false))
        if (area == 14681)CheckPointReached(Target);
      if (StrEqual(current_map, "c13m2_southpinestream", false))
        if (area == 2910)CheckPointReached(Target);
      if (StrEqual(current_map, "c13m3_memorialbridge", false))
        if (area == 154511)CheckPointReached(Target);
    }
  }
  return Plugin_Continue;
}

public void CheckPointReached(int client)
{
  if (l4d2_plugin_keyman)
  {
    if (SomeMapOfCampaign())
    {
      g_cvarIsMapFinished.SetInt(1, false, false);
      CPrintToChatAll("%t", "Player %N reached the safe room!", client);
      PrintToChatAll("%t", "Players reached the safe room!");
    }
  }
  else
  {
    g_cvarIsMapFinished.SetInt(1, false, false);
    CPrintToChatAll("%t", "Player %N reached the safe room!", client);
    PrintToChatAll("%t", "Players reached the safe room!");
  }
}

bool SomeMapOfCampaign()
{
  char MapName[128];
  GetCurrentMap(MapName, sizeof(MapName));
  if (StrContains(MapName, "c10m3", true) > -1 || StrContains(MapName, "l4d_yama_2", true) > -1)return true;
  return false;
}

public Action Event_PlayerNowIt(Event event, const char[] name, bool dontBroadcast)
{
  ExtinguishEntity(GetClientOfUserId(event.GetInt("userid")));
}

public void Blizzard(int client, float trspos[3])
{
  EmitAmbientSound(SOUND_IMPACT01, trspos);
  EmitAmbientSound(SOUND_IMPACT02, trspos);
  
  TE_SetupBeamRingPoint(trspos, 10.0, l4d2_freeze_radius, g_BeamSprite, g_HaloSprite, 0, 10, 0.3, 10.0, 0.5, { 40, 40, 230, 230 }, 400, 0);
  TE_SendToAll();
  
  float position[3];
  for (int i = 1; i <= MaxClients; i++)
  {
    if (!IsClientInGame(i) || !IsPlayerAlive(i))continue;
    
    GetClientEyePosition(i, position);
    
    if (GetVectorDistance(position, trspos) <= l4d2_freeze_radius)
    {
      if (freeze[i] == 0)FreezePlayer(i, position);
    }
  }
}

public void FreezePlayer(int entity, float position[3])
{
  SaveSkinColor(entity);
  SetEntityMoveType(entity, MOVETYPE_NONE);
  SetEntityRenderColor(entity, 102, 204, 255, 195);
  ScreenFade(entity, 0, 128, 255, 192, RoundToZero(l4d2_freeze_time * 1000), 1);
  EmitAmbientSound(SOUND_FREEZE, position, entity, SNDLEVEL_RAIDSIREN);
  TE_SetupGlowSprite(position, g_GlowSprite, l4d2_freeze_time, 0.5, 130);
  TE_SendToAll();
  freeze[entity] = 1;
  CreateTimer(l4d2_freeze_time, DefrostPlayer, entity);
}

void SaveSkinColor(int entity)
{
  if (entity > 0)
  {
    int offset = GetEntSendPropOffs(entity, "m_clrRender");
    icolor[entity][0] = GetEntData(entity, offset, 1);
    icolor[entity][1] = GetEntData(entity, offset + 1, 1);
    icolor[entity][2] = GetEntData(entity, offset + 2, 1);
  }
}

public Action DefrostPlayer(Handle timer, any entity)
{
  if (IsValidEdict(entity) && IsValidEntity(entity) && (freeze[entity] == 1))Func_DefrostPlayer(entity);
  
  return Plugin_Stop;
}

void Func_DefrostPlayer(int client)
{
  float entPos[3];
  GetEntPropVector(client, Prop_Send, "m_vecOrigin", entPos);
  EmitAmbientSound(SOUND_DEFROST, entPos, client, SNDLEVEL_RAIDSIREN);
  SetEntityMoveType(client, MOVETYPE_WALK);
  ScreenFade(client, 0, 0, 0, 0, 0, 1);
  freeze[client] = 0;
  if (GetClientTeam(client) == 2 && IsPlayerAlive(client))
  {
    SetEntityRenderColor(client, 255, 255, 255, 255);
    bool isHaveColor = true;
    if (icolor[client][0] == 255 && icolor[client][1] == 255 && icolor[client][2] == 255)
    {
      isHaveColor = false;
    }
    if (isHaveColor)
    {
      SetEntityRenderColor(client, icolor[client][0], icolor[client][1], icolor[client][2], 255);
    }
  }
}

public void ScreenFade(int target, int red, int green, int blue, int alpha, int duration, int type)
{
  Handle msg = StartMessageOne("Fade", target);
  BfWriteShort(msg, 500);
  BfWriteShort(msg, duration);
  if (type == 0)BfWriteShort(msg, (0x0002 | 0x0008));
  else BfWriteShort(msg, (0x0001 | 0x0010));
  BfWriteByte(msg, red);
  BfWriteByte(msg, green);
  BfWriteByte(msg, blue);
  BfWriteByte(msg, alpha);
  EndMessage();
}

void KillAllFreezes()
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsValidEdict(i) && IsValidEntity(i) && IsClientInGame(i) && IsPlayerAlive(i) && (freeze[i] == 1))Func_DefrostPlayer(i);
  }
}

public void CreateRingEffect(int client, int colRed, int colGre, int colBlu, int alpha, float width)
{
  int color[4];
  color[0] = colRed;
  color[1] = colGre;
  color[2] = colBlu;
  color[3] = alpha;
  
  float position[3];
  GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);
  position[2] += 10;
  TE_SetupBeamRingPoint(position, 10.0, 50.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.3, width, 1.5, color, 300, 0);
  TE_SendToAll();
}

public void Vomit(int client, float trspos[3])
{
  EmitAmbientSound(SOUND_JAR, trspos);
  
  TE_SetupBeamRingPoint(trspos, 10.0, l4d2_vomit_radius, g_BeamSprite, g_HaloSprite, 0, 10, 0.3, 10.0, 0.5, { 51, 153, 0, 230 }, 400, 0);
  TE_SendToAll();
  
  float position[3];
  for (int i = 1; i <= MaxClients; i++)
  {
    if (!IsClientInGame(i) || !IsPlayerAlive(i))continue;
    
    GetClientEyePosition(i, position);
    
    if (GetVectorDistance(position, trspos) <= l4d2_vomit_radius)VomitOnlyPlayer(i);
  }
}

void VomitOnlyPlayer(int target)
{
  if (GetClientTeam(target) == 3)SDKCall(sdkVomitInfected, target, target, true);
  if (GetClientTeam(target) == 2)SDKCall(sdkVomitSurvivor, target, target, true);
}

public void Cyl(float position[3])
{
  for (int i = 1; i <= 200; i++) // Создаем цикл. На этот раз радиус один. i просто счетчик высоты. Цилиндр будет высотой 200 единиц.
  {  // Создаем маяк (кольцо) с нач. диаметром 50.0 ед. и конечным 51.0 единица, чтобы все работало.
    TE_SetupBeamRingPoint(position, 50.0, 51.0, g_BeamSprite, g_HaloSprite, 0, 15, 5.0, 2.0, 0.0, { 255, 40, 0, 200 }, 10, 0);
    TE_SendToAll(); // Применяем
    position[2] = position[2] + 1.0; // Добавляем + 1 единицу к координате Z, чтобы фигура росла в высоту.
  }
}

void CreateExplosion(float position[3])
{
  char sRadius[256];
  char sPower[256];
  float flMaxDistance = g_cvarRadius * 1.0;
  float power = g_cvarPower * 1.0;
  float cvarDuration = g_cvarDuration * 1.0;
  IntToString(g_cvarRadius, sRadius, sizeof(sRadius));
  IntToString(g_cvarPower, sPower, sizeof(sPower));
  int exParticle2 = CreateEntityByName("info_particle_system");
  int exParticle3 = CreateEntityByName("info_particle_system");
  int exPhys = CreateEntityByName("env_physexplosion");
  int exParticle = CreateEntityByName("info_particle_system");
  int exEntity = CreateEntityByName("env_explosion");
  
  DispatchKeyValue(exParticle, "effect_name", EXPLOSION_PARTICLE);
  DispatchSpawn(exParticle);
  ActivateEntity(exParticle);
  TeleportEntity(exParticle, position, NULL_VECTOR, NULL_VECTOR);
  
  DispatchKeyValue(exParticle2, "effect_name", EXPLOSION_PARTICLE2);
  DispatchSpawn(exParticle2);
  ActivateEntity(exParticle2);
  TeleportEntity(exParticle2, position, NULL_VECTOR, NULL_VECTOR);
  
  DispatchKeyValue(exParticle3, "effect_name", EXPLOSION_PARTICLE3);
  DispatchSpawn(exParticle3);
  ActivateEntity(exParticle3);
  TeleportEntity(exParticle3, position, NULL_VECTOR, NULL_VECTOR);
  
  DispatchKeyValue(exEntity, "fireballsprite", "sprites/muzzleflash4.vmt");
  DispatchKeyValue(exEntity, "iMagnitude", sPower);
  DispatchKeyValue(exEntity, "iRadiusOverride", sRadius);
  DispatchKeyValue(exEntity, "spawnflags", "828");
  DispatchSpawn(exEntity);
  TeleportEntity(exEntity, position, NULL_VECTOR, NULL_VECTOR);
  
  DispatchKeyValue(exPhys, "radius", sRadius);
  DispatchKeyValue(exPhys, "magnitude", sPower);
  DispatchSpawn(exPhys);
  TeleportEntity(exPhys, position, NULL_VECTOR, NULL_VECTOR);
  
  EmitSoundToAll(EXPLOSION_SOUND2, exParticle);
  
  AcceptEntityInput(exParticle, "Start");
  AcceptEntityInput(exParticle2, "Start");
  AcceptEntityInput(exParticle3, "Start");
  AcceptEntityInput(exEntity, "Explode");
  AcceptEntityInput(exPhys, "Explode");
  
  DataPack pack = new DataPack();
  pack.WriteCell(exParticle);
  pack.WriteCell(exParticle2);
  pack.WriteCell(exParticle3);
  pack.WriteCell(exEntity);
  pack.WriteCell(exPhys);
  CreateTimer(cvarDuration + 1.5, timerDeleteParticles, pack, TIMER_FLAG_NO_MAPCHANGE);
  
  float tpos[3];
  float traceVec[3];
  float resultingFling[3];
  float currentVelVec[3];
  for (int i = 1; i <= MaxClients; i++)
  {
    if (i == 0 || !IsValidEntity(i) || !IsClientInGame(i) || GetClientTeam(i) != 2 || !IsPlayerAlive(i))continue;
    
    GetEntPropVector(i, Prop_Data, "m_vecOrigin", tpos);
    
    if (GetVectorDistance(position, tpos) <= flMaxDistance)
    {
      MakeVectorFromPoints(position, tpos, traceVec); // draw a line from car to Survivor
      GetVectorAngles(traceVec, resultingFling); // get the angles of that line
      
      resultingFling[0] = Cosine(DegToRad(resultingFling[1])) * power; // use trigonometric magic
      resultingFling[1] = Sine(DegToRad(resultingFling[1])) * power;
      resultingFling[2] = power;
      
      GetEntPropVector(i, Prop_Data, "m_vecVelocity", currentVelVec); // add whatever the Survivor had before
      resultingFling[0] += currentVelVec[0];
      resultingFling[1] += currentVelVec[1];
      resultingFling[2] += currentVelVec[2];
      
      FlingPlayer(i, resultingFling, i);
      
      CreateParticle(i, FIRESMALL_PARTICLE, true, 5.0);
      
      ScreenFade(i, 240, 115, 25, 100, RoundToZero(1 * 1000.0), 1);
    }
  }
}

void CreateParticle(int client, char[] Particle_Name, bool Parent, float duration)
{
  float pos[3];
  char sName[64];
  int Particle = CreateEntityByName("info_particle_system");
  GetClientAbsOrigin(client, pos);
  TeleportEntity(Particle, pos, NULL_VECTOR, NULL_VECTOR);
  DispatchKeyValue(Particle, "effect_name", Particle_Name);
  if (Parent)
  {
    int userid = GetClientUserId(client);
    Format(sName, 64, "%d", userid);
    DispatchKeyValue(client, "targetname", sName);
  }
  DispatchSpawn(Particle);
  if (Parent)
  {
    SetVariantString(sName);
    AcceptEntityInput(Particle, "SetParent", Particle, Particle, 0);
  }
  ActivateEntity(Particle);
  AcceptEntityInput(Particle, "Start");
  CreateTimer(duration, timerRemovePrecacheParticle, Particle);
}

public Action timerDeleteParticles(Handle timer, DataPack pack) {
  pack.Reset();
  int entity;
  for (int i = 1; i <= 5; i++) {
    entity = pack.ReadCell();
    if (IsValidEntity(entity))AcceptEntityInput(entity, "Kill");
  }
  pack.Close();
  return Plugin_Stop;
}

void FlingPlayer(int target, float vector[3], int attacker, float stunTime = 3.0)
{
  SDKCall(sdkCallPushPlayer, target, vector, 96, attacker, stunTime);
}

//---===--=====---===---===---===---Stocks---===--=====---===---===---===---//
bool IsCommonInfected(int iEntity)
{
  if (iEntity && IsValidEntity(iEntity))
  {
    char strClassName[64];
    GetEdictClassname(iEntity, strClassName, sizeof(strClassName));
    return StrEqual(strClassName, "infected");
  }
  return false;
}

bool IsWitch(int iEntity)
{
  if (iEntity && IsValidEntity(iEntity))
  {
    char strClassName[64];
    GetEdictClassname(iEntity, strClassName, sizeof(strClassName));
    return StrEqual(strClassName, "witch");
  }
  return false;
}

int GetRandomClient(bool bot = false, bool alive = false, int team = 0)
{
  int count = 0;
  int players[MAXPLAYERS + 1];
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i) && bot == IsFakeClient(i) && alive == IsPlayerAlive(i) && !(team > 0 && team != GetClientTeam(i)))
    {
      players[count++] = i;
    }
  }
  return count > 0 ? players[GetRandomInt(0, count - 1)] : -1;
}

bool IsValidClient(int client)
{
  if (!IsValidEntity(client))
  {
    return false;
  }
  if (client < 1 || client > MaxClients)
  {
    return false;
  }
  return true;
}

int GetClientHealthTotal(int client)
{
  return RoundToZero(GetClientTempHealth(client) * 1.0 + GetClientHealth(client) * 1.0);
}

public void ServerKickClient(int client) {
  if(!IsClientInKickQueue(client)) {
    KickClientEx(client);
  }
}

public void KickFakeClients(int kick_mode)
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i))
    {
      if (IsFakeClient(i))
      {
        if (kick_mode < 0)ServerKickClient(i);
        else if (kick_mode == GetClientTeam(i))ServerKickClient(i);
      }
    }
  }
}

public void KickTeam(int team)
{
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i))
    {
      if (GetClientTeam(i) == team)
      {
        ServerKickClient(i);
      }
    }
  }
}

//---===--=====---===---===---===---Acidbox---===--=====---===---===---===---//
void CreateAcid(int client)
{
  float vecPos[3];
  GetClientAbsOrigin(client, vecPos);
  vecPos[2] += 16.0;
  
  int iAcid = CreateEntityByName("spitter_projectile");
  if (IsValidEntity(iAcid))
  {
    DispatchSpawn(iAcid);
    SetEntPropFloat(iAcid, Prop_Send, "m_DmgRadius", 1024.0); // Radius of the acid.
    SetEntProp(iAcid, Prop_Send, "m_bIsLive", 1); // Without this set to 1, the acid won't make any sound.
    TeleportEntity(iAcid, vecPos, NULL_VECTOR, NULL_VECTOR);
    SDKCall(sdkDetonateAcid, iAcid);
  }
}

//---===--=====---===---===---===---Grenadebox---===--=====---===---===---===---//
void Gren(int client)
{
  CheatCMD(client, "give", "weapon_grenade_launcher");
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iExtraPrimaryAmmo", 0, 4, 0);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", 100, 4, 0);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 1, 4, 0);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 100, 4, 0);
}

//---===--=====---===---===---===---luckybox---===--=====---===---===---===---//
void lucky(int client)
{
  CheatCMD(client, "give", "health");
  SetEntProp(client, Prop_Send, "m_iHealth", 100, 1);
  SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
  SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
  CleanAura(client);
  CheatCMD(client, "give", "sniper_awp");
  CheatCMD(client, "give", "knife");
  CheatCMD(client, "give", "molotov");
  CheatCMD(client, "give", "first_aid_kit");
  CheatCMD(client, "give", "pain_pills");
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iExtraPrimaryAmmo", 0, 4);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", 10, 4);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 1, 4);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 10, 4);
}

//---===--=====---===---===---===---weaponbox---===--=====---===---===---===---//
void weap(int client)
{
  CheatCMD(client, "give", "health");
  SetEntProp(client, Prop_Send, "m_iHealth", 100, 1);
  SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
  SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
  CleanAura(client);
  CheatCMD(client, "give", "shotgun_spas");
  CheatCMD(client, "give", "katana");
  CheatCMD(client, "give", "molotov");
  CheatCMD(client, "give", "first_aid_kit");
  CheatCMD(client, "give", "pain_pills");
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iExtraPrimaryAmmo", 0, 4);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", 10, 4);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 1, 4);
  SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 10, 4);
}

//---===--=====---===---===---===---lifebox---===--=====---===---===---===---//
void lifes(int client)
{
  CheatCMD(client, "give", "health");
  SetEntProp(client, Prop_Send, "m_iHealth", 100, 1);
  SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
  SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
  SetEntityHealth(client, 200);
  CleanAura(client);
}

//---===--=====---===---===---===---knifebox---===--=====---===---===---===---//
void knifes(int client)
{
  CheatCMD(client, "give", "health");
  SetEntProp(client, Prop_Send, "m_iHealth", 100, 1);
  SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
  SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
  CleanAura(client);
  CheatCMD(client, "give", "knife");
  CheatCMD(client, "give", "molotov");
  CheatCMD(client, "give", "first_aid_kit");
  CheatCMD(client, "give", "pain_pills");
}

//---===--=====---===---===---===---Matrixbox---===--=====---===---===---===---//
public void DoMatrix()
{
  TriggerMatrix();
  if (l4d2_ammo_matrix_glowon)GlowInfected();
}

public void TriggerMatrix()
{
  MatrixOn = true;
  char time[32];
  l4d2_ammo_matrix_ts.GetString(time, sizeof(time));
  int i_Ent;
  i_Ent = CreateEntityByName("func_timescale");
  DispatchKeyValue(i_Ent, "desiredTimescale", time);
  DispatchKeyValue(i_Ent, "acceleration", "1.0");
  DispatchKeyValue(i_Ent, "minBlendRate", "0.1");
  DispatchKeyValue(i_Ent, "blendDeltaMultiplier", "1.0");
  DispatchSpawn(i_Ent);
  AcceptEntityInput(i_Ent, "Start");
  DataPack h_pack = new DataPack();
  h_pack.WriteCell(i_Ent);
  CreateTimer(l4d2_ammo_matrix_timer2.FloatValue, RestoreTime, h_pack);
}

public Action RestoreTime(Handle Timer, DataPack h_pack)
{
  if (MatrixOn)
  {
    int i_Ent;
    h_pack.Reset(false);
    i_Ent = h_pack.ReadCell();
    delete h_pack;
    if (IsValidEdict(i_Ent))
    {
      AcceptEntityInput(i_Ent, "Stop");
      MatrixOn = false;
      if (l4d2_ammo_matrix_glowon.IntValue)
      {
        RemoveGlow();
        RestoreBW();
      }
    }
    else
    {
      PrintToServer("[SM] i_Ent is not a valid edict!");
      MatrixOn = false;
      if (l4d2_ammo_matrix_glowon.IntValue)
      {
        RemoveGlow();
        RestoreBW();
      }
    }
  }
  else
  {
    PrintToServer("Restore time was triggered, but MatrixOn returned false"); //Probably never gonna happen, but you never know
  }
}

public void GlowInfected()
{
  g_bGlow = true;
  CreateTimer(0.1, GlowInfectedFunc, _, TIMER_REPEAT);
  CreateTimer(0.5, GlowBossesFunc, _, TIMER_REPEAT);
}

public Action GlowInfectedFunc(Handle timer)
{
  if (!g_bGlow)return Plugin_Stop;
  
  int c2;
  int c3;
  c2 = l4d2_ammo_matrix_colormobs.IntValue;
  c3 = l4d2_ammo_matrix_colorwitch.IntValue;
  int iMaxEntities = GetMaxEntities();
  for (int iEntity = MaxClients + 1; iEntity < iMaxEntities; iEntity++)
  {
    if (IsCommonInfected(iEntity))
    {
      SetEntProp(iEntity, Prop_Send, "m_iGlowType", 3, 1);
      SetEntProp(iEntity, Prop_Send, "m_glowColorOverride", c2, 1);
    }
    else if (IsWitch(iEntity))
    {
      SetEntProp(iEntity, Prop_Send, "m_iGlowType", 3, 1);
      SetEntProp(iEntity, Prop_Send, "m_glowColorOverride", c3, 1);
    }
  }
  
  return Plugin_Continue;
}

public Action GlowBossesFunc(Handle timer)
{
  if (!g_bGlow)return Plugin_Stop;
  
  int c1;
  c1 = l4d2_ammo_matrix_colorbosses.IntValue;
  
  PropGhost = FindSendPropInfo("CTerrorPlayer", "m_isGhost");
  
  for (int iClient = 1; iClient <= MaxClients; iClient++)
  {
    if (IsClientInGame(iClient) && IsPlayerAlive(iClient) && GetClientTeam(iClient) == 3 && GetEntData(iClient, PropGhost, 1) != 1)
    {
      SetEntProp(iClient, Prop_Send, "m_iGlowType", 3);
      SetEntProp(iClient, Prop_Send, "m_glowColorOverride", c1);
    }
    else if (IsClientInGame(iClient))
    {
      SetEntProp(iClient, Prop_Send, "m_iGlowType", 0);
      SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 0);
    }
  }
  
  return Plugin_Continue;
}

/**
* This glow works just when matrixbox it's working
*/
public void RemoveGlow()
{
  g_bGlow = false;
  
  int iMaxEntities = GetMaxEntities();
  for (int iEntity = MaxClients + 1; iEntity < iMaxEntities; iEntity++)
  {
    if (IsCommonInfected(iEntity))
    {
      SetEntProp(iEntity, Prop_Send, "m_iGlowType", 0, 1);
      SetEntProp(iEntity, Prop_Send, "m_glowColorOverride", 0, 1);
    }
    else if (IsWitch(iEntity))
    {
      SetEntProp(iEntity, Prop_Send, "m_iGlowType", 0, 1);
      SetEntProp(iEntity, Prop_Send, "m_glowColorOverride", 0, 1);
    }
  }
  
  for (int iClient = 1; iClient <= MaxClients; iClient++)
  {
    if (IsClientInGame(iClient) && IsPlayerAlive(iClient) && GetClientTeam(iClient) == 3)
    {
      SetEntProp(iClient, Prop_Send, "m_iGlowType", 0);
      SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 0);
    }
  }
}


public Action Deathbox(Handle timer) {
  float time = 0.0;
  EmitSoundToAll(DeathBoxSounds[1]);
  for (int i = 1; i <= MaxClients; i++) {
    if (IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && CheckCommandAccess(i, "sm_fk", ADMFLAG_RESERVATION, true)) {
      time += 1.0;
      CreateTimer(time, WillDie, i);
    }
  }
  return Plugin_Handled;
}

public Action WillDie(Handle timer, any client) {
  switch (GetRandomInt(0, 2)) {
    case 0: {
      ForcePlayerSuicide(client);
      CPrintToChat(client, "\x04[\x05DEATHBOX\x04]{default} Game over man,{blue} GAME OVER!");
    }
  }
}
//========Jack in the box ** seccion===========================================//
public Action JackInTheBox(Handle timer)
{
  float tiempo = 0.0;
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
    {
      tiempo += 1.0;
      CreateTimer(tiempo, YouWithLucky, i);
    }
  }
  return Plugin_Stop;
}
public Action YouWithLucky(Handle timer, any client) {
  int random = GetRandomInt(0, 4);
  switch (random) {
    case 1, 2: {
      EmitSoundToClient(client, JackInTheBoxSounds[random]);
      ServerCommand("sm_givepoints #%d %d", GetClientUserId(client), GetRandomInt(10, 100));
      CPrintToChat(client, "\x04[\x05JiB\x04]{default} You were born with {blue}lucky!");
    }
    case 3: {
      EmitSoundToClient(client, JackInTheBoxSounds[random]);
      ForcePlayerSuicide(client);
      CPrintToChat(client, "\x04[\x05JiB\x04]{default} Game over man,{blue} GAME OVER!");
    }
    default: {
      EmitSoundToClient(client, JackInTheBoxSounds[random]);
      CPrintToChat(client, "\x04[\x05JiB\x04]{default} Hmmm, and who are you?");
    }
  }
}
//========jackpotbox ** seccion===========================================//
public Action Jackpotbox(Handle timer)
{
  float time = 0.0;
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
    {
      time += 0.5;
      CreateTimer(time, JackpotboxPoints, i);
    }
  }
  return Plugin_Handled;
}

public Action JackpotboxPoints(Handle timer, any client) {
  switch (GetRandomInt(0, 3)) {
    case 0: {
      EmitSoundToAll(JACKPOTBOX);
      ServerCommand("sm_givepoints #%d %d", GetClientUserId(client), GetRandomInt(10, 50));
      PrintToChat(client, "\x04[\x05jackpotbox\x04]\x05 You were born with lucky!");
    }
    default: {
      PrintToChat(client, "\x04[\x05jackpotbox\x04]\x05 Good try\x04 maybe the next time...");
    }
  }
}
// ==========================================================================================

//---===--=====---===---===---===---Barrelbox---===--=====---===---===---===---//
void StartBarrel(int client)
{
  if (g_bBarrelRain)return;
  float g_pos[3];
  GetClientAbsOrigin(client, g_pos);
  DataPack h = new DataPack();
  h.WriteFloat(g_pos[0]);
  h.WriteFloat(g_pos[1]);
  h.WriteFloat(g_pos[2]);
  h.WriteFloat(GetEngineTime());
  g_bBarrelRain = true;
  CreateTimer(1.5, UpdateBarrel, h, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action UpdateBarrel(Handle timer, DataPack h)
{
  h.Reset();
  float g_pos[3];
  g_pos[0] = h.ReadFloat();
  g_pos[1] = h.ReadFloat();
  g_pos[2] = h.ReadFloat();
  float time = h.ReadFloat();
  
  if (GetEngineTime() - time > l4d2_ammo_barrel_duration.FloatValue)
  {
    g_bBarrelRain = false;
    h.Close();
    return Plugin_Stop;
  }
  
  if (GetRandomInt(1, 2) == 1)
  {
    //EmitSoundToAll(F18_Sounds[GetRandomInt(0, 5)], -2, 0, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
    float vPos[3];
    int entity = CreateEntityByName("prop_dynamic_override");
    DispatchKeyValue(entity, "targetname", "silver_f18_model");
    DispatchKeyValue(entity, "disableshadows", "1");
    DispatchKeyValue(entity, "model", "models/f18/f18_sb.mdl");
    DispatchSpawn(entity);
    vPos[0] = g_pos[0];
    vPos[1] = g_pos[1];
    vPos[2] = g_pos[2] + 1000.0;
    TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
    SetEntPropFloat(entity, Prop_Send, "m_flModelScale", 5.0, 0);
    int random = GetRandomInt(1, 5);
    if (random == 1)SetVariantString("flyby1");
    else if (random == 2)SetVariantString("flyby2");
    else if (random == 3)SetVariantString("flyby3");
    else if (random == 4)SetVariantString("flyby4");
    else if (random == 5)SetVariantString("flyby5");
    AcceptEntityInput(entity, "SetAnimation");
    AcceptEntityInput(entity, "Enable");
    
    SetVariantString("OnUser1 !self:Kill::6.5.0:1");
    AcceptEntityInput(entity, "AddOutput");
    AcceptEntityInput(entity, "FireUser1");
    
    EmitSoundToAll(F18_Sounds[GetRandomInt(0, 5)], entity, SNDCHAN_AUTO, SNDLEVEL_HELICOPTER);
  }
  
  int ent = CreateEntityByName("prop_fuel_barrel"); //Special prop type for the barrel
  DispatchKeyValue(ent, "model", "models/props_industrial/barrel_fuel.mdl");
  DispatchKeyValue(ent, "BasePiece", "models/props_industrial/barrel_fuel_partb.mdl");
  DispatchKeyValue(ent, "FlyingPiece01", "models/props_industrial/barrel_fuel_parta.mdl"); //FlyingPiece01 - FlyingPiece04 are supported
  DispatchKeyValue(ent, "DetonateParticles", "weapon_pipebomb"); //Particles to use, weapon_vomitjar might work haven't tested
  DispatchKeyValue(ent, "FlyingParticles", "barrel_fly"); //Particles to use, I have never successfully gotten a list of L4D2 particle names yet
  DispatchKeyValue(ent, "DetonateSound", "BaseGrenade.Explode"); //Scene File name 
  DispatchSpawn(ent);
  
  g_pos[2] += 500.0;
  float radius = l4d2_ammo_barrel_radius.FloatValue;
  g_pos[0] += GetRandomFloat(radius * -1, radius);
  g_pos[1] += GetRandomFloat(radius * -1, radius);
  TeleportEntity(ent, g_pos, NULL_VECTOR, NULL_VECTOR);
  SetEntityGravity(ent, 0.1);
  IgniteEntity(ent, 5.0);
  
  return Plugin_Continue;
}

//---===--=====---===---===---===---Airstrikebox---===--=====---===---===---===---//
void StartAirstrike(int client)
{
  if (g_bAirstrike)return;
  float g_pos[3];
  float vAng[3];
  GetClientAbsOrigin(client, g_pos);
  GetClientEyeAngles(client, vAng);
  
  DataPack h = new DataPack();
  h.WriteFloat(g_pos[0]);
  h.WriteFloat(g_pos[1]);
  h.WriteFloat(g_pos[2]);
  h.WriteFloat(vAng[1]);
  h.WriteFloat(GetEngineTime());
  g_bAirstrike = true;
  CreateTimer(1.5, UpdateAirstrike, h, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action UpdateAirstrike(Handle timer, DataPack h)
{
  h.Reset();
  float g_pos[3];
  float vAng[3];
  g_pos[0] = h.ReadFloat();
  g_pos[1] = h.ReadFloat();
  g_pos[2] = h.ReadFloat();
  vAng[1] = h.ReadFloat();
  float time = h.ReadFloat();
  
  if (GetEngineTime() - time > l4d2_ammo_airstrike_duration.FloatValue)
  {
    g_bAirstrike = false;
    h.Close();
    return Plugin_Stop;
  }
  
  g_pos[2] += 1.0;
  float radius = l4d2_ammo_airstrike_radius.FloatValue;
  g_pos[0] += GetRandomFloat(radius * -1, radius);
  g_pos[1] += GetRandomFloat(radius * -1, radius);
  vAng[1] += GetRandomFloat(radius * -1, radius);
  ShowAirstrike(g_pos, vAng[1]);
  
  return Plugin_Continue;
}

void ShowAirstrike(float vPos[3], float direction)
{
  int index = -1;
  for (int i = 0; i < MAX_ENTITIES; i++)
  {
    if (IsValidEntRef(g_iEntities[i]) == false)
    {
      index = i;
      break;
    }
  }
  
  if (index == -1)return;
  
  float vAng[3];
  float vSkybox[3];
  vAng[0] = 0.0;
  vAng[1] = direction;
  vAng[2] = 0.0;
  
  GetEntPropVector(0, Prop_Data, "m_WorldMaxs", vSkybox);
  
  int entity = CreateEntityByName("prop_dynamic_override");
  g_iEntities[index] = EntIndexToEntRef(entity);
  DispatchKeyValue(entity, "targetname", "silver_f18_model");
  DispatchKeyValue(entity, "disableshadows", "1");
  DispatchKeyValue(entity, "model", "models/f18/f18_sb.mdl");
  DispatchSpawn(entity);
  SetEntProp(entity, Prop_Data, "m_iHammerID", RoundToNearest(vPos[2]));
  float height = vPos[2] + 1000.0;
  if (height > vSkybox[2] - 200)vPos[2] = vSkybox[2] - 200;
  else vPos[2] = height;
  TeleportEntity(entity, vPos, vAng, NULL_VECTOR);
  
  SetEntPropFloat(entity, Prop_Send, "m_flModelScale", 5.0);
  
  int random = GetRandomInt(1, 5);
  if (random == 1)SetVariantString("flyby1");
  else if (random == 2)SetVariantString("flyby2");
  else if (random == 3)SetVariantString("flyby3");
  else if (random == 4)SetVariantString("flyby4");
  else if (random == 5)SetVariantString("flyby5");
  AcceptEntityInput(entity, "SetAnimation");
  AcceptEntityInput(entity, "Enable");
  
  SetVariantString("OnUser1 !self:Kill::6.5.0:1");
  AcceptEntityInput(entity, "AddOutput");
  AcceptEntityInput(entity, "FireUser1");
  
  CreateTimer(1.5, tmrDrop, EntIndexToEntRef(entity));
}

public Action tmrDrop(Handle timer, any f18)
{
  if (IsValidEntRef(f18))
  {
    float g_cvarRadiusF18 = 950.0;
    float vPos[3];
    float vAng[3];
    float vVec[3];
    GetEntPropVector(f18, Prop_Data, "m_vecAbsOrigin", vPos);
    GetEntPropVector(f18, Prop_Data, "m_angRotation", vAng);
    
    int entity = CreateEntityByName("grenade_launcher_projectile");
    DispatchSpawn(entity);
    SetEntityModel(entity, "models/missiles/f18_agm65maverick.mdl");
    
    SetEntityMoveType(entity, MOVETYPE_NOCLIP);
    CreateTimer(0.9, TimerGrav, EntIndexToEntRef(entity));
    
    GetAngleVectors(vAng, vVec, NULL_VECTOR, NULL_VECTOR);
    NormalizeVector(vVec, vVec);
    ScaleVector(vVec, -800.0);
    
    MoveForward(vPos, vAng, vPos, 2400.0);
    
    vPos[0] += GetRandomFloat(-1.0 * g_cvarRadiusF18, g_cvarRadiusF18);
    vPos[1] += GetRandomFloat(-1.0 * g_cvarRadiusF18, g_cvarRadiusF18);
    TeleportEntity(entity, vPos, vAng, vVec);
    // Accelerator code start
    SDKHook(entity, SDKHook_Touch, OnBombTouch);
    // Accelerator code end
    
    SetVariantString("OnUser1 !self:Kill::10.0:1");
    AcceptEntityInput(entity, "AddOutput");
    AcceptEntityInput(entity, "FireUser1");
    
    SetEntPropFloat(entity, Prop_Send, "m_flModelScale", 0.3);
    
    int projectile = entity;
    // BLUE FLAMES
    entity = CreateEntityByName("info_particle_system");
    if (entity != -1)
    {
      DispatchKeyValue(entity, "effect_name", "flame_blue");
      DispatchSpawn(entity);
      ActivateEntity(entity);
      TeleportEntity(entity, vPos, vAng, NULL_VECTOR);
      
      SetVariantString("!activator");
      AcceptEntityInput(entity, "SetParent", projectile);
      
      SetVariantString("OnUser4 !self:Kill::10.0:1");
      AcceptEntityInput(entity, "AddOutput");
      AcceptEntityInput(entity, "FireUser4");
      AcceptEntityInput(entity, "Start");
    }
    // FLAMES
    entity = CreateEntityByName("info_particle_system");
    if (entity != -1)
    {
      DispatchKeyValue(entity, "effect_name", "fire_medium_01");
      DispatchSpawn(entity);
      ActivateEntity(entity);
      TeleportEntity(entity, vPos, vAng, NULL_VECTOR);
      
      SetVariantString("!activator");
      AcceptEntityInput(entity, "SetParent", projectile);
      
      SetVariantString("OnUser4 !self:Kill::10.0:1");
      AcceptEntityInput(entity, "AddOutput");
      AcceptEntityInput(entity, "FireUser4");
      AcceptEntityInput(entity, "Start");
    }
    
    // SPARKS
    entity = CreateEntityByName("info_particle_system");
    if (entity != -1)
    {
      DispatchKeyValue(entity, "effect_name", "fireworks_sparkshower_01e");
      DispatchSpawn(entity);
      ActivateEntity(entity);
      TeleportEntity(entity, vPos, vAng, NULL_VECTOR);
      
      SetVariantString("!activator");
      AcceptEntityInput(entity, "SetParent", projectile);
      
      SetVariantString("OnUser4 !self:Kill::10.0:1");
      AcceptEntityInput(entity, "AddOutput");
      AcceptEntityInput(entity, "FireUser4");
      AcceptEntityInput(entity, "Start");
    }
    
    // RPG SMOKE
    entity = CreateEntityByName("info_particle_system");
    if (entity != -1)
    {
      DispatchKeyValue(entity, "effect_name", "rpg_smoke");
      DispatchSpawn(entity);
      ActivateEntity(entity);
      AcceptEntityInput(entity, "start");
      TeleportEntity(entity, vPos, vAng, NULL_VECTOR);
      
      SetVariantString("!activator");
      AcceptEntityInput(entity, "SetParent", projectile);
      
      SetVariantString("OnUser3 !self:Kill::10.0:1");
      AcceptEntityInput(entity, "AddOutput");
      AcceptEntityInput(entity, "FireUser3");
      
      // Refire
      SetVariantString("OnUser1 !self:Stop::0.65:-1");
      AcceptEntityInput(entity, "AddOutput");
      SetVariantString("OnUser1 !self:FireUser2::0.7:-1");
      AcceptEntityInput(entity, "AddOutput");
      AcceptEntityInput(entity, "FireUser1");
      
      SetVariantString("OnUser2 !self:Start::0:-1");
      AcceptEntityInput(entity, "AddOutput");
      SetVariantString("OnUser2 !self:FireUser1::0:-1");
      AcceptEntityInput(entity, "AddOutput");
    }
    
    // SOUND	
    EmitSoundToAll(F18_Sounds[GetRandomInt(0, 5)], entity, SNDCHAN_AUTO, SNDLEVEL_HELICOPTER);
  }
}

public Action TimerGrav(Handle timer, any entity)
{
  if (IsValidEntRef(entity))CreateTimer(0.1, TimerGravity, entity, TIMER_REPEAT);
}

public Action TimerGravity(Handle timer, any entity)
{
  if (IsValidEntRef(entity))
  {
    int tick = GetEntProp(entity, Prop_Data, "m_iHammerID");
    if (tick > 10)
    {
      SetEntityMoveType(entity, MOVETYPE_FLYGRAVITY);
      return Plugin_Stop;
    }
    else
    {
      SetEntProp(entity, Prop_Data, "m_iHammerID", tick + 1);
      
      float vAng[3];
      GetEntPropVector(entity, Prop_Data, "m_vecVelocity", vAng);
      vAng[2] -= 50.0;
      TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, vAng);
      return Plugin_Continue;
    }
  }
  return Plugin_Stop;
}

public Action OnBombTouch(int entity, int activator)
{
  char sTemp[64];
  GetEdictClassname(activator, sTemp, sizeof(sTemp));
  
  if (strcmp(sTemp, "trigger_multiple") && strcmp(sTemp, "trigger_hurt"))
  {
    SDKUnhook(entity, SDKHook_Touch, OnBombTouch);
    
    CreateTimer(0.1, TimerBombTouch, EntIndexToEntRef(entity));
  }
}

public Action TimerBombTouch(Handle timer, any entity)
{
  if (EntRefToEntIndex(entity) == INVALID_ENT_REFERENCE)return;
  
  float vPos[3];
  char sTemp[64];
  int g_iCvarStumble = 400;
  int g_iCvarDamage = 80;
  int g_iCvarDistance = 400;
  int g_iCvarShake = 1000;
  GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", vPos);
  AcceptEntityInput(entity, "Kill");
  IntToString(g_iCvarDamage, sTemp, sizeof(sTemp));
  
  entity = CreateEntityByName("env_explosion");
  DispatchKeyValue(entity, "spawnflags", "1916");
  IntToString(g_iCvarDamage, sTemp, sizeof(sTemp));
  DispatchKeyValue(entity, "iMagnitude", sTemp);
  IntToString(g_iCvarDistance, sTemp, sizeof(sTemp));
  DispatchKeyValue(entity, "iRadiusOverride", sTemp);
  DispatchSpawn(entity);
  TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
  AcceptEntityInput(entity, "Explode");
  
  int shake = CreateEntityByName("env_shake");
  if (shake != -1)
  {
    DispatchKeyValue(shake, "spawnflags", "8");
    DispatchKeyValue(shake, "amplitude", "16.0");
    DispatchKeyValue(shake, "frequency", "1.5");
    DispatchKeyValue(shake, "duration", "0.9");
    IntToString(g_iCvarShake, sTemp, sizeof(sTemp));
    DispatchKeyValue(shake, "radius", sTemp);
    DispatchSpawn(shake);
    ActivateEntity(shake);
    AcceptEntityInput(shake, "Enable");
    
    TeleportEntity(shake, vPos, NULL_VECTOR, NULL_VECTOR);
    AcceptEntityInput(shake, "StartShake");
    
    SetVariantString("OnUser1 !self:Kill::1.1:1");
    AcceptEntityInput(shake, "AddOutput");
    AcceptEntityInput(shake, "FireUser1");
  }
  
  int client;
  float fDistance;
  float fNearest = 1500.0;
  float vPos2[3];
  
  int i = 1;
  while (i <= MaxClients)
  {
    if (IsClientInGame(i) && GetClientTeam(i) == 2 && IsPlayerAlive(i))
    {
      GetClientAbsOrigin(i, vPos2);
      fDistance = GetVectorDistance(vPos, vPos2);
      
      if (fDistance <= fNearest)
      {
        client = i;
        fNearest = fDistance;
      }
      
      if (fDistance <= g_iCvarStumble)
      {
        SDKCall(sdkStaggerPlayer, i, shake, vPos);
        IgnitePlayer(i, 5.0, false);
      }
    }
    i += 1;
  }
  
  if (client)
  {
    Vocalize(client);
  }
  
  entity = CreateEntityByName("info_particle_system");
  if (entity != -1)
  {
    int random = GetRandomInt(1, 4);
    switch(random)
    {
      case 1:
      {
        DispatchKeyValue(entity, "effect_name", EXPLOSION_PARTICLE);
        vPos[2] += 175.0;
      }
      case 2:
      {
        DispatchKeyValue(entity, "effect_name", "missile_hit1");
        vPos[2] += 100.0;
      }
      case 3:
      {
        DispatchKeyValue(entity, "effect_name", "gas_explosion_main");
      }
      case 4:
      {
        DispatchKeyValue(entity, "effect_name", "explosion_huge");
        vPos[2] += 25.0;
      }
    }
    
    DispatchSpawn(entity);
    ActivateEntity(entity);
    AcceptEntityInput(entity, "start");
    
    TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
    
    SetVariantString("OnUser1 !self:Kill::1.0:1");
    AcceptEntityInput(entity, "AddOutput");
    AcceptEntityInput(entity, "FireUser1");
  }
  
  int random = GetRandomInt(0, 2);
  switch(random)
  {
    case 0: EmitSoundToAll(EXPLODE_SOUND_3, entity, SNDCHAN_AUTO, SNDLEVEL_HELICOPTER);
    case 1: EmitSoundToAll(EXPLODE_SOUND_4, entity, SNDCHAN_AUTO, SNDLEVEL_HELICOPTER);
    case 2: EmitSoundToAll(EXPLODE_SOUND_5, entity, SNDCHAN_AUTO, SNDLEVEL_HELICOPTER);
  }
}

void MoveForward(const float vPos[3], const float vAng[3], float vReturn[3], float fDistance)
{
  float vDir[3];
  GetAngleVectors(vAng, vDir, NULL_VECTOR, NULL_VECTOR);
  vReturn = vPos;
  vReturn[0] += vDir[0] * fDistance;
  vReturn[1] += vDir[1] * fDistance;
  vReturn[2] += vDir[2] * fDistance;
}

void Vocalize(int client)
{
  if (GetRandomInt(1, 100) > 70)
  {
    return;
  }
  
  char sTemp[64];
  GetEntPropString(client, Prop_Data, "m_ModelName", sTemp, 64);
  
  int random;

  if (sTemp[26] == 'c') // c = Coach
  {
    random = GetRandomInt(0, 2);
  }
  else if (sTemp[26] == 'g') // g = Gambler
  {
    random = GetRandomInt(3, 6);
  }
  else if (sTemp[26] == 'm' && sTemp[27] == 'e') // me = Mechanic
  {
    random = GetRandomInt(7, 12);
  }
  else if (sTemp[26] == 'p') // p = Producer
  {
    random = GetRandomInt(13, 15);
  }
  else
  {
    return;
  }
  
  int entity = CreateEntityByName("instanced_scripted_scene");
  DispatchKeyValue(entity, "SceneFile", g_sVocalize[random]);
  DispatchSpawn(entity);
  SetEntPropEnt(entity, Prop_Data, "m_hOwner", client);
  ActivateEntity(entity);
  AcceptEntityInput(entity, "Start", client, client);
}

//---===--=====---===---===---===---Flamebox---===--=====---===---===---===---//
void IgnitePlayer(int client, float duration, bool Flame)
{
  int team = GetClientTeam(client);
  if (team != 2)
  {
    IgniteEntity(client, duration);
  }
  else
  {
    float pos[3];
    GetClientAbsOrigin(client, pos);
    char sUser[256];
    IntToString(GetClientUserId(client) + 25, sUser, sizeof(sUser));
    CreateParticle(client, FIRESMALL_PARTICLE, true, duration);
    int Damage = CreateEntityByName("point_hurt");
    if (IsIncapacitated(client))
    {
      DispatchKeyValue(Damage, "Damage", "4");
    }
    else
    {
      DispatchKeyValue(Damage, "Damage", "1");
    }
    DispatchKeyValue(Damage, "DamageType", "8");
    DispatchKeyValue(client, "targetname", sUser);
    DispatchKeyValue(Damage, "DamageTarget", sUser);
    DispatchSpawn(Damage);
    TeleportEntity(Damage, pos, NULL_VECTOR, NULL_VECTOR);
    AcceptEntityInput(Damage, "Hurt");
    if (Flame)
    {
      SetEntityHealth(client, 150);
      SetTempHealth(client, 0);
      ChangeSpeed(client, 2.0);
    }
    CreateTimer(0.1, timerHurtMe, Damage, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
    CreateTimer(duration, timerResetSpeed, client, TIMER_FLAG_NO_MAPCHANGE);
    CreateTimer(duration, timerStopAndRemoveParticle, Damage, TIMER_FLAG_NO_MAPCHANGE);
  }
}

public Action timerHurtMe(Handle timer, any hurt)
{
  if (IsValidEntity(hurt) && IsValidEdict(hurt))
  {
    AcceptEntityInput(hurt, "Hurt");
    return Plugin_Continue;
  }
  return Plugin_Stop;
}

public Action timerResetSpeed(Handle timer, any client)
{
  ChangeSpeed(client, 1.0);
}

void ChangeSpeed(int target, float newspeed)
{
  if (!IsValidEntity(target))
  {
    return;
  }
  SetEntPropFloat(target, Prop_Data, "m_flLaggedMovementValue", newspeed);
}

public Action timerStopAndRemoveParticle(Handle timer, any entity)
{
  if (entity > 0 && IsValidEntity(entity) && IsValidEdict(entity))
  {
    AcceptEntityInput(entity, "Kill");
  }
}

//---===--=====---===---===---===---Meteorbox---===--=====---===---===---===---//
void StartMeteorFall(int client)
{
  if (g_bMeterRain)return;
  float pos[3];
  float vSkybox[3];
  GetClientEyePosition(client, pos);
  GetEntPropVector(0, Prop_Data, "m_WorldMaxs", vSkybox);
  
  float height = pos[2] + 600.0;
  if (height > vSkybox[2] - 100)pos[2] = vSkybox[2] - 100;
  else pos[2] = height;
  
  DataPack h = new DataPack();
  h.WriteFloat(pos[0]);
  h.WriteFloat(pos[1]);
  h.WriteFloat(pos[2]);
  h.WriteFloat(GetEngineTime());
  g_bMeterRain = true;
  g_iMeteorTick = 0;
  
  CreateTimer(0.5, UpdateMeteorFall, h, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action UpdateMeteorFall(Handle timer, DataPack h)
{
  h.Reset();
  float pos[3];
  
  pos[0] = h.ReadFloat();
  pos[1] = h.ReadFloat();
  pos[2] = h.ReadFloat();
  
  float time = h.ReadFloat();
  
  if ((GetEngineTime() - time) > (l4d2_ammo_meteor_duration.FloatValue + 1.0))
  {
    g_bMeterRain = false;
    g_iMeteorTick = 0;
    h.Close();
    return Plugin_Stop;
  }
  
  if (g_iMeteorTick == 0 || (g_iMeteorTick % 2) == 0)
  {
    int ent = CreateEntityByName("tank_rock");
    if (ent > 0)
    {
      DispatchKeyValue(ent, "model", "models/props_debris/concrete_chunk01a.mdl");
      DispatchSpawn(ent);
      float angle[3];
      float velocity[3];
      float radius = l4d2_ammo_meteor_radius.FloatValue;
      
      pos[0] += GetRandomFloat(radius * -1, radius);
      pos[1] += GetRandomFloat(radius * -1, radius);
      
      angle[0] = GetRandomFloat(-180.0, 180.0);
      angle[1] = GetRandomFloat(-180.0, 180.0);
      angle[2] = GetRandomFloat(-180.0, 180.0);
      
      velocity[0] = GetRandomFloat(0.0, 350.0);
      velocity[1] = GetRandomFloat(0.0, 350.0);
      velocity[2] = GetRandomFloat(0.0, 30.0);
      
      TeleportEntity(ent, pos, angle, velocity);
      ActivateEntity(ent);
      
      AcceptEntityInput(ent, "Ignite");
    }
  }
  
  int entity = -1;
  
  while ((entity = FindEntityByClassname(entity, "tank_rock")) != INVALID_ENT_REFERENCE)
  {
    if (OnGroundUnits(entity) < 150.0)ExplodeMeteor(entity);
  }
  
  g_iMeteorTick++;
  
  return Plugin_Continue;
}

float OnGroundUnits(int i_Ent)
{
  if (!(GetEntityFlags(i_Ent) & (FL_ONGROUND)))
  {
    float f_Origin[3];
    float f_Position[3];
    float f_Down[3] =  { 90.0, 0.0, 0.0 };
    
    GetEntPropVector(i_Ent, Prop_Send, "m_vecOrigin", f_Origin);
    Handle h_Trace = TR_TraceRayFilterEx(f_Origin, f_Down, CONTENTS_SOLID | CONTENTS_MOVEABLE, RayType_Infinite, TraceRayDontHitSelfAndLive, i_Ent);
    
    if (TR_DidHit(h_Trace))
    {
      float f_Units;
      TR_GetEndPosition(f_Position, h_Trace);
      
      f_Units = f_Origin[2] - f_Position[2];
      
      h_Trace.Close();
      
      return f_Units;
    }
    h_Trace.Close();
  }
  
  return 0.0;
}

void ExplodeMeteor(int entity)
{
  if (IsValidEntity(entity))
  {
    char classname[20];
    GetEdictClassname(entity, classname, 20);
    if (!StrEqual(classname, "tank_rock", true))return;
    
    float pos[3];
    GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
    pos[2] += 50.0;
    AcceptEntityInput(entity, "Kill");
    
    int ent = CreateEntityByName("prop_physics");
    DispatchKeyValue(ent, "model", "models/props_junk/propanecanister001a.mdl");
    DispatchSpawn(ent);
    TeleportEntity(ent, pos, NULL_VECTOR, NULL_VECTOR);
    ActivateEntity(ent);
    AcceptEntityInput(ent, "Break");
    
    float damage = l4d2_ammo_meteor_explode_damage.FloatValue;
    float radius = l4d2_ammo_meteor_explode_radius.FloatValue;
    
    int pointHurt = CreateEntityByName("point_hurt");
    DispatchKeyValueFloat(pointHurt, "Damage", damage);
    DispatchKeyValue(pointHurt, "DamageType", "2");
    DispatchKeyValue(pointHurt, "DamageDelay", "0.0");
    DispatchKeyValueFloat(pointHurt, "DamageRadius", radius);
    DispatchSpawn(pointHurt);
    TeleportEntity(pointHurt, pos, NULL_VECTOR, NULL_VECTOR);
    CreateTimer(0.1, DeletePointHurt, pointHurt, TIMER_FLAG_NO_MAPCHANGE);
    
    int push = CreateEntityByName("point_push");
    DispatchKeyValueFloat(push, "magnitude", 600.0);
    DispatchKeyValueFloat(push, "radius", radius * 1.0);
    SetVariantString("spawnflags 24");
    AcceptEntityInput(push, "AddOutput");
    DispatchSpawn(push);
    TeleportEntity(push, pos, NULL_VECTOR, NULL_VECTOR);
    AcceptEntityInput(push, "Enable", -1, -1);
    ExplosionEffect(pos);
    CreateTimer(0.5, DeletePushForce, push, TIMER_FLAG_NO_MAPCHANGE);
  }
}

void ExplosionEffect(float pos[3]) // Взрыв
{  //pos - точка взрыва, g_ExplosionSprite - прекэшнутый спрайт взрыва,
  TE_SetupExplosion(pos, g_ExplosionSprite, 10.0, 1, 0, 200, 5000); // 10.0 - растяжение спрайта, 100 - радиус взрыва, 5000 - магнитуда взрыва
  TE_SendToAll(); // Применяем
}

public Action DeletePushForce(Handle timer, any ent)
{
  if (IsValidEntity(ent))
  {
    char classname[64];
    GetEdictClassname(ent, classname, sizeof(classname));
    if (StrEqual(classname, "point_push", false))
    {
      AcceptEntityInput(ent, "Disable");
      AcceptEntityInput(ent, "Kill");
      RemoveEdict(ent);
    }
  }
}

public Action DeletePointHurt(Handle timer, any ent)
{
  if (IsValidEntity(ent))
  {
    char classname[64];
    GetEdictClassname(ent, classname, sizeof(classname));
    if (StrEqual(classname, "point_hurt", false))
    {
      AcceptEntityInput(ent, "Kill");
      RemoveEdict(ent);
    }
  }
}

//---===--=====---===---===---===---Hellbox---===--=====---===---===---===---//
public void TimedAirStrike(int client)
{
  g_bRing = true;
  CreateTimer(0.2, timerRing, client, TIMER_REPEAT);
  CreateTimer(9.0, timerRingTimeout);
  CreateTimer(7.0, timerStartStrike, client);
}

public Action timerStartStrike(Handle timer, any client)
{
  Airstrike2(client);
  return Plugin_Continue;
}

public Action timerRing(Handle timer, any client)
{
  if (!g_bRing)return Plugin_Stop;
  if (client == 0)return Plugin_Stop;
  CreateRingEffect(client, 250, 20, 200, 255, 2.0);
  float vec[3];
  GetClientAbsOrigin(client, vec);
  vec[2] += 10;
  EmitAmbientSound(SOUND_BLIP, vec, client, SNDLEVEL_RAIDSIREN);
  return Plugin_Continue;
}

public Action timerRingTimeout(Handle timer)
{
  g_bRing = false;
}

void Airstrike2(int client)
{
  g_bStrike2 = true;
  CreateTimer(1.7, timerStrike2, client, TIMER_REPEAT);
  CreateTimer(8.8, timerStrikeTimeout2);
}

public Action timerStrikeTimeout2(Handle timer)
{
  g_bStrike2 = false;
}

public Action timerStrike2(Handle timer, any client)
{
  if (!g_bStrike2) return Plugin_Stop;
  if (client == 0)return Plugin_Stop;
  if (!IsPlayerAlive(client))return Plugin_Stop;
  
  float position[3];
  GetClientAbsOrigin(client, position);
  float radius = g_cvarExplosionRadius;
  position[0] += GetRandomFloat(radius * -1, radius);
  position[1] += GetRandomFloat(radius * -1, radius);
  EmitSoundToAll(EXPLOSION_SOUND);
  ChargeCircle(client, position);
  Boom2(position);
  Fire(position);
  return Plugin_Continue;
}

public void ChargeCircle(int client, float position[3])
{
  float client_pos[3];
  GetClientEyePosition(client, position);
  EmitAmbientSound(SOUND_IMPACT03, position);
  
  for (int i = 1; i <= MaxClients; i++)
  {
    if (!IsClientInGame(i) || !IsPlayerAlive(i))continue;
    GetClientEyePosition(i, client_pos);
    if (GetVectorDistance(position, client_pos) < g_cvarExplosionRadius)
    {
      if (GetEntProp(i, Prop_Send, "m_zombieClass") != 8)Charge(i);
    }
  }
  
  char mName[64];
  float entPos[3];
  
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsValidEdict(i) && IsValidEntity(i))
    {
      GetEntPropString(i, Prop_Data, "m_ModelName", mName, sizeof(mName));
      if (StrContains(mName, "infected") != -1)
      {
        GetEntPropVector(i, Prop_Send, "m_vecOrigin", entPos);
        if (GetVectorDistance(position, entPos) < l4d2_explosion_radius)Charge(i);
      }
    }
  }
}

void Charge(int client)
{
  float tpos[3];
  float spos[3];
  float distance[3];
  float ratio[3];
  float addVel[3];
  float tvec[3];
  
  GetClientAbsOrigin(client, tpos);
  distance[0] = (spos[0] - tpos[0]);
  distance[1] = (spos[1] - tpos[1]);
  distance[2] = (spos[2] - tpos[2]);
  GetEntPropVector(client, Prop_Data, "m_vecVelocity", tvec);
  ratio[0] = distance[0] / SquareRoot(distance[1] * distance[1] + distance[0] * distance[0]); //Ratio x/hypo
  ratio[1] = distance[1] / SquareRoot(distance[1] * distance[1] + distance[0] * distance[0]); //Ratio y/hypo
  
  addVel[0] = ratio[0] * -1 * 500.0;
  addVel[1] = ratio[1] * -1 * 500.0;
  addVel[2] = 500.0;
  SDKCall(sdkCallPushPlayer, client, addVel, 76, client, 7.0);
}

//---===--=====---===---===---===---Respawnbox---===--=====---===---===---===---//
void RespawnWithMelee(int client, int target)
{
  SDKCall(sdkRoundRespawn, target);
  PerformTeleport(client, target);
  CreateTimer(0.2, TimerIncap, target);
  CreateTimer(0.3, TimerRevive, target);
  CreateTimer(0.4, TimerSetHP, target);
  CreateTimer(3.1, TimerMortal, target);
}

public Action TimerIncap(Handle timer, any client)
{
  if (IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client))
  {
    IncapPlayer(client);
  }
}

public Action TimerRevive(Handle timer, any client)
{
  if (IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client))
  {
    SDKCall(sdkRevive, client);
  }
}

public Action TimerSetHP(Handle timer, any client)
{
  if (IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client))
  {
    CheatCMD(client, "give", "health");
    SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
    SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
    SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
    SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
    SetEntProp(client, Prop_Send, "m_iHealth", 50, 1);
    RemoveTempHealth(client);
    SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);
  }
}

public Action TimerMortal(Handle timer, any client)
{
  if (IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client))
  {
    SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
  }
}

void PerformTeleport(int client, int target)
{
  float pOs2[3];
  GetClientAbsOrigin(client, pOs2);
  TeleportEntity(target, pOs2, NULL_VECTOR, NULL_VECTOR);
}

void IncapPlayer(int client)
{
  if (client == 0)return;
  if (GetClientTeam(client) != 2)return;
  if (!IsPlayerAlive(client))return;
  if (GetEntProp(client, Prop_Send, "m_isIncapacitated") == 1)return;
  
  if (IsValidEntity(client))
  {
    int iDmgEntity = CreateEntityByName("point_hurt");
    SetEntityHealth(client, 1);
    DispatchKeyValue(client, "targetname", "bm_target");
    DispatchKeyValue(iDmgEntity, "DamageTarget", "bm_target");
    DispatchKeyValue(iDmgEntity, "Damage", "100");
    DispatchKeyValue(iDmgEntity, "DamageType", "0");
    DispatchSpawn(iDmgEntity);
    AcceptEntityInput(iDmgEntity, "Hurt", client);
    DispatchKeyValue(client, "targetname", "bm_targetoff");
    RemoveEdict(iDmgEntity);
  }
}

//---===--=====---===---===---===---Lightningbox---===--=====---===---===---===---//
public void Lightning(int client)
{
  int victim = client;
  int attacker = client;
  ClearLightning(attacker);
  iLightning[attacker][victim] = 1;
  iLightning[attacker][attacker] = 1;
  Victim[attacker] = victim;
  AttackerTime[attacker] = GetEngineTime();
  ShowEffectToPlayer(attacker, victim);
  CreateTimer(1.0, ScanPlayer, attacker, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}

void ShowEffectToPlayer(int attacker, int victim)
{
  float pos1[3];
  float pos2[3];
  GetClientEyePosition(victim, pos1);
  GetClientEyePosition(attacker, pos2);
  DamageEffects(victim, l4d2_ammo_lightning_damage1);
  float life = 0.2;
  float width1 = 5.0;
  ShowParticle(pos1, "electrical_arc_01_system", 0.5);
  ShowLightning(pos1);
  TE_SetupBeamPoints(pos1, pos2, g_BeamSprite, 0, 0, 0, life, width1, width1, 1, 0.0, whiteColor, 0);
  TE_SendToAll();
  EmitSoundToAll(LINGHNING2, 0, SNDCHAN_WEAPON, SNDLEVEL_TRAFFIC, SND_NOFLAGS, SNDVOL_NORMAL, 100, _, pos1, NULL_VECTOR, false, 0.0);
  ClientCommand(victim, "vocalize PlayerDeath");
}

void ShowLightning(float pos1[3])
{
  int randomx = GetRandomInt(-500, 500); // Получаем случайные позиции Х и У, чтобы молния не была однобокой
  int randomy = GetRandomInt(-500, 500);
  
  //Получаем верхнюю точку молнии. Она будет рандомная по Х и У и выше нижней позиции на 800, чтобы молния била сверху вниз
  float startpos[3];
  startpos[0] = pos1[0] + randomx;
  startpos[1] = pos1[1] + randomy;
  startpos[2] = pos1[2] + 800;
  
  //Делаем	цвет молнии (у нас синий)
  int color[4] =  { 0, 0, 200, 255 };
  
  //Делаем направление искр (к началу координат карты)
  float dir[3] =  { 0.0, 0.0, 0.0 };
  
  TE_SetupBeamPoints(startpos, pos1, g_BeamSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 2.0, color, 3); //Делаем лазер с амплитудой в 2 единицы
  TE_SendToAll(); // Применяем
  
  TE_SetupBeamPoints(startpos, pos1, g_BeamSprite, 0, 0, 0, 0.2, 10.0, 5.0, 0, 1.0, { 255, 255, 255, 255 }, 3); //Делаем второй лазер (белый) с амплитудой в 1 единицу
  TE_SendToAll(); // Применяем																																							 //И в 2 раза уже, чтобы молния смотрелась органично
  
  TE_SetupSparks(pos1, dir, 5000, 1000); //Делаем искры
  TE_SendToAll(); // Применяем
  
  TE_SetupEnergySplash(pos1, dir, false); //Делаем всплеск энергии
  TE_SendToAll(); // Применяем
  
  TE_SetupSmoke(pos1, g_SteamSprite, 5.0, 10); //Делаем дым
  TE_SendToAll(); // Применяем
  
  //Можно добавить маяк, если хотите. 
  TE_SetupBeamRingPoint(pos1, 10.0, 70.0, g_BeamSprite, g_HaloSprite, 0, 15, 15.0, 2.0, 0.0, {255, 255, 0, 255}, 10, 0);
  TE_SendToAll();
}

public Action ScanPlayer(Handle timer, any attacker)
{
  float time = AttackerTime[attacker];
  int victim = Victim[attacker];
  if ((GetEngineTime() - time) > l4d2_ammo_lightning_life.FloatValue)
  {
    ClearLightning(attacker);
    return Plugin_Stop;
  }
  if (victim > 0 && IsClientInGame(victim))
  {
    int v = SearchVictim(victim, attacker);
    if (v > 0)
    {
      Victim[attacker] = v;
      iLightning[attacker][v] = 1;
      ShowEffectToPlayer(victim, v);
    }
    else if (v == 0)
    {
      float pos[3];
      GetClientEyePosition(victim, pos);
      pos[2] -= 15.0;
      ShowParticle(pos, "electrical_arc_01_system", 0.5);
      ShowLightning(pos);
      EmitSoundToAll(LINGHNING2, 0, SNDCHAN_WEAPON, SNDLEVEL_TRAFFIC, SND_NOFLAGS, SNDVOL_NORMAL, 100, _, pos, NULL_VECTOR, false, 0.0);
      if (l4d2_ammo_lightning_todeath.IntValue == 1)
      {
        DamageEffects(victim, l4d2_ammo_lightning_damage2);
      }
      else if (!IsIncapacitated(victim))
      {
        DamageEffects(victim, l4d2_ammo_lightning_damage2);
      }
      else if (l4d2_ammo_lightning_todeath.IntValue == 0)
      {
        ClearLightning(attacker);
      }
    }
    else if (v < 0)
    {
      ClearLightning(attacker);
      return Plugin_Stop;
    }
    return Plugin_Continue;
  }
  else
  {
    ClearLightning(attacker);
    return Plugin_Stop;
  }
}

void ClearLightning(int attacker)
{
  for (int client = 1; client <= MaxClients; client++)iLightning[attacker][client] = 0;
  Victim[attacker] = 0;
  AttackerTime[attacker] = 0.0;
}

int SearchVictim(int victim, int attacker)
{
  int t = 0;
  float pos1[3];
  float pos2[3];
  GetClientEyePosition(victim, pos1);
  bool left = false;
  float range = l4d2_ammo_lightning_range.FloatValue;
  for (int client = 1; client <= MaxClients; client++)
  {
    if (IsClientInGame(client) && IsPlayerAlive(client))
    {
      if (iLightning[attacker][client] == 0)
      {
        if (GetClientTeam(client) == 2)left = true;
        GetClientEyePosition(client, pos2);
        float d = GetVectorDistance(pos1, pos2);
        if (d < range)
        {
          bool visible;
          visible = IfTwoPosVisible(pos1, pos2, 0);
          if (visible)
          {
            t = client;
            break;
          }
        }
      }
    }
  }
  
  if (!left)t = -1;
  return t;
}

public void ShowParticle(float pos[3], char[] particlename, float time)
{
  int particle = CreateEntityByName("info_particle_system");
  if (IsValidEdict(particle))
  {
    TeleportEntity(particle, pos, NULL_VECTOR, NULL_VECTOR);
    DispatchKeyValue(particle, "effect_name", particlename);
    DispatchKeyValue(particle, "targetname", "particle");
    DispatchSpawn(particle);
    ActivateEntity(particle);
    AcceptEntityInput(particle, "start");
    CreateTimer(time, DeleteParticles, particle, TIMER_FLAG_NO_MAPCHANGE);
  }
}

void DamageEffects(int target, ConVar damageconvar)
{
  char damage[10];
  damageconvar.GetString(damage, 10);
  char N[20];
  Format(N, 20, "target%d", target);
  int pointHurt = CreateEntityByName("point_hurt");
  if (pointHurt <= 0)return;
  DispatchKeyValue(target, "targetname", N);
  DispatchKeyValue(pointHurt, "Damage", damage);
  DispatchKeyValue(pointHurt, "DamageTarget", N);
  DispatchKeyValue(pointHurt, "DamageType", "8");
  DispatchSpawn(pointHurt);
  AcceptEntityInput(pointHurt, "Hurt");
  AcceptEntityInput(pointHurt, "Kill");
  RemoveEdict(pointHurt);
}

public Action DeleteParticles(Handle timer, any particle)
{
  if (IsValidEntity(particle))
  {
    char classname[64];
    GetEdictClassname(particle, classname, sizeof(classname));
    if (StrEqual(classname, "info_particle_system", false))
    {
      AcceptEntityInput(particle, "stop");
      AcceptEntityInput(particle, "kill");
      RemoveEdict(particle);
    }
  }
}

public int AttachParticle(int i_Ent, char[] s_Effect, float f_Origin[3])
{
  int i_Particle;
  char s_TargetName[32];
  i_Particle = CreateEntityByName("info_particle_system");
  
  if (IsValidEdict(i_Particle))
  {
    TeleportEntity(i_Particle, f_Origin, NULL_VECTOR, NULL_VECTOR);
    FormatEx(s_TargetName, sizeof(s_TargetName), "target%d", i_Ent);
    DispatchKeyValue(i_Particle, "targetname", s_TargetName);
    GetEntPropString(i_Ent, Prop_Data, "m_iName", s_TargetName, sizeof(s_TargetName));
    DispatchKeyValue(i_Particle, "parentname", s_TargetName);
    DispatchKeyValue(i_Particle, "effect_name", s_Effect);
    DispatchSpawn(i_Particle);
    SetVariantString(s_TargetName);
    AcceptEntityInput(i_Particle, "SetParent", i_Particle, i_Particle, 0);
    ActivateEntity(i_Particle);
    AcceptEntityInput(i_Particle, "Start");
  }
  return i_Particle;
}

bool IfTwoPosVisible(float pos1[3], float pos2[3], int self)
{
  bool r = true;
  Handle trace = TR_TraceRayFilterEx(pos2, pos1, MASK_SOLID, RayType_EndPoint, TraceRayDontHitSelfAndLive, self);
  if (TR_DidHit(trace))
  {
    r = false;
  }
  trace.Close();
  return r;
}

public bool TraceRayDontHitSelfAndLive(int entity, int mask, any data)
{
  if (entity == data)return false;
  else if (entity > 0 && entity <= MaxClients)
  {
    if (IsClientInGame(entity))return false;
  }
  return true;
}

//---===--=====---===---===---===---Cloudbox---===--=====---===---===---===---//
public void CreateGasCloud(int client, float g_pos[3])
{
  float targettime = GetEngineTime() + l4d2_ammo_cloudbox_duration.FloatValue;
  
  DataPack data = new DataPack();
  data.WriteCell(client);
  data.WriteFloat(g_pos[0]);
  data.WriteFloat(g_pos[1]);
  data.WriteFloat(g_pos[2]);
  data.WriteFloat(targettime);
  
  CreateTimer(2.0, Point_Hurt, data, TIMER_REPEAT);
  
  float pos[3];
  GetEntPropVector(client, Prop_Send, "m_vecOrigin", pos);
  
  DataPack cloud = new DataPack();
  cloud.WriteCell(client);
  cloud.WriteFloat(pos[0]);
  cloud.WriteFloat(pos[1]);
  cloud.WriteFloat(pos[2]);
  cloud.WriteFloat(targettime);
  
  CreateSmoke(client);
}

public Action Point_Hurt(Handle timer, DataPack hurt)
{
  hurt.Reset();
  int client = hurt.ReadCell();
  float g_pos[3];
  g_pos[0] = hurt.ReadFloat();
  g_pos[1] = hurt.ReadFloat();
  g_pos[2] = hurt.ReadFloat();
  float targettime = hurt.ReadFloat();
  
  if (targettime - GetEngineTime() < 0)
  {
    hurt.Close();
    return Plugin_Stop;
  }
  
  if (!IsClientInGame(client))client = -1;
  
  float targetVector[3];
  float distance;
  float radiussetting = l4d2_ammo_cloudbox_radius.FloatValue;
  char soundFilePath[256];
  l4d2_ammo_cloudbox_sound_path.GetString(soundFilePath, sizeof(soundFilePath));
  bool shakeenabled = l4d2_ammo_cloudbox_shake.BoolValue;
  int damage = l4d2_ammo_cloudbox_damage.IntValue;
  
  for (int target = 1; target <= MaxClients; target++)
  {
    if (!target || !IsClientInGame(target) || !IsPlayerAlive(target) || GetClientTeam(target) != 2)continue;
    
    GetClientEyePosition(target, targetVector);
    distance = GetVectorDistance(targetVector, g_pos);
    
    if (distance > radiussetting || !IsVisibleTo(g_pos, targetVector))
    {
      continue;
    }
    
    EmitSoundToClient(target, soundFilePath);
    switch (l4d2_ammo_cloudbox_damage_message.IntValue)
    {
      case 1: PrintCenterText(target, "You're suffering from a toxic Cloud!");
      case 2: PrintHintText(target, "%t", "Hint You're suffering from a toxic Cloud!");
      case 3: PrintToChat(target, "%t", "Chat You're suffering from a toxic Cloud!");
    }
    
    ScreenFade(target, 16, 122, 0, 100, RoundToZero(1 * 1000.0), 1);
    
    if (shakeenabled)
    {
      Handle hBf = StartMessageOne("Shake", target);
      BfWriteByte(hBf, 0);
      BfWriteFloat(hBf, 6.0);
      BfWriteFloat(hBf, 1.0);
      BfWriteFloat(hBf, 1.0);
      EndMessage();
      CreateTimer(1.0, StopShake, target);
    }
    
    applyDamage(damage, target);
  }
  
  return Plugin_Continue;
}

public Action StopShake(Handle timer, any target)
{
  if (!target || !IsClientInGame(target))
  {
    return;
  }
  
  Handle hBf = StartMessageOne("Shake", target);
  BfWriteByte(hBf, 0);
  BfWriteFloat(hBf, 0.0);
  BfWriteFloat(hBf, 0.0);
  BfWriteFloat(hBf, 0.0);
  EndMessage();
}

void applyDamage(int damage, int victim)
{
  DataPack dataPack = new DataPack();
  dataPack.WriteCell(damage);
  dataPack.WriteCell(victim);
  
  CreateTimer(0.10, timer_stock_applyDamage, dataPack);
}

public Action timer_stock_applyDamage(Handle timer, DataPack dataPack)
{
  dataPack.Reset();
  int damage = dataPack.ReadCell();
  int victim = dataPack.ReadCell();
  dataPack.Close();
  
  float victimPos[3];
  char strDamage[16];
  char strDamageTarget[16];
  
  if (!IsClientInGame(victim))return;
  GetClientEyePosition(victim, victimPos);
  IntToString(damage, strDamage, sizeof(strDamage));
  Format(strDamageTarget, sizeof(strDamageTarget), "hurtme%d", victim);
  
  int entPointHurt = CreateEntityByName("point_hurt");
  if (!entPointHurt)return;
  
  bool reviveblock = l4d2_ammo_cloudbox_blocks_revive.BoolValue;
  
  DispatchKeyValue(victim, "targetname", strDamageTarget);
  DispatchKeyValue(entPointHurt, "DamageTarget", strDamageTarget);
  DispatchKeyValue(entPointHurt, "Damage", strDamage);
  DispatchKeyValue(entPointHurt, "DamageType", reviveblock ? "65536" : "263168");
  DispatchSpawn(entPointHurt);
  
  TeleportEntity(entPointHurt, victimPos, NULL_VECTOR, NULL_VECTOR);
  AcceptEntityInput(entPointHurt, "Hurt", (victim > 0 && victim < MaxClients && IsClientInGame(victim)) ? victim : -1);
  
  DispatchKeyValue(entPointHurt, "classname", "point_hurt");
  DispatchKeyValue(victim, "targetname", "null");
  RemoveEdict(entPointHurt);
}

bool IsVisibleTo(float position[3], float targetposition[3])
{
  float vAngles[3];
  float vLookAt[3];
  
  MakeVectorFromPoints(position, targetposition, vLookAt); // compute vector from start to target
  GetVectorAngles(vLookAt, vAngles); // get angles from vector for trace
  
  Handle trace = TR_TraceRayFilterEx(position, vAngles, MASK_SHOT, RayType_Infinite, TraceFilter);
  
  bool isVisible = false;
  if (TR_DidHit(trace))
  {
    float vStart[3];
    TR_GetEndPosition(vStart, trace);
    
    if ((GetVectorDistance(position, vStart, false) + TRACE_TOLERANCE) >= GetVectorDistance(position, targetposition))isVisible = true;
  }
  else
  {
    LogError("Tracer Bug: Player-Zombie Trace did not hit anything, WTF");
    isVisible = true;
  }
  trace.Close();
  
  return isVisible;
}

public bool TraceFilter(int entity, int contentsMask)
{
  if (!entity || !IsValidEntity(entity))return false;
  return true;
}

public bool Player_TraceFilter(int entity, int contentsMask)
{
  return entity > MaxClients || !entity;
}

void CreateSmoke(int target)
{
  if (target > 0 && IsValidEdict(target) && IsClientInGame(target) && IsPlayerAlive(target))
  {
    int SmokeEnt = CreateEntityByName("env_smokestack");
    float location[3];
    GetClientAbsOrigin(target, location);
    
    char originData[64];
    Format(originData, sizeof(originData), "%f %f %f", location[0], location[1], location[2]);
    
    char SmokeColor[128];
    l4d2_ammo_cloudbox_color.GetString(SmokeColor, sizeof(SmokeColor));
    
    float delay = l4d2_ammo_cloudbox_duration.FloatValue;
    char SmokeTransparency[32];
    l4d2_ammo_cloudbox_transparency.GetString(SmokeTransparency, sizeof(SmokeTransparency));
    
    char SmokeDensity[32];
    l4d2_ammo_cloudbox_density.GetString(SmokeDensity, sizeof(SmokeDensity));
    
    if (SmokeEnt)
    {
      char SName[128];
      Format(SName, sizeof(SName), "Smoke%i", target);
      DispatchKeyValue(SmokeEnt, "targetname", SName);
      DispatchKeyValue(SmokeEnt, "Origin", originData);
      DispatchKeyValue(SmokeEnt, "BaseSpread", "100");
      DispatchKeyValue(SmokeEnt, "SpreadSpeed", "70");
      DispatchKeyValue(SmokeEnt, "Speed", "80");
      DispatchKeyValue(SmokeEnt, "StartSize", "200");
      DispatchKeyValue(SmokeEnt, "EndSize", "2");
      DispatchKeyValue(SmokeEnt, "Rate", SmokeDensity);
      DispatchKeyValue(SmokeEnt, "JetLength", "400");
      DispatchKeyValue(SmokeEnt, "Twist", "20");
      DispatchKeyValue(SmokeEnt, "RenderColor", SmokeColor);
      DispatchKeyValue(SmokeEnt, "RenderAmt", SmokeTransparency);
      DispatchKeyValue(SmokeEnt, "SmokeMaterial", "particle/particle_smokegrenade1.vmt");
      
      DispatchSpawn(SmokeEnt);
      AcceptEntityInput(SmokeEnt, "TurnOn");
      
      DataPack pack = new DataPack();
      CreateDataTimer(delay, Timer_KillSmoke, pack);
      pack.WriteCell(SmokeEnt);
      
      float longerdelay = 5.0 + delay;
      DataPack pack2 = new DataPack();
      CreateDataTimer(longerdelay, Timer_StopSmoke, pack2);
      pack2.WriteCell(SmokeEnt);
    }
  }
}

public Action Timer_KillSmoke(Handle timer, DataPack pack)
{
  pack.Reset();
  int SmokeEnt = pack.ReadCell();
  StopSmokeEnt(SmokeEnt);
}

void StopSmokeEnt(int target)
{
  if (IsValidEntity(target))AcceptEntityInput(target, "TurnOff");
}

public Action Timer_StopSmoke(Handle timer, DataPack pack)
{
  pack.Reset();
  int SmokeEnt = pack.ReadCell();
  RemoveSmokeEnt(SmokeEnt);
}

void RemoveSmokeEnt(int target)
{
  if (IsValidEntity(target))AcceptEntityInput(target, "Kill");
}

//---===--=====---===---===---===---Bridebox---===--=====---===---===---===---//
void BrideBox(int client)
{
  for (int i = 1; i < l4d2_ammo_bridewitches.IntValue; i++)
  {
    CheatCMD(client, "z_spawn_old", "witch_bride");
  }
}

//---===--=====---===---===---===---Multiplebox---===--=====---===---===---===---//
public void MultipleBox(int client)
{
  int ItemNumber;
  char ItemName[36];
  for (int i = 0; i < l4d2_ammo_multipleboxes.IntValue; i++)
  {
    ItemNumber = GetRandomInt(1, 2);
    switch (ItemNumber)
    {
      case 1:ItemName = "weapon_upgradepack_explosive";
      case 2:ItemName = "weapon_upgradepack_incendiary";
    }
    SpawnItem(client, ItemName);
  }
}

//---===--=====---===---===---===---Blazebox---===--=====---===---===---===---//
public void Blaze(int client)
{
  g_BlazeLife[client] = l4d2_ammo_blaze_life.FloatValue;
  CreateTimer(0.1, Timer_Blaze, client, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
  switch (GetRandomInt(0, 2))
  {
    case 0: EmitSoundToAll(ONEBADMAN, client, SNDCHAN_AUTO, SNDLEVEL_RAIDSIREN);
    case 1: EmitSoundToAll(BLAZEMUSIC, client, SNDCHAN_AUTO, SNDLEVEL_RAIDSIREN);
    case 2: EmitSoundToAll(MIDNIGHTRIDE, client, SNDCHAN_AUTO, SNDLEVEL_RAIDSIREN);
  }
}

public Action Timer_Blaze(Handle timer, any client)
{
  g_BlazeLife[client] -= 0.1;
  
  if (IsValidForBlazeClient(client) && g_BlazeLife[client] > 0.0)
  {
    int blazetype = l4d2_ammo_blaze_type.IntValue;
    switch (blazetype)
    {
      case 0:CreateParticle(client, FIRESMALL_PARTICLE, true, 0.1);
      case 1:CreateParticle(client, FIRESMALL_PARTICLE1, true, 0.1);
      case 2:CreateParticle(client, FIRESMALL_PARTICLE2, true, 0.1);
    }
    
    float position[3];
    GetClientAbsOrigin(client, position);
    BlazeCircle(client, position);
    
    return Plugin_Continue;
  }
  else
  {
    g_BlazeLife[client] = 0.0;
  }
  
  return Plugin_Stop;
}

public void BlazeCircle(int client, float position[3])
{
  float client_pos[3];
  GetClientEyePosition(client, position);
  
  float l4d2_ammo_blaze_radius = 80.0;
  
  float entPos[3];
  int ddamag = l4d2_ammo_blazeDmg.IntValue;
  
  for (int i = 1; i <= MaxClients; i++)
  {
    if (IsValidForBlazeInfected(i) && IsPlayerAlive(i))
    {
      GetClientEyePosition(i, client_pos);
      if (GetVectorDistance(position, client_pos) < l4d2_ammo_blaze_radius)
      {
        IgniteEntity(i, 5.0);
        DealDamage(i, ddamag, client, DMG_EXPLOSIVE, "weapon_rifle");
        CreateShieldPush(client, i, 160.0);
      }
    }
  }
  
  char class[64];
  
  int maxents = GetMaxEntities();
  for (int i = MaxClients + 1; i <= maxents; i++)
  {
    if (!IsValidEdict(i))continue;
    GetEdictClassname(i, class, sizeof(class));
    
    if (!StrEqual(class, "infected") && !StrEqual(class, "witch"))continue;
    GetEntityAbsOrigin(i, entPos);
    
    if (GetVectorDistance(position, entPos) < l4d2_ammo_blaze_radius)
    {
      IgniteEntity(i, 3.0);
      DealDamage(i, ddamag, client, DMG_EXPLOSIVE, "weapon_rifle");
      CreateShieldPush(client, i, 80.0);
    }
  }
}

void GetEntityAbsOrigin(int entity, float origin[3])
{
  if (entity && IsValidEntity(entity) && (GetEntSendPropOffs(entity, "m_vecOrigin") != -1) && (GetEntSendPropOffs(entity, "m_vecMins") != -1) && (GetEntSendPropOffs(entity, "m_vecMaxs") != -1))
  {
    float mins[3];
    float maxs[3];
    
    GetEntPropVector(entity, Prop_Send, "m_vecOrigin", origin);
    GetEntPropVector(entity, Prop_Send, "m_vecMins", mins);
    GetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs);
    
    origin[0] += (mins[0] + maxs[0]) * 0.5;
    origin[1] += (mins[1] + maxs[1]) * 0.5;
    origin[2] += (mins[2] + maxs[2]) * 0.5;
  }
}

void CreateShieldPush(int client, int target, float force = 0.0)
{
  if (IsValidForBlazeClient(client) && IsValidEntity(target))
  {
    float ppDM[3];
    float qqDM[3];
    float qqAA[3];
    float qqDA[3];
    float qqVv[3];
    
    GetEntPropVector(target, Prop_Send, "m_vecOrigin", ppDM);
    GetEntPropVector(client, Prop_Send, "m_vecOrigin", qqDM);
    
    MakeVectorFromPoints(qqDM, ppDM, qqAA);
    GetVectorAngles(qqAA, qqDA);
    qqDA[0] -= 20.0;
    GetAngleVectors(qqDA, qqVv, NULL_VECTOR, NULL_VECTOR);
    NormalizeVector(qqVv, qqVv);
    ScaleVector(qqVv, force);
    TeleportEntity(target, NULL_VECTOR, NULL_VECTOR, qqVv);
  }
}

void DealDamage(int victim, int damage, int attacker = 0, int dmg_type = DMG_GENERIC, char[] weapon = "")
{
  if (victim > 0 && GetEntProp(victim, Prop_Data, "m_iHealth") > 0 && attacker > 0 && damage > 0)
  {
    char dmg_str[16];
    IntToString(damage, dmg_str, 16);
    char dmg_type_str[32];
    IntToString(dmg_type, dmg_type_str, 32);
    int pointHurt = CreateEntityByName("point_hurt");
    if (pointHurt)
    {
      DispatchKeyValue(victim, "targetname", "war3_hurtme");
      DispatchKeyValue(pointHurt, "DamageTarget", "war3_hurtme");
      DispatchKeyValue(pointHurt, "Damage", dmg_str);
      DispatchKeyValue(pointHurt, "DamageType", dmg_type_str);
      if (!StrEqual(weapon, ""))DispatchKeyValue(pointHurt, "classname", weapon);
      DispatchSpawn(pointHurt);
      AcceptEntityInput(pointHurt, "Hurt", (attacker > 0) ? attacker:-1);
      DispatchKeyValue(pointHurt, "classname", "point_hurt");
      DispatchKeyValue(victim, "targetname", "war3_donthurtme");
      RemoveEdict(pointHurt);
    }
  }
}

bool IsValidForBlazeInfected(int client)
{
  if (client < 1 || client > MaxClients)return false;
  if (!IsClientConnected(client))return false;
  if (!IsClientInGame(client))return false;
  if (GetClientTeam(client) != 3)return false;
  return true;
}

bool IsValidForBlazeClient(int client)
{
  if (client < 1 || client > MaxClients)return false;
  if (!IsClientConnected(client))return false;
  if (!IsClientInGame(client))return false;
  if (GetClientTeam(client) != 2)return false;
  if (!IsPlayerAlive(client))return false;
  return true;
}

//---===--=====---===---===---===---Tinybox---===--=====---===---===---===---//
// https://forums.alliedmods.net/showthread.php?p=1542708

public Action onEventWitchSpawn(Event event, const char[] name, bool dontBroadcast)
{
  int witchid = event.GetInt("witchid");
  
  if (witchid > 0 && g_bIsTinyBox)
  {
    float chance = l4d2_ammo_tiny_scale_witch.FloatValue;
    float r = GetRandomFloat(0.0, 100.0);
    if (r < chance)
    {
      CreateTimer(1.0, DelaySetTrace, witchid, TIMER_FLAG_NO_MAPCHANGE);
    }
  }
}

public Action DelaySetTrace(Handle timer, any witchid)
{
  if (!IsThisWitch(witchid))return;
  float modelScale = GetEntPropFloat(witchid, Prop_Send, "m_flModelScale");
  if (modelScale != 1.0) {
    return;
  }
  
  if (GetRandomInt(0, 1) == 0) {
    CreateTimer(0.1, TraceWitch, EntIndexToEntRef(witchid), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
  } else {
    float scale = GetRandomFloat(l4d2_ammo_tiny_scale_witch_min.FloatValue, l4d2_ammo_tiny_scale_witch_max.FloatValue);
    if (scale > 0.1 && scale < 10.0) {
      SetEntPropFloat(witchid, Prop_Send, "m_flModelScale", scale);
    }
  }
}

bool IsThisWitch(int witch) {
  if (witch > 0 && IsValidEdict(witch) && IsValidEntity(witch)) {
    char classname[64];
    GetEdictClassname(witch, classname, sizeof(classname));
    if (StrEqual(classname, "witch") || StrEqual(classname, "witch_bride")) {
      return true;
    }
  }
  return false;
}

public Action TraceWitch(Handle timer, any witch)
{
  if (witch != INVALID_ENT_REFERENCE && IsValidEdict(witch) && IsValidEntity(witch))
  {
    char classname[64];
    GetEdictClassname(witch, classname, sizeof(classname));
    if (StrEqual(classname, "witch") || StrEqual(classname, "witch_bride"))
    {
      float rage = GetEntPropFloat(witch, Prop_Send, "m_rage");
      int rush = GetEntProp(witch, Prop_Send, "m_mobRush");
      float scale = 1.0 + rage * (l4d2_ammo_tiny_scale_witch_max.FloatValue - 1.0);
      SetEntPropFloat(witch, Prop_Send, "m_flModelScale", scale);
      if (rush)
      {
        SetEntPropFloat(witch, Prop_Send, "m_flModelScale", l4d2_ammo_tiny_scale_witch_max.FloatValue);
        return Plugin_Stop;
      }
      return Plugin_Continue;
    }
    else return Plugin_Stop;
  }
  return Plugin_Stop;
}

void Start(int entity, float chance)
{
  if (chance == 0.0)return;
  float r = GetRandomFloat(0.0, 100.0);
  if (r < chance)CreateTimer(0.05, SetInfectedSize, EntIndexToEntRef(entity), TIMER_FLAG_NO_MAPCHANGE);
}

public Action SetInfectedSize(Handle timer, any ent)
{
  if (ent != INVALID_ENT_REFERENCE && IsValidEdict(ent) && IsValidEntity(ent))
  {
    float scale;
    scale = GetRandomFloat(l4d2_ammo_tiny_scale_infected_min.FloatValue, l4d2_ammo_tiny_scale_infected_max.FloatValue);
    if (scale > 0.1 && scale < 10.0)SetEntPropFloat(ent, Prop_Send, "m_flModelScale", scale);
  }
}

public void OnEntityCreated(int entity, const char[] classname)
{
  if (!g_bIsTinyBox)return;
  
  float chance = l4d2_ammo_tiny_scale_infected.FloatValue;
  if (chance == 0.0)return;
  if (StrEqual(classname, "infected"))Start(entity, chance);
}

//---===--=====---===---===---===---Изменение цвета экрана игрока---===--=====---===---===---===---//
static int g_iInfectedMind[MAXPLAYERS + 1][2];
static int MindDuration[MAXPLAYERS + 1];
float g_fConfMindDistance = 350.0;

public Action Command_ColorScreen(int client, int args)
{
  if (!client)
  {
    return Plugin_Handled;
  }
  
  if (args != 2)
  {
    PrintToChat(client, "Incorrect usage! Usage: sm_colorscreen <type> <duration>");
    return Plugin_Handled;
  }
  
  char Arg1[8];
  char Arg2[32];
  
  GetCmdArg(1, Arg1, sizeof(Arg1));
  GetCmdArg(2, Arg2, sizeof(Arg2));
  
  int type;
  int duration;
  type = StringToInt(Arg1);
  duration = StringToInt(Arg2);
  
  if (type < 0)
  {
    type = 0;
  }
  else if (type > 8)
  {
    type = 8;
  }
  
  if (duration < 3)
  {
    duration = 3;
  }
  else if (duration > 60)
  {
    duration = 60;
  }
  
  CreateCorrection(client, type);
  MindDuration[client] = duration * 10;
  
  return Plugin_Handled;
}

void CreateCorrection(int client, int correction)
{
  char sTemp[64];
  float vPos[3];
  GetClientEyePosition(client, vPos);
  
  int entity = CreateEntityByName("color_correction");
  if (entity == -1)
  {
    LogError("Failed to create 'color_correction'");
    return;
  }
  else
  {
    g_iInfectedMind[client][0] = EntIndexToEntRef(entity);
    
    DispatchKeyValue(entity, "spawnflags", "2");
    DispatchKeyValue(entity, "maxweight", "50.0");
    DispatchKeyValue(entity, "fadeInDuration", "3");
    DispatchKeyValue(entity, "fadeOutDuration", "1");
    DispatchKeyValue(entity, "maxfalloff", "-1");
    DispatchKeyValue(entity, "minfalloff", "-1");
    
    switch(correction)
    {
      case 0: DispatchKeyValue(entity, "filename", "materials/correction/ghost.raw");
      case 1: DispatchKeyValue(entity, "filename", "materials/correction/urban_night_red.pwl.raw");
      case 2: DispatchKeyValue(entity, "filename", "materials/correction/lightningstrike50.pwl.raw");
      case 3: DispatchKeyValue(entity, "filename", "materials/correction/dlc3_river03_outro.pwl.raw");
      case 4: DispatchKeyValue(entity, "filename", "materials/correction/infected.pwl.raw");
      case 5: DispatchKeyValue(entity, "filename", "materials/correction/thirdstrike.raw");
      case 6: DispatchKeyValue(entity, "filename", "materials/correction/dlc3_river01_kiln.pwl.raw");
      case 7: DispatchKeyValue(entity, "filename", "materials/correction/sunrise.pwl.raw");
      
    }
    
    DispatchSpawn(entity);
    ActivateEntity(entity);
    AcceptEntityInput(entity, "Enable");
    TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
    
    Format(sTemp, sizeof(sTemp), "col_cor%d%d", entity, client);
    DispatchKeyValue(entity, "targetname", sTemp);
  }
  
  ToggleFogVolume(false);
  
  entity = CreateEntityByName("fog_volume");
  
  if (entity == -1)LogError("Failed to create 'fog_volume'");
  else
  {
    g_iInfectedMind[client][1] = entity;
    
    DispatchKeyValue(entity, "ColorCorrectionName", sTemp);
    Format(sTemp, sizeof(sTemp), "%d%d", client, entity);
    DispatchKeyValue(entity, "PostProcessName", sTemp);
    DispatchKeyValue(entity, "spawnflags", "0");
    
    DispatchSpawn(entity);
    ActivateEntity(entity);
    AcceptEntityInput(entity, "Enable");
    TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
    
    float vMins[3];
    float vMaxs[3];
    
    vMins[0] = -1.0 * g_fConfMindDistance;
    vMins[1] = -1.0 * g_fConfMindDistance;
    vMins[2] = 0.0;
    vMaxs[0] = g_fConfMindDistance;
    vMaxs[1] = g_fConfMindDistance;
    vMaxs[2] = 150.0;
    SetEntPropVector(entity, Prop_Send, "m_vecMins", vMins);
    SetEntPropVector(entity, Prop_Send, "m_vecMaxs", vMaxs);
  }
  
  ToggleFogVolume(true);
  
  CreateTimer(0.1, tmrTeleport, client, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action tmrTeleport(Handle timer, any client)
{
  if (IsValidEntRef(client))
  {
    if (MindDuration[client] > 0)
    {
      float vPos[3];
      GetClientEyePosition(client, vPos);
      
      int entity;
      entity = g_iInfectedMind[client][1];
      if (IsValidEntRef(entity))TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
      
      MindDuration[client]--;
      
      return Plugin_Continue;
    }
    else
    {
      DeleteEntityMind(client);
      return Plugin_Stop;
    }
  }
  
  return Plugin_Continue;
}

void ToggleFogVolume(bool enable)
{
  int entity = -1;
  
  if (enable)
  {
    for (int i = 1; i <= MaxClients; i++)
    {
      entity = g_iInfectedMind[i][1];
      if (IsValidEntRef(entity))
      {
        AcceptEntityInput(entity, "Disable");
        AcceptEntityInput(entity, "Enable");
      }
    }
  }
  
  int m_bDisabled;
  int breaker;
  while ((entity = FindEntityByClassname(entity, "fog_volume")) != INVALID_ENT_REFERENCE)
  {
    breaker = 0;
    for (int i = 1; i <= MaxClients; i++)
    {
      if (g_iInfectedMind[i][1] == entity)
      {
        breaker = 1;
        break;
      }
      
      if (breaker == 1)
      {
        break;
      }
    }
    
    if (enable)
    {
      m_bDisabled = GetEntProp(entity, Prop_Data, "m_bDisabled");
      if (m_bDisabled == 0)
      {
        AcceptEntityInput(entity, "Enable");
      }
    }
    else
    {
      m_bDisabled = GetEntProp(entity, Prop_Data, "m_bDisabled");
      SetEntProp(entity, Prop_Data, "m_iHammerID", m_bDisabled);
      AcceptEntityInput(entity, "Disable");
    }
  }
}

void DeleteEntityMind(int index)
{
  int entity;
  entity = g_iInfectedMind[index][0];
  
  if (IsValidEntRef(entity))
  {
    AcceptEntityInput(entity, "TurnOff");
    SetVariantString("OnUser1 !self:Kill::3:-1");
    AcceptEntityInput(entity, "AddOutput");
    AcceptEntityInput(entity, "FireUser1");
  }
  
  entity = g_iInfectedMind[index][1];
  
  if (IsValidEntRef(entity))
  {
    float vMins[3] =  { -1.0, -1.0, -1.0 };
    float vMaxs[3] =  { 1.0, 1.0, 1.0 };
    SetEntPropVector(entity, Prop_Send, "m_vecMins", vMins);
    SetEntPropVector(entity, Prop_Send, "m_vecMaxs", vMaxs);
    
    AcceptEntityInput(entity, "TurnOff");
    SetVariantString("OnUser1 !self:Kill::3:-1");
    AcceptEntityInput(entity, "AddOutput");
    AcceptEntityInput(entity, "FireUser1");
  }
  return;
}

bool IsValidEntRef(int entity)
{
  if (entity && EntRefToEntIndex(entity) != INVALID_ENT_REFERENCE)
  {
    return true;
  }
  return false;
}

//---===--=====---===---===---===---[L4D & L4D2] Boomer Bit** Slap---===--=====---===---===---===---//
// https://forums.alliedmods.net/showthread.php?t=97952?t=97952
public Action onEventPlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
  int slapper = GetClientOfUserId(event.GetInt("attacker"));
  int target = GetClientOfUserId(event.GetInt("userid"));
  
  if (!slapper)
  {
    slapper = 1;
  }
  
  if (!target || !IsClientInGame(target))
  {
    return;
  }
  
  char weapon[56];
  event.GetString("weapon", weapon, sizeof(weapon));
  if (GetClientTeam(target) == 2 && StrEqual(weapon, "boomer_claw") && CanSlapAgain(slapper))
  {
    if (!IsIncapacitated(target) && IsNotFalling(target))
    {
      if (!IsFakeClient(target))
      {
        EmitSoundToClient(target, PUNCH_SOUND, target, SNDCHAN_AUTO, SNDLEVEL_GUNFIRE);
      }
      
      float HeadingVector[3];
      float AimVector[3];
      float power = 150.0;
      
      GetClientEyeAngles(slapper, HeadingVector);
      
      AimVector[0] = Cosine(DegToRad(HeadingVector[1])) * power;
      AimVector[1] = Sine(DegToRad(HeadingVector[1])) * power;
      
      float current[3];
      GetEntPropVector(target, Prop_Data, "m_vecVelocity", current);
      
      float resulting[3];
      resulting[0] = current[0] + AimVector[0];
      resulting[1] = current[1] + AimVector[1];
      resulting[2] = power * 1.5;
      
      FlingPlayer(target, resulting, slapper);
      
      lastSlapTime[slapper] = GetEngineTime();
    }
  }
}

bool CanSlapAgain(int client)
{
  return ((GetEngineTime() - lastSlapTime[client]) > 6.0);
}

bool IsNotFalling(int client)
{
  return GetEntProp(client, Prop_Send, "m_isHangingFromLedge") == 0 && GetEntProp(client, Prop_Send, "m_isFallingFromLedge") == 0;
}

public void AnnounceOpenBox(int client, const char[] box_name) {
  if(!StrEqual("nothing", box_name)) {
    for(int i = 1; i < MaxClients; i++) {
      if(IsClientInGame(i) && !IsFakeClient(i)) {
        if(client != i) {
          CPrintToChat(i, "{blue}%N\x01 opened a {blue}%s", client, box_name);
        } else {
          CPrintToChat(i, "{blue}You\x01 have opened a {blue}%s", box_name);
        }
      }
    }
  }
}

