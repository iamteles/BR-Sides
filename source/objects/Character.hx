package objects;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;
import flxanimate.FlxAnimate;
import backend.utils.CharacterUtil;
import backend.utils.CharacterUtil.*;
import objects.note.Note;

using StringTools;

class Character extends FlxAnimate
{
	// dont mess with these unless you know what youre doing!
	// they are used in important stuff
	public var curChar:String = "bf";
	public var isPlayer:Bool = false;
	public var onEditor:Bool = false;
	public var specialAnim:Int = 0;
	public var curAnimFrame(get, never):Int;
	public var curAnimFinished(get, never):Bool;
	public var curDirection(get, never):String;
	public var holdTimer:Float = Math.NEGATIVE_INFINITY;

	// time (in seconds) that takes to the character return to their idle anim
	public var holdLength:Float = 0.7;
	// when (in frames) should the character singing animation reset when pressing long notes
	public var holdLoop:Int = 4;

	// modify these for your liking (idle will cycle through every array value)
	public var idleAnims:Array<String> = ["idle"];
	public var altIdle:String = "";
	public var altSing:String = "";
	
	// true: dances every beat // false: dances every other beat
	public var quickDancer:Bool = false;

	// warning, only uses this
	// if the current character doesnt have game over anims
	public var deathChar:String = "bf-dead";

	// you can modify these manually but i reccomend using the offset editor instead
	public var globalOffset:FlxPoint = new FlxPoint();
	public var cameraOffset:FlxPoint = new FlxPoint();
	public var ratingsOffset:FlxPoint = new FlxPoint();
	private var scaleOffset:FlxPoint = new FlxPoint();

	// you're probably gonna use sparrow by default?
	var spriteType:SpriteType = SPARROW;

	public function new(curChar:String = "bf", isPlayer:Bool = false, onEditor:Bool = false)
	{
		super(0,0,false);
		this.onEditor = onEditor;
		this.isPlayer = isPlayer;
		this.curChar = curChar;
		
		antialiasing = FlxSprite.defaultAntialiasing;
		isPixelSprite = false;
		
		var doidoChar = CharacterUtil.defaultChar();
		switch(curChar)
		{
			case "bf-chimas":
				doidoChar.spritesheet += 'bf/chimas';
				doidoChar.anims = [
					['idle', 			'Beto idle', 		24, false],
					['singUP', 			'Beto up0', 			24, false],
					['singLEFT', 		'Beto left0', 		24, false],
					['singRIGHT', 		'Beto right0', 		24, false],
					['singDOWN', 		'Beto down0', 		24, false],
					['singUPmiss', 			'Beto up miss', 			24, false],
					['singLEFTmiss', 		'Beto left miss', 		24, false],
					['singRIGHTmiss', 		'Beto right miss', 		24, false],
					['singDOWNmiss', 		'Beto down miss', 		24, false],
					['hey', 			'Beto TOMANDO', 				24, false],
				];
				
				flipX = true;

				scale.set(0.75,0.75);
			case "purobobora" | "purobobora-d":
				doidoChar.spritesheet += 'purobobora/purobobora';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],
					['arroz', 			'arroz0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],
				];


				if(curChar == "purobobora-d") {
					doidoChar.extrasheets = ['purobobora/dancing'];
					doidoChar.anims.push(['dance', 			'arroz', 		24, true]);
				}

				scale.set(0.75,0.75);
			case "gf":
				//spriteType = ATLAS; // man
				doidoChar.spritesheet += 'gf/gi_ass_sets';
				doidoChar.anims = [
					['idle', 			'idle', 		24, false],
				];

				idleAnims = ["idle"];
				//quickDancer = true;
				flipX = isPlayer;

				scale.set(0.75,0.75);

			case "gf-week2" | "gf-sequestro":
				doidoChar.spritesheet += 'gf/week2/gi_week2';
				doidoChar.anims = [
					['idle', 			'idle', 		24, false],
				];

				if(curChar == "gf-sequestro") {
					doidoChar.extrasheets = ['gf/week2/gi_sequestro'];
					doidoChar.anims.push(['staring1', 			'staring1', 		24, false]);
					doidoChar.anims.push(['staring2', 			'staring2', 		24, false]);
					doidoChar.anims.push(['return', 			'return idle', 		24, false]);

					idleAnims = ["staring1", "staring2"];
				}
				else
					idleAnims = ["idle"];


				flipX = isPlayer;

				scale.set(0.72,0.72);

			case "gf-tutorial":
				doidoChar.spritesheet += 'gf/gi_ass_sets';
				doidoChar.extrasheets = ['gf/gi_tutorial'];
				doidoChar.anims = [
					['idle', 			'idle', 		24, false],
					['cheer', 		'hooray', 	24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],

					['singLEFTalt', 	'left alt', 24, false],
					['singRIGHTalt', 	'right alt',24, false],
					['singUPalt', 		'up alt', 	24, false],
					['singDOWNalt', 	'down alt', 24, false],
				];

				idleAnims = ["idle"];
				//quickDancer = true;
				flipX = isPlayer;

				scale.set(0.75,0.75);
			
			case "no-gf":
				doidoChar.spritesheet += 'gf/no-gf/no-gf';
				doidoChar.anims = [
					['idle', 'idle'],
				];

			case 'saco':
				doidoChar.spritesheet += 'saco/saco';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],
					['ai', 			'ai0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],

					['singLEFTalt', 	'lealt0', 24, false],
					['singRIGHTalt', 	'rialt0',24, false],
					['singUPalt', 		'ualt0', 	24, false],
					['singDOWNalt', 	'doalt0', 24, false],
				];

				scale.set(0.75,0.75);

			case 'saco-creep':
				doidoChar.spritesheet += 'saco/creep';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],
				];

				scale.set(0.75,0.75);

			case 'danilo':
				doidoChar.spritesheet += 'danilo/DaniloNormal';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],
				];

				scale.set(0.8,0.8);

			case 'danilo-brabo':
				doidoChar.spritesheet += 'danilo/DaniloBrabo';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],
				];

				if(states.PlayState.hasCutscene()) {
					doidoChar.extrasheets = ['danilo/DaniloCut'];
					doidoChar.anims.push(['start', 			'brabo0007', 		24, true]);
					doidoChar.anims.push(['rage', 			'brabo', 		24, false]);
				}

				scale.set(0.8,0.8);

			case "test-note":
				doidoChar.spritesheet = "notes/base/notes";
				doidoChar.anims = [
					['idle', 			'arrowLEFT', 		24, false],
					['pressed', 			'left press', 		24, false],
					['confirm', 			'left confirm', 		24, false],
				];

			default: // case "bf"
				if(!["bf", "face"].contains(curChar))
					curChar = (isPlayer ? "bf" : "face");

				if(curChar == "bf")
				{
					doidoChar.spritesheet += 'bf/BETO';
					doidoChar.anims = [
						['idle', 			'Beto idle', 		24, false],
						['singUP', 			'Beto up0', 			24, false],
						['singLEFT', 		'Beto left0', 		24, false],
						['singRIGHT', 		'Beto right0', 		24, false],
						['singDOWN', 		'Beto down0', 		24, false],
						['singUPmiss', 			'Beto up miss', 			24, false],
						['singLEFTmiss', 		'Beto left miss', 		24, false],
						['singRIGHTmiss', 		'Beto right miss', 		24, false],
						['singDOWNmiss', 		'Beto down miss', 		24, false],
						['hey', 			'Beto HEY', 				24, false],
					];
					
					flipX = true;

					scale.set(0.75,0.75);
				}
				else if(curChar == "face")
				{
					spriteType = ATLAS;
					doidoChar.spritesheet += 'face';
					doidoChar.anims = [
						['idle', 			'idle-alive', 		24, false],
						['idlemiss', 		'idle-dead', 		24, false],

						['singLEFT', 		'left-alive', 		24, false],
						['singDOWN', 		'down-alive', 		24, false],
						['singUP', 			'up-alive', 		24, false],
						['singRIGHT', 		'right-alive', 		24, false],
						['singLEFTmiss', 	'left-dead', 		24, false],
						['singDOWNmiss', 	'down-dead', 		24, false],
						['singUPmiss', 		'up-dead', 			24, false],
						['singRIGHTmiss', 	'right-dead', 		24, false],
					];
				}
				this.curChar = curChar;
			
			case "bf-dead":
				doidoChar.spritesheet += 'bf/BETO';
				doidoChar.anims = [
					['firstDeath', 		"Beto dies", 			24, false],
					['deathLoop', 		"Beto Dead Loop", 	24, true],
					['deathConfirm', 	"Beto Dead confirm", 	24, false],
				];

				idleAnims = ['firstDeath'];
				
				flipX = true;

				scale.set(0.72,0.72);

			case 'dublando':
				doidoChar.spritesheet += 'dublando/DublandoCoisasRe';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],
					['ring', 			'ring0', 		24, false],
					['sound', 			'sound0', 		24, false],
				];

				scale.set(0.75,0.75);

			case 'dublando-alt':
				doidoChar.spritesheet += 'dublando/DublandoCoisasRe';
				doidoChar.anims = [
					['idle', 			'altid0', 		24, false],
					['idle-old', 			'idle0', 		24, false],
					['ring', 			'ring0', 		24, false],
					['sound', 			'sound0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],
				];

				scale.set(0.75,0.75);

			case 'renan':
				doidoChar.spritesheet += 'renan/RenanDraw';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],
				];

				scale.set(0.75,0.75);

			case 'vrazillian':
				doidoChar.spritesheet += 'vrazillian/VrazilianNew';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],

					['singLEFTmiss', 	'lemiss', 		24, false],
					['singDOWNmiss', 	'domiss', 		24, false],
					['singUPmiss', 		'umiss', 			24, false],
					['singRIGHTmiss', 	'rimiss', 		24, false],
				];

				scale.set(3,3);
				isPixelSprite = true;
				flipX = true;

				deathChar = "vrazillian-dead";

			case "vrazillian-dead":
				doidoChar.spritesheet += 'vrazillian/DeadVrazilian';
				doidoChar.anims = [
					['firstDeath', 		"dead", 			24, false],
					['deathLoop', 		"loop", 	24, true],
					['deathConfirm', 	"confirm", 	24, false],
				];

				idleAnims = ['firstDeath'];
				
				scale.set(3,3);
				isPixelSprite = true;
				flipX = true;

			case 'fuleco':
				doidoChar.spritesheet += 'fuleco/FulecoNormal';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],
					['laugh', 			'laugh', 		24, false],
					['trans', 			'trans', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],
				];

				scale.set(0.75,0.75);

			case 'fuleco-rar':
				doidoChar.spritesheet += 'fuleco/FulecoRar';
				doidoChar.anims = [
					['idle', 			'idle0', 		24, false],

					['singLEFT', 	'left0', 24, false],
					['singRIGHT', 	'right0',24, false],
					['singUP', 		'up0', 	24, false],
					['singDOWN', 	'down0', 24, false],
				];

				scale.set(0.75,0.75);
	
		}

		if(isPixelSprite) antialiasing = false;

		if(spriteType != ATLAS)
		{
			if(Paths.fileExists('images/${doidoChar.spritesheet}.txt')) {
				frames = Paths.getPackerAtlas(doidoChar.spritesheet);
				spriteType = PACKER;
			}
			else if(Paths.fileExists('images/${doidoChar.spritesheet}.json')) {
				frames = Paths.getAsepriteAtlas(doidoChar.spritesheet);
				spriteType = ASEPRITE;
			}
			else if(doidoChar.extrasheets != null) {
				frames = Paths.getMultiSparrowAtlas(doidoChar.spritesheet, doidoChar.extrasheets, '', 'characters/');
				spriteType = MULTISPARROW;
			}
			else
				frames = Paths.getSparrowAtlas(doidoChar.spritesheet);

			for(i in 0...doidoChar.anims.length)
			{
				var anim:Array<Dynamic> = doidoChar.anims[i];
				if(anim.length > 4)
					animation.addByIndices(anim[0],  anim[1], anim[4], "", anim[2], anim[3]);
				else
					animation.addByPrefix(anim[0], anim[1], anim[2], anim[3]);
			}
		}
		else
		{
			// :shushing_face:
			isAnimateAtlas = true;

			loadAtlas(Paths.getPath('images/${doidoChar.spritesheet}'));
			showPivot = false;
			for(i in 0...doidoChar.anims.length)
			{
				var dAnim:Array<Dynamic> = doidoChar.anims[i];
				if(dAnim.length > 4)
					anim.addBySymbolIndices(dAnim[0], dAnim[1], dAnim[4], dAnim[2], dAnim[3]);
				else
					anim.addBySymbol(dAnim[0], dAnim[1], dAnim[2], dAnim[3]);
			}
		}

		// adding animations to array
		for(i in 0...doidoChar.anims.length) {
			var daAnim = doidoChar.anims[i][0];
			if(animExists(daAnim) && !animList.contains(daAnim))
				animList.push(daAnim);
		}

		// prevents crashing
		for(i in 0...idleAnims.length)
		{
			if(!animList.contains(idleAnims[i]))
				idleAnims[i] = animList[0];
		}
		
		// offset gettin'
		switch(curChar)
		{
			default:
				try {
					var charData:DoidoOffsets = cast Paths.json('images/characters/_offsets/${curChar}');
					
					for(i in 0...charData.animOffsets.length)
					{
						var animData:Array<Dynamic> = charData.animOffsets[i];
						addOffset(animData[0], animData[1], animData[2]);
					}
					globalOffset.set(charData.globalOffset[0], charData.globalOffset[1]);
					cameraOffset.set(charData.cameraOffset[0], charData.cameraOffset[1]);
					ratingsOffset.set(charData.ratingsOffset[0], charData.ratingsOffset[1]);
				} catch(e) {
					Logs.print('$curChar offsets not found', WARNING);
				}
		}
		
		playAnim(idleAnims[0]);

		updateHitbox();
		scaleOffset.set(offset.x, offset.y);

		if(isPlayer)
			flipX = !flipX;

		dance();
	}

	public var curDance:Int = 0;

	public function dance(forced:Bool = false)
	{
		if(specialAnim > 0) return;

		switch(curChar)
		{
			default:
				var daIdle = idleAnims[curDance];
				if(animExists(daIdle + altIdle))
					daIdle += altIdle;
				playAnim(daIdle);

				if(daIdle != "staring" || FlxG.random.bool(30))
					curDance++;

				if (curDance >= idleAnims.length)
					curDance = 0;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if(!onEditor)
		{
			if(animExists(curAnimName + '-loop') && curAnimFinished)
				playAnim(curAnimName + '-loop');
	
			if(specialAnim > 0 && specialAnim != 3 && curAnimFinished)
			{
				specialAnim = 0;
				dance();
			}
		}
	}

	public var singAnims:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
	public var absoluteAnims:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
	public function playNote(note:Note, miss:Bool = false, alt:String = '')
	{
		var daAnim:String = singAnims[note.noteData];
		if(animExists(daAnim + 'miss') && miss)
			daAnim += 'miss';

		if(animExists(daAnim + altSing))
			daAnim += altSing;

		if(animExists(daAnim + alt))
			daAnim += alt;

		holdTimer = 0;
		specialAnim = 0;
		playAnim(daAnim, true);
	}

	// animation handler
	public var curAnimName:String = '';
	public var animList:Array<String> = [];
	public var animOffsets:Map<String, Array<Float>> = [];

	public function addOffset(animName:String, offX:Float = 0, offY:Float = 0):Void
		return animOffsets.set(animName, [offX, offY]);

	public function playAnim(animName:String, ?forced:Bool = false, ?reversed:Bool = false, ?frame:Int = 0)
	{
		if(!animExists(animName)) return;
		
		curAnimName = animName;
		if(spriteType != ATLAS)
			animation.play(animName, forced, reversed, frame);
		else
			anim.play(animName, forced, reversed, frame);
		
		try
		{
			var daOffset = animOffsets.get(animName);
			offset.set(daOffset[0] * scale.x, daOffset[1] * scale.y);
		}
		catch(e)
			offset.set(0,0);

		// useful for pixel notes since their offsets are not 0, 0 by default
		offset.x += scaleOffset.x;
		offset.y += scaleOffset.y;
	}

	public function invertDirections(axes:FlxAxes = NONE)
	{
		switch(axes) {
			case X:
				singAnims = ['singRIGHT', 'singDOWN', 'singUP', 'singLEFT'];
			case Y:
				singAnims = ['singLEFT', 'singUP', 'singDOWN', 'singRIGHT'];
			case XY:
				singAnims = ['singRIGHT', 'singUP', 'singDOWN', 'singLEFT'];
			default:
				singAnims = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
		}
	}

	public function pauseAnim()
	{
		if(spriteType != ATLAS)
			animation.pause();
		else
			anim.pause();
	}

	public function animExists(animName:String):Bool
	{
		if(spriteType != ATLAS)
			return animation.getByName(animName) != null;
		else
			return anim.getByName(animName) != null;
	}

	public function get_curAnimFrame():Int
	{
		if(spriteType != ATLAS)
			return animation.curAnim.curFrame;
		else
			return anim.curSymbol.curFrame;
	}

	public function get_curAnimFinished():Bool
	{
		if(spriteType != ATLAS)
			return animation.curAnim.finished;
		else
			return anim.finished;
	}

	public function get_curDirection():String
	{
		for (i in 0...singAnims.length) {
			if(curAnimName.startsWith(singAnims[i]) && !curAnimName.endsWith('miss')) {
				//trace(absoluteAnims[i]);
				return absoluteAnims[i];	
			}
		}

		return 'none';
	}
}