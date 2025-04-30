package states;

import backend.game.GameData.MusicBeatState;
import backend.utils.DialogueUtil;
import backend.song.ChartLoader;
import backend.song.SongData.SwagSong;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import objects.*;
import objects.hud.*;
import objects.note.*;
import objects.dialogue.Dialogue;
import flixel.util.FlxTimer;
#if VIDEOS_ALLOWED
import backend.game.DoidoVideoSprite;
#end

#if PRELOAD_SONG
import sys.thread.Mutex;
import sys.thread.Thread;
#end

/*
*	preloads all the stuff before going into playstate
*	i would advise you to put your custom preloads inside here!!
*/
class LoadMisc extends MusicBeatState
{
	var threadActive:Bool = true;
    var canFinish:Bool = false;

	#if PRELOAD_SONG
	var mutex:Mutex;
	#end

	var behind:FlxGroup;
    var loadPercent:Float = 0.0;
	
	function addBehind(item:FlxBasic)
	{
		behind.add(item);
		behind.remove(item);
	}
	
	override function create()
	{
		super.create();

		behind = new FlxGroup();
		add(behind);
		
		var color = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
		color.screenCenter();
		add(color);

		#if PRELOAD_SONG
		mutex = new Mutex();
		#else
		var black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
		#end

        var guy = new FlxSprite();
		guy.frames = Paths.getSparrowAtlas('loading');
		guy.animation.addByPrefix("load", "Woman_gif", 24, true);
		guy.animation.play("load");
		guy.scale.set(0.27,0.27);
		guy.updateHitbox();
		guy.screenCenter();
		guy.x = FlxG.width - guy.width - 20;
        guy.y = FlxG.height - guy.height - 20;
        guy.antialiasing = false;
		add(guy);
		
		var oldAnti:Bool = FlxSprite.defaultAntialiasing;
		FlxSprite.defaultAntialiasing = false;

		#if PRELOAD_SONG
		var preloadThread = Thread.create(function()
		{
			mutex.acquire();
		#end
            for(i in 0...Paths.dumpExclusions.length) {
                if(Paths.dumpExclusions[i].endsWith('.png'))
                    Paths.preloadGraphic(Paths.dumpExclusions[i].replace('.png', ''));
                else if(Paths.dumpExclusions[i].endsWith('.ogg'))
                    Paths.preloadSound(Paths.dumpExclusions[i].replace('.ogg', ''));
            }
            
            for(i in 0...Paths.otherLoadings.length) {
                if(Paths.otherLoadings[i].endsWith('.png'))
                    Paths.preloadGraphic(Paths.otherLoadings[i].replace('.png', ''));
                else if(Paths.otherLoadings[i].endsWith('.ogg'))
                    Paths.preloadSound(Paths.otherLoadings[i].replace('.ogg', ''));
            }

            var timer:FlxTimer = new FlxTimer().start(3.5, function(tmr:FlxTimer)
            {
                canFinish = true;
            });
            loadPercent = 1.0;
            Logs.print('finished loading');
            threadActive = false;
            FlxSprite.defaultAntialiasing = oldAnti;
        #if PRELOAD_SONG
            mutex.release();
		});
		#end
	}
	
	var byeLol:Bool = false;
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(!threadActive && !byeLol && canFinish)
		{
			byeLol = true;
			Main.skipClearMemory = true;
            if(!SaveData.data.get("first"))
                Main.switchState(new LanguageState(), 'base');
            else
                Main.switchState(new SplashState(), 'base');
		}
	}
}