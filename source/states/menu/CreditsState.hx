package states.menu;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import backend.game.GameData.MusicBeatState;
import backend.song.Highscore;
import backend.song.Highscore.ScoreData;
import backend.song.SongData;
import objects.menu.AlphabetMenu;
import objects.hud.HealthIcon;
import states.*;
import states.editors.ChartingState;
import subStates.menu.DeleteScoreSubState;

using StringTools;

typedef CreditData = {
	var name:String;
    var icon:String;
    var color:FlxColor;
    var info:String;
	var link:Null<String>;
}
class CreditsState extends MusicBeatState
{
	var creditList:Array<CreditData> = [];
    
	function addCredit(name:String, icon:String, color:FlxColor, info:String, ?link:Null<String>)
	{
		creditList.push({
            name: name,
            icon: icon,
            color: color,
            info: info,
			link: link,
        });
	}

	static var curSelected:Int = 0;

	var bg:FlxSprite;
	var bgTween:FlxTween;
	var grpItems:FlxGroup;
	var infoTxtFocus:AlphabetMenu;
	var infoTxt:FlxText;

	override function create()
	{
		super.create();
		CoolUtil.playMusic("freakyMenu");

		DiscordIO.changePresence("Credits - Thanks!!");

		bg = new FlxSprite().loadGraphic(Paths.image('menu/backgrounds/menuDesat'));
		bg.scale.set(1.2,1.2); bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		grpItems = new FlxGroup();
		add(grpItems);

		infoTxt = new FlxText(0, 0, FlxG.width * 0.6, 'balls');
		infoTxt.setFormat(Main.gFont, 24, 0xFFFFFFFF, CENTER);
        infoTxt.setBorderStyle(OUTLINE, 0xFF000000, 1.5);
        add(infoTxt);

		final specialPeople = 'Anakim, ArturYoshi, BeastlyChip♧, Bnyu, Evandro, NxtVithor, Pi3tr0, Raphalitos, ZieroSama';
		final specialCoders = 'Crowplexus, Gazozoz, Joalor64GH, soushimiya';
		// yes, this implies coders aren't people
		// :D
		
		/*
		// btw you dont need to credit everyone here on your mod, just credit doido engine as a whole and we're good
		addCredit('JulianoBeta', 				'juliano', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Daniel DGL', 				'dgl', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Bew', 				'bew', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Lamenzito', 				'lamenzito', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		//addCredit('Julitolito', 				'Tel', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('DoubleoNikoo', 				'nikoo', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Guityz', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('DiogoTV', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Novaize', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Knira', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Lucas Barbosa', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Neverminds', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('ZieroSama', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Anna The Fennec', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Telly', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Morgan', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Hiro Mizuki', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Léozito', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('teles', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		*/

		addCredit('teles', 				'Teles', 	 0xFF696969, "SAI DAQUI PORRA NAO TA PRONTO",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		
		for(i in 0...creditList.length)
		{
			var credit = creditList[i];

			var item = new AlphabetMenu(0, 0, credit.name, false);
			item.align = CENTER;
			item.updateHitbox();
			grpItems.add(item);

			var icon = new FlxSprite();
			icon.loadGraphic(Paths.image('credits/${credit.icon}'));
			grpItems.add(icon);

			// big ears
			if(credit.icon == "anna")
				icon.offset.y = 30;

			item.icon = icon;
			item.ID = i;
			icon.ID = i;

			item.spaceX = 0;
			item.spaceY = 200;
			item.xTo = (FlxG.width / 2) - (icon.width / 2);
			item.focusY = i - curSelected;
			item.updatePos();
		}
		changeSelection();

		#if TOUCH_CONTROLS
		createPad("back");
		#end
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		curSelected = FlxMath.wrap(curSelected, 0, creditList.length - 1);
		
		for(rawItem in grpItems.members)
		{
			if(Std.isOfType(rawItem, AlphabetMenu))
			{
				var item = cast(rawItem, AlphabetMenu);
				item.focusY = item.ID - curSelected;

				item.alpha = 0.4;
				if(item.ID == curSelected) {
					infoTxtFocus = item;
					item.alpha = 1;
				}
			}
		}

		infoTxt.text = creditList[curSelected].info;
		infoTxt.screenCenter(X);
		
		if(bgTween != null) bgTween.cancel();
		bgTween = FlxTween.color(bg, 0.4, bg.color, creditList[curSelected].color);

		if(change != 0)
			FlxG.sound.play(Paths.sound("menu/scroll"));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(Controls.justPressed(UI_UP))
			changeSelection(-1);
		if(Controls.justPressed(UI_DOWN))
			changeSelection(1);

		if(Controls.justPressed(BACK))
			Main.switchState(new DebugState());

		if(Controls.justPressed(ACCEPT))
		{
			var daCredit = creditList[curSelected].link;
			if(daCredit != null)
				CoolUtil.openURL(daCredit);
		}
		
		infoTxt.y = infoTxtFocus.y + infoTxtFocus.height + 48;
		for(rawItem in grpItems.members)
		{
			if(Std.isOfType(rawItem, AlphabetMenu))
			{
				var item = cast(rawItem, AlphabetMenu);
				item.icon.x = item.x + (item.width / 2);
				item.icon.y = item.y - item.icon.height / 6;
				item.icon.alpha = item.alpha;
			}
		}
	}
}