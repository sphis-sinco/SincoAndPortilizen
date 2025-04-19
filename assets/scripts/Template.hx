// Pure initalization
function initalizeMod() {}
function initalizeLanguage() {}

// These are run for EVERY STATE
function stateSwitched() {}
function stateCreate() {}
function statePostCreate() {}
function stateUpdate(elapsed:Float) {}

// Ctrl+Alt+Shift+L Crash
function CASLCrash() {}

// Called by the worldmap
function worldmapSelection(character:String, selection:Int) {}