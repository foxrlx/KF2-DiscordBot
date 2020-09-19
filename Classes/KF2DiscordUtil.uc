class KF2DiscordUtil extends object;

//static function string GetMessageJsonObject(string message, PlayerData pd) {
static function string GetMessageJsonObject(string uid, string playerName, string message, KFPawn kfp, KFPlayerReplicationInfo kfpri) {
    local JsonObject json;
    local JsonObject jsonContent;
    local PlayerData pd;

    json = new() Class'JSonObject';
    jsonContent = new() Class'JSonObject';
    
    json.SetStringValue("code", "KF2_MSG");
    jsonContent.SetStringValue("steamid", pd.steamid);
    jsonContent.SetStringValue("name", pd.playername);
    jsonContent.SetStringValue("message", message);
    jsonContent.SetIntValue("health", pd.health);
    jsonContent.SetIntValue("maxhealth", pd.maxhealth);
    jsonContent.SetIntValue("healthpercent", pd.healthpercent);
    jsonContent.SetStringValue("perkname", pd.perkname);
    jsonContent.SetIntValue("perklevel", pd.perklevel);
    
    json.SetObject("content", jsonContent);

    return class'JSonObject'.static.EncodeJSon(json);
}

static function string GetMatchCreatedJsonObject(string session) {
    local JsonObject json;
    local JsonObject jsonContent;

    json = new() class'JsonObject';
    jsonContent = new() class'JsonObject';

    json.SetStringValue("code", "KF2_MATCHCREATED");
    jsonContent.SetStringValue("matchsession", session);

    json.SetObject("content", jsonContent);

    return class'JsonObject'.static.EncodeJson(json);
}

static function string GetLobbyJsonObject(MatchData matchData) {
    local PlayerData pd;

    local JsonObject json;
    local JsonObject jsonContent;
    local JsonObject pdJson;
    local JsonObject playerarray;

    local int i;

    json = new() class'JsonObject';
    jsonContent = new() class'JsonObject';
    playerarray = new() class'JsonObject';

    json.SetStringValue("code", "KF2_LOBBY_UPDATE");
    jsonContent.SetStringValue("matchsession", matchData.matchsession);
    jsonContent.SetStringValue("mapname", matchData.mapname);
    jsonContent.SetStringValue("gamelength", matchData.gamelength);
    jsonContent.SetStringValue("gamedifficulty", matchData.gamedifficulty);
    jsonContent.SetIntValue("totalwave", matchData.totalWave);

    for (i = 0; i < matchData.players.length; i++) {
        pd = matchData.players[i];
        pdJson = new() class'JsonObject';
        pdJson.SetStringValue("playername", pd.playername);
        pdJson.SetIntValue("id", pd.playerid);
        pdJson.SetBoolValue("ready", pd.ready);
        pdJson.SetStringValue("perkname", pd.perkname);
        pdJson.SetIntValue("perklevel", pd.perklevel);

        playerarray.ObjectArray[playerarray.ObjectArray.length] = pdJson;
    }

    jsonContent.SetObject("playerlist", playerarray);
    json.SetObject("content", jsonContent);

    return class'JsonObject'.static.EncodeJson(json);
}

static function string GetMatchDataJsonObject(MatchData matchData, string code) {
    local PlayerData pd;

    local JsonObject json;
    local JsonObject jsonContent;
    local JsonObject pdJson;
    local JsonObject playerarray;

    local int i;

    json = new() class'JsonObject';
    jsonContent = new() class'JsonObject';
    playerarray = new() class'JsonObject';

    json.SetStringValue("code", code);
    jsonContent.SetStringValue("matchsession", matchData.matchsession);
    jsonContent.SetStringValue("mapname", matchData.mapname);
    jsonContent.SetStringValue("gamelength", matchData.gamelength);
    jsonContent.SetStringValue("gamedifficulty", matchData.gamedifficulty);
    jsonContent.SetIntValue("totalwave", matchData.totalwave);
    jsonContent.SetIntValue("currentwave", matchData.currentwave);
    jsonContent.SetBoolValue("wavestarted", matchData.wavestarted);
    jsonContent.SetBoolValue("waveisactive", matchData.waveisactive);

    for (i = 0; i < matchData.players.length; i++) {
        pd = matchData.players[i];
        pdJson = new() class'JsonObject';
        pdJson.SetStringValue("playername", pd.playername);
        pdJson.SetStringValue("steamid", pd.steamid);
        pdJson.SetIntValue("id", pd.playerid);
        pdJson.SetBoolValue("ready", pd.ready);
        pdJson.SetStringValue("perkname", pd.perkname);
        pdJson.SetIntValue("perklevel", pd.perklevel);
        pdJson.SetFloatValue("dosh", pd.dosh);
        pdJson.SetIntValue("deaths", pd.deaths);
        pdJson.SetIntValue("kills", pd.kills);
        pdJson.SetIntValue("assists", pd.assists);
        pdJson.SetIntValue("ping", pd.ping * 4);
        pdJson.SetIntValue("health", pd.health);
        pdJson.SetIntValue("maxhealth", pd.maxhealth);
        pdJson.SetIntValue("healthpercent", pd.maxhealth);

        playerarray.ObjectArray[playerarray.ObjectArray.length] = pdJson;
    }
	
    jsonContent.SetObject("playerlist", playerarray);
    json.SetObject("content", jsonContent);

    return class'JsonObject'.static.EncodeJson(json);
}
