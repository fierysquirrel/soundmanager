package fs.soundmanager;

import openfl.Assets;

enum AudioState
{
	On;
	Off;
}

/**
 * ...
 * @author Fiery Squirrel
 */
class SoundManager
{
	public static var NAME : String = "SOUND_MANAGER";
	
	private static var soundsState : AudioState;
	
	private static var musicState : AudioState;
	
	private static var instance : SoundManager;
	
	private static var soundsData : Map<String,flash.media.Sound>;
	
	private static var soundsPath : String;
	
	
	public static function InitInstance(soundsPath : String): SoundManager
	{
		if (instance == null)
			instance = new SoundManager(soundsPath);
		
		soundsData = new Map<String,flash.media.Sound>();
		
		return instance;
	}
	
	/*
	 * Creates and returns a screen manager instance if it's not created yet.
	 * Returns the current instance of this class if it already exists.
	 */
	public static function GetInstance(): SoundManager
	{
		if ( instance == null )
			throw "The Sound Manager is not initialized. Use function 'InitInstance'";
		
		return instance;
	}
	
	/*
	 * Constructor
	 */
	private function new(path : String) 
	{
		soundsPath = path;
	}
	
	public static function AddSoundData(id : String,name : String, extension : String = "wav", internalPath : String = "") : Void
	{
		var path : String;
		var soundData : flash.media.Sound;
		
		if (soundsData == null)
			throw "Sounds are not initialized. Use function 'InitInstance'";

		path = soundsPath + internalPath + name + "." + extension;
		
		if (!soundsData.exists(path))
		{
			soundData = Assets.getSound(path);
			if (soundData != null)
				soundsData.set(id , soundData);
		}
	}
	
	public static function GetSoundData(id : String) : flash.media.Sound
	{
		return soundsData.get(id);
	}
	
	public static function CreateSound(soundDataId : String) : Sound
	{
		var soundData : flash.media.Sound;
		var sound : Sound;
		
		soundData = soundsData.get(soundDataId);
		
		if (soundData == null)
			sound = null;
		else
			sound = new Sound(soundData, false); //Sounds are not loops
		
			
		return sound;
	}
	
	public static function TurnSoundsOn() : Void
	{
		soundsState = AudioState.On;
	}
	
	public static function TurnSoundsOff() : Void
	{
		soundsState = AudioState.Off;
	}
	
	public static function TurnMusicOn() : Void
	{
		musicState = AudioState.On;
	}
	
	public static function TurnMusicOff() : Void
	{
		musicState = AudioState.Off;
	}
	
	public static function PlaySound(sound : Sound, startTime : Float = 0) : Void
	{
		if (soundsState == AudioState.On)
			sound.Play(startTime);
	}
}