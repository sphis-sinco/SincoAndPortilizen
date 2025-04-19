package sap;

import flixel.system.FlxVersion;

/**
 * Helper object for semantic versioning.
 * @see   http://semver.org/
 */
@:build(flixel.system.macros.FlxGitSHA.buildGitSHA("flixel"))
class SAPVersion
{
	public static function toString():String
	{
		var sha = FlxVersion.sha;
		if (sha != "")
		{
			sha = sha.substring(0, 7);
		}
		return '${Global.GENERATED_BY.split('v')[0]} v${Global.VERSION_FULL} $sha';
	}
}
