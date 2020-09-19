class KF2DiscordBot extends Actor Config(DiscordBot) DependsOn(KF2Util);

// https://docs.unrealengine.com/udk/Three/UnrealScriptIterators.html

//var KF2DiscordBroadcastHandler bcastHandler;

var KF2DiscordLink link;
var string matchSession;
var KF2EventDetector kf2ed;
var MatchData matchData;

const VERSION = "0.01";

function postBeginPlay() {
    local MessagingSpectator msgSpec;

    Super.postBeginPlay();

    matchSession = Spawn(class'KF2Util').getRandomString(10);

    matchData.matchsession = matchSession;
    
    msgSpec = Spawn(class'MessagingSpectator');
    msgSpec.AddReceiver(MsgSpecHandler);

    //SetTimer(1, true, 'CheckLobbyStatus');
    SetTimer(1, true, 'UpdateMatchStatus');
    
    kf2ed = Spawn(class'KF2EventDetector');

    ConnectToDiscordAdapter();
}

function MsgSpecHandler(PlayerReplicationInfo Sender, string Msg, name Type ) {
    local string serializedData;
    local string uid;
    local Pawn p;
    local int health;
    local KFPawn kfp;
    local KFPlayerReplicationInfo kfpri;
    
    local KFGameInfo kfgi;
    
    //KFP.InvManager
    //!MyKFGRI.IsBossWave()

    //some tests
    kfgi = KFGameInfo(WorldInfo.Game);
    `Log("Game Length " $ kfgi.GameLength);
    `Log("Zeds Killed " $ kfgi.GameConductor.TotalZedsKilled);
    `Log("Zeds Killed Wave " $ kfgi.GameConductor.CurrentWaveTotalZedsKilled);
    foreach WorldInfo.AllPawns(class'Pawn', p)
    {
        if (p.PlayerReplicationInfo != none && p.PlayerReplicationInfo.PlayerId == Sender.PlayerId)
        {
            health = p.Health;
            kfp = KFPawn_Human(p);
            kfpri = KFPlayerReplicationInfo(p.PlayerReplicationInfo);

            `Log("Player Ready: " $ KFGameInfo(WorldInfo.Game).IsPlayerReady(KFPlayerReplicationInfo(p.PlayerReplicationInfo)));
            
            `Log("Damage Dealt " $ kfpri.DamageDealtOnTeam);
            `Log("Prestige Level " $ kfpri.GetActivePerkPrestigeLevel());
            `Log("Score " $ kfpri.Score); // Dosh
            `Log("Death " $ kfpri.Deaths);
            `Log("Ping " $ kfpri.Ping);
            `Log("NumLives " $ kfpri.NumLives);
            `Log("Kills " $ kfpri.Kills);
            // kfpri.Assists
            // kfpri.GetActivePerkPrestigeLevel()

            break;
        }
    }

    // GET SteamID in hex format
    uid = class'OnlineSubsystem'.static.UniqueNetIdToString(Sender.UniqueId);
    
    serializedData = class'KF2DiscordUtil'.static.GetMessageJsonObject(uid, Sender.PlayerName, Msg, kfp, kfpri);
    link.SendData(serializedData);
}

function ConnectToDiscordAdapter() {
    link = Spawn(Class'KF2DiscordLink');
    link.SetOwner(self);
    link.ConnectionOpened = ConnectionOpenedHandler;

    link.Connect("127.0.0.1", 7070);
}
function ConnectionOpenedHandler() {
    local string serializedData;

    serializedData = class'KF2DiscordUtil'.static.GetMatchCreatedJsonObject(matchSession);
    link.SendData(serializedData);
}

function CheckLobbyStatus() {
    local KFGameInfo kfgi;
    local KFPlayerController pc;
    local KFPawn kfp;
    local KFPlayerReplicationInfo kfpri;

    local PlayerData pd;
    local string serializedData;
    
    kfgi = KFGameInfo(WorldInfo.Game);

    matchData.gamelength = Spawn(class'KF2Util').getGameLength(kfgi.GameLength);
    matchData.gamedifficulty = Spawn(class'KF2Util').getGameDifficulty(kfgi.GameDifficulty);
    matchData.mapname = WorldInfo.GetMapName();
    matchData.totalwave = kfgi.MyKFGRI.WaveMax;

    matchData.players.length = 0;
    foreach WorldInfo.AllControllers(class'KFPlayerController', pc) {
        if (pc.Pawn != none) {
            kfp = KFPawn(pc.Pawn);
            kfpri = KFPlayerReplicationInfo(pc.PlayerReplicationInfo);
            
            pd.playername = pc.PlayerReplicationInfo.PlayerName;
            pd.playerid = pc.PlayerReplicationInfo.PlayerId;
            pd.ready = pc.PlayerReplicationInfo.bReadyToPlay;
            pd.perkname = kfp.GetPerk().PerkName;
            pd.perklevel = kfpri.GetActivePerkLevel();

            matchData.players[matchData.players.length] = pd;
        }
    }

    if (kf2ed.MatchStatus == 0) {

        serializedData = class'KF2DiscordUtil'.static.GetLobbyJsonObject(matchData);
        link.SendData(serializedData);
    }
    else {
        ClearTimer('CheckLobbyStatus');
    }
}

function UpdateMatchStatus() {
    local string serializedData;

    matchData = Spawn(class'KF2Util').getMatchData(matchSession);

    serializedData = class'KF2DiscordUtil'.static.GetMatchDataJsonObject(matchData, "KF2_LOBBY_UPDATE");
    link.SendData(serializedData);
}

defaultproperties {
}
