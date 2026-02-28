package src.sphis;

class Version {
	public var MajorVersion:Int = 0;
	public var MinorVersion:Int = 0;
	public var PatchVersion:Int = 0;
	public var HotfixVersion:Int = 0;
	public var Suffix:String = '';

	public function generateVersionString(patch:Bool = true, hotfix:Bool = true, suffix:Bool = true) {
		var versionString:String = '${MajorVersion}.${MinorVersion}';
		versionString += '${patch && PatchVersion > 0 ? '.${PatchVersion}' : ''}';
		versionString += '${hotfix && HotfixVersion > 0 ? '_${HotfixVersion > 9 ? '' : '0'}${HotfixVersion}' : ''}';
		if (suffix)
			versionString += Suffix;

		return versionString;
	}
}
