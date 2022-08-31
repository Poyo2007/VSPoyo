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

        grpChars = new FlxTypedGroup<Character>();
		    add(grpChars);
        for (i in 0...characterArray.length)
        {
          var char:Character = new Character(0, 0, characterArray[i], true);
      		char.updateHitbox();
      		char.screenCenter();
      		char.ID = i;
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
  		
  		selectedText.text = charsArray[curSelected];
  
  		// selector.y = (70 * curSelected) + 30;
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
        MusicBeatState.switchState(new PlayState());
        FlxG.sound.music.volume = 0;
        }
        if (controls.BACK){
        FlxG.sound.play(Paths.sound('cancelMenu'));
        MusicBeatState.switchState(new FreeplayState());
        }
 
        grpChars.forEach(function(char:Character)
				{
		      if (curSelected != char.ID)
		        char.alpha = 0;
		      else
		        char.alpha = 1;
				}
        super.update(elapsed);
    }
}