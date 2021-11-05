package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	public var baseStrum:Float = 0;
	
	public var charterSelected:Bool = false;

	public var rStrumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var noteType:Int = 0;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var burning:Bool = false; //fire
	public var death:Bool = false;    //halo/death
	public var warning:Bool = false; //warning
	public var angel:Bool = false; //angel
	public var alt:Bool = false; //alt animation note
	public var bob:Bool = false; //bob arrow
	public var glitch:Bool = false; //glitch

	public var noteScore:Float = 1;
	public static var mania:Int = 0;
	public var noteYOff:Int = 0;

	public static var noteyOff1:Array<Float> = [4, 0, 0, 0, 0, 0];
	public static var noteyOff2:Array<Float> = [0, 0, 0, 0, 0, 0];
	public static var noteyOff3:Array<Float> = [0, 0, 0, 0, 0, 0];

	public static var swagWidth:Float;
	public static var noteScale:Float;
	public static var pixelnoteScale:Float;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var tooMuch:Float = 30;
	public var rating:String = "shit";
	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx

	public var isParent:Bool = false;
	public var parent:Note = null;
	public var spotInLine:Int = 0;
	public var sustainActive:Bool = true;
	public var noteColors:Array<String> = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark', 'darkred', 'orange'];
	var pixelnoteColors:Array<String> = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];

	public var children:Array<Note> = [];


	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0, ?_mustPress:Bool = false, ?inCharter:Bool = false)
	{
		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		pixelnoteScale = 1;
		mania = 0;
		if (PlayState.SONG.mania == 1)
		{
			swagWidth = 120 * 0.7;
			noteScale = 0.6;
			pixelnoteScale = 0.83;
			mania = 1;
		}
		else if (PlayState.SONG.mania == 2)
		{
			swagWidth = 95 * 0.7;
			noteScale = 0.5;
			pixelnoteScale = 0.7;
			mania = 2;
		}
		else if (PlayState.SONG.mania == 3)
			{
				swagWidth = 130 * 0.7;
				noteScale = 0.65;
				pixelnoteScale = 0.9;
				mania = 3;
			}
		else if (PlayState.SONG.mania == 4)
			{
				swagWidth = 110 * 0.7;
				noteScale = 0.58;
				pixelnoteScale = 0.78;
				mania = 4;
			}
		else if (PlayState.SONG.mania == 5)
			{
				swagWidth = 100 * 0.7;
				noteScale = 0.55;
				pixelnoteScale = 0.74;
				mania = 5;
			}

		else if (PlayState.SONG.mania == 6)
			{
				swagWidth = 200 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 6;
			}
		else if (PlayState.SONG.mania == 7)
			{
				swagWidth = 180 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 7;
			}
		else if (PlayState.SONG.mania == 8)
			{
				swagWidth = 170 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 8;
			}
		super();

		if (prevNote == null)
			prevNote = this;
		this.noteType = noteType;
		this.prevNote = prevNote; 
		isSustainNote = sustainNote;

		x += 50;
		if (PlayState.SONG.mania == 2)
			{
				x -= tooMuch;
			}
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		if (Main.editor)
			this.strumTime = strumTime;
		else 
			this.strumTime = Math.round(strumTime);

		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData % 9;
		burning = noteType == 1;
		death = noteType == 2;
		warning = noteType == 3;
		angel = noteType == 4;
		alt = noteType == 5;
		bob = noteType == 6;
		glitch = noteType == 7;

		if (FlxG.save.data.noteColor != 'darkred' && FlxG.save.data.noteColor != 'black' && FlxG.save.data.noteColor != 'orange')
			FlxG.save.data.noteColor = 'darkred';

		var daStage:String = PlayState.curStage;

		//defaults if no noteStyle was found in chart
		var noteTypeCheck:String = 'normal';

		if (PlayState.SONG.noteStyle == null) {
			switch(PlayState.storyWeek) {case 6: noteTypeCheck = 'pixel';}
		} else {noteTypeCheck = PlayState.SONG.noteStyle;}

		
		if (PlayState.SONG.song.toLowerCase() == 'shadoune' || PlayState.SONG.song.toLowerCase() == 'decition')

			{
				frames = Paths.getSparrowAtlas('notes/cool_notes');
		
				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				
				if (burning || death || warning || angel || bob || glitch)
					{
						frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
						switch(noteType)
						{
							case 1: 
								for (i in 0...11)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'fire ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'fire hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'fire hold end'); // Tails
									}
							case 2: 
								for (i in 0...11)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'halo ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'halo hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'halo hold end'); // Tails
									}
							case 3: 
								for (i in 0...11)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'warning ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'warning hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'warning hold end'); // Tails
									}
							case 4: 
								for (i in 0...11)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'angel ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'angel hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'angel hold end'); // Tails
									}
							case 6: 
								for (i in 0...11)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'bob ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'bob hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'bob hold end'); // Tails
									}
							case 7:
								for (i in 0...11)
									{
										animation.addByPrefix(noteColors[i] + 'Scroll', 'glitch ' + noteColors[i] + '0'); // Normal notes
										animation.addByPrefix(noteColors[i] + 'hold', 'glitch hold piece'); // Hold
										animation.addByPrefix(noteColors[i] + 'holdend', 'glitch hold end'); // Tails
									}
						}
					}


				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
			}

			else if (PlayState.SONG.song.toLowerCase() == 'you-are-mine')

				{
					frames = Paths.getSparrowAtlas('notes/cool_notes_noche');
			
					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');
	
					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');
	
					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');
					
					if (burning || death || warning || angel || bob || glitch)
						{
							frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
							switch(noteType)
							{
								case 1: 
									for (i in 0...11)
										{
											animation.addByPrefix(noteColors[i] + 'Scroll', 'fire ' + noteColors[i] + '0'); // Normal notes
											animation.addByPrefix(noteColors[i] + 'hold', 'fire hold piece'); // Hold
											animation.addByPrefix(noteColors[i] + 'holdend', 'fire hold end'); // Tails
										}
								case 2: 
									for (i in 0...11)
										{
											animation.addByPrefix(noteColors[i] + 'Scroll', 'halo ' + noteColors[i] + '0'); // Normal notes
											animation.addByPrefix(noteColors[i] + 'hold', 'halo hold piece'); // Hold
											animation.addByPrefix(noteColors[i] + 'holdend', 'halo hold end'); // Tails
										}
								case 3: 
									for (i in 0...11)
										{
											animation.addByPrefix(noteColors[i] + 'Scroll', 'warning ' + noteColors[i] + '0'); // Normal notes
											animation.addByPrefix(noteColors[i] + 'hold', 'warning hold piece'); // Hold
											animation.addByPrefix(noteColors[i] + 'holdend', 'warning hold end'); // Tails
										}
								case 4: 
									for (i in 0...11)
										{
											animation.addByPrefix(noteColors[i] + 'Scroll', 'angel ' + noteColors[i] + '0'); // Normal notes
											animation.addByPrefix(noteColors[i] + 'hold', 'angel hold piece'); // Hold
											animation.addByPrefix(noteColors[i] + 'holdend', 'angel hold end'); // Tails
										}
								case 6: 
									for (i in 0...11)
										{
											animation.addByPrefix(noteColors[i] + 'Scroll', 'bob ' + noteColors[i] + '0'); // Normal notes
											animation.addByPrefix(noteColors[i] + 'hold', 'bob hold piece'); // Hold
											animation.addByPrefix(noteColors[i] + 'holdend', 'bob hold end'); // Tails
										}
								case 7:
									for (i in 0...11)
										{
											animation.addByPrefix(noteColors[i] + 'Scroll', 'glitch ' + noteColors[i] + '0'); // Normal notes
											animation.addByPrefix(noteColors[i] + 'hold', 'glitch hold piece'); // Hold
											animation.addByPrefix(noteColors[i] + 'holdend', 'glitch hold end'); // Tails
										}
							}
						}
	
	
					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
				}
				
				else if (PlayState.SONG.song.toLowerCase() == 'permadeath')

					{
						
				
						frames = Paths.getSparrowAtlas('noteassets/NOTE_assets_noche');
							for (i in 0...11)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}	
							if (burning || death || warning || angel || bob || glitch)
								{
									frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
									switch(noteType)
									{
										case 1: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'fire ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'fire hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'fire hold end'); // Tails
												}
										case 2: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'halo ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'halo hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'halo hold end'); // Tails
												}
										case 3: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'warning ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'warning hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'warning hold end'); // Tails
												}
										case 4: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'angel ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'angel hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'angel hold end'); // Tails
												}
										case 6: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'bob ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'bob hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'bob hold end'); // Tails
												}
										case 7:
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'glitch ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'glitch hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'glitch hold end'); // Tails
												}
									}
								}
							setGraphicSize(Std.int(width * noteScale));
							updateHitbox();
							antialiasing = true;
					}
				
			else
				{
					switch (noteTypeCheck)
					{
						case 'pixel':
							loadGraphic(Paths.image('noteassets/pixel/arrows-pixels'), true, 17, 17);
							if (isSustainNote && noteType == 0)
								loadGraphic(Paths.image('noteassets/pixel/arrowEnds'), true, 7, 6);
			
							for (i in 0...9)
							{
								animation.add(pixelnoteColors[i] + 'Scroll', [i + 9]); // Normal notes
								animation.add(pixelnoteColors[i] + 'hold', [i]); // Holds
								animation.add(pixelnoteColors[i] + 'holdend', [i + 9]); // Tails
							}
							if (burning)
								{
									loadGraphic(Paths.image('noteassets/pixel/firenotes/arrows-pixels'), true, 17, 17);
									if (isSustainNote && burning)
										loadGraphic(Paths.image('noteassets/pixel/firenotes/arrowEnds'), true, 7, 6);
									for (i in 0...9)
										{
											animation.add(pixelnoteColors[i] + 'Scroll', [i + 9]); // Normal notes
											animation.add(pixelnoteColors[i] + 'hold', [i]); // Holds
											animation.add(pixelnoteColors[i] + 'holdend', [i + 9]); // Tails
										}
								}
							else if (death)
								{
									loadGraphic(Paths.image('noteassets/pixel/halo/arrows-pixels'), true, 17, 17);
									if (isSustainNote && death)
										loadGraphic(Paths.image('noteassets/pixel/halo/arrowEnds'), true, 7, 6);
									for (i in 0...9)
										{
											animation.add(pixelnoteColors[i] + 'Scroll', [i + 9]); // Normal notes
											animation.add(pixelnoteColors[i] + 'hold', [i]); // Holds
											animation.add(pixelnoteColors[i] + 'holdend', [i + 9]); // Tails
										}
								}
							else if (warning)
								{
									loadGraphic(Paths.image('noteassets/pixel/warning/arrows-pixels'), true, 17, 17);
									if (isSustainNote && warning)
										loadGraphic(Paths.image('noteassets/pixel/warning/arrowEnds'), true, 7, 6);
									for (i in 0...9)
										{
											animation.add(pixelnoteColors[i] + 'Scroll', [i + 9]); // Normal notes
											animation.add(pixelnoteColors[i] + 'hold', [i]); // Holds
											animation.add(pixelnoteColors[i] + 'holdend', [i + 9]); // Tails
										}
								}
							else if (angel)
								{
									loadGraphic(Paths.image('noteassets/pixel/angel/arrows-pixels'), true, 17, 17);
									if (isSustainNote && angel)
										loadGraphic(Paths.image('noteassets/pixel/angel/arrowEnds'), true, 7, 6);
									for (i in 0...9)
										{
											animation.add(pixelnoteColors[i] + 'Scroll', [i + 9]); // Normal notes
											animation.add(pixelnoteColors[i] + 'hold', [i]); // Holds
											animation.add(pixelnoteColors[i] + 'holdend', [i + 9]); // Tails
										}
								}
							else if (bob)
								{
									loadGraphic(Paths.image('noteassets/pixel/bob/arrows-pixels'), true, 17, 17);
									if (isSustainNote && bob)
										loadGraphic(Paths.image('noteassets/pixel/bob/arrowEnds'), true, 7, 6);
									for (i in 0...9)
										{
											animation.add(pixelnoteColors[i] + 'Scroll', [i + 9]); // Normal notes
											animation.add(pixelnoteColors[i] + 'hold', [i]); // Holds
											animation.add(pixelnoteColors[i] + 'holdend', [i + 9]); // Tails
										}
								}
							else if (glitch)
								{
									loadGraphic(Paths.image('noteassets/pixel/glitch/arrows-pixels'), true, 17, 17);
									if (isSustainNote && glitch)
										loadGraphic(Paths.image('noteassets/pixel/glitch/arrowEnds'), true, 7, 6);
									for (i in 0...9)
										{
											animation.add(pixelnoteColors[i] + 'Scroll', [i + 9]); // Normal notes
											animation.add(pixelnoteColors[i] + 'hold', [i]); // Holds
											animation.add(pixelnoteColors[i] + 'holdend', [i + 9]); // Tails
										}
								}
			
							
			
							setGraphicSize(Std.int(width * PlayState.daPixelZoom * pixelnoteScale));
							updateHitbox();
						default:
							frames = Paths.getSparrowAtlas('noteassets/NOTE_assets');
							for (i in 0...11)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}	
							if (burning || death || warning || angel || bob || glitch)
								{
									frames = Paths.getSparrowAtlas('noteassets/notetypes/NOTE_types');
									switch(noteType)
									{
										case 1: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'fire ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'fire hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'fire hold end'); // Tails
												}
										case 2: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'halo ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'halo hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'halo hold end'); // Tails
												}
										case 3: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'warning ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'warning hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'warning hold end'); // Tails
												}
										case 4: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'angel ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'angel hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'angel hold end'); // Tails
												}
										case 6: 
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'bob ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'bob hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'bob hold end'); // Tails
												}
										case 7:
											for (i in 0...11)
												{
													animation.addByPrefix(noteColors[i] + 'Scroll', 'glitch ' + noteColors[i] + '0'); // Normal notes
													animation.addByPrefix(noteColors[i] + 'hold', 'glitch hold piece'); // Hold
													animation.addByPrefix(noteColors[i] + 'holdend', 'glitch hold end'); // Tails
												}
									}
								}
							setGraphicSize(Std.int(width * noteScale));
							updateHitbox();
							antialiasing = true;
					}
				}

				

		
		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		switch (mania)
		{
			case 1: 
				frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
			case 2: 
				if (noteTypeCheck == 'pixel')
					frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
				else
					frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', FlxG.save.data.noteColor, 'dark'];
			case 3: 
				if (FlxG.save.data.gthc && noteTypeCheck != 'pixel')
					frameN = ['green', 'red', 'yellow', 'dark', 'orange'];
				else
					frameN = ['purple', 'blue', 'white', 'green', 'red'];
			case 4: 
				frameN = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'dark'];
			case 5: 
				if (noteTypeCheck == 'pixel')
					frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
				else
					frameN = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', FlxG.save.data.noteColor, 'dark'];
			case 6: 
				frameN = ['white'];
			case 7: 
				frameN = ['purple', 'red'];
			case 8: 
				frameN = ['purple', 'white', 'red'];

		}
	
								
						

		x += swagWidth * noteData;
		animation.play(frameN[noteData] + 'Scroll');

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && sustainNote) 
			flipY = true;

		var stepHeight = (0.45 * Conductor.stepCrochet * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed, 2));


		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			animation.play(frameN[noteData] + 'holdend');

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{

				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');
				prevNote.updateHitbox();



				prevNote.scale.y *= (stepHeight + 1) / prevNote.height; // + 1 so that there's no odd gaps as the notes scroll
				prevNote.updateHitbox();
				prevNote.noteYOff = Math.round(-prevNote.offset.y);

				// prevNote.setGraphicSize();

				noteYOff = Math.round(-offset.y);

				// prevNote.setGraphicSize();
			}
		}
	}


	public function maniaSwitch(newMania:Int) //copy pasted shit so it works
	{
		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		pixelnoteScale = 1;
		mania = 0;
		if (newMania == 1)
		{
			swagWidth = 120 * 0.7;
			noteScale = 0.6;
			pixelnoteScale = 0.83;
			mania = 1;
		}
		else if (newMania == 2)
		{
			swagWidth = 95 * 0.7;
			noteScale = 0.5;
			pixelnoteScale = 0.7;
			mania = 2;
		}
		else if (newMania == 3)
			{
				swagWidth = 130 * 0.7;
				noteScale = 0.65;
				pixelnoteScale = 0.9;
				mania = 3;
			}
		else if (newMania == 4)
			{
				swagWidth = 110 * 0.7;
				noteScale = 0.58;
				pixelnoteScale = 0.78;
				mania = 4;
			}
		else if (newMania == 5)
			{
				swagWidth = 100 * 0.7;
				noteScale = 0.55;
				pixelnoteScale = 0.74;
				mania = 5;
			}

		else if (newMania == 6)
			{
				swagWidth = 200 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 6;
			}
		else if (newMania == 7)
			{
				swagWidth = 180 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 7;
			}
		else if (newMania == 8)
			{
				swagWidth = 170 * 0.7;
				noteScale = 0.7;
				pixelnoteScale = 1;
				mania = 8;
			}

			var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
			switch (mania)
			{
				case 1: 
					frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
				case 2: 
					frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
				case 3: 
					frameN = ['purple', 'blue', 'white', 'green', 'red'];
				case 4: 
					frameN = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'dark'];
				case 5: 
					frameN = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'black', 'dark'];
				case 6: 
					frameN = ['white'];
				case 7: 
					frameN = ['purple', 'red'];
				case 8: 
					frameN = ['purple', 'white', 'red'];
	
			}
	
			//x += swagWidth * noteData;
			animation.play(frameN[noteData] + 'Scroll');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		angle = modAngle + localAngle;

		if (!modifiedByLua)
		{
			if (!sustainActive)
			{
				alpha = 0.3;
			}
		}

		if (mustPress)
		{
			if (isSustainNote)
				{
					if (strumTime - Conductor.songPosition <= ((166 * Conductor.timeScale) * 0.5)
						&& strumTime - Conductor.songPosition >= (-166 * Conductor.timeScale))
						canBeHit = true;
					else
						canBeHit = false;
				}
				else if (burning || death)
				{
					if (strumTime - Conductor.songPosition <= (100 * Conductor.timeScale)
						&& strumTime - Conductor.songPosition >= (-50 * Conductor.timeScale))
						canBeHit = true;
					else
						canBeHit = false;	
				}
				else
				{
					if (strumTime - Conductor.songPosition <= (166 * Conductor.timeScale)
						&& strumTime - Conductor.songPosition >= (-166 * Conductor.timeScale))
						canBeHit = true;
					else
						canBeHit = false;
				}
				if (strumTime - Conductor.songPosition < -166 && !wasGoodHit)
					tooLate = true;
			}
			else
			{
				canBeHit = false;
	
				if (strumTime <= Conductor.songPosition)
					wasGoodHit = true;
			}
	
			if (tooLate && !wasGoodHit)
			{
				if (alpha > 0.3)
					alpha = 0.3;
			}
	}
}