package fs.soundmanager;

/**
 * Interface to represent sounds: sound effects and soundtracks.
 * 
 * @author Henry D. Fernández B.
 */

interface ISound 
{
	/*
	 * Play the sound.
	 */
	function Play(startTime : Float = 0) : Void;
	
	/*
	 * Pause the sound.
	 */
	function Pause() : Void;
	
	/*
	 * Resume the sound.
	 */
	function Resume() : Void;
    
    /*
	 * Stop the sound.
	 */
	function Stop() : Void;
	
	/*
	 * Updates the logic to reproduce the sound.
	 * 
	 * @param gameTime Current game time
	 */
	function Update(gameTime:Float) : Void;	
}