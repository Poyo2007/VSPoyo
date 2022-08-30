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
    
    private var grpChars:FlxTypedGroup<Character>;
    
    public static var curSelected:Int = 0;
    
    var characterArray:Array<String> = [
  		'new bf',
  		'bf',
  		'poyo player',
  		'old poyo player'
  	];

    override function create(){
        leBG = new FlxSprite().loadGraphic(Paths.image('menuBG'));
        leBG.color = FlxColor.BLUE;
        leBG.screenCenter();
        add(leBG);
        
        switch(SONG.player1)
        {
          case 'new bf':
            curSelected = 0;
          case 'bf':
            curSelected = 1;
          case 'poyo':
            curSelected = 2;
          case 'old poyo':
            curSelected = 3;
          default:
            curSelected = 0;
        }
 
        grpChars = new FlxTypedGroup<Character>();
		    add(grpChars);
        for (i in 0...characterArray.length)
        {
          var char:Character = new Character((145 * i), 0, characterArray[i], true);
      		char.screenCenter(Y);
      		char.setGraphicSize(Std.int(char.width * 0.75));
      		char.updateHitbox();
      		char.dance();
      		grpChars.insert(1, char);
        }
        if(curSelected >= characterArray.length) curSelected = 0;
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

    function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = characterArray.length - 1;
		if (curSelected >= characterArray.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpChars.members)
		
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
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
        case 2:
        FlxFlicker.flicker(poyo, 1.5, 0.15, false);
        poyo.animation.play('hey');
        case 3:
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