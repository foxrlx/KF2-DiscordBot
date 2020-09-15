class KF2DiscordUtil extends object;

static function string GetMessageJsonObject(string uid, string playerName, string message, int health, KFPawn kfp, KFPlayerReplicationInfo kfpri) {
    local JsonObject json;
    local JsonObject jsonContent;

    json = new() Class'JSonObject';
    jsonContent = new() Class'JSonObject';
    
    json.SetStringValue("code", "KF2_MSG");
    jsonContent.SetStringValue("steamid", uid);
    jsonContent.SetStringValue("name", playerName);
    jsonContent.SetStringValue("message", message);
    jsonContent.SetIntValue("health", health);
    jsonContent.SetStringValue("perkname", kfp.GetPerk().PerkName);
    jsonContent.SetIntValue("perklevel", kfpri.GetActivePerkLevel());
    
    json.SetObject("content", jsonContent);

    return class'JSonObject'.static.EncodeJSon(json);
}