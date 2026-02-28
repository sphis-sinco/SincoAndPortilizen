# Beta

## 4.0.1 - 8/20/2025

### Fixed

- Button sizes on web builds

## 4b (Beta Milestone 5) - 8/20/2025

Mobile update:
This update adds _support_ for mobile devices (idk about iOS but android works defenitely). But the mobile compiled build isn't on the itch.io page

### New Contributors

- @wonderinglostsoul44 made their first contribution in https://github.com/sphis-sinco/SincoAndPortilizen/pull/45

### Removed

- Error message related to compiling on mobile

### Fixed

- Bullets in Tres will no longer move when the game is paused
- The clear save screen confirmation text has the correct intended alignment
- When leaving the Clear Save Screen you can now see the message

### Changed

- The default app icon is the 512x app icon
- The instructions for swapping are removed on mobile for Tres
- On mobile in Tres the player moves differently
- You can tap the screen to jump in Osin
- You can press and hold the screen (moving your finger OR MOUSE) to move in String Quest
- On mobile "Tres" will have the T-DM2 firing more bullets
- On mobile "Osin" will have osin firing a max of 10 "bullets"
- On mobile "String Quest" will have 10 enemies and 6 _can_ be attacking at once
- On mobile "String Quest" will have a bridge-like floor
- You can tap the screen to leave the outdated screen
- More accurate range to pet Sinco
- All the functions and variables in the credits state are no longer static functions and or variables
- Improved Global.hx by @wonderinglostsoul44 in https://github.com/sphis-sinco/SincoAndPortilizen/pull/45
- You can swipe to scroll on the credits
- When leaving the Clear Save Screen the confirmation text fades out
- When leaving the Clear Save Screen all buttons fade out
- Several UI elements are made bigger on mobile
- `Global.dummyBG` will now generate a background that fits the window resolution

### Added

- Mobile support
- `InteractableSpr` class so that interactable sprite buttons are easier
- `MOBILE_TESTING` define
- `MOBILE_BUILD` define

## 3.1.2b (desktop-only) - 8/20/2025

### Fixed

- Null Access crash on desktop builds related to the `SAVESLOT_SUFFIX` define

## 3.1.1b (web-only) - 8/20/2025

### Fixed

- Crash related to the `SAVESLOT_SUFFIX` define

## 3.1b - 8/19/2025

### Fixed

- When entering the clear save screen the description text will fade out too
- When entering the clear save screen you can no longer press the clear save button
- When leaving the clear save screen the cursor will no longer change (if the proper condition was met)

### Changed

- Leaving the settings menu will send you to the title screen
- Leaving the credits menu will send you to the title screen
- The credits button has been moved to the title screen
- The console in the Level Select will no longer send you to the settings menu

### Added

- `SAVESLOT_SUFFIX=` build define
- Title Screen

## 3b (Beta Milestone 4) - 8/19/2025

### Added

- Levels can now have a custom hover color defined in their json file
- Levels can now have a custom color defined in their json file
- **NEW OST TRACK: TRES**
- **LEVEL 3: TRES**

### Fixed

- The volume setting is made up-to-date with the actual volume value
- Crashes on web related to save data
- The default flixel cursor is no longer seen in the splash screen

## 2b (Beta Milestone 3) - 8/19/2025

### Removed

- Tweening for the Winged Enemy in Level 1

### Fixed

- Volume 10000
- Issues with reading the `build` file on desktop platforms
- Settings menu will now properly allow the menu music to loop in the background
- Fixed all timers and tweens being disabled when going back to the level select after pausing in a level

### Added

- Splash Screen
- Clear Save Setting
- **LEVEL 2: OSIN**
- Credits menu
- Different cursors for Sinco and Port for the settings menu
- Volume Setting (how the hell did I forget this?)
- A crown is added to the level cards when the level's been beat
- `volume` argument (back) to `Global.playSoundEffect`
- Pet sounds for Sinco and Portilizen
- 2 new pet "animations" for Sinco and Portilizen on the Level Select for when they are/aren't picked

### Changed

- Your save is now flushed when the window is exitted.
- Updated App Icons
- In debug builds the `build` file is changed along with the `build` file in the source-code
- Slightly bigger region for clicking on port and sinco to pet them
- shifted level icons over to the left by a few pixels

## 1b (Beta Milestone 2) - 8/18/2025

Game remade from the (almost) ground up
**This version clears your save. Sorry, the Save data merge from previous versions was crashing the game**

### Removed

- All levels entirely from the game except for String Quest and Osin, though only String Quest is playable right now

### Changed

- Discord RPC says "Ready" when ready instead of "Starting the Game"
- The Game Version text file is included in compiled builds now
- Hitboxes are updated automatically when scaled using `Global.scaleSprite`

### Added

- Build file and build number, currently at 16 (this is just a random one cuz I've seen too many videos on windows development and the build numbers interested me)
- Overhauled String Quest Level
- Overhauled Level Select
- Decimal scale offsets for `Global.scaleSprite`

## 0.1.1b - 7/2/2025

### Added

- New build flags
- Pause menu artwork
- **Stage 5 OST Song: Family Rivalry**
- New preloader art

### Removed

- Web build

### Fixed

- Mainmenu changelog option sending you to the main menu when the mod option is gone
- "The OC of today" Medal unlock condition (was flipped basically and I'm going insane)

## 0.1_01b - 7/1/2025

### Changed

- When the `spanish` locale is enabled, the mainmenu texts chage size

### Fixed

- Clear save crash on web (Issue #41)
- Incorrect sizing on mainmenu option box (Issue #40)
- Missing locale changes for "mods" and "changelog" in the main menu (Issue #39)
- Medal text doesn't change when a locale does (Issue #38 / #40)

## 0.1b (Pitstop 3 - Sidebit 2) - 7/1/2025

### Added

- **Sidebit 2**
- Preloader artwork (easy to add more on desktop, and if you don't want antialiasing add "-px" to the end of the filename)
- Asset preloading
- SongPlayer class
     - When a song plays if there is a json then a text will display with song
     - I call this the SPJC system
- **Stage 1 OST Song: Like Brothers (Extreme)**
- Spanish and Portuguese translations for the "download latest traces" option
- **Level pausing (Issue #15)**
- "Clear save" option in the settings menu
- **Stage 4 OST Song: Inner Hardware**
- **Stage 1 OST Song: Like Brothers**
- CHANGELOG_MENU Build flag
- **Changelog Menu**

### Removed

- Unused texture atlas for the stage1 background
- MASS MOD mentions
- Intro Cutscene

### Changed

- `getScriptArray` has been turned into `getTypeArray` in FileManager and can support any type now. (`getTypeArray`)
- The stage 5 timer text is black now for visability
- Music tracks are now apart of the SPJC system
- SparrowSprites have antialiasing set to enabled by default now
- Sidebit 1 post-cutscene
- Sidebit 1 pre-cutscene is a sparrow cutscene
- Adjusted time when you can't attack Osin in stage 1
- Mods no longer are enabled by default when loaded
- Mod API version is 1.5 - FileManager has `getTypeArray` which is `getScriptArray` but with **any type** - Global has a previousState variable - Version is a valid variable
- The main menu music 22 has been replaced with Lado.
- Beta changelog format
- The changelog has been split for every section of production
- FileManager's writeToPath function has been improved
- Version system is now the same as Creative
- (Desktop only) Version system is softcoded
- Locale system

### Fixed

- When going to the worldmap, portilization levels use the right character json
- When reseting stages 1, and 4 the jump variables should be initalized
- Sidebit 1 cutscenes
- "The OC of today" Medal unlock condition (was flipped basically)
- (Web only) Worldmap crash when switching to Sidebit mode
