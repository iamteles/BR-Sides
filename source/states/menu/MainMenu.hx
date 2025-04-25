package states.menu;

import backend.system.Discord.DiscordIO;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import backend.game.GameData.MusicBeatState;
import objects.menu.Alphabet;
import flixel.text.FlxText;
import backend.song.SongData;
import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;
import flixel.effects.FlxFlicker;

using StringTools;

class MainMenu extends MusicBeatState
{
	var optionShit:Array<String> = ["story", "freeplay", "credits", "options"];
	static var curSelected:Int = 0;

	var optionGroup:FlxTypedGroup<FlxSprite>;
	var gradient:FlxSprite;
	var bg:FlxSprite;
	var tiles:FlxBackdrop;

	override function create()
	{
		super.create();
		CoolUtil.playMusic("freakyMenu");
		//115 bpm

		//Main.setMouse(true);

		// Updating Discord Rich Presence
		DiscordIO.changePresence("In the Main Menu...");

		tiles = new FlxBackdrop(Paths.image('menu/grid'), XY, 0, 0);
        tiles.velocity.set(40,40);
        tiles.scale.set(3,3);
        tiles.updateHitbox();
        tiles.screenCenter();
        tiles.antialiasing = false;
        add(tiles);

		gradient = new FlxSprite().loadGraphic(Paths.image('menu/main/gradient'));
		gradient.updateHitbox();
		gradient.screenCenter();
        gradient.blend = BlendMode.ADD;
		add(gradient);

        bg = new FlxSprite().loadGraphic(Paths.image('menu/main/bg'));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		optionGroup = new FlxTypedGroup<FlxSprite>();
		add(optionGroup);

		for(i in 0...optionShit.length)
		{
			var item = new FlxSprite().loadGraphic(Paths.image('menu/main/buttons/' + optionShit[i].toUpperCase()));
			item.scale.set(0.95, 0.95);
			item.updateHitbox();
			item.screenCenter();
			item.x -= 300;
			item.y -= 240;
			item.y += ((107 + 50) * i);
			item.ID = i;
			optionGroup.add(item);
		}

		var doidoSplash:String = 'BR Sides v${FlxG.stage.application.meta.get('version')} (IN-DEV)\nDoido Engine Kai v3.4.1k';

		var splashTxt = new FlxText(4, 0, 0, '$doidoSplash');
		splashTxt.setFormat(Main.gFont, 15, 0xFFFFFFFF, LEFT);
		splashTxt.setBorderStyle(OUTLINE, 0xFF000000, 1.5);
		splashTxt.y = FlxG.height - splashTxt.height - 4;
		add(splashTxt);

		changeSelection();
	}

	var selected:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		for(item in optionGroup.members)
		{
			if(item.ID == curSelected) {
				item.scale.x = FlxMath.lerp(item.scale.x, 1, elapsed * 8);
				item.scale.y = FlxMath.lerp(item.scale.y, 1, elapsed * 8);
				item.alpha = FlxMath.lerp(item.alpha, 1, elapsed * 10);
			}
			else {
				item.scale.x = FlxMath.lerp(item.scale.x, 0.95, elapsed * 8);
				item.scale.y = FlxMath.lerp(item.scale.y, 0.95, elapsed * 8);
				item.alpha = FlxMath.lerp(item.alpha, 0.56, elapsed * 10);
			}

			item.screenCenter();
			item.updateHitbox();
			item.x -= 300;
			item.y -= 240;
			item.y += ((107 + 50) * item.ID);
		}

		if(!selected) {
			if(Controls.justPressed(UI_UP))
				changeSelection(-1);
			if(Controls.justPressed(UI_DOWN))
				changeSelection(1);
	
			if(FlxG.keys.justPressed.ONE)
				SongData.unlockAll();

			if(FlxG.keys.justPressed.TWO)
				SongData.lockAll();

			if(Controls.justPressed(ACCEPT))
			{
				if(curSelected != 3) {
					FlxG.sound.play(Paths.sound('menu/confirm'));
					for(item in optionGroup.members)
					{
						if(item.ID == curSelected) {
							selected = true;
							FlxFlicker.flicker(item, 0.9, 0.06, true, false, function(_)
							{
								switch(optionShit[curSelected])
								{
									case "story":
										Main.switchState(new states.menu.StoryMenuState());

									case "freeplay":
										Main.switchState(new states.menu.FreeplayState());
					
									case "credits":
										Main.switchState(new states.menu.CreditsState());
								}
							});
						}
					}
				}
				else {
					openSubState(new subStates.options.OptionsSubState());
				}
			}
		}
	}

	public function changeSelection(change:Int = 0)
	{
		if(change != 0)
			FlxG.sound.play(Paths.sound("menu/scroll"));

		curSelected += change;
		curSelected = FlxMath.wrap(curSelected, 0, optionShit.length - 1);
	}
}