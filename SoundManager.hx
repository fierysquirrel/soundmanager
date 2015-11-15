package;

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
	
	private static var soundsData : Map<String,SoundData>;
	
	private static var soundsPath : String;
	
	private static var musicPath : String;
	
	private static var sounds : Map<String,Sound>;
	
	
	public static function InitInstance(soundsPath : String,musicPath : String, soundsState : AudioState = null, musicState : AudioState  = null): SoundManager
	{
		if (instance == null)
			instance = new SoundManager(soundsPath,musicPath,soundsState,musicState);
		
		soundsData = new Map<String,SoundData>();
		sounds = new Map<String,Sound>();
		
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
	private function new(sPath : String,mPath : String, sState : AudioState, mState : AudioState) 
	{
		soundsPath = sPath;
		musicPath = mPath;
		soundsState = sState == null ? AudioState.On : sState;
		musicState = mState == null ? AudioState.On : mState;
	}
	
	public static function GetSoundsState() : AudioState
	{
		return soundsState;
	}
	
	public static function GetMusicState() : AudioState
	{
		return musicState;
	}
	
	public static function LoadSoundDataFromXML(fileName : String, internalPath : String = "") : Void
	{
		LoadDataFromXML(fileName, soundsPath, AddSoundData,"wav",internalPath);
	}
	
	public static function LoadMusicDataFromXML(fileName : String, internalPath : String = "") : Void
	{
		LoadDataFromXML(fileName, musicPath, AddMusicData,"ogg", internalPath);
	}
	
	private static function LoadDataFromXML(fileName : String, path : String,addDataFunc : String -> String -> String -> String -> Void,defaultExt :String, internalPath : String = "") : Void
	{
		var str,name,id,extension,soundIntPath : String;
		var xml : Xml;
			
		try
		{
			str = Assets.getText(path + internalPath + fileName + ".xml");
			xml = Xml.parse(str).firstElement();
			for (i in xml.iterator())
			{
				if (i.nodeType == Xml.Element)
				{
					name = i.get("name") == null ? "" : i.get("name");
					extension = i.get("extension") == null ? defaultExt : i.get("extension");
					//If we don't specify the id, we use the file name (name + extension)
					id = i.get("id") == null ? name + "." + extension : i.get("id");
					soundIntPath = i.get("path") == null ? "" : i.get("path");
					
					if (id != "" && name != "")
						addDataFunc(id, name, extension, soundIntPath);	
				}
			}
		}
		catch (e : String)
		{
			trace(e);
		}
	}
	
	public static function Update(gameTime : Float) : Void
	{
		for (s in sounds)
			s.Update(gameTime);
	}
	
	private static function AddBaseData(id : String,audioPath : String,name : String, extension : String, internalPath : String,getDataFunc : String -> Bool -> flash.media.Sound,dataType : String) : Void
	{
		var path : String;
		var soundData : SoundData;
		
		if (soundsData == null)
			throw "Sounds are not initialized. Use function 'InitInstance'";

		path = audioPath + internalPath + name + "." + extension;
		
		if (!soundsData.exists(path))
		{
			soundData = null;
			
			switch(dataType)
			{
				case SoundFXData.TYPE:
					//TODO: generalize this to pass 'cache' as a parameter as well
					soundData = new SoundFXData(getDataFunc(path, true));
				case MusicData.TYPE:
					//TODO: generalize this to pass 'cache' as a parameter as well
					soundData = new MusicData(getDataFunc(path, true));
			}
			
			if (soundData != null)
				soundsData.set(id , soundData);
		}
	}
	
	public static function AddSoundData(id : String,name : String, extension : String = "wav", internalPath : String = "") : Void
	{
		AddBaseData(id,soundsPath,name, extension, internalPath,Assets.getSound,SoundFXData.TYPE);
	}
	
	public static function AddMusicData(id : String,name : String, extension : String = "ogg", internalPath : String = "") : Void
	{
		AddBaseData(id,musicPath,name, extension, internalPath,Assets.getMusic,MusicData.TYPE);
	}
	
	public static function GetSoundData(id : String) : SoundData
	{
		return soundsData.get(id);
	}
	
	public static function CreateSound(soundDataId : String,loop: Bool = false, load : Bool = false) : Sound
	{
		var soundData : SoundData;
		var sound : Sound;
		
		soundData = soundsData.get(soundDataId);
		
		if (soundData == null)
			sound = null;
		else
			sound = new Sound(soundData, loop);
		
		//Load it and can be reproduced later with the same id
		if (load)
			sounds.set(soundDataId, sound);
			
		return sound;
	}
	
	public static function TurnSoundsOn() : Void
	{
		soundsState = AudioState.On;
	}
	
	public static function TurnSoundsOff() : Void
	{
		soundsState = AudioState.Off;
		StopAllSounds();
	}
	
	public static function TurnMusicOn() : Void
	{
		musicState = AudioState.On;
		StopAllSounds();
	}
	
	public static function TurnMusicOff() : Void
	{
		musicState = AudioState.Off;
		StopAllMusic();
	}
	
	public static function PlaySound(sound : Sound, startTime : Float = 0) : Void
	{
		if (sound == null)
			throw("Sound is null");
		else
		{
			switch(sound.GetSoundData().GetType())
			{
				case SoundFXData.TYPE:
					if (soundsState == AudioState.On)
						sound.Play(startTime);
				case MusicData.TYPE:
					if (musicState == AudioState.On)
						sound.Play(startTime);
			}
		}
	}
	
	public static function StopLoadedSound(soundId : String) : Void
	{
		if (sounds.exists(soundId))
			sounds.get(soundId).Stop();
	}
	
	public static function PlayLoadedSound(soundId : String, startTime : Float = 0) : Void
	{
		if (sounds.exists(soundId))
		{
			if(sounds.get(soundId) != null)
				PlaySound(sounds.get(soundId), startTime);
		}
		else
			throw("The sound has not being added");
	}
	
	public static function ResumeSound(sound : Sound) : Void
	{
		switch(sound.GetSoundData().GetType())
		{
			case SoundFXData.TYPE:
				if (soundsState == AudioState.On)
					sound.Resume();
			case MusicData.TYPE:
				if (musicState == AudioState.On)
					sound.Resume();
		}
	}
	
	public static function ResumeLoadedSound(soundId : String) : Void
	{		
		if (sounds.exists(soundId))
		{
			if(sounds.get(soundId) != null)
				ResumeSound(sounds.get(soundId));
		}	
		else
			throw("The sound has not being added");
	}
	
	public static function PauseLoadedSound(soundId : String) : Void
	{
		if (sounds.exists(soundId))
		{
			if(sounds.get(soundId) != null)
				sounds.get(soundId).Pause();
		}	
		else
			throw("The sound has not being added");
	}
	
	public static function StopAllSounds() : Void
	{
		for (s in sounds)
		{
			if(s.GetSoundData().GetType() == SoundFXData.TYPE)
				s.Stop();
		}
	}
	
	public static function StopAllMusic() : Void
	{
		for (s in sounds)
		{
			if(s.GetSoundData().GetType() == MusicData.TYPE)
				s.Stop();
		}
	}
}