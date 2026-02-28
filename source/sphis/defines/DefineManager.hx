package sphis.defines;

class DefineManager {
	/**
	 * An array of enabled defines.
	 * 
	 * So if you're looking for the `debug` define you do
	 * "`DEFINES.contains('debug')`"
	 * And yeah
	 */
	public static var DEFINES:Array<String> = [];

	/**
	 * Run this in `Main.hx`!
	 * It will initalize all the defines...
	 * 
	 * Unless you wanna do it yourself
	 */
	public static function initalizeDefines() {
		#if debug
		DEFINES.push('debug');
		#end
		#if flixelModding
		DEFINES.push('flixelModding');
		#end
		#if hscriptIris
		DEFINES.push('hscriptIris');
		#end
	}

	/**
	 * Returns if a define is added to `DEFINES`
	 */
	public static function enabledDefine(define:String):Bool {
		return DEFINES.contains(define);
	}
}
