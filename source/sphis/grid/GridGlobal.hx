package sphis.grid;

class GridGlobal {
	public static var GRID_WIDTH:Int = 8;
	public static var GRID_HEIGHT:Int = 8;

	/**
	 * This will set both `GRID_WIDTH` and `GRID_HEIGHT` through 1 argument
	 */
	public static function setGridSizePack(packSize:Int)
        {
                setGridSize(packSize, packSize);
        }

	/**
	 * This will set both `GRID_WIDTH` and `GRID_HEIGHT` through 2 arguments
	 */
	public static function setGridSize(width:Int,height:Int)
        {
                GRID_WIDTH = width;
                GRID_HEIGHT = height;
        }
}
