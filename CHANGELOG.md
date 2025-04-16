# Alpha
## 0.5.0a - 4/??/2025
### Added
- (Source) FileManager has 2 new QOL functions: `getPackerAtlas` and `getSparrowAtlas`
- Sticker transition from FNF
- (Web only) Pixel perfect rendering ([#27][#27_link])
### Fixed
- Fixed the character ring characters on the titlescreen blinking from invisible to visible when switching to the titlestate
### Changed
- (Debug only) The titlestate now has a `DEBUG` intro state that waits a second before actually starting the intro sequence
- Global now has a `randomStickerFolder` function that is used for when a random sticker folder is needed
- Global now has a `RANDOM_STICKER_FOLDERS` variable that is used for when a random sticker folder is needed
- (Debug only) InitState uses a random sticker transition when there are no build flags enabled
- The screenshot plugin now has (probably) everything as a static var/function
- SparrowSprite uses the file manager's `getSparrowAtlas` function
- Several states now use the `switchState` function from Global
- Global now has a `switchState` function that uses the new sticker transition

## 0.4.3a - 4/15/2025
### Added
- (Desktop only) Added oudated version menu
### Fixed
- Fixed crash when switching from the stage 4 ending cutscene to the worldmap ([#23](#23_link))
### Changed
- Worldmap character asset grabbing is no longer case sensitive
- Modding API version is now `0.1.3`
  - There are now additional "Variables" from `import.hx`
- (Desktop only) The menu text box vertical size changes depending on if the mod option is visible or not
- (Desktop only) The MainMenu mod option is not visible when there are no mods
- (source) `GENERATED_BY` now uses `VERSION_FULL`
- (source) `GENERATED_BY` can be modified from other files
- (compiling) `ModFolderManager` traces the supported modding API versions with `EXCESS_TRACES` enabled only
- (source) In stage 1 you can no longer attack when the opponent is attacking
- (source) Global now has 2 version variables: `VERSION` and `VERSION_FULL`, `VERSION` is the simplist version (i.e `0.5.2a`), `VERSION_FULL` is the most complicated (i.e `0.10.5a-debug-playtester (github-actions)`)
- (source) The FileManager now has a new function for saying if it cant find a file via `unfoundAsset`
- (source) The FileManager now says if it can't find a file in the `readFile` function
- (source) The FileManager no longer only traces that it couldn't find a file when `EXCESS_TRACES` is enabled
- (compiling) The project xml no longer echos the game name and version
### Removed
- (compiling) Sinlib is no longer required to compile and has been integrated into the source code

## 0.4.2a - 4/14/2025
### Added
- Sidebit 1 health icons
- Portuguese Tutorial assets for sidebit1
### Fixed
- Tutorial assets are visible in Sidebit 1 now
### Changed
- Modding API version is now `0.1.2`
  - `ModFolderManager` now traces the supported modding API versions
  - New function: `PlayMusic`
  - New function: `PlaySFX`
- Sidebit 1 tutorial assets are more visible on the white background
- Medals no longer unlock on web (the icon doesnt appear)

## 0.4.1a - 4/13/2025
### Added
- MOD MENU <!-- Moved up because it's the main addition -->
- PROPER SAVING
- `DO_NOT_RECOMPILE_ON_MOD_UPDATE` build flag
- `modInfo` function to help get mod info in a similar format
- `getEnabledMods` function in the SaveManager
- The missing `getMedals` function in the SaveManager is here
- `enabled_mods` save field
- `StringSortAlphabetically` function to Random.hx
### Fixed
- AnsiTrace now actually enforces `MAX_TRACES`
### Removed
- Source code mods
### Changed
- The `RECOMPILE_ON_MOD_UPDATE` build flag is enabled by default
- This `CHANGELOG.md` file is now included in compiled builds
- CrashHandler now includes enabled mods
- (Desktop only) the menu text box is longer vertically to fit the mods menu option
- Mods are now sorted alphabetically
- There is no longer spam about missing assets once it is found to be missing in the FileManager
- Mod API version is now `0.1.1`
  - `loadScripts` now destroys the scripts before clearing the list to avoid script instances with the same name
  - New function for mod scripts: `UnlockMedal(medal:String)`
  - Mods now run `initalizeMod` after `loadScripts`
  - When using `getAssetFile` it now checks mod folders first before actually checking the assets folders, with a first come first serve system

## 0.4.0a (Pitstop 2 - Sidebit 1) - 4/13/2025
### Added
<!-- These are moved up because they are epicer-->
- (Desktop) MEDALS MENU
- (Desktop only probably) SOFTCODED MODDING (v0.1)
- NEW MENU TRACK: LADOS
- (Desktop only probably) HSCRIPTING (via [`hscript-iris`](https://github.com/pisayesiwsi/hscript-iris))
- VOICE-ACTED CUTSCENES
- SIDEBIT 1
- POST-LEVEL4 CUTSCENE
- 7 UNLOCKABLE MEDALS
- SIDEBIT SELECT MENU
- (source) `RECOMPILE_ON_MOD_UPDATE` build flag
- (source) [HSV Shader](https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/graphics/shaders/HSVShader.hx)
- Stage 2 now has a health bar for tempo city
- (source) `SIDEBIT_MENU` build flag
- (Desktop only) Added Discord RPC setting that toggles discord RPC
- Cutscenes asset folder containing all the cutscene assets
- (source) `SIDEBIT_ONE_INSTANT` build flag
- (source) `SIDEBIT_ONE` build flag
- Easier comic cutscene support via JSON (minus the fact you need a haxe file n shit but uh shush)
- TJ Credit (TJ is apart of SAPTeam now)
- Texture atlas cutscene support
- (source) `FLXANIMATE_TESTING` build flag
- (source) Crash trace (terminal) after the crash log is generator
- (source) `PLAYTESTER_BUILD` build flag
- Sparrow spritesheet cutscene support
- (source) `SIDEBIT1_INTRO_CUTSCENE` build flag
- Medal unlock sound effect
- (source) [`InitState`](https://github.com/sphis-Sinco/SincoAndPortilizen/blob/main/source/InitState.hx) now tracks how long functions are taking via [`haxe.Timer`](https://github.com/HaxeFoundation/haxe/blob/4.3.6/std/haxe/Timer.hx)
- (source) `GIF_PORT_GAMEOVER` build flag
- (source) [FlxGif](https://github.com/MAJigsaw77/flxgif) library
- (source) [Adjust Color Shader](https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/graphics/shaders/AdjustColorShader.hx)
- (Desktop and sys only) New settings menu option to download latest traces
### Removed
- Removed several unused assets
### Fixed
- You can no longer select levels unlocked for one character but locked for another in the worldmap
- The credits text no longer only updates to a new language by reloading the game
- Level medals no longer unlock in other levels
- Panel 1 of comic cutscenes not calling [`panelEvents`](https://github.com/sphis-Sinco/SincoAndPortilizen/blob/main/source/sap/cutscenes/PanelCutscene.hx)
- Stage 2 tempo city health not initializing is fixed
- Stage 2 rocks not spawning more rocks after playing a failed playthrough is fixed
- The crash when trying to check if uninitalize stages medals are unlocked is fixed
- The "Huh, someone cares" medal icon now loads properly
- (Desktop only) The settings menu no longer displays the incorrect window resolution
### Changed
- (Desktop only) the menu text box is longer vertically to fit the medals menu option
- The version text on the title screen has the modding api version
- The version text on the title screen is smaller
- When crashing the game with Ctrl+Alt+Shift+L it now says CASLCrash
- The Stage 1 Info text below the health bar is now screenCentered on the X axis
- (Desktop only) Discord RPC now says the level difficulty
- (source) Start state flags related to difficulty run with `SIDEBIT_` build flags
- Reworked comic cutscenes to work with JSON
- Re-enabled medals
- In the title state the characters in the character sing fade in via shaders
- [`Combo.hx`](https://github.com/sphis-Sinco/SincoAndPortilizen/blob/main/source/sap/stages/Combo.hx) now is in the `sap.stages` folder
- The title screen version text no longer is visible during the intro sequence
- The crash handler trace for loop is now in the `AnsiTrace` file as a [`neatTraceList`](https://github.com/sphis-Sinco/SincoAndPortilizen/blob/main/source/funkin/util/logging/AnsiTrace.hx#L8) function
- In the settings menu, if a save has a null value, the value will not display
- Several InitState traces are not apart of `EXCESS_TRACES`
- [`get_VERSION`](https://github.com/sphis-Sinco/SincoAndPortilizen/blob/main/source/Global.hx#L21) now has the version trace as apart of `EXCESS_TRACES`
- Sparrow Sprites that get their animation added via [`addAnimationByPrefix`](https://github.com/sphis-Sinco/SincoAndPortilizen/blob/main/source/sap/utils/SparrowSprite.hx#L11) now have the animation play automatically

<!-- A patch content update? How peculiar... normally this would be v0.4.0a but versioning has changed, like right now, LOL -->
<!-- If there ain't a new level or MAJOR content update then its a "patch" update, otherwise a minor-->
## 0.3.2a - 4/9/2025
### Removed
- Removed `max_rocks` stage 2 difficulty json field
### Fixed
- Fixed bug in stage 2 where sinco would float on air
- Fixed bug in stage 2 where you could get 200% thanks to negative values
- Fixed bug in stage 2 where you hit the first rock and it wouldnt spawn extra rocks(?) <!-- nope -->
### Changed
- Stage 1 UI is now updated and overhauled to be a health bar with text below it
### Added
- Added `rock_speed_divider` field to Stage 2 difficulty json files (replaces `max_rocks` field)
- Added crash keybind for states using the [`State.hx`](source/sap/utils/State.hx) file
- Added the Friday Night Funkin AnsiTrace file
- Added the Friday Night Funkin Crash Handler
  - [Crash logs](random/crash.log) now get generated
- Added EXCESS_TRACES build flag to limit the traces (so far only removes the SFX and Music traces)
- Added combos to Stage 1
  - Sinco now has a custom combo pose
  - Sinco's combo pose plays when you have an attack combo of 10, 20, and 30 but can be changed by the [`combo_poses`](assets/data/stages/stage1/combo_poses.txt) text file
  - The combo resets when osin attacks sinco
  - There is now a combo sprite that appears for when a combo occors
- Added `attack_percentage` field to Stage 4 difficulty json files
  - Extreme difficulty now has a 95% chance of attack
  - Hard difficulty now has a 50% chance of attack
  - Easy difficulty now has a 12.5% chance of attack
- Added `-debug` text at the end of the version strings added when in debug builds

## 0.3.1a - 4/8/2025
### Added
- Added Post-Stage 2 panel Cutscene
- Added spanish, and portuguese translation to the intro cutscene and post-stage1 cutscene
### Fixed
- Fixed typos in the 3rd intro cutscene panel
- Fixed web bug where pressing continue crashes the game

## 0.3.0a (Destination 2 - Tierra) - 4/8/2025
### Added
- Added Spanish and Portuguese translations for the tutorial objects
- Added difficulties: Easy, Normal, Hard, and Extreme
- Added reset buttons to Stages 1, 2, and 4
- Added back custom Stage 1 background created by @iampauleps
- Added Stage 2
- Added window resolution change on startup
- Added save for the window resolution before leaving the settings menu
- Added a settings save data value
### Changed
- Main menu sinco and portilizen are now moves more to the left and right respectively
- Main menu option box is now bigger
- Level data is now controlled by json
- The player now starts on the last level selected in the worldmap
- Updated all sinco assets
- Updated osin assets
### Fixed
- Fixed Main Menu option texts being able to escape the bounds of the box
- Fixed stage 1 bug where you can dodge and jump at the same time
- Fixed portilizen map being sincos map after swapping
- Fixed negative percentages on Results Menu
- Fixed bug where stage 4 would crash because when jumping ([#19](#19_link))
- Fixed window resolution option not being accurate to the actual resolution (This was due to the missing window resolution save value)

## 0.2.1a - 3/12/2025
### Nerd stuff
- Reverted most shit to 0.1.1a
### Removed
- Removed HScript modding
### Fixed
- Fixed hitHurt sounds trying to play a hitHurt-0 sound that doesn't exist.

## 0.2.0a (Pitstop 1 - Scripting) - 3/12/2025
### Changed
- Changed it so that now [Stage 1 and Stage 4 are now a mix of soft-coded and hard-coded.](#18_link)
### Fixed
- Fixed internal bug where it would say "`Failed to change to language: english`" but `LANGUAGE` is supposed to be another language
### Added
- Added custom Stage 1 background created by @iampauleps
- Added mod support (`scripts/`) for:
        - MainMenu (`menus/MainMenu`)
        - WorldMap (`gameplay/Worldmap`)
        - TitleState (`menus/TitleState`)
        - Stage1 (`gameplay/MainMenu`)
        - Stage4 (`gameplay/MainMenu`)
        - Credits (`submenus/Credits`)
        - Settings (`submenus/Settings`)
        - Results (`gamplay/Results`)
- Added [tutorial elements to stage 1 and 4](#14_link)

## 0.1.1a - 2/22/2025
### Fixed
- Fixed crash on web when trying to take a screenshot ([#16][#16_link])
- Fixed when returning to the world map from a portilizen level the character wheel is on the sinco selection ([#11][#11_link])
- Fixed no sound in stage 4 ([#12][#12_link])
- Fixed volume being at 100% on desktop is 99.99...% on web ([#10][#10_link])

## 0.1.0a (Destination 1 - Osin & Dimension String)  - 2/22/2025
### Added
- Added Results menu on death for stage 1
### Fixed
- Fixed HTML5 crashing when beating a level
- Fixed bug where in stage 1 the Results menu wouldn't adapt to the players max health.
- Fixed bug where in stage 1 and 4 the opponent wont attack once replaying the level ([#8][#8_link])
- Fixed bug where in stage 4 there is no results screen ([#9][#9_link])
- Fixed bug where in stage 4 the timer stays the same as it last was ([#7][#7_link])
### Changed
- Changed Results menu so the music stops when you leave
- Changed Company name in `project.xml` to `SAPTeam`

# Prototype
## 0.0.8-p - 2/22/2025
### Added
- Settings menu
- Language Setting
- Volume Setting
- Window resolution Setting (neko, windows, linux and mac only)
### Removed
- Translations folder

## 0.0.7-p - 2/19/2025
This update adds a `Build.py` file that helps with compiling :)

### Changed
- Changed the following custom BUILD_DIR conditions to no longer depend on being a release build for their directory to take place unless specified by `DEFAULT_DIRECTORY`
        - MASS_MOD
        - FORCED_ENGLISH_LANGUAGE
        - SPANISH_LANGUAGE
        - PORTUGUESE_LANGUAGE
- Changed it so credits alignment is now center
- Changed Results percent text to be opaque
### Fixed
- Fixed Djotta flow credits exitting screen bounds
### Added
- Readded Translations (they are back and now they work on windows!)
        - Added Translations for Credits
- Added new Build directories

## 0.0.6-p - 2/18/2025
This update fixes crashes on 0.0.5-p with no additional content.

### Fixed
- [Fixed game crashing on launch][#6_link]
### Removed
- Translations (cause of [crash][#6_link])

## 0.0.5-p - 2/15/2025
### Removed
- Removed "Press any" alpha fade in
### Added
- Added Indicator for when Osin is going to attack (Stage 1)
- [Added Localization][#4_link]
        - Added Build flags for Localization
        - Added Spanish Translation (Google Translate)
        - Added Portuguese Translation (by Djotta Flow)
        - Added Localized Assets for images with text (for both languages)
        - Added `cur_lang.txt` file that can control the language thats set (gets overwritten by build flags)
        - Added BUILD_DIRs for the different languages
- [Added `.bat` files for compiling (some for different languages too!)][#4_link]
- [Added source code mod support through a plugin-like system][#5_link]
        - Added Mass mod (modifies every state that can be changed)
### Changed
- [Changed the Sound Tray][#3_link]
- [Changed almost every state's custom functions to be `public static dynamic` functions (Source Code Mod Support)][#5_link]

## 0.0.4-p - 2/14/2025
### Changed
- Changed system for levels beat
- Changed savedata `level` to `levels_completed`
- Changed Screenshot plugin to now be the FNF Screenshot Plugin (same keybind, its just based of funkin to fix a bug)
### Added
- Added countdown text to Stage 4
- Added HMM file
- Added Results State
- Added Several Build Flags
- Added Discord RPC
- Added [Build Flags markdown file](/compiling/BUILD%20FLAGS.md)
- [Added Credits Menu][#2_link]
### Removed
- Removed unused data files
- Removed Chaos Emeralds (Gameplay and code)
### Fixed
- Fixed bug where DISABLE_PLUGINS enables plugins
- Fixed bug where the screenshot [didnt do things](/random/screenshotplugin-before.png) it [should've been doing](/random/screenshotplugin-after.png)
- Fixed bug where you couldn't select the level you're on after you swap in the Worldmap

## 0.0.3-p - 2/13/2025
- Gameplay changes
        - Added screenshot plugin (you can take a screenshot with F2 unless in debug, you do F1)
        - Added stage 4 winning condition (you have to survive the level for a minute)
        - We are now in the prototype era officially
- Code changes:
        - Modified `Global.setEmeraldAmount()` function
        - Moved every folder that is sap specific to the new sap folder
        - Moved Debug build and Game version traces to the project xml
        - Added echo for build/test targets
        - Added ability to enable and disable annoying errors and warnings
        - Added compiler error for mobile
                - Compiling for mobile doesnt work
        - `FileManager_v8` now has been replaced with `Sinlib`'s `FileManager` (basically the same though)
        - Now using 8 tabs instead of like 2 or 4 spaces or smth?
        - In the code I have this little code style I've started implementing:
                - Don't leave unused imports in the code
                - Code shouldnt be more than 4 tabs long unless optimizing wouldn't do much.

## 0.0.2-p - 2/6/2025
- Added post-stage 1 cutscene
- Added title screen version text
- Worldmap Changes:
        - Added character wheel to worldmap
                - Added Portilizen world map character
                - Map now reloads when you swap
        - Added "Background" to the Worldmap
        - Worldmap tiles are now dark for levels that are not implemented
        - Worldmap tiles with unimplemented levels dont send you to the Mainmenu when you try and play them anymore
- Added Stage 4 (Portilizens first level)

## 0.0.1-p - 2/2/2025
CURRENT FEATURES:
- Title Screen
- Main Menu
- Intro Cutscene
- World map
- Stage 1 (Sinco)

[#2_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/pull/2
[#3_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/pull/3
[#4_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/pull/4
[#5_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/pull/5
[#6_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/6
[#7_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/7
[#8_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/8
[#9_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/9
[#10_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/10
[#11_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/11
[#12_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/12
[#14_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/14
[#16_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/16
[#18_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/18
[#19_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/19
[#23_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/23
[#27_link]: https://github.com/sphis-Sinco/SincoAndPortilizen/issues/27