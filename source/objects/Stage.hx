package objects;

import crowplexus.iris.Iris;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import states.PlayState;
import openfl.display.BlendMode;
import flixel.addons.display.FlxBackdrop;

class Stage extends FlxGroup
{
	public static var instance:Stage;

	public var curStage:String = "";
	public var gfVersion:String = "no-gf";
	public var camZoom:Float = 1;

	// things to help your stage get better
	public var bfPos:FlxPoint  = new FlxPoint();
	public var dadPos:FlxPoint = new FlxPoint();
	public var gfPos:FlxPoint  = new FlxPoint();

	public var bfCam:FlxPoint  = new FlxPoint();
	public var dadCam:FlxPoint = new FlxPoint();
	public var gfCam:FlxPoint  = new FlxPoint();

	public var foreground:FlxGroup;

	var loadedScripts:Array<Iris> = [];
	var scripted:Array<String> = [];

	var lowQuality:Bool = false;

	public function new() {
		super();
		foreground = new FlxGroup();
		instance = this;
	}

	public function reloadStageFromSong(song:String = "test"):Void
	{
		var stageList:Array<String> = [];
		
		stageList = switch(song)
		{
			default: ["w1"];
			
			case "calorao": ["w2"];
			case "verdadeira-historia": ["quarto"];
		};

		//this stops you from fucking stuff up by changing this mid song
		lowQuality = SaveData.data.get("Low Quality");
		
		/*
		*	makes changing stages easier by preloading
		*	a bunch of stages at the create function
		*	(remember to put the starting stage at the last spot of the array)
		*/
		for(i in stageList) {
			if(DevOptions.stageScripts)
				preloadScript(i);
			
			reloadStage(i);
		}
	}

	public function reloadStage(curStage:String = "")
	{
		this.clear();
		foreground.clear();
		this.curStage = curStage;
		
		gfPos.set(660, 580);
		dadPos.set(260, 700);
		bfPos.set(1100, 700);
		
		if(scripted.contains(curStage))
			callScript("create");
		else
			loadCode(curStage);

		PlayState.camZoom = camZoom;
	}

	public function preloadScript(stage:String = "")
	{
		var path:String = 'images/stages/_scripts/$stage';
		
		if(Paths.fileExists('$path.hxc'))
			path += '.hxc';
		else if(Paths.fileExists('$path.hx'))
			path += '.hx';
		else
			return;

		var newScript:Iris = new Iris(Paths.script('$path'), {name: path, autoRun: false, autoPreset: true});

		// variables to be used inside the scripts
		newScript.set("FlxSprite", FlxSprite);
		newScript.set("Paths", Paths);
		newScript.set("this", instance);

		newScript.set("add", add);
		newScript.set("foreground", foreground);

		newScript.set("bfPos", bfPos);
		newScript.set("dadPos", dadPos);
		newScript.set("gfPos", gfPos);

		newScript.set("bfCam", bfCam);
		newScript.set("dadCam", dadCam);
		newScript.set("gfCam", gfCam);

		newScript.set("lowQuality", lowQuality);

		newScript.execute();

		loadedScripts.push(newScript);
		scripted.push(stage);
	}

	// Hardcode your stages here!
	public function loadCode(curStage:String = "")
	{
		gfVersion = getGfVersion(curStage);

		switch(curStage)
		{
			case "quarto":
				gfVersion = "dublando";
				camZoom = 0.7;
			
				bfPos.y += 20;
			
				var bg = new FlxSprite(150, -60).loadGraphic(Paths.image("stages/quarto"));
				bg.scale.set(2.15,2.15);
				bg.antialiasing = false;
				add(bg);
			case "w2":
				gfPos.y -= 20;
				gfPos.x += 230;
			
				bfPos.x += 250;
			
				dadPos.x += 100;
			
				this.gfVersion = "gf";
				this.camZoom = 0.7; // 0.7
			
				PlayState.zoomPl = 0.1;
			
				var bg = new FlxSprite(-400, -400).loadGraphic(Paths.image("stages/w2/sky"));
				bg.scrollFactor.set(0.3,0.7);
				add(bg);
			
				/*
				var clouds = new FlxSprite(-400, -500).loadGraphic(Paths.image("stages/w2/clouds"));
				clouds.scrollFactor.set(0.6,0.9);
				add(clouds);*/

				var clouds = new FlxBackdrop(Paths.image("stages/w2/clouds"), X, 0, 0);
				clouds.scrollFactor.set(0.6,0.9);
				clouds.velocity.set(12,0);
				clouds.screenCenter();
				clouds.x = -400;
				clouds.y = -500;
				add(clouds);
			
				var grd = new FlxSprite(-570, -360).loadGraphic(Paths.image("stages/w2/grd"));
				grd.scale.set(1.1,1.1);
				add(grd);
			
				var overlay = new FlxSprite(-400, -400).loadGraphic(Paths.image("stages/w2/overlay"));
				overlay.blend = BlendMode.ADD;
				overlay.alpha = 0.4;
				bg.scrollFactor.set(0.3,0.7);
				foreground.add(overlay);

				
			case "w1":
				//dadPos.x += 80;
				//dadCam.y -= 30;
				gfPos.y -= 80;
				gfPos.x += 20;
				gfCam.y += 100;
			
				this.gfVersion = "gf";
				this.camZoom = 0.8;
			
				var bg = new FlxSprite(-400, -400).loadGraphic(Paths.image("stages/w1/sky"));
				bg.scrollFactor.set(0,0);
				add(bg);
			
				var back = new FlxSprite(-400, -600).loadGraphic(Paths.image("stages/w1/back"));
				back.scrollFactor.set(0.6,0.9);
				add(back);
			
				var grd = new FlxSprite(-400, -570).loadGraphic(Paths.image("stages/w1/grd"));
				grd.scale.set(1.1,1.1);
				add(grd);
			
				var overlay = new FlxSprite(-400, -370).loadGraphic(Paths.image("stages/w1/overlay"));
				overlay.scale.set(1.1,1.1);
				overlay.blend = BlendMode.ADD;
				overlay.alpha = 0.13;
				foreground.add(overlay);
			default:
				this.curStage = "stage";
				camZoom = 0.9;
				
				var bg = new FlxSprite(-600, -600).loadGraphic(Paths.image("stages/stage/stageback"));
				bg.scrollFactor.set(0.6,0.6);
				add(bg);
				
				var front = new FlxSprite(-580, 440);
				front.loadGraphic(Paths.image("stages/stage/stagefront"));
				add(front);

				var curtains = new FlxSprite(-600, -400).loadGraphic(Paths.image("stages/stage/stagecurtains"));
				curtains.scrollFactor.set(1.4,1.4);
				foreground.add(curtains);
		}
	}

	public function getGfVersion(curStage:String)
	{
		return switch(curStage)
		{
			default: "gf";
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		callScript("update", [elapsed]);
	}
	
	public function stepHit(curStep:Int = -1)
	{
		// beat hit
		// if(curStep % 4 == 0)

		callScript("stepHit", [curStep]);
	}

	public function callScript(fun:String, ?args:Array<Dynamic>)
	{
		for(i in 0...loadedScripts.length) {
			if(scripted[i] != curStage)
				continue;

			var script:Iris = loadedScripts[i];

			@:privateAccess {
				var ny: Dynamic = script.interp.variables.get(fun);
				try {
					if(ny != null && Reflect.isFunction(ny))
						script.call(fun, args);
				} catch(e) {
					Logs.print('error parsing script: ' + e, ERROR);
				}
			}
		}
	}
}