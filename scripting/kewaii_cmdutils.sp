#include <csgocolors>

#pragma newdecls required
#pragma semicolon 1

#define PLUGIN_DESCRIPTION 	"Many commands to help in server moderation."
#define PLUGIN_AUTHOR 		"Kewaii"
#define PLUGIN_VERSION 		"1.3.1"
#define PLUGIN_TAG			"{pink}	[CMDUtils by Kewaii]{green}"
#define PLUGIN_NAME      "CMDUtils"

public Plugin myinfo = {
 name = PLUGIN_NAME,
 author = PLUGIN_AUTHOR,
 description = PLUGIN_DESCRIPTION,
 version = PLUGIN_VERSION,
 url = "https://steamcommunity.com/id/KewaiiGamer"
};

public void OnPluginStart() {
	RegAdminCmd("sm_hudsay", Command_HUDSay, ADMFLAG_KICK, "replacement to msay without being annoying");
	RegAdminCmd("sm_bc", Command_Colorify, ADMFLAG_KICK, "colorifies the player");
	LoadTranslations("kewaii_cmdutils.phrases");
}

public Action Command_HUDSay(int client, int args)
{
	if (args == 0)
	{
		CReplyToCommand(client, "%s Usage: sm_hudsay <msg>", PLUGIN_TAG);
		return Plugin_Handled;
	}
	else
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsFakeClient(i))
			{
				char arg1[512];
				GetCmdArgString(arg1, sizeof(arg1));
				SetHudTextParams(0.1, -1.0, 5.0, 255, 0, 0, 255, 0, 0.1, 0.1, 0.1);			
				ShowHudText(i, 5, arg1);
			}
		}
	}
	return Plugin_Handled;
}

public Action Command_Colorify(int client, int args)
{
	if (args < 2)
	{
		CReplyToCommand(client, "%s Usage: sm_bc <target> red|blue|<r|g|b>", PLUGIN_TAG);
		return Plugin_Handled;
	}
	else if (args >= 2)
	{
		char arg1[64], arg2[64];
		GetCmdArg(1, arg1, sizeof(arg1));
		GetCmdArg(2, arg2, sizeof(arg2));
		int target1 = FindTarget(client, arg1);
		char name[64];
		GetClientName(target1, name, sizeof(name));
		if (args == 2)
		{
			if (IsPlayerAlive(target1))
			{
				if (StrEqual(arg2, "red"))
				{
					CPrintToChatAll("%s %t", PLUGIN_TAG, "RedColor", name);
					SetEntityRenderColor(target1, 255, 0, 0, 0);
				}
				else if (StrEqual(arg2, "blue"))
				{
					CPrintToChatAll("%s %t", PLUGIN_TAG, "BlueColor", name);
					SetEntityRenderColor(target1, 0, 0, 255, 0);
				}
				else
				{
					CPrintToChat(client, "%s %t", PLUGIN_TAG, "UnrecognizedColor");
				}
			}
			else
			{
				CPrintToChat(client, "%s %t", PLUGIN_TAG, "TargetDead");
			}
		}
		else if(args == 4)
		{
			char arg3[4], arg4[4];
			GetCmdArg(3, arg3, sizeof(arg3));
			GetCmdArg(4, arg4, sizeof(arg4));
			int r,g,b;
			r = StringToInt(arg2);
			g = StringToInt(arg3);
			b = StringToInt(arg4);
			CPrintToChatAll("%s %t", PLUGIN_TAG, "RGBColor", name, r, g, b);
			SetEntityRenderColor(target1, r, g, b, 0);
		}
	}
	return Plugin_Handled;
}
