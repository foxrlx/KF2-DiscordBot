class KF2Util extends Actor;
struct PlayerData {
	var string playername;
	var string steamid;
	var int playerid;
	var bool ready;
	var string perkname;
	var int perklevel;
	var int kills;
	var int deaths;
	var float dosh;
	var int health;
	var int maxhealth;
	var int healthpercent;
	var int assists;
	var int ping;
	var int damagedealt;
};
struct MatchData {
	var string matchsession;
	var string mapname;
	var string gamelength;
	var string gamedifficulty;
	var int totalwave;
	var int currentwave;
	var bool waveisactive;
	var bool wavestarted;
	var Array<PlayerData> players;
};

static function Array<PlayerData> getPlayersData() {
	local KFPlayerController pc;
    local KFPawn kfp;
    local KFPlayerReplicationInfo kfpri;
	local Array<KFPlayerReplicationInfo> KFPRIArray;
	local Pawn p;
	local WorldInfo wi;

	local PlayerData pd;
	local Array<PlayerData> pdArray;
	
	wi = class'WorldInfo'.static.GetWorldInfo();
	KFGameReplicationInfo(wi.GRI).GetKFPRIArray(KFPRIArray);

	foreach KFPRIArray(kfpri) {
		pc = KFPlayerController(kfpri.Owner);
		p = pc.Pawn;
		kfp = KFPawn(pc.Pawn);

		pd.playername = kfpri.PlayerName;
		pd.steamid = class'OnlineSubsystem'.static.UniqueNetIdToString(kfpri.UniqueId);
		pd.playerid = kfpri.PlayerId;
		pd.perklevel = kfpri.GetActivePerkLevel();
		pd.dosh = kfpri.Score;
		pd.deaths = kfpri.Deaths;
		pd.kills = kfpri.Kills;
		pd.assists = kfpri.Assists;
		pd.ping = kfpri.ping;
		pd.healthpercent = kfpri.PlayerHealthPercent;
		pd.ready = kfpri.bReadyToPlay;
		pd.damagedealt = kfpri.DamageDealtOnTeam;
		if (p != none) {
			pd.health = p.Health;
			pd.maxhealth = p.HealthMax;
		}
		if (kfp != none)
			pd.perkname = kfp.GetPerk().PerkName;

		pdArray[pdArray.length] = pd;
	}
	return pdArray;
}
static function MatchData getMatchData(string matchSession) {
    local KFGameInfo kfgi;
	local KFGameReplicationInfo KFGRI;
	local WorldInfo wi;

	local MatchData matchData;

	matchData.matchsession = matchSession;
	
	wi = class'WorldInfo'.static.GetWorldInfo();

	kfgi = KFGameInfo(wi.Game);
	KFGRI = kfgi.MyKFGRI;

	matchData.gamelength = getGameLength(kfgi.GameLength);
    matchData.gamedifficulty = getGameDifficulty(kfgi.GameDifficulty);
    matchData.mapname = wi.GetMapName();
    matchData.totalwave = kfgi.MyKFGRI.WaveMax;
	matchData.currentWave = KFGRI.WaveNum;
	matchData.wavestarted = KFGRI.bWaveStarted;
	matchData.waveisactive = KFGRI.bWaveIsActive;

	matchData.players = getPlayersData();

	return matchData;
}

static function string getGameLength(int gl) {
	switch (gl) {
		case 0:
			return "Short";
			break;
		case 1:
			return "Medium";
			break;
		case 2:
			return "Long";
			break;
		case 3:
			return "Custom";
			break;
	}
}

static function string getGameDifficulty(int gd) {
	switch (gd) {
		case 0:
			return "Normal";
			break;
		case 1:
			return "Hard";
			break;
		case 2:
			return "Suicidal";
			break;
		case 3:
			return "Hell on Earth";
			break;
		default:
			return "Custom";
			break;
	}
}

static function string getRandomString(int length) {
	local string result;
	local string chars;
	local int randomIdx;
	local int i;

	chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

	for (i = 0; i < length; i++) {
		randomIdx = Rand(Len(chars) - (i == 0) ? 10 : 0);
		result $= Mid(chars, randomIdx, 1);
	}
	
	return result;
}
