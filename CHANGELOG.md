# 0.0.3 - 2/?/2025
- Gameplay changes
        - Added screenshot plugin (you can take a screenshot with F2 unless in debug, you do F1)
        - Added stage 4 winning condition (you have to survive the level for a minute)
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
                - 

# 0.0.2 - 2/6/2025
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

# 0.0.1 - 2/2/2025
CURRENT FEATURES:
- Title Screen
- Main Menu
- Intro Cutscene
- World map
- Stage 1 (Sinco)