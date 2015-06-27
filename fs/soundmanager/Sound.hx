package fs.soundmanager;

import flash.events.Event;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

/**
 * Class to represent sounds.
 * 
 * @author Henry D. Fernández B.
 */

 /*
  * Sound State: Play, Pause, Stop.
  * */
enum State
{
	Play;
	Pause;
	Stop;
}

class Sound implements ISound
{
	/*
	 * The real sound, this object lets usto reproduce the sound.
	 */
	private var sound : flash.media.Sound;
	
	/*
	 * A sound handler that allows us to manage the sound.
	 */
	private var soundChannel : SoundChannel;
	
	/*
	 * Is the sound a loop?.
	 */
	private var isLoop : Bool;
	
	/*
	 * It's used to resume the sound.
	 * This is the exact position at what the sound paused.
	 */
	private var resumePosition : Float;
	
	/*
	 * Current state: Playing, Paused, Stopped.
	 */
	private var state : State;
	
	/*
	 * Initializes a sound effect or soundtrack.
	 * 
	 * @param sound the sound asset.
	 * @param isLoop is the sound a loop?.
	 * */
	public function new(sound : flash.media.Sound, isLoop : Bool) 
	{	
		if (sound == null)
			throw "Error: sound should be initialized";
			
		this.sound = sound;
		this.isLoop = isLoop;
		state = State.Stop;
	}
	
	public function GetState() : State
	{
		return state;
	}
	
	/*
	 * Play the sound if it's stopped or paused.
	 * */
	public function Play(startTime : Float = 0)
	{
		var looping : Int = isLoop ? 99999 : 0;
		
		if (state == State.Stop || state == State.Pause)
		{
			soundChannel = sound.play(startTime, looping,new SoundTransform (1, 0));
			soundChannel.addEventListener(Event.SOUND_COMPLETE, OnComplete);
			state = State.Play;
		}
	}

	/*
	 * Pauses the sound if it's playing.
	 * */
	public function Pause()
	{
		if (state == State.Play && soundChannel != null)
		{
			resumePosition = soundChannel.position;
			soundChannel.stop();
			state = State.Pause;
		}
	}

	/*
	 * Resumes the sound if it's paused.
	 * */
	public function Resume()
	{
		var looping : Int = isLoop ? 99999 : 0;
		
		if (state == State.Pause)
		{
			if (soundChannel != null)
			{
				soundChannel = sound.play(resumePosition, looping);
				soundChannel.addEventListener(Event.COMPLETE, OnComplete);
				state = State.Play;
				resumePosition = 0;
			}
		}
		else if(state == State.Stop)
			Play();
	}

	/*
	 * Stops the sound if it's playing.
	 * */
	public function Stop()
	{
		if (soundChannel != null)
		{
			state = State.Stop;
			soundChannel.stop();
			resumePosition = 0;
		}
	}

	/*
	 * Updates the logic to reproduce the sound.
	 *
	 * @param gameTime Current game time.
	 * */
	public function Update(gameTime:Float)
	{
	}
	
	/*
	 * Sound complete listener.
	 * It's executed when the sound is completely played.
	 *
	 * @param event SOUND_COMPLETE event.
	 * */
	private function OnComplete(event : Event)
	{
		if(!isLoop)
			Stop();
	}
	
	/*
	 * Set sound's volumen 0..1.
	 *
	 * @param volume a value from 0 to 1, where 0 is the minimum and 1 the maximum.
	 * */
	public function SetVolume(volume:Float)
	{
		if (volume < 0 || volume > 1)
			throw "Error: volume must be between 0..1";
			
		if (soundChannel != null)
		{
			//soundChannel.soundTransform = new SoundTransform(volume);
			soundChannel.soundTransform.volume = volume;
		}
	}
	
	public function GetVolume() : Float
	{
		return soundChannel.soundTransform.volume;
	}
	
	/*
	 * Adds a listener to the SOUND_COMPLETE event.
	 *
	 * @param listener a function to be executed when the sound is complete.
	 * */
	public function AddOnCompleteListener(listener : Dynamic -> Void)
	{
		if(soundChannel != null)
			soundChannel.addEventListener(Event.SOUND_COMPLETE,listener);
	}
	
	/*
	 * Removes a listener from the SOUND_COMPLETE event.
	 *
	 * @param listener a function to be executed when the sound is complete.
	 * */
	public function RemoveOnCompleteListener(listener : Dynamic -> Void)
	{
		if(soundChannel != null)
			soundChannel.removeEventListener(Event.SOUND_COMPLETE,listener);
	}
}