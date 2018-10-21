package;

import flash.media.SoundLoaderContext;
import flash.net.URLRequest;

/**
 * ...
 * @author Fiery Squirrel
 */
class MusicData extends SoundData
{
	static public inline var TYPE = "Music";
	
	public function new(data : flash.media.Sound) 
	{
		super(TYPE,data);	
	}
}