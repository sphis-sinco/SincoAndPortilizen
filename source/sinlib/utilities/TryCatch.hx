package sinlib.utilities;

typedef TryCatchParamaters = {
	var ?errFunc:Dynamic;
	var ?traceErr:Bool;
}

class TryCatch {
	/**
	 * This function is purely to clean up your code with all the try catch statements you are trying to use.
	 * @param func the function you are trying to run
	 * @param paramaters optional paramaters for the tryCatch.
	 */
	public static function tryCatch(func:Dynamic, ?paramaters:TryCatchParamaters) {
		try {
			func();
		} catch (e) {
			try {
				if (paramaters.traceErr)
					trace(e);
			} catch (e) {/** This is purely incase you do `tryCatch(funcHere);` **/}

			try {
				paramaters.errFunc();
			} catch (e) {}
		}
	}
}
