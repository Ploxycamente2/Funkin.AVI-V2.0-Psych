package options.spanish;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import openfl.Lib;

using StringTools;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Graficos';
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('calidad baja', //Name
			'El Juego Se Pondra A Baja calidad para mejor optimizacion.', //Description
			'lowQuality', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Antiescalonamiento',
			'activalo para aumentar el rendimiento \ny el costo de imágenes más nítidas.',
			'globalAntialiasing',
			'bool',
			true);
		option.showBoyfriend = true;
		option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);

		#if !html5 //Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		var option:Option = new Option('Frames Por Segundo',
			"Titulo",
			'framerate',
			'int',
			60);
		addOption(option);

		option.minValue = 60;
		option.maxValue = 240;
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		
			
		var option:Option = new Option('Shaders', //this one too btw
			'Desactivalo Si Tienes PC De Bajos Recursos!',
			'funiShaders',
			'bool',
			true);
		addOption(option);
        #end

		#if desktop //no need for this at other platforms cuz only desktop has fullscreen as false by default (MAYBE I'LL TRY TO MAKE IT FOR FULLSCREEN MODE TOO)
		var option:Option = new Option('Resolucion',
			'Elige La Resolucion De Pantalla.',
			'screenRes',
			'string',
			'1280x720',
			['640x360', '852x480', '960x540', '1280x720', '1920x1080', '3840x2160']);
		addOption(option);
		option.onChange = onChangeScreenRes;

		var option:Option = new Option('Pantalla Completa',
			'Activalo Para tener Pantalla completa',
			'fullscreen',
			'bool',
			false);
		addOption(option);
		option.onChange = onChangeFullscreen;
		#end

		/*
		var option:Option = new Option('Persistent Cached Data',
			'If checked, images loaded will stay in memory\nuntil the game is closed, this increases memory usage,\nbut basically makes reloading times instant.',
			'imagesPersist',
			'bool',
			false);
		option.onChange = onChangePersistentData; //Persistent Cached Data changes FlxGraphic.defaultPersist
		addOption(option);
		*/

		super();
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	}

	function onChangeScreenRes()
	{
		var res = ClientPrefs.screenRes.split('x');
		FlxG.resizeWindow(Std.parseInt(res[0]), Std.parseInt(res[1]));

		FlxG.fullscreen = false;

		if(!FlxG.fullscreen)
			onChangeFullscreen();
	}

	function onChangeFullscreen()
	{
		FlxG.fullscreen = ClientPrefs.fullscreen;
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}
}
