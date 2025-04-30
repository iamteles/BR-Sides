package states.menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import backend.game.GameData;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

class TitleScreen extends MusicBeatState
{
    var bg:FlxSprite;
    var tiles:FlxBackdrop;
    var logo:FlxSprite;
    var info:FlxText;

    override public function create():Void 
    {
        super.create();

        //CoolUtil.playMusic("MENU");
        CoolUtil.playMusic("freakyMenu");

        //CoolUtil.flash(FlxG.camera, 0.5);
        
		tiles = new FlxBackdrop(Paths.image('menu/grid'), XY, 0, 0);
        tiles.velocity.set(40,40);
        tiles.scale.set(3,3);
        tiles.updateHitbox();
        tiles.screenCenter();
        tiles.alpha = 0.4;
        tiles.antialiasing = false;
        add(tiles);

        bg = new FlxSprite().loadGraphic(Paths.image('menu/title/gradient'));
		bg.updateHitbox();
		bg.screenCenter();
        bg.blend = BlendMode.ADD;
		add(bg);

        logo = new FlxSprite(0, 0).loadGraphic(Paths.image('menu/title/logo'));
        logo.scale.set(0.67, 0.67);
        logo.updateHitbox();
        logo.screenCenter();
        logo.y -= 40;
        var storeY:Float = logo.y;
		logo.y -= 20;
		FlxTween.tween(logo, {y: storeY + 20}, 1.6, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
		add(logo);

        var text:String = "Pressione ACCEPT pra começar!";
        if(SaveData.en)
            text = "Press ACCEPT to start!";

        info = new FlxText(0,0,0,text);
		info.setFormat(Main.gFont, 50, 0xFFFFFFFF, CENTER);
		info.setBorderStyle(OUTLINE, FlxColor.BLACK, 2.4);
        info.screenCenter(X);
        info.y = 599.95;
        add(info);
    }

    var isTouch:Bool = false;
    var started:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        #if mobile
        for (touch in FlxG.touches.list)
        {
            if (touch.justPressed)
                isTouch = true;
        }
        #end

        if(Controls.justPressed(ACCEPT) || isTouch)
            end();
    }

    function end()
    {
        if(started) return;
        started = true;
        FlxG.sound.play(Paths.sound("menu/confirm"));
        CoolUtil.flash(FlxG.camera, 1, 0xffffffff); 
        FlxFlicker.flicker(info, 1.2, 0.06, true, false, function(_)
        {
            Main.skipClearMemory = true;
            Main.switchState(new states.menu.MainMenu());
        });
    }
}