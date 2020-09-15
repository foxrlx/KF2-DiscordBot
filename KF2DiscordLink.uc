class KF2DiscordLink extends TCPLink;

var bool connected;
var IpAddr adapterIpAddr;

function PreBeginPlay() {
    connected = false;
	ReceiveMode = RMODE_Event;
	LinkMode = MODE_Line;
}

function Connect(string ip, int port) {
    StringToIpAddr(ip, adapterIpAddr);
    adapterIpAddr.port = 7070;
    
    BindPort();
    open(adapterIpAddr);
}

function opened() {
    connected = true;
}

function SendData(string data) {
    SendText(data);
}