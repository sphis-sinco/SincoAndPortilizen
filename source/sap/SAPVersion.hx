package sap;

import flixel.system.FlxVersion;

/**
 * Helper object for semantic versioning.
 * @see   http://semver.org/
 */
@:build(flixel.system.macros.FlxGitSHA.buildGitSHA("flixel"))
class SAPVersion
{
	public var major(default, null):Int;
	public var minor(default, null):Int;
	public var patch(default, null):Int;

	public function new(Major:Int, Minor:Int, Patch:Int)
	{
		major = Major;
		minor = Minor;
		patch = Patch;
	}

	/**
	 * Formats the version in the format "Sinco and Portilizen MAJOR.MINOR.PATCH-COMMIT_SHA",
	 * e.g. HaxeFlixel 3.0.4.
	 * If this is a dev version, the git sha is included.
	 */
	public function toString():String
	{
		var sha = FlxVersion.sha;
		if (sha != "")
		{
			sha = "@" + sha.substring(0, 7);
		}
		return '${Global.GENERATED_BY.split('v')[0]} $major.$minor.$patch$sha';
	}
}
