package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;

class CharSelectState extends MusicBeatState{
    var charsArray:Array<String> = ['Boyfriend (VS Poyo)', 'Boyfriend (PhantomArcade)', 'Poyo', 'Poyo (DEMO 1-2)'];
    var leBG:FlxSprite;
    var newbfpoyo:FlxSprite;
    var bfphantom:FlxSprite;
    var oldpoyo:FlxSprite;
    var poyo:FlxSprite;
    var selectedText:FlxText;
    var charSelect:FlxSprite;
    public static var curSelected:Int = 0;
    override function create(){
        leBG = new FlxSprite().loadGraphic(Paths.image('menuBG'));
        leBG.color = FlxColor.BLUE;
        leBG.screenCenter();
        add(leBG);
 
        newbfpoyo = new FlxSprite(0, 0).loadGraphic(Paths.image('characters/newbfpoyo'));
        newbfpoyo.frames = Paths.getSparrowAtlas('characters/newbfpoyo');
        newbfpoyo.animation.addByPrefix('idle', 'BF idle dance', 24, true);
        newbfpoyo.animation.addByPrefix('hey', 'BF NOTE UP', 24, true);
        newbfpoyo.animation.play('idle');
        newbfpoyo.screenCenter();
        add(newbfpoyo);

        bfphantom = new FlxSprite(0, 0).loadGraphic(Paths.image('characters/BOYFRIEND'));
        bfphantom.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
        bfphantom.animation.addByPrefix('idle', 'BF idle dance', 24, true);
        bfphantom.animation.addByPrefix('hey', 'BF HEY!!', 24, true);
        bfphantom.animation.play('idle');
        bfphantom.screenCenter();
        add(bfphantom);

        poyo = new FlxSprite(450, 300).loadGraphic(Paths.image('characters/poyo anims'));
        poyo.frames = Paths.getSparrowAtlas('characters/poyo anims');
        poyo.animation.addByPrefix('idle', 'idle instance 1', 24, true);
        poyo.animation.addByPrefix('hey', 'up instance 1', 24, true);
        poyo.animation.addByPrefix('singUP', 'up instance 1', 24, true);
        poyo.scale.set(2, 2)
        poyo.screenCenter();
        poyo.animation.play('idle');
        add(poyo);
        
        oldpoyo = new FlxSprite(450, 300).loadGraphic(Paths.image('characters/poyolmao'));
        oldpoyo.frames = Paths.getSparrowAtlas('characters/poyolmao');
        oldpoyo.animation.addByPrefix('idle', 'Idle', 24, true);
        oldpoyo.animation.addByPrefix('hey', 'Up', 24, true);
        oldpoyo.animation.addByPrefix('singUP', 'Up', 24, true);
        oldpoyo.screenCenter();
        oldpoyo.animation.play('idle');
        add(oldpoyo);
		selectedText = new FlxText(0, 10, charsArray[0], 24);
		selectedText.alpha = 0.5;
		selectedText.x = (FlxG.width) - (selectedText.width) - 25;
        add(selectedText);
        charSelect = new Alphabet(0, 50, "Select Your Character", true, false);
        charSelect.offset.x -= 150;
        add(charSelect);
        changeSelection();

        #if android
    		  addVirtualPad(LEFT_RIGHT, A_B);
    		#end

        super.create();
    }

    function changeSelection(change:Int = 0){
        curSelected += change;

        if (curSelected < 0)
			curSelected = charsArray.length - 1;
		if (curSelected >= charsArray.length)
			curSelected = 0;

        selectedText.text = charsArray[curSelected];

        switch(curSelected){
        case 0:
        newbfpoyo.visible = true;
        bfphantom.visible = false;
        poyo.visible = false;
        oldpoyo.visible = false;
        case 1:
        newbfpoyo.visible = false;
        bfphantom.visible = true;
        poyo.visible = false;
        oldpoyo.visible = false;
        case 2:
        newbfpoyo.visible = false;
        bfphantom.visible = false;
        poyo.visible = true;
        oldpoyo.visible = false;
        case 3:
        newbfpoyo.visible = false;
        bfphantom.visible = false;
        poyo.visible = false;
        oldpoyo.visible = true;
        }
    }

    override function update(elapsed:Float){
        if (controls.UI_LEFT_P){
        changeSelection(-1);
        FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        if (controls.UI_RIGHT_P){
        changeSelection(1);
        FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        if (controls.ACCEPT){
        FlxG.sound.play(Paths.sound('confirmMenu'));
        switch(curSelected){
        case 0:
        FlxFlicker.flicker(newbfpoyo, 1.5, 0.15, false);
        newbfpoyo.animation.play('hey');
        case 1:
        FlxFlicker.flicker(bfphantom, 1.5, 0.15, false);
        bfphantom.animation.play('hey');
        case 1:
        FlxFlicker.flicker(poyo, 1.5, 0.15, false);
        poyo.animation.play('hey');
        case 1:
        FlxFlicker.flicker(oldpoyo, 1.5, 0.15, false);
        oldpoyo.animation.play('hey');
        }
        new FlxTimer().start(1.5, function(tmr:FlxTimer)
            {
        MusicBeatState.switchState(new PlayState());
        FlxG.sound.music.volume = 0;
            });
        }
        if (controls.BACK){
        FlxG.sound.play(Paths.sound('cancelMenu'));
        MusicBeatState.switchState(new FreeplayState());
        }
        super.update(elapsed);
    }
}