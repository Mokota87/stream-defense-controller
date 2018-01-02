# stream-defense-controller

SDC is an interface for the twitch stream game "Stream Defense" (https://www.twitch.tv/archonthewizard)
It is NOT a bot or anything like that. It only assists you playing the game via buttons instead of typeing the chat commands.
Neither has the developer of this interface anything to do with the development of the game itself, nor has the developer of the game anything to do with the development of this interface.
Please visit http://www.se-development.com/ttdc for further explanations.

# Version History

## v.1.0:
* Main build

## v.1.01:
* Updated mana consumption of priest spells. 
* Some little design changes.
* Now it automatically selects the strength buff when you open the highpriest window.
* New shortkeys for the highpriest window. You can now switch between the buffs with 1 2 and 3.
* New target window with all target functions. The target buttons stay pressed so you can always see the actual mode.
* The commands !stats and !unlocks are now implemented as buttons.

## v.1.02:
* Faster typing of the commands.
* Reworked command system so hopefully no more missing letters.
* Frames around some buttons for better visual grouping.
* The endnumbers (to overgo chat spambot) for highpriest now always start with 1 at a new command type.
* No new setup needed. Your configurations (window positions etc.) will stay.
* New button design for the class window.
* Shrinked all raw button graphics to the needed size.

## v.1.03:
* IRC integration (thanks to klrpatrickstar).
* Profile system, so you can now play with different or multiple twitch accounts :)
Just start SDC multiple times and choose different profiles to multibox.
(Configurations needed to be resettet because of the new system.)
* Bugfix: Assassin got a missing "s" back.
* Some little design changes.

## v.1.04:
* Changed the name from 'Twitch Tower Defense Controller' (TTDC) to Stream Defense Controller (SDC).
* You can now load multiple profiles into one window. So you can control several accounts with one interface.
* When you load multiple profiles into one interface you can select/deselect your caracters via buttons. So you can still perform
commands only with specific characters. Leftclick=Select/Deselect - Rightclick=Only select the button you clicked on.
* Slightly changed the tower button graphics for better contrast.
* Updated the texts of the buff buttons to mach the game changes.
* Added a reconnect button in the settings window to reconnect to twitch-chat when you lost connection. So you dont have to restart SDC.
* Combined the status buttons "!gold", "!stats" and "!unlocks" to a questionmark button which opens a popup dialogue.
* Added the new command "!highscores" to this popup-dialogue
* New command-window (activatable in the settings). When this window is open, all buttons will send the commands into a text field on this new window
instead of posting the commands directly to the chat. So you can insert multiple commands in one line and decide yourself when to post them.
There's also a checkbox which will activate posting all commands in this text field automatically after X milliseconds.

## v.1.05:
* Changed to Unicode formate
* Bugfix: Crash when profile was changed via the "Profiles" button.
* Some small code changes

# Pure Pasic Version

PB v.5.42 LTS