# Build Flags
These do things. Lmao!

## Misc
- `DISABLE_PLUGINS`: Disables plugins (mind blown)
- `DISCORDRPC`: Enables Discord RPC if your not on windows, only works for C++ target platforms otherwise you just get a compiler error
- `DISABLE_SCREENSHOT`: Disables screenshots (mind blown)
- `SCRIPT_FILES`: Enables the `getScriptFile` function for `FileManager.hx`
- `DISABLE_LOCALIZED_ASSETS`: Disables asset localization attempts for `FileManager.hx`
- `DEFAULT_DIRECTORY`: Disables custom build directories besides the original ones
- `EXCESS_TRACES`: Adds in traces that are unimportant
- `PLAYTESTER_BUILD`: Adds in a "-playtest" to the end of the version string

## QOL Flags
- `DISABLE_ANNOYING_ERRORS`: Makes errors less annoying
- `DISABLE_ANNOYING_WARNINGS`: Makes warnings less annoying
- `RECOMPILE_ON_MOD_UPDATE` (enabled by default): Makes it so that when doing `-watch` and changing mod files the game recompiles
- `DO_NOT_RECOMPILE_ON_MOD_UPDATE`: Disables `RECOMPILE_ON_MOD_UPDATE`
- `NO_MODS`: When compiling with debug you don't get the debug_mods folder being turnt into the mods folder
- `RECOMPILE_ON_ASSET_UPDATE` (enabled by default): Makes it so that when doing `-watch` and changing asset script files the game recompiles
- `DONT_RECOMPILE_ON_ASSET_UPDATE`: Disables `RECOMPILE_ON_ASSET_UPDATE`

## Start State Flags
- `SKIP_TITLE`: Sends you to the Main Menu instantly instead of the Title Screen

- `STAGE_ONE`: Sends you to the first stage
- `STAGE_TWO`: Sends you to the second stage
- `STAGE_FOUR`: Sends you to the fourth stage

- `SIDEBIT_ONE`: Sends you to the first sidebit intro cutscene
- `SIDEBIT_ONE_INSTANT`: Sends you to the first sidebit instantly

- `EASY_DIFFICULTY` (executes with a `STAGE_` flag or a `SIDEBIT_` flag): Sets the difficulty to easy
- `HARD_DIFFICULTY` (executes with a `STAGE_` flag or a `SIDEBIT_` flag): Sets the difficulty to hard
- `EXTREME_DIFFICULTY` (executes with a `STAGE_` flag or a `SIDEBIT_` flag): Sets the difficulty to extreme

- `WORLDMAP`: Sends you to the worldmap as Sinco

- `RESULTS`: Sends you to the results state as Sinco
- `BAD_RANK` (executes with `RESULTS`): Sets the rank you will get to the bad rank
- `GOOD_RANK` (executes with `RESULTS`): Sets the rank you will get to the good rank
- `GREAT_RANK` (executes with `RESULTS`): Sets the rank you will get to the great rank
- `EXCELLENT_RANK` (executes with `RESULTS`): Sets the rank you will get to the excellent rank
- `PERFECT_RANK` (executes with `RESULTS`): Sets the rank you will get to the perfect rank
- `PORT_RANK_CHAR` (executes with `RESULTS`): Sends you to the results state as Portilizen

- `GIF_PORT_GAMEOVER`: Sends you to the experimental `PaulPortGameOver` state

- `SIDEBIT1_INTRO_CUTSCENE`: Sends you to the `Sidebit1IntroCutscene` state
- `FLXANIMATE_TESTING`: Sends you to the `Sidebit1IntroCutsceneAtlas` state

- `SIDEBIT_MENU`: Sends you to the `SidebitSelect` state

## Language Flags
- `CNGLA_TRACES`: Allows the console to print out what localized assets it could not get
- `FORCED_ENGLISH_LANGUAGE`: Forces your language to English
- `SPANISH_LANGUAGE`: Sets your language to (Google-translated) Spanish
- `PORTUGUESE_LANGUAGE`: Sets your language to Portuguese