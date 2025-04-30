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
		var tex:String = "Aviso!\n\n"
			+ "Esse mod contem luzes piscantes que podem\n"
			+ "prejudicar aqueles com epilepsia e sensibilidade a luz.\n"
			+ "Você pode desativar elas no menu de Opções\n\n"
			+ "Pressione ACCEPT para continuar";
		if(SaveData.en) {
			tex = "Warning!\n\n"
			+ "This mod features flashing lights that may\n"
			+ "be harmful to those with photosensitivity.\n"
			+ "You can disable them in the Options menu.\n\n"
			+ "Press ACCEPT to continue";
		}
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