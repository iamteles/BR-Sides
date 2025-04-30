package objects.hud;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import backend.utils.CharacterUtil;
import flixel.tweens.FlxTween;

class HealthIcon extends FlxSprite
{
	public function new()
	{
		super();
	}

	public var isPlayer:Bool = false;
	public var curIcon:String = "";
	public var maxFrames:Int = 0;

	public function setIcon(curIcon:String = "face", isPlayer:Bool = false):HealthIcon
	{
		this.curIcon = curIcon;

		if(curIcon == "fuleco-rar" && FlxG.random.bool(5))
			curIcon = "fuleco-tar";

		if(!Paths.fileExists('images/icons/icon-${curIcon}.png'))
		{
			if(curIcon.contains('-'))
				return setIcon(CharacterUtil.formatChar(curIcon), isPlayer);
			else
				return setIcon("face", isPlayer);
		}

		var iconGraphic = Paths.image("icons/icon-" + curIcon);

		maxFrames = Math.floor(iconGraphic.width / 150);

		loadGraphic(iconGraphic, true, Math.floor(iconGraphic.width / maxFrames), iconGraphic.height);

		antialiasing = FlxSprite.defaultAntialiasing;
		isPixelSprite = false;
		if(curIcon.contains('pixel'))
		{
			antialiasing = false;
			isPixelSprite = true;
		}

		animation.add("icon", [for(i in 0...maxFrames) i], 0, false);
		animation.play("icon");

		this.isPlayer = isPlayer;
		flipX = isPlayer;

		return this;
	}

	public function setAnim(health:Float = 1)
	{
		health /= 2;
		var daFrame:Int = 0;

		if(health < 0.3)
			daFrame = 1;

		if(health > 0.7)
			daFrame = 2;

		if(daFrame >= maxFrames)
			daFrame = 0;

		animation.curAnim.curFrame = daFrame;
	}

	public static function getColor(char:String = "", freeplay:Bool = false):FlxColor
	{
		var colorMap:Map<String, FlxColor> = [
			"face" 		=> 0xFFA1A1A1,
			"bf" 		=> 0xFF66FFFF,
			"gf"		=> 0xFF603657,
			"gf-_fp"	=> 0xFF7d4d73,
			"danilo"	=> 0xFFE5E3FA,
			"purobobora"=> 0xFF339999,
			"saco"		=> 0xFF74A40D,
			"fuleco"	=> 0xFFF5963D,
			"renan"		=> 0xFFFFFF99,
			"vrazillian"=> 0xFF4D4DF9,
			"dublando"	=> 0xFF663333,
		];

		if(freeplay)
			char += '-_fp';

		function loopMap()
		{
			if(!colorMap.exists(char))
			{
				if(char.contains('-'))
				{
					char = CharacterUtil.formatChar(char);
					loopMap();
				}
				else
					char = "face";
			}
		}
		loopMap();

		return colorMap.get(char);
	}
}