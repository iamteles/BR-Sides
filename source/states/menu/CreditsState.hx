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
import objects.menu.AlphabetRetro;
import objects.hud.HealthIcon;
import states.*;
import states.editors.ChartingState;
import subStates.menu.DeleteScoreSubState;
import flixel.addons.display.FlxBackdrop;

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

	var bg:FlxBackdrop;
	var bgTween:FlxTween;
	var grpItems:FlxGroup;
	var infoTxtFocus:AlphabetRetro;
	var infoTxt:FlxText;

	override function create()
	{
		super.create();
		CoolUtil.playMusic("freakyMenu");

		DiscordIO.changePresence("Credits - Thanks!!");

        bg = new FlxBackdrop(Paths.image('menu/grid'), XY, 0, 0);
        bg.velocity.set(40,40);
        bg.scale.set(3,3);
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = false;
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
		
		// btw you dont need to credit everyone here on your mod, just credit doido engine as a whole and we're good
		addCredit('JulianoBeta', 				'juliano', 	 0xFF696969, "Diretor, Compositor e Charter",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Daniel DGL', 				'dgl', 	 0xFF696969, "Artista Principal",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('teles', 				'teles', 	 0xFF696969, "Programadora Principal, Sound Design",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('DiogoTV', 				'diogotv', 	 0xFF696969, "Artista e Programador",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Bew', 				'bew', 	 0xFF696969, "Artista",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Lamenzito', 				'lamenzito', 	 0xFF696969, "Artista",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Julitolito', 				'julito', 	 0xFF696969, "Artista",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('DoubleoNikoo', 				'nikoo', 	 0xFF696969, "Artista",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Guityz', 				'guityz', 	 0xFF696969, "Artes Adicionais",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Novaize', 				'dn', 	 0xFF696969, "Animador",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Knira', 				'knira', 	 0xFF696969, "Designs",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Lucas Barbosa', 				'lucas', 	 0xFF696969, "Compositor",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Neverminds', 				'nevermindslol', 	 0xFF696969, "Compositor",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('ZieroSama', 				'ziero', 	 0xFF696969, "Compositor",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Anna The Fennec', 				'anna', 	 0xFF696969, "Charter",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Telly', 				'telly', 	 0xFF696969, "Compositor",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Morgan', 				'morgan', 	 0xFF696969, "Voice Actor",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Hiro Mizuki', 				'hiro', 	 0xFF696969, "Voice Actor",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Leozito', 				'leo', 	 0xFF696969, "Voice Actor",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		addCredit('Tagaki', 				'tagaki', 	 0xFF696969, "Voice Actor",					'https://www.youtube.com/shorts/jQ1frxU_a6o');
		
		for(i in 0...creditList.length)
		{
			var credit = creditList[i];

			var item = new AlphabetRetro(0, 0, credit.name, false);
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

		var color:FlxColor = 0xFF696969;
		
		for(rawItem in grpItems.members)
		{
			if(Std.isOfType(rawItem, AlphabetRetro))
			{
				var item = cast(rawItem, AlphabetRetro);
				item.focusY = item.ID - curSelected;

				item.alpha = 0.4;
				if(item.ID == curSelected) {
					infoTxtFocus = item;
					item.alpha = 1;

					color = CoolUtil.dominantColor(item.icon);
				}
			}
		}

		infoTxt.text = creditList[curSelected].info;
		infoTxt.screenCenter(X);
		
		if(bgTween != null) bgTween.cancel();
		bgTween = FlxTween.color(bg, 0.4, bg.color, color);

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
			Main.switchState(new states.menu.MainMenu());

		if(Controls.justPressed(ACCEPT))
		{
			var daCredit = creditList[curSelected].link;
			if(daCredit != null)
				CoolUtil.openURL(daCredit);
		}
		
		infoTxt.y = infoTxtFocus.y + infoTxtFocus.height + 48;
		for(rawItem in grpItems.members)
		{
			if(Std.isOfType(rawItem, AlphabetRetro))
			{
				var item = cast(rawItem, AlphabetRetro);
				item.icon.x = item.x + (item.width / 2);
				item.icon.y = item.y - item.icon.height / 6;
				item.icon.alpha = item.alpha;
			}
		}
	}
}