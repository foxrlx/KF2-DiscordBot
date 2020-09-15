class KF2DiscordBot extends Actor Config(DiscordBot);

// https://docs.unrealengine.com/udk/Three/UnrealScriptIterators.html

var KF2DiscordLink link;
//var KF2DiscordBroadcastHandler bcastHandler;
//var KF2DiscordEventDetector eventDetector;

const VERSION = "0.01";

function postBeginPlay() {
    local MessagingSpectator msgSpec;
    
    Super.postBeginPlay();    

    msgSpec = Spawn(class'MessagingSpectator');
    msgSpec.AddReceiver(MsgSpecHandler);
    
    //eventDetector = Spawn(class'KF2DiscordEventDetector');

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

    kfgi = KFGameInfo(WorldInfo.GameInfo);
    `Log("Game Length " $ kfgi.GameLength);

    foreach WorldInfo.AllPawns(class'Pawn', p)
    {
        if (p.PlayerReplicationInfo != none && p.PlayerReplicationInfo.PlayerId == Sender.PlayerId)
        {
            health = p.Health;
            kfp = KFPawn(p);
            kfpri = KFPlayerReplicationInfo(p.PlayerReplicationInfo);
            break;
        }
    }

    // GET SteamID in hex format
    uid = class'OnlineSubsystem'.static.UniqueNetIdToString(Sender.UniqueId);
    
    serializedData = class'KF2DiscordUtil'.static.GetMessageJsonObject(uid, Sender.PlayerName, Msg, health, kfp, kfpri);
    //link.SendData(serializedData);
}

function ConnectToDiscordAdapter() {
    link = Spawn(Class'KF2DiscordLink');
    link.SetOwner(self);

    //bcastHandler = Spawn(class'KF2DiscordBroadcastHandler');
    //bcastHandler.SetOwner(self);


    link.Connect("127.0.0.1", 7070);
}

defaultproperties {
}