package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import backend.game.GameData.MusicBeatState;

class FreeplayCue extends MusicBeatState
{
	var sprite:FlxSprite;
	var canSkip:Bool;
	var text:FlxText;
	override public function create():Void 
	{
		super.create();
		sprite = new FlxSprite().loadGraphic(Paths.image("phone"));
		sprite.updateHitbox();
		sprite.screenCenter();
		sprite.y -= 7;
		sprite.alpha = 0;
		add(sprite);

		var text = new FlxText(0, 16, 0, (SaveData.en ? "Some songs have been unlocked in Freeplay!" : "Algumas músicas foram desbloqueadas no Freeplay!"));
        text.setFormat(Main.gFont, 36, 0xFFFFFFFF, CENTER);
        text.screenCenter(X);
		text.y = sprite.y + sprite.height + 14;
		text.alpha = 0;
        add(text);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			CoolUtil.flash(FlxG.camera, 1, 0xffffffff); 
			canSkip = true;
			sprite.alpha = 1;
			FlxG.sound.play(Paths.sound("volume"), 1, false, null, true);

			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				FlxTween.tween(text, {alpha: 1}, 1.2, {ease: FlxEase.linear, onComplete: function(twn:FlxTween)
				{
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						finish();
					});
				}});
			});
		});
	}
	
	override public function update(elapsed:Float):Void 
	{
		//Thing to skip the splash screen
		//Comment this out if you want it unskippable
		if (Controls.justPressed(ACCEPT) && canSkip)
			finish();
		
		super.update(elapsed);
	}
	
	private function finish():Void
	{
		Main.switchState(new states.menu.TitleScreen(), 'base');
	}
	
}