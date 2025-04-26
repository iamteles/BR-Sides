package states;

import backend.game.GameData.MusicBeatState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class WarningState extends MusicBeatState
{
	override public function create():Void 
	{
		super.create();
		var tex:String = "Warning!\n\n"
			+ " \n"
			+ "comi o cu de quem leu\n"
			+ " \n\n"
			+ "Press ACCEPT to continue \n";
		var popUpTxt = new FlxText(0,0,0,tex);
		popUpTxt.setFormat(Main.gFont, 36, 0xFFFFFFFF, CENTER);
		popUpTxt.screenCenter();
		add(popUpTxt);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if(Controls.justPressed(ACCEPT))
		{
			Main.skipClearMemory = true;
            Main.switchState(new states.SplashState(), 'base');

            FlxG.save.data.beenWarned = true;
            FlxG.save.flush();
        }
	}
}