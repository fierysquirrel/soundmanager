package;

import flash.media.SoundLoaderContext;
import flash.net.URLRequest;

/**
 * ...
 * @author Fiery Squirrel
 */
class SoundFXData extends SoundData
{
	static public inline var TYPE = "SoundFX";
	
	public function new(data : flash.media.Sound) 
	{
		super(TYPE,data);
		
	}
}