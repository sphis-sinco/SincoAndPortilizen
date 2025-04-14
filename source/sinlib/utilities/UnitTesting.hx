package sinlib.utilities;

class UnitTesting {
	/**
	 * Checks if `func` returns `expectedValue`
	 * @param func 
	 * @param expectedValue 
	 */
	public static function testDynamicReturn(func:Dynamic, expectedValue:Dynamic) {
		if (func() != expectedValue)
			throw 'Function did not return $expectedValue when being tested.';
	}

	/**
	 * Uses `testDynamicReturn` to check if `func` returns `expectedValue`
	 * @param func The function you would like to test
	 * @param expectedValue The value you expect
	 */
	public static function testBoolReturn(func:Dynamic, expectedValue:Bool = false) {
		testDynamicReturn(func, expectedValue);
	}

	/**
	 * Uses `testDynamicReturn` to check if `func` returns `expectedValue`
	 * @param func The function you would like to test
	 * @param expectedValue The value you expect
	 */
	public static function testStringReturn(func:Dynamic, expectedValue:String = '') {
		testDynamicReturn(func, expectedValue);
	}

	/**
	 * Uses `testDynamicReturn` to check if `func` returns `expectedValue`
	 * @param func The function you would like to test
	 * @param expectedValue The value you expect
	 */
	public static function testIntReturn(func:Dynamic, expectedValue:Int = 0) {
		testDynamicReturn(func, expectedValue);
	}

	/**
	 * Uses `testDynamicReturn` to check if `func` returns `expectedValue`
	 * @param func The function you would like to test
	 * @param expectedValue The value you expect
	 */
	public static function testFloatReturn(func:Dynamic, expectedValue:Float = 0.0) {
		testDynamicReturn(func, expectedValue);
	}
}
