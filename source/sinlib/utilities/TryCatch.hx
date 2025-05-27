package sinlib.utilities;

typedef TryCatchParamaters =
{
	var ?errFunc:Dynamic;
	var ?traceErr:Bool;
}

class TryCatch
{
	/**
	 * This function is purely to clean up your code with all the try catch statements you are trying to use.
	 * @param func the function you are trying to run
	 * @param paramaters optional paramaters for the tryCatch.
	 */
	public static function tryCatch<T>(func:Void->T, ?options:TryCatchParamaters):T
	{
		try
		{
			return func();
		}
		catch (e:Dynamic)
		{
			if (options != null)
			{
				if (options.traceErr)
					trace('Error: $e');
				if (options.errFunc != null)
					options.errFunc();
			}
			return null;
		}
	}
}
