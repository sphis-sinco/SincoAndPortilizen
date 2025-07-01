package;

class Version {
        public static var MajorVersion:Int = 0;
	public static var MinorVersion:Int = 1;
	public static var PatchVersion:Int = 0;
	public static var HotfixVersion:Int = 0;
        public static var Suffix:String = 'b';

        public static function generateVersionString(patch:Bool = true, hotfix:Bool = true, suffix:Bool = true)
        {
                var versionString:String = '${MajorVersion}.${MinorVersion}';
		versionString += '${patch && PatchVersion > 0 ? '.${PatchVersion}' : ''}${hotfix && HotfixVersion > 0 ? '_${HotfixVersion > 9 ? '' : '0'}${HotfixVersion}' : ''}';
                if (suffix)
                        versionString += Suffix;

                return versionString;
        }
}