package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.*;
import backend.game.GameData.MusicBeatState;

class LanguageState extends MusicBeatState
{
	var selectedSomethin:Bool = false;
	var curSelected:Int = 0;
	var options:Array<String> = ["PORTUGUES","ENGLISH"];
	var optionsNames:Array<String> = ["PORTUGUÊS","ENGLISH"];
	var daButtons:Array<FlxText> = [];

	override function create()
	{
		super.create();
		
		for(i in 0...options.length)
		{
			var daText:FlxText = new FlxText(40, 40, 1180, optionsNames[i].toUpperCase(), 36);
			daText.setFormat(Main.gFont, 36, FlxColor.WHITE, CENTER);
			daText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
			daText.antialiasing = true;

			daText.x = Math.floor((FlxG.width / 2) - (daText.width / 2));
			daText.y = Math.floor((FlxG.height / 2) - (daText.height / 2));
			
			daText.y += (i == 0) ? -15 : 15;
			
			daText.ID = i;
			daButtons.push(daText);
			add(daText);
		}
	}

	override function update(elapsed:Float)
	{
		if(!selectedSomethin)
		{
			if(Controls.justPressed(ACCEPT))
				gotoGame();
			
			if(Controls.justPressed(UI_UP) || Controls.justPressed(UI_DOWN))
				changeSelection();
		}
		
		for(i in daButtons)
			i.alpha = (i.ID == curSelected) ? 1 : 0.7;
	}

	function gotoGame()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('menu/cancel'));
			
		//FlxG.save.data.firstTime = false;
		SaveData.data.set('Language', options[curSelected]);
		SaveData.save();
		
		Main.switchState(new WarningState(), 'base');
	}
	
	function changeSelection()
	{
		curSelected++;
		
		FlxG.sound.play(Paths.sound('menu/scroll'));
		
		if(curSelected < 0)
		   curSelected = options.length - 1;
		if(curSelected > options.length - 1)
		   curSelected = 0;
	}
}
