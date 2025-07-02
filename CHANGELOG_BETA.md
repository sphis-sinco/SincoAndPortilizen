# Beta
## Unreleased
- Stage 5 OST Song: Family Rivalry
- Stage 2 OST Song: Teen Prodigy
<version>

## 0.1.1b - 7/1/2025
### Added
- **Newgrounds Login/Logout**
### Fixed
- "The OC of today" Medal unlock condition (was flipped basically and I'm going insane)

<version>

## 0.1_01b - 7/1/2025
### Changed
- When the `spanish` locale is enabled, the mainmenu texts chage size
### Fixed
- Clear save crash on web (Issue #41)
- Incorrect sizing on mainmenu option box (Issue #40)
- Missing locale changes for "mods" and "changelog" in the main menu (Issue #39)
- Medal text doesn't change when a locale does (Issue #38 / #40)

<version>

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
- Mod API version is 1.5
        - FileManager has `getTypeArray` which is `getScriptArray` but with **any type**
        - Global has a previousState variable
        - Version is a valid variable
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