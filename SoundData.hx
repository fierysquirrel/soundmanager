package;

import flash.media.Sound;
import flash.media.SoundLoaderContext;
import flash.net.URLRequest;

/**
 * ...
 * @author Fiery Squirrel
 */
class SoundData
{
	private var type : String;
	private var data : Sound;
	
	public function new(type : String,data : flash.media.Sound) 
	{
		this.data = data;
		this.type = type;
	}
	
	public function GetData() : flash.media.Sound
	{
		return data;
	}
	
	public function GetType() : String
	{
		return type;
	}
}