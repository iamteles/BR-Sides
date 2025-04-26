package;

import backend.game.GameData.MusicBeatState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import states.*;

class Init extends MusicBeatState
{
	override function create()
	{
		super.create();
		SaveData.init();
		DiscordIO.check();
				
		FlxG.fixedTimestep = false;
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = false;
		FlxGraphic.defaultPersist = true;

		firstState();
	}

	function firstState()
	{
		Main.switchState(new states.LoadMisc(), 'base');
	}
}