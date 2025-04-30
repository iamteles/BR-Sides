package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import backend.game.GameData.MusicBeatState;
import flixel.system.FlxAssets;

class SplashState extends MusicBeatState
{
	public static var nextState:Class<FlxState>;

	/**
	 * @since 4.8.0
	 */
	public static var muted:Bool = #if html5 true #else false #end;

	var _sprite:Sprite;
	var _gfx:Graphics;
	var _text:TextField;

	var _times:Array<Float>;
	var _functions:Array<Void->Void>;
	var _curPart:Int = 0;
	var _cachedBgColor:FlxColor;
	var _cachedTimestep:Bool;
	var _cachedAutoPause:Bool;

	override public function create():Void
	{
		_times = [0.041, 0.184, 0.334, 0.495, 0.636];
		_functions = [drawGreen, drawYellow, drawRed, drawBlue, drawLightBlue];

		for (time in _times)
		{
			new FlxTimer().start(time, timerCallback);
		}

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		_sprite = new Sprite();
		FlxG.stage.addChild(_sprite);
		_gfx = _sprite.graphics;

		_text = new TextField();
		_text.selectable = false;
		_text.embedFonts = true;
		var dtf = new TextFormat(FlxAssets.FONT_DEFAULT, 16, 0x009440);
		dtf.align = TextFormatAlign.CENTER;
		_text.defaultTextFormat = dtf;
		_text.text = "HaxeFlixel";
		FlxG.stage.addChild(_text);

		onResize(stageWidth, stageHeight);

		#if FLX_SOUND_SYSTEM
		if (!muted)
		{
			FlxG.sound.play(Paths.sound("flixel"), 1, false, null, true);
		}
		#end
	}

	override public function destroy():Void
	{
		_sprite = null;
		_gfx = null;
		_text = null;
		_times = null;
		_functions = null;
		super.destroy();
	}

	override public function onResize(Width:Int, Height:Int):Void
	{
		super.onResize(Width, Height);

		_sprite.x = (Width / 2);
		_sprite.y = (Height / 2) - 20 * FlxG.game.scaleY;

		_text.width = Width / FlxG.game.scaleX;
		_text.x = 0;
		_text.y = _sprite.y + 80 * FlxG.game.scaleY;

		_sprite.scaleX = _text.scaleX = FlxG.game.scaleX;
		_sprite.scaleY = _text.scaleY = FlxG.game.scaleY;
	}

	function timerCallback(Timer:FlxTimer):Void
	{
		_functions[_curPart]();
		//_text.textColor = _colors[_curPart];
		_text.text = "HaxeFlixel";
		_curPart++;

		if (_curPart == 5)
		{
			// Make the logo a tad bit longer, so our users fully appreciate our hard work :D
			FlxTween.tween(_sprite, {alpha: 0}, 3.0, {ease: FlxEase.quadOut, onComplete: onComplete});
			FlxTween.tween(_text, {alpha: 0}, 3.0, {ease: FlxEase.quadOut});
		}
	}

	function drawGreen():Void
	{
		_gfx.beginFill(0xffcb00);
		_gfx.moveTo(0, -37);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(37, 1);
		_gfx.lineTo(1, 37);
		_gfx.lineTo(0, 37);
		_gfx.lineTo(-37, 1);
		_gfx.lineTo(-37, 0);
		_gfx.lineTo(0, -37);
		_gfx.endFill();
	}

	function drawYellow():Void
	{
		_gfx.beginFill(0x009440);
		_gfx.moveTo(-50, -50);
		_gfx.lineTo(-25, -50);
		_gfx.lineTo(0, -37);
		_gfx.lineTo(-37, 0);
		_gfx.lineTo(-50, -25);
		_gfx.lineTo(-50, -50);
		_gfx.endFill();
	}

	function drawRed():Void
	{
		_gfx.beginFill(0x009440);
		_gfx.moveTo(50, -50);
		_gfx.lineTo(25, -50);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(50, -25);
		_gfx.lineTo(50, -50);
		_gfx.endFill();
	}

	function drawBlue():Void
	{
		_gfx.beginFill(0x009440);
		_gfx.moveTo(-50, 50);
		_gfx.lineTo(-25, 50);
		_gfx.lineTo(0, 37);
		_gfx.lineTo(-37, 1);
		_gfx.lineTo(-50, 25);
		_gfx.lineTo(-50, 50);
		_gfx.endFill();
	}

	function drawLightBlue():Void
	{
		_gfx.beginFill(0x009440);
		_gfx.moveTo(50, 50);
		_gfx.lineTo(25, 50);
		_gfx.lineTo(1, 37);
		_gfx.lineTo(37, 1);
		_gfx.lineTo(50, 25);
		_gfx.lineTo(50, 50);
		_gfx.endFill();
	}

	function onComplete(Tween:FlxTween):Void
	{
		skip();
		//FlxG.game._gameJustStarted = true;
	}

	function skip():Void
	{
		FlxG.stage.removeChild(_sprite);
		FlxG.stage.removeChild(_text);
		Main.skipClearMemory = true;
		Main.switchState(new DoidoSplash(), 'base');
		//FlxG.game._gameJustStarted = true;
	}

	override public function update(elapsed:Float):Void 
	{
		//Thing to skip the splash screen
		//Comment this out if you want it unskippable
		if (Controls.justPressed(ACCEPT))
			skip();

		super.update(elapsed);
	}
}

class DoidoSplash extends MusicBeatState
{
	var sprite:FlxSprite;
	var canSkip:Bool;
	var text:FlxText;
	override public function create():Void 
	{
		super.create();
		sprite = new FlxSprite().loadGraphic(Paths.image("doido_logo"));
		sprite.updateHitbox();
		sprite.screenCenter();
		sprite.y -= 7;
		sprite.alpha = 0;
		add(sprite);

		var text = new FlxText(0, 16, 0, "Doido Engine ~ Kai");
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
			FlxG.sound.play(Paths.sound("doido"), 1, false, null, true);

			new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
				FlxTween.tween(text, {alpha: 1}, 0.6, {ease: FlxEase.linear, onComplete: function(twn:FlxTween)
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