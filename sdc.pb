;**************************************************************
;     STREAM DEFENSE CONTROLLER v.1.06 by Stefan Elser - www.se-development.com - email: support@se-development.com
;     Copyright (c) 2017 Stefan Elser
;**************************************************************

Global version.s = "1.06"

Procedure Createprogramdirectory(folder.s,searchdir.s,savedir.s,name.s)
Define existing.b
If ExamineDirectory(0,folder + searchdir, "*.*")  
  While NextDirectoryEntry(0)
    If DirectoryEntryName(0) = name
      existing=1
    EndIf
  Wend
  FinishDirectory(0)
EndIf
If existing=0
  If CreateDirectory(folder + savedir + name)=0
    MessageRequester("ERROR","COULDN'T CREATE THE FOLDER: " + folder + savedir + name)
    End
  EndIf
EndIf
EndProcedure
Procedure Createprogramfile(folder.s,searchdir.s,savedir.s,name.s,sourcefile.s)
Define existing.b
If ExamineDirectory(0,folder + searchdir, "*.*")  
  While NextDirectoryEntry(0)
    If DirectoryEntryName(0) = name
      existing=1
    EndIf
  Wend
  FinishDirectory(0)
EndIf
If existing=0
  If CopyFile(sourcefile ,folder + savedir + name)=0
    MessageRequester("ERROR","COULDN'T COPY: '"+ sourcefile + "' TO THE DIRECTORY: '"+ folder + savedir + name)
    End
  EndIf
EndIf
EndProcedure
Createprogramdirectory(GetEnvironmentVariable("APPDATA") + "\","","","SE-Development")
Createprogramdirectory(GetEnvironmentVariable("APPDATA") + "\","SE-Development","SE-Development\","SDC")
Createprogramdirectory(GetEnvironmentVariable("APPDATA") + "\","SE-Development\SDC","SE-Development\SDC\","v."+version)

;CHECK IF OLD CONFIG.TXT IS EXISTING:
Define takeconfig.i=0

If ExamineDirectory(1,GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v.1.05\", "*.*")  
  While NextDirectoryEntry(1)
    If DirectoryEntryType(1) = #PB_DirectoryEntry_File
      If Len(DirectoryEntryName(1)) > 2
        Createprogramfile(GetEnvironmentVariable("APPDATA") + "\","SE-Development\SDC\v."+version,"SE-Development\SDC\v."+version+"\",DirectoryEntryName(1),GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v.1.05\"+DirectoryEntryName(1))
        Delay(60)
        DeleteFile(GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v.1.05\"+DirectoryEntryName(1))
        Delay(30)
        takeconfig=1
      EndIf
    EndIf
  Wend
  FinishDirectory(1)
EndIf
If takeconfig=0
  If ExamineDirectory(1,GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v.1.04\", "*.*")  
    While NextDirectoryEntry(1)
      If DirectoryEntryType(1) = #PB_DirectoryEntry_File
        If Len(DirectoryEntryName(1)) > 2
          Createprogramfile(GetEnvironmentVariable("APPDATA") + "\","SE-Development\SDC\v."+version,"SE-Development\SDC\v."+version+"\",DirectoryEntryName(1),GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v.1.04\"+DirectoryEntryName(1))
          Delay(60)
          DeleteFile(GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v.1.04\"+DirectoryEntryName(1))
          Delay(30)
          takeconfig=1
        EndIf
      EndIf
    Wend
    FinishDirectory(1)
  EndIf  
EndIf
If takeconfig=0
  If ExamineDirectory(1,GetEnvironmentVariable("APPDATA") + "\SE-Development\TTDC\v.1.03\", "*.*")  
     While NextDirectoryEntry(1)
       If DirectoryEntryType(1) = #PB_DirectoryEntry_File
         If Len(DirectoryEntryName(1)) > 2
           Createprogramfile(GetEnvironmentVariable("APPDATA") + "\","SE-Development\SDC\v."+version,"SE-Development\SDC\v."+version+"\",DirectoryEntryName(1),GetEnvironmentVariable("APPDATA") + "\SE-Development\TTDC\v.1.03\"+DirectoryEntryName(1))
           Delay(60)
           DeleteFile(GetEnvironmentVariable("APPDATA") + "\SE-Development\TTDC\v.1.03\"+DirectoryEntryName(1))
           Delay(30)
         EndIf
       EndIf
     Wend
     FinishDirectory(1)
   EndIf
 EndIf
 

;***********************************
;VARIABLE DECLARATION
;***********************************
InitMouse()
XIncludeFile "IRC.pb"
Global commandnr.i=0
Global lastcommand.s=""
Global Quit.b=0
Global time.i=0
Global Dim activeprofile.s(10)
Global Dim activeauth.s(10)
Global loadedprofiles.i=0
Global Dim activechar.i(10)
Global Dim config.s(19)


;***********************************
;GADGET AND WINDOW ENUMARATION
;***********************************
Enumeration ;WINDOWS
  #WINDOW_profiles
  #WINDOW_main
  #WINDOW_classes
  #WINDOW_shop
  #WINDOW_priestcast
  #WINDOW_settings
  #WINDOW_target
  #WINDOW_command
EndEnumeration
Enumeration ;GADGETS
  
  ;Mainwindow
  #GADGET_BUTTON_1
  #GADGET_BUTTON_2
  #GADGET_BUTTON_3
  #GADGET_BUTTON_4
  #GADGET_BUTTON_5
  #GADGET_BUTTON_6
  #GADGET_BUTTON_7
  #GADGET_BUTTON_8
  #GADGET_BUTTON_9
  #GADGET_BUTTON_10
  #GADGET_BUTTON_11
  #GADGET_BUTTON_12
  #GADGET_BUTTON_train
  #GADGET_BUTTON_p
  #GADGET_BUTTON_pd
  #GADGET_BUTTON_altar
  #GADGET_FRAME_rahmen
  #GADGET_BUTTON_classes
  #GADGET_BUTTON_shop
  #GADGET_BUTTON_leave
  #GADGET_BUTTON_priestcast
  #GADGET_BUTTON_settings
  #GADGET_BUTTON_target
  #GADGET_BUTTON_profiles
  #GADGET_BUTTON_status
  
  ;Classes
  #GADGET_BUTTON_alchemist
  #GADGET_BUTTON_archer
  #GADGET_BUTTON_frostmage
  #GADGET_BUTTON_firemage
  #GADGET_BUTTON_rogue
  #GADGET_BUTTON_bard
  #GADGET_BUTTON_ninja
  #GADGET_BUTTON_necromancer
  #GADGET_BUTTON_sniper
  #GADGET_BUTTON_trickster
  #GADGET_BUTTON_stormmage
  #GADGET_BUTTON_mimic
  #GADGET_BUTTON_deathdealer
  #GADGET_BUTTON_falconeer
  #GADGET_BUTTON_pyromancer
  #GADGET_BUTTON_assasin
  #GADGET_BUTTON_highpriest
  #GADGET_BUTTON_bombermage
  #GADGET_BUTTON_scout
  #GADGET_BUTTON_lightningmage
  
  ;Shop
  #GADGET_FRAME_classes
  #GADGET_FRAME_highpriestspells
  #GADGET_FRAME_gem
  
  #GADGET_BUTTON_buybowman
  #GADGET_BUTTON_buysniper
  #GADGET_BUTTON_buyfalconeer
  
  #GADGET_BUTTON_buyknife
  #GADGET_BUTTON_buyassassin
  #GADGET_BUTTON_buyninja

  #GADGET_BUTTON_buypyromancer
  #GADGET_BUTTON_buybombermage
  #GADGET_BUTTON_buylightningmage
  
  #GADGET_BUTTON_buyicemage
  #GADGET_BUTTON_buytrickster
  #GADGET_BUTTON_buystormmage
  #GADGET_BUTTON_buyshockmage
  
  #GADGET_BUTTON_buyplaguedoctor
  #GADGET_BUTTON_buydeathdealer
  #GADGET_BUTTON_buynecromancer
  #GADGET_BUTTON_buypotionmaster
  
  #GADGET_BUTTON_buymistrel
  #GADGET_BUTTON_buymimic
  #GADGET_BUTTON_buyscout
   
  #GADGET_BUTTON_buyhaste
  #GADGET_BUTTON_buyfocus
  #GADGET_BUTTON_buypower
  #GADGET_BUTTON_buyshield
  #GADGET_BUTTON_buymeditate
  #GADGET_BUTTON_buyarm
  
  #GADGET_BUTTON_socketruby
  #GADGET_BUTTON_socketemerald
  #GADGET_BUTTON_socketcitrine
  #GADGET_BUTTON_socketonyx
  
  ;Priestcast
  #GADGET_FRAME_buffs
  #GADGET_FRAME_spells
  #GADGET_BUTTON_boosttraining
  #GADGET_BUTTON_boostdamage
  #GADGET_BUTTON_boostfreeze
  #GADGET_BUTTON_haste
  #GADGET_BUTTON_shield
  #GADGET_BUTTON_boostpower
  #GADGET_BUTTON_boostrange
  #GADGET_BUTTON_boostmeditate
  #GADGET_BUTTON_boostarmy
    
  ;Settings
  #GADGET_CHECKBOX_autoclose
  #GADGET_CHECKBOX_command
  #GADGET_BUTTON_reconnect
  
  ;Target
  #GADGET_FRAME_mode
  #GADGET_BUTTON_targetdefault
  #GADGET_BUTTON_targetfront
  #GADGET_BUTTON_targetclosest
  #GADGET_BUTTON_targethighest
  #GADGET_BUTTON_targetlowest
  #GADGET_FRAME_lock
  #GADGET_BUTTON_targetlockon
  #GADGET_BUTTON_targetlockoff
  
  ;Profiles
  #GADGET_PROFILES_CANVAS_header
  #GADGET_PROFILES_FRAME_rahmen
  #GADGET_PROFILES_LIST_list
  #GADGET_PROFILES_BUTTON_add
  #GADGET_PROFILES_BUTTON_delete
  #GADGET_PROFILES_FRAME_edit
  #GADGET_PROFILES_TEXT_name
  #GADGET_PROFILES_TEXT_auth
  #GADGET_PROFILES_STRING_name
  #GADGET_PROFILES_STRING_auth
  #GADGET_PROFILES_BUTTON_auth
  #GADGET_PROFILES_BUTTON_load
  #GADGET_PROFILES_CANVAS_bar
  
  ;Command
  #GADGET_STRING_Command
  #GADGET_BUTTON_Command
  #GADGET_CHECKBOX_Commandautosend
  #GADGET_SPIN_Commandautosend
  #GADGET_PROGRESS_command
EndEnumeration


;******************************************
;LOAD IMAGES
;******************************************
UsePNGImageDecoder()
LoadImage(0,"data\button_red.png")
LoadImage(1,"data\button_blue.png")
LoadImage(2,"data\button_yellow.png")
LoadImage(3,"data\button_default.png")
LoadImage(4,"data\button_train.png")
LoadImage(5,"data\button_p.png")
LoadImage(6,"data\button_pd.png")
LoadImage(7,"data\button_class.png")
LoadImage(8,"data\star_blue.png")
LoadImage(9,"data\star_red.png")
LoadImage(10,"data\star_green.png")
LoadImage(11,"data\star_white.png")
LoadImage(12,"data\star_black.png")
LoadImage(13,"data\star_yellow.png")
LoadImage(14,"data\header_window.png")
LoadImage(15,"data\button_charselection.png")
LoadImage(16,"data\button_charselection_selected.png")
LoadImage(17,"data\button_charselection_empty.png")
LoadImage(18,"data\button_altar.png")


;******************************************
;LOAD FONTS
;******************************************
If LoadFont(0, "Impact", 17)=0
  MessageBeep_(#MB_ICONHAND)
  MessageRequester("ERROR","Couldn't load the font 'Impact - Size 17'")
  End
EndIf
If LoadFont(1, "Arial Black", 7,#PB_Font_Bold)=0
  MessageBeep_(#MB_ICONHAND)
  MessageRequester("ERROR","Couldn't load the font 'Arial Black - Size 7 - Bold'")
  End
EndIf
If LoadFont(2, "Arial", 8, #PB_Font_Bold)=0
  MessageBeep_(#MB_ICONHAND)
  MessageRequester("ERROR","Couldn't load the font 'Arial - Size 8 - Bold'")
  End
EndIf
If LoadFont(3, "Arial Black",8, #PB_Font_Bold)=0
  MessageBeep_(#MB_ICONHAND)
  MessageRequester("ERROR","Couldn't load the font 'Arial Black - Size 8 - Bold'")
  End
EndIf


;******************************************
;LOAD AND SAVE CONFIGURATION/PROFILE
;******************************************
Procedure loadconfig(profilename.s)
a=0
If ReadFile(0, GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v."+version+"\"+profilename+".txt")
  ReadStringFormat(0)
  While Eof(0) = 0
    config(a) = ReadString(0)
    a+1
  Wend
  CloseFile(0)
Else
  MessageBeep_(#MB_ICONHAND)
  MessageRequester("ERROR","Couldn't find: "+GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v."+version+"\"+profilename+".txt")
  End
EndIf
EndProcedure

Procedure saveconfig()
 If CreateFile(0, GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v."+version+"\"+activeprofile(loadedprofiles-1)+".txt")
   WriteStringFormat(0, #PB_UTF8 )
   WriteStringN(0, Str(WindowX(#WINDOW_main)))
   WriteStringN(0, Str(WindowY(#WINDOW_main)))
   WriteStringN(0, Str(WindowX(#WINDOW_classes)))
   WriteStringN(0, Str(WindowY(#WINDOW_classes)))
   WriteStringN(0, Str(WindowX(#WINDOW_shop)))
   WriteStringN(0, Str(WindowY(#WINDOW_shop)))
   WriteStringN(0, Str(WindowX(#WINDOW_priestcast)))
   WriteStringN(0, Str(WindowY(#WINDOW_priestcast)))
   WriteStringN(0, Str(WindowX(#WINDOW_settings)))
   WriteStringN(0, Str(WindowY(#WINDOW_settings)))
   WriteStringN(0, Str(GetGadgetState(#GADGET_CHECKBOX_autoclose)))
   WriteStringN(0, Str(WindowX(#WINDOW_target)))
   WriteStringN(0, Str(WindowY(#WINDOW_target)))
   WriteStringN(0, activeauth(loadedprofiles-1))
   WriteStringN(0, Str(GetGadgetState(#GADGET_CHECKBOX_command)))
   WriteStringN(0, Str(WindowX(#WINDOW_command)))
   WriteStringN(0, Str(WindowY(#WINDOW_command)))
   WriteStringN(0, Str(GetGadgetState(#GADGET_CHECKBOX_Commandautosend)))
   WriteString(0, Str(GetGadgetState(#GADGET_SPIN_Commandautosend)))
   CloseFile(0)
 Else
   MessageBeep_(#MB_ICONHAND)
   MessageRequester("ERROR","Couldn't save the configuration")
   End
 EndIf
EndProcedure


;******************************************
;PROFILE WINDOW
;******************************************
Profiles:
OpenWindow(#WINDOW_profiles,0,0,300,407,"Profiles", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
StickyWindow(#WINDOW_profiles,1)
CanvasGadget(#GADGET_PROFILES_CANVAS_header,0,0,WindowWidth(#WINDOW_profiles),ImageHeight(14)+6)
 AusgabeID = CanvasOutput(#GADGET_PROFILES_CANVAS_header)
 Ergebnis = StartDrawing(AusgabeID)
 Box(0,0,GadgetWidth(#GADGET_PROFILES_CANVAS_header),GadgetHeight(#GADGET_PROFILES_CANVAS_header),RGB(0,0,0))
 DrawImage(ImageID(14), 3, 3 ,GadgetWidth(#GADGET_PROFILES_CANVAS_header)-6,GadgetHeight(#GADGET_PROFILES_CANVAS_header)-6)
 DrawingFont(FontID(0))
 DrawingMode(#PB_2DDrawing_Transparent)
 DrawText(105,10,"PROFILES",RGB(170,170,230))
 StopDrawing()

FrameGadget(#GADGET_PROFILES_FRAME_rahmen,5,55,290,227,"Profiles (doubleclick to open)")
SetGadgetFont(#GADGET_PROFILES_FRAME_rahmen,FontID(1))
ListIconGadget(#GADGET_PROFILES_LIST_list,15,72,270,175,"NAME",265,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_MultiSelect)
ButtonGadget(#GADGET_PROFILES_BUTTON_delete,15,GadgetY(#GADGET_PROFILES_LIST_list)+GadgetHeight(#GADGET_PROFILES_LIST_list)+6,130,22,"Delete selected")
ButtonGadget(#GADGET_PROFILES_BUTTON_load,WindowWidth(#WINDOW_profiles)-145,GadgetY(#GADGET_PROFILES_LIST_list)+GadgetHeight(#GADGET_PROFILES_LIST_list)+6,130,22,"Load selected")

CanvasGadget(#GADGET_PROFILES_CANVAS_bar,0,291,WindowWidth(#WINDOW_profiles),2)
 AusgabeID = CanvasOutput(#GADGET_PROFILES_CANVAS_bar)
 Ergebnis = StartDrawing(AusgabeID)
 Box(0,0,GadgetWidth(#GADGET_PROFILES_CANVAS_bar),GadgetHeight(#GADGET_PROFILES_CANVAS_bar),RGB(40,40,40))
 StopDrawing()

FrameGadget(#GADGET_PROFILES_FRAME_edit,5,300,290,104,"Create Profile")
SetGadgetFont(#GADGET_PROFILES_FRAME_edit,FontID(1))

TextGadget(#GADGET_PROFILES_TEXT_name,15,321,75,20,"Twitch Name:")
TextGadget(#GADGET_PROFILES_TEXT_auth,15,351,75,20,"Authentication:")
StringGadget(#GADGET_PROFILES_STRING_name,90,318,195,20,"YourTwitchName")
StringGadget(#GADGET_PROFILES_STRING_auth,90,348,110,20,"",#PB_String_Password)


ButtonGadget(#GADGET_PROFILES_BUTTON_add,(WindowWidth(#WINDOW_profiles)/2)-70,WindowHeight(#WINDOW_profiles)-30,140,22,"Create profile")

ButtonGadget(#GADGET_PROFILES_BUTTON_auth,205,347,80,21,"Authentication?")

Procedure RefreshProfilesload()
Protected.i a
Protected.s name

ClearGadgetItems(#GADGET_PROFILES_LIST_list) 
 If ExamineDirectory(1, GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v."+version+"\", "*.*")
   While NextDirectoryEntry(1)
     If DirectoryEntryType(1) = #PB_DirectoryEntry_File
       If Len(DirectoryEntryName(1))>2
         name=DirectoryEntryName(1)
         While CountString(name,".txt")>0
           name=RemoveString(name, ".txt", #PB_String_NoCase)
         Wend
         AddGadgetItem(#GADGET_PROFILES_LIST_list, a, name)
         a+1
       EndIf
     EndIf
   Wend
   FinishDirectory(1)
 EndIf
EndProcedure
RefreshProfilesload()

Repeat
  EventID = WaitWindowEvent()
  Select EventID
    Case #PB_Event_Gadget:
      Select EventGadget()
        Case #GADGET_PROFILES_BUTTON_add
          If CountGadgetItems(#GADGET_PROFILES_LIST_list)<10
          If Len(GetGadgetText(#GADGET_PROFILES_STRING_name))>2
            If Len(GetGadgetText(#GADGET_PROFILES_STRING_auth))>2
            If CreateFile(0, GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v."+version+"\"+GetGadgetText(#GADGET_PROFILES_STRING_name)+".txt")
              WriteStringFormat(0, #PB_UTF8 )
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, "1")
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteStringN(0, GetGadgetText(#GADGET_PROFILES_STRING_auth))
              WriteStringN(0, "0")
              WriteStringN(0, "0")
              WriteString(0, "500")
              CloseFile(0)
            Else
              MessageBeep_(#MB_ICONHAND)
              MessageRequester("ERROR","Couldn't save the configuration")
              End
            EndIf
            Delay(100)
            RefreshProfilesload()
            EndIf
          EndIf
          EndIf
        Case #GADGET_PROFILES_LIST_list
            If EventType()=#PB_EventType_LeftDoubleClick
              If GetGadgetState(#GADGET_PROFILES_LIST_list)>-1
                                
                loadconfig(GetGadgetItemText(#GADGET_PROFILES_LIST_list,GetGadgetState(#GADGET_PROFILES_LIST_list),0))
                activeprofile(0) = GetGadgetItemText(#GADGET_PROFILES_LIST_list,GetGadgetState(#GADGET_PROFILES_LIST_list),0)
                activeauth(0) = config(13)
                
                IRC::Init()
                IRC::Connect(0)
                IRC::Login(0,activeprofile(0), activeauth(0))
                IRC::Join(0)
                
                loadedprofiles=1
                Delay(1000)
                Quit=1
              EndIf
            EndIf
        Case #GADGET_PROFILES_BUTTON_load
            loadedprofiles=0
            If GetGadgetState(#GADGET_PROFILES_LIST_list)>-1
              IRC::Init()
              For a=0 To CountGadgetItems(#GADGET_PROFILES_LIST_list)-1
                If loadedprofiles<3
                  If GetGadgetItemState(#GADGET_PROFILES_LIST_list,a)=1 
                    loadconfig(GetGadgetItemText(#GADGET_PROFILES_LIST_list,a,0))
                    activeprofile(loadedprofiles) = GetGadgetItemText(#GADGET_PROFILES_LIST_list,a,0)
                    activeauth(loadedprofiles) = config(13)
                  
                    IRC::Connect(loadedprofiles)
                    IRC::Login(loadedprofiles,activeprofile(loadedprofiles), activeauth(loadedprofiles))
                    IRC::Join(loadedprofiles)
                    Debug(Str(a)+"="+activeprofile(loadedprofiles)+" "+activeauth(loadedprofiles))
                  
                    loadedprofiles+1
                    Delay(1000)
                  EndIf
                Else
                  MessageRequester("WARNING","You tried to load more than 3 profiles. Sorry, but this is actually not allowed by the developer of the game.")
                  a=CountGadgetItems(#GADGET_PROFILES_LIST_list)-1
                  Quit=1
                EndIf
              Next
              Quit=1
            EndIf
        Case #GADGET_PROFILES_BUTTON_delete
           If GetGadgetState(#GADGET_PROFILES_LIST_list)>-1
              DeleteFile(GetEnvironmentVariable("APPDATA") + "\SE-Development\SDC\v."+version+"\"+GetGadgetItemText(#GADGET_PROFILES_LIST_list,GetGadgetState(#GADGET_PROFILES_LIST_list),0)+".txt")
              RefreshProfilesload()
           EndIf
           
        Case #GADGET_PROFILES_BUTTON_auth
            RunProgram("https://twitchapps.com/tmi/")   
           
      EndSelect
    Case #PB_Event_CloseWindow
      If EventWindow()=#WINDOW_profiles
        End
      EndIf
  EndSelect    
Until Quit=1
CloseWindow(#WINDOW_profiles)
Quit=0
Delay(100)


;******************************************
;MAIN WINDOW
;******************************************
title.s="SD Controller v." + version + " ~ ["+activeprofile(loadedprofiles-1)+"]"
If loadedprofiles>1
  For i.i=0 To loadedprofiles-2
    title=title+" + "+activeprofile(i)
  Next
  yplus.i=27
Else
  yplus.i=0
EndIf

If Val(config(0))=0
  OpenWindow(#WINDOW_main,0,0,710,115+yplus,"SD Controller v." + version + " ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
Else
  OpenWindow(#WINDOW_main,Val(config(0)),Val(config(1)),710,115+yplus,"SD Controller v." + version + " ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu)
EndIf
StickyWindow(#WINDOW_main,1)
SetWindowTitle(#WINDOW_main,title)


FrameGadget(#GADGET_FRAME_rahmen,5,5+yplus,WindowWidth(#WINDOW_main)-195,105,"",#PB_Frame_Double)

CanvasGadget(#GADGET_BUTTON_1,10,10+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_2,60,10+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_3,110,10+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_4,160,10+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_5,210,10+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_6,260,10+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_7,10,60+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_8,60,60+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_9,110,60+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_10,160,60+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_11,210,60+yplus,45,45)
CanvasGadget(#GADGET_BUTTON_12,260,60+yplus,45,45)

CanvasGadget(#GADGET_BUTTON_p,315,12+yplus,55,40)
CanvasGadget(#GADGET_BUTTON_pd,315,62+yplus,55,40)
CanvasGadget(#GADGET_BUTTON_train,380,12+yplus,90,90)
CanvasGadget(#GADGET_BUTTON_altar,480,12+yplus,36,90)

ButtonGadget(#GADGET_BUTTON_profiles,525,4+yplus,70,20,"PROFILES")
ButtonGadget(#GADGET_BUTTON_status,530,28+yplus,60,60,"?")
SetGadgetFont(#GADGET_BUTTON_status,FontID(3))
ButtonGadget(#GADGET_BUTTON_leave,525,92+yplus,70,20,"LEAVE")

ButtonGadget(#GADGET_BUTTON_settings,605,4+yplus,95,20,"SETTINGS >",#PB_Button_Toggle)
ButtonGadget(#GADGET_BUTTON_classes,605,26+yplus,95,20,"CLASSES >",#PB_Button_Toggle)
ButtonGadget(#GADGET_BUTTON_shop,605,48+yplus,95,20,"SHOP >",#PB_Button_Toggle)
ButtonGadget(#GADGET_BUTTON_priestcast,605,70+yplus,95,20,"PRIESTCAST >",#PB_Button_Toggle)
ButtonGadget(#GADGET_BUTTON_target,605,92+yplus,95,20,"TARGET >",#PB_Button_Toggle)


activechar(0)=1
If loadedprofiles>1
  For i.i=0 To loadedprofiles-1
    CanvasGadget(i+150,100+(i*((WindowWidth(#WINDOW_main)-100)/loadedprofiles)),0,(WindowWidth(#WINDOW_main)-100)/loadedprofiles,28)
    activechar(i)=1
  Next
  CanvasGadget(160,0,0,100,28)
  AusgabeID = CanvasOutput(160)
  Ergebnis = StartDrawing(AusgabeID)
  DrawImage(ImageID(17), 0, 0 ,GadgetWidth(160),GadgetHeight(160))
  DrawingFont(FontID(3))
  DrawingMode(#PB_2DDrawing_Transparent)
  DrawText(9,6,"CHARACTER:",RGB(0+highlight*40,0+highlight*40,0+highlight*40))
  StopDrawing()
    
EndIf


;******************************************
;CLASS WINDOW
;******************************************
If Val(config(2))=0
  OpenWindow(#WINDOW_classes,0,0,775,110,"Classes ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Tool)
Else
   OpenWindow(#WINDOW_classes,Val(config(2)),Val(config(3)),775,110,"Classes ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_Tool)
EndIf
StickyWindow(#WINDOW_classes,1)
HideWindow(#WINDOW_classes,1)

CanvasGadget(#GADGET_BUTTON_firemage,5,5,105,22)
CanvasGadget(#GADGET_BUTTON_pyromancer,5,31,105,22)
CanvasGadget(#GADGET_BUTTON_bombermage,5,57,105,22)
CanvasGadget(#GADGET_BUTTON_lightningmage,5,83,105,22)
CanvasGadget(#GADGET_BUTTON_archer,115,5,105,22)
CanvasGadget(#GADGET_BUTTON_sniper,115,31,105,22)
CanvasGadget(#GADGET_BUTTON_falconeer,115,57,105,22)
CanvasGadget(#GADGET_BUTTON_frostmage,225,5,105,22)
CanvasGadget(#GADGET_BUTTON_stormmage,225,31,105,22)
CanvasGadget(#GADGET_BUTTON_trickster,225,57,105,22)
CanvasGadget(#GADGET_BUTTON_rogue,335,5,105,22)
CanvasGadget(#GADGET_BUTTON_ninja,335,31,105,22)
CanvasGadget(#GADGET_BUTTON_assasin,335,57,105,22)
CanvasGadget(#GADGET_BUTTON_bard,445,5,105,22)
CanvasGadget(#GADGET_BUTTON_mimic,445,31,105,22)
CanvasGadget(#GADGET_BUTTON_scout,445,57,105,22)
CanvasGadget(#GADGET_BUTTON_alchemist,555,5,105,22)
CanvasGadget(#GADGET_BUTTON_necromancer,555,31,105,22)
CanvasGadget(#GADGET_BUTTON_deathdealer,555,57,105,22)

CanvasGadget(#GADGET_BUTTON_highpriest,665,5,105,74)


;******************************************
;SHOP WINDOW
;******************************************
If Val(config(4))=0
  OpenWindow(#WINDOW_shop,0,0,345,595,"Shop ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Tool)
Else
  OpenWindow(#WINDOW_shop,Val(config(4)),Val(config(5)),345,595,"Shop ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_Tool)
EndIf
StickyWindow(#WINDOW_shop,1)
HideWindow(#WINDOW_shop,1)

FrameGadget(#GADGET_FRAME_classes,5,5,WindowWidth(#WINDOW_shop)-185,585,"CHANGE SPECS [5000 Gold]")
SetGadgetFont(#GADGET_FRAME_classes,FontID(1))
y.i=10
ButtonGadget(#GADGET_BUTTON_buybowman,10,10+y,150,25,"Spec Bowman")
GadgetToolTip(#GADGET_BUTTON_buybowman, "REQUIRES: Nothing") 
y+28
ButtonGadget(#GADGET_BUTTON_buysniper,10,10+y,150,25,"Spec Sniper")
GadgetToolTip(#GADGET_BUTTON_buysniper, "REQUIRES: Archer Rank 10, Rogue Rank 10") 
y+28
ButtonGadget(#GADGET_BUTTON_buyfalconeer,10,10+y,150,25,"Spec Falconeer")
GadgetToolTip(#GADGET_BUTTON_buyfalconeer, "REQUIRES: Archer Rank 20") 
y+38

ButtonGadget(#GADGET_BUTTON_buyknife,10,10+y,150,25,"Spec Knife-Thrower")
GadgetToolTip(#GADGET_BUTTON_buyknife, "REQUIRES: Nothing") 
y+28
ButtonGadget(#GADGET_BUTTON_buyassassin,10,10+y,150,25,"Spec Assassin")
GadgetToolTip(#GADGET_BUTTON_buyassassin, "REQUIRES: Rogue Rank 10, Alchemist Rank 10") 
y+28
ButtonGadget(#GADGET_BUTTON_buyninja,10,10+y,150,25,"Spec Ninja")
GadgetToolTip(#GADGET_BUTTON_buyninja, "REQUIRES: Rogue Rank 20") 
y+38

ButtonGadget(#GADGET_BUTTON_buypyromancer,10,10+y,150,25,"Spec Pyromancer")
GadgetToolTip(#GADGET_BUTTON_buypyromancer, "REQUIRES: Nothing") 
y+28
ButtonGadget(#GADGET_BUTTON_buybombermage,10,10+y,150,25,"Spec Bombermage")
GadgetToolTip(#GADGET_BUTTON_buybombermage, "REQUIRES: Firemage Rank 10") 
y+28
ButtonGadget(#GADGET_BUTTON_buylightningmage,10,10+y,150,25,"Spec Lightningmage")
GadgetToolTip(#GADGET_BUTTON_buylightningmage, "REQUIRES: Firemage Rank 5, Frostmage Rank 15") 
y+38

ButtonGadget(#GADGET_BUTTON_buyicemage,10,10+y,150,25,"Spec Ice-Mage")
GadgetToolTip(#GADGET_BUTTON_buyicemage, "REQUIRES: Nothing") 
y+28
ButtonGadget(#GADGET_BUTTON_buytrickster,10,10+y,150,25,"Spec Trickster")
GadgetToolTip(#GADGET_BUTTON_buytrickster, "REQUIRES: Frostmage Rank 10, Bard Rank 10") 
y+28
ButtonGadget(#GADGET_BUTTON_buystormmage,10,10+y,150,25,"Spec Storm-Mage")
GadgetToolTip(#GADGET_BUTTON_buystormmage, "REQUIRES: Frostmage Rank 20") 
y+28
ButtonGadget(#GADGET_BUTTON_buyshockmage,10,10+y,150,25,"Spec Shock-Mage")
GadgetToolTip(#GADGET_BUTTON_buyshockmage, "REQUIRES: Frostmage Rank 50 (And resets you to rank 0)") 
y+38

ButtonGadget(#GADGET_BUTTON_buyplaguedoctor,10,10+y,150,25,"Spec Plague-Doctor")
GadgetToolTip(#GADGET_BUTTON_buyplaguedoctor, "REQUIRES: Nothing") 
y+28
ButtonGadget(#GADGET_BUTTON_buydeathdealer,10,10+y,150,25,"Spec Deathdealer")
GadgetToolTip(#GADGET_BUTTON_buydeathdealer, "REQUIRES: Firemage Rank 5, Alchemist Rank 15") 
y+28
ButtonGadget(#GADGET_BUTTON_buynecromancer,10,10+y,150,25,"Spec Necromancer")
GadgetToolTip(#GADGET_BUTTON_buynecromancer, "REQUIRES: Alchemist Rank 20") 
y+28
ButtonGadget(#GADGET_BUTTON_buypotionmaster,10,10+y,150,25,"Spec Potion-Master")
GadgetToolTip(#GADGET_BUTTON_buypotionmaster, "REQUIRES: Alchemist Rank 50 (And resets you to rank 0)") 
y+38

ButtonGadget(#GADGET_BUTTON_buymistrel,10,10+y,150,25,"Spec Mistrel")
GadgetToolTip(#GADGET_BUTTON_buymistrel, "REQUIRES: Nothing") 
y+28
ButtonGadget(#GADGET_BUTTON_buymimic,10,10+y,150,25,"Spec Mimic")
GadgetToolTip(#GADGET_BUTTON_buymimic, "REQUIRES: Archer Rank 5, Rogue Rank 5, Firemage Rank 5, Frostmage Rank 5, Alchemist Rank 5") 
y+28
ButtonGadget(#GADGET_BUTTON_buyscout,10,10+y,150,25,"Spec Scout")
GadgetToolTip(#GADGET_BUTTON_buymimic, "REQUIRES: Bard Rank 15") 

FrameGadget(#GADGET_FRAME_highpriestspells,180,5,WindowWidth(#WINDOW_shop)-185,195,"HIGHPRIEST SPELLS")
SetGadgetFont(#GADGET_FRAME_highpriestspells,FontID(1))
y=10

ButtonGadget(#GADGET_BUTTON_buyhaste,185,10+y,150,25,"Priest Hastespell [5000g]")
y+28
ButtonGadget(#GADGET_BUTTON_buyfocus,185,10+y,150,25,"Priest Focusspell [5000g]")
y+28
ButtonGadget(#GADGET_BUTTON_buypower,185,10+y,150,25,"Priest Powerspell [5000g]")
y+28
ButtonGadget(#GADGET_BUTTON_buyshield,185,10+y,150,25,"Priest Shieldspell [5000g]")
y+28
ButtonGadget(#GADGET_BUTTON_buymeditate,185,10+y,150,25,"Priest Meditatespell [5000g]")
y+28
ButtonGadget(#GADGET_BUTTON_buyarm,185,10+y,150,25,"Priest Armyspell [5000g]")

FrameGadget(#GADGET_FRAME_gem,180,385,WindowWidth(#WINDOW_shop)-185,75,"GEMS")
SetGadgetFont(#GADGET_FRAME_gem,FontID(1))
y=290
ButtonGadget(#GADGET_BUTTON_socketruby,185,10+y,150,25,"Socket Ruby")
y+28
ButtonGadget(#GADGET_BUTTON_socketemerald,185,10+y,150,25,"Socket Emerald")
y+28
ButtonGadget(#GADGET_BUTTON_socketcitrine,185,10+y,150,25,"Socket Citrine")
y+28
ButtonGadget(#GADGET_BUTTON_socketonyx,185,10+y,150,25,"Socket Onyx")


;******************************************
;PRIESTCAST WINDOW
;******************************************
If Val(config(6))=0
  OpenWindow(#WINDOW_priestcast,0,0,265,315,"Priestcast ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Tool)
Else
  OpenWindow(#WINDOW_priestcast,Val(config(6)),Val(config(7)),265,315,"Priestcast ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_Tool)
EndIf
StickyWindow(#WINDOW_priestcast,1)
HideWindow(#WINDOW_priestcast,1)

FrameGadget(#GADGET_FRAME_buffs,5,5,WindowWidth(#WINDOW_priestcast)-10,105,"TOWER BUFFS")
SetGadgetFont(#GADGET_FRAME_buffs,FontID(1))

ButtonGadget(#GADGET_BUTTON_boostdamage,10,20,245,25,"Strength (Damage+Range) [20 Mana]",#PB_Button_Toggle)
ButtonGadget(#GADGET_BUTTON_boostpower,10,50,245,25,"Power [30 Mana]",#PB_Button_Toggle)
ButtonGadget(#GADGET_BUTTON_boostrange,10,80,245,25,"Focus (+30 Gem ranks) [20 Mana]",#PB_Button_Toggle)

FrameGadget(#GADGET_FRAME_spells,5,115,WindowWidth(#WINDOW_priestcast)-10,195,"GENERAL SPELLS")
SetGadgetFont(#GADGET_FRAME_spells,FontID(1))
ButtonGadget(#GADGET_BUTTON_boosttraining,10,130,245,25,"Training [40 Mana]")
ButtonGadget(#GADGET_BUTTON_boostfreeze,10,160,245,25,"Freeze [35 Mana]")
ButtonGadget(#GADGET_BUTTON_haste,10,190,245,25,"Haste [45 Mana]")
ButtonGadget(#GADGET_BUTTON_shield,10,220,245,25,"Shield [70 Mana]")
ButtonGadget(#GADGET_BUTTON_boostarmy,10,250,245,25,"Army [100 Mana]")
ButtonGadget(#GADGET_BUTTON_boostmeditate,10,280,245,25,"Meditate [75 Mana]")


;******************************************
;SETTINGS WINDOW
;******************************************
If Val(config(8))=0
  OpenWindow(#WINDOW_settings,0,0,250,95,"Settings ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Tool)
Else
  OpenWindow(#WINDOW_settings,Val(config(8)),Val(config(9)),250,95,"Settings ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_Tool)
EndIf
StickyWindow(#WINDOW_settings,1)
HideWindow(#WINDOW_settings,1)

ButtonGadget(#GADGET_BUTTON_reconnect,10,10,230,22,"RECONNECT TO TWITCH CHAT")
CheckBoxGadget(#GADGET_CHECKBOX_autoclose,10,40,230,20,"Auto close the class window after selection")
CheckBoxGadget(#GADGET_CHECKBOX_command,10,70,230,20,"Use command window")
SetGadgetState(#GADGET_CHECKBOX_autoclose,Val(config(10)))
SetGadgetState(#GADGET_CHECKBOX_command,Val(config(14)))


;******************************************
;COMMAND WINDOW
;******************************************
If Val(config(15))=0
  OpenWindow(#WINDOW_command,0,0,350,81,"Commands ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Tool)
Else
  OpenWindow(#WINDOW_command,Val(config(15)),Val(config(16)),350,81,"Commands ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_Tool)
EndIf
StickyWindow(#WINDOW_command,1)
If Val(config(14))=0
  HideWindow(#WINDOW_command,1)
EndIf

StringGadget(#GADGET_STRING_Command,5,5,275,23,"")
ButtonGadget(#GADGET_BUTTON_Command,285,5,60,23,"SEND")
CheckBoxGadget(#GADGET_CHECKBOX_Commandautosend,5,36,200,20,"Auto send command after milliseconds:")
SpinGadget(#GADGET_SPIN_Commandautosend,285,34,60,23,100,10000,#PB_Spin_Numeric)
SetGadgetState(#GADGET_CHECKBOX_Commandautosend,Val(config(17)))
SetGadgetState(#GADGET_SPIN_Commandautosend,Val(config(18)))
If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=0
  DisableGadget(#GADGET_SPIN_Commandautosend,1)
EndIf
ProgressBarGadget(#GADGET_PROGRESS_command,5,61,340,15,0,GetGadgetState(#GADGET_SPIN_Commandautosend),#PB_ProgressBar_Smooth)


;******************************************
;TARGET WINDOW
;******************************************
If Val(config(11))=0
  OpenWindow(#WINDOW_target,0,0,160,255,"Target ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Tool)
Else
  OpenWindow(#WINDOW_target,Val(config(11)),Val(config(12)),160,255,"Target ~ "+activeprofile(loadedprofiles-1),#PB_Window_SystemMenu|#PB_Window_Tool)
EndIf
StickyWindow(#WINDOW_target,1)
HideWindow(#WINDOW_target,1)

FrameGadget(#GADGET_FRAME_mode,5,5,WindowWidth(#WINDOW_target)-10,165,"TARGET MODE")
SetGadgetFont(#GADGET_FRAME_mode,FontID(1))
If loadedprofiles=1
  ButtonGadget(#GADGET_BUTTON_targetdefault,10,20,140,25,"Target default",#PB_Button_Toggle)
  ButtonGadget(#GADGET_BUTTON_targetfront,10,50,140,25,"Target front (widest)",#PB_Button_Toggle)
  ButtonGadget(#GADGET_BUTTON_targetlowest,10,80,140,25,"Target lowest (HP)",#PB_Button_Toggle)
  ButtonGadget(#GADGET_BUTTON_targethighest,10,110,140,25,"Target highest (HP)",#PB_Button_Toggle)
  ButtonGadget(#GADGET_BUTTON_targetclosest,10,140,140,25,"Target closest",#PB_Button_Toggle)
  SetGadgetState(#GADGET_BUTTON_targetdefault,1)
Else
  ButtonGadget(#GADGET_BUTTON_targetdefault,10,20,140,25,"Target default")
  ButtonGadget(#GADGET_BUTTON_targetfront,10,50,140,25,"Target front (widest)")
  ButtonGadget(#GADGET_BUTTON_targetlowest,10,80,140,25,"Target lowest (HP)")
  ButtonGadget(#GADGET_BUTTON_targethighest,10,110,140,25,"Target highest (HP)")
  ButtonGadget(#GADGET_BUTTON_targetclosest,10,140,140,25,"Target closest")
EndIf
  
FrameGadget(#GADGET_FRAME_lock,5,175,WindowWidth(#WINDOW_target)-10,75,"TARGET LOCK")
SetGadgetFont(#GADGET_FRAME_lock,FontID(1))
ButtonGadget(#GADGET_BUTTON_targetlockon,10,190,140,25,"Target lock ON")
ButtonGadget(#GADGET_BUTTON_targetlockoff,10,220,140,25,"Target lock OFF")


;******************************************
;PROCEDURES
;******************************************
Procedure Command(name.s)
Protected nr.i=0

   If lastcommand=name
   Else
     commandnr=0
   EndIf
   lastcommand=name

   If FindString(name,"XX")
     commandnr=commandnr+1
     If commandnr>9
       commandnr=1
     EndIf
     If commandnr>1
       name = ReplaceString(name, "XX", Str(commandnr))
     Else
       name = ReplaceString(name, "XX", "")
     EndIf
   EndIf
  
  For nr = 0 To loadedprofiles-1
   If activechar(nr)=1
     If name="/w ttdbot !stats" Or name="/w ttdbot !unlocks" Or name="/w ttdbot !highscores"
       If nr=loadedprofiles-1
         IRC::Send(nr,name)
       EndIf
     Else
       If IRC::Send(nr,name) = 5
         
       Else
         MessageRequester("TIMEOUT", "Please reconnect")
       EndIf
     EndIf
   
     Delay(50)
   EndIf
  Next
EndProcedure

Procedure Drawbutton(buttonnr.s, highlight.i,image.i, gadget.i,textx.i,texty.i)
  AusgabeID = CanvasOutput(gadget)
  Ergebnis = StartDrawing(AusgabeID)
  Box(0,0,GadgetWidth(gadget),GadgetHeight(gadget),RGB(highlight*150,highlight*150,highlight*150))
  DrawImage(ImageID(image), 2, 2 ,GadgetWidth(gadget)-4,GadgetHeight(gadget)-4)
  DrawingFont(FontID(2))
  DrawingMode(#PB_2DDrawing_Transparent)
  DrawText(textx,texty,buttonnr,RGB(highlight*30+210,highlight*30+210,highlight*30+210))
  StopDrawing()
EndProcedure

Procedure DrawCharselection(gadget.i,text.s,active.b,highlight.b)
  AusgabeID = CanvasOutput(gadget)
  Ergebnis = StartDrawing(AusgabeID)
  Box(0,0,GadgetWidth(gadget),GadgetHeight(gadget),RGB(highlight*70,highlight*70,highlight*150))
  DrawImage(ImageID(15+active),2,2,GadgetWidth(gadget)-4,GadgetHeight(gadget)-4)
  DrawingFont(FontID(3))
  DrawingMode(#PB_2DDrawing_Transparent)
  DrawText(9-highlight,6,text,RGB(0+highlight*40,0+highlight*40,0+highlight*40))
  StopDrawing()
EndProcedure

Procedure Drawbuttontrain(highlight.i,image.i, gadget.i,textx.i,texty.i)
  AusgabeID = CanvasOutput(gadget)
  Ergebnis = StartDrawing(AusgabeID)
  Box(0,0,GadgetWidth(gadget),GadgetHeight(gadget),RGB(highlight*150,highlight*200,highlight*150))
  DrawImage(ImageID(image), 3, 3 ,GadgetWidth(gadget)-6,GadgetHeight(gadget)-6)
  DrawingFont(FontID(0))
  DrawingMode(#PB_2DDrawing_Transparent)
  DrawText(textx,texty,"TRAIN",RGB(highlight*60+150,highlight*60+180,highlight*60+150))
  StopDrawing() 
EndProcedure

Procedure Drawbuttonaltar(highlight.i,image.i, gadget.i)
  AusgabeID = CanvasOutput(gadget)
  Ergebnis = StartDrawing(AusgabeID)
  Box(0,0,GadgetWidth(gadget),GadgetHeight(gadget),RGB(highlight*150,highlight*200,highlight*150))
  DrawImage(ImageID(image), 3, 3 ,GadgetWidth(gadget)-6,GadgetHeight(gadget)-6)
  StopDrawing() 
EndProcedure

Procedure Drawbuttonpower(highlight.i,image.i, gadget.i,textx.i,texty.i)
  AusgabeID = CanvasOutput(gadget)
  Ergebnis = StartDrawing(AusgabeID)
  Box(0,0,GadgetWidth(gadget),GadgetHeight(gadget),RGB(highlight*150,highlight*150,highlight*150))
  DrawImage(ImageID(image), 3, 3 ,GadgetWidth(gadget)-6,GadgetHeight(gadget)-6)
  DrawingFont(FontID(2))
  DrawingMode(#PB_2DDrawing_Transparent)
  DrawText(textx,texty,"POWER",RGB(highlight*60+170,highlight*60+170,highlight*60+170))
  StopDrawing()
EndProcedure

Procedure Drawbuttonclass(buttontext.s, highlight.i,image.i, gadget.i,textx.i,texty.i,textred.i,textblue.i,textgreen.i,starimage.i)
  AusgabeID = CanvasOutput(gadget)
  Ergebnis = StartDrawing(AusgabeID)
  Box(0,0,GadgetWidth(gadget),GadgetHeight(gadget),RGB(highlight*40+textred,highlight*40+textblue,highlight*40+textgreen))
  DrawImage(ImageID(image), 2, 2 ,GadgetWidth(gadget)-4,GadgetHeight(gadget)-4)
  DrawingFont(FontID(2))
  DrawingMode(#PB_2DDrawing_Transparent)
  DrawText(textx,texty,buttontext,RGB(highlight*40+textred,highlight*40+textblue,highlight*40+textgreen))

  If starimage<99
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    DrawImage(ImageID(starimage), GadgetWidth(gadget)-15, 5,11,11)
  EndIf
  StopDrawing()   
EndProcedure

Procedure Button(nr.s,gadget.i)
  If EventType()=#PB_EventType_LeftClick
    
    If GetGadgetState(#GADGET_CHECKBOX_command)=0
      If GetGadgetState(#GADGET_BUTTON_boostdamage)=1
        Command("!hpstr"+nr+" XX")
      ElseIf GetGadgetState(#GADGET_BUTTON_boostrange)=1
        Command("!hpfcs"+nr+" XX")
      ElseIf GetGadgetState(#GADGET_BUTTON_boostpower)=1
        Command("!hppwr"+nr+" XX")
      Else
        Command("!"+nr)
      EndIf
    Else
      If GetGadgetState(#GADGET_BUTTON_boostdamage)=1
        SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hpstr"+nr+" ")
      ElseIf GetGadgetState(#GADGET_BUTTON_boostrange)=1
        SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hpfcs"+nr+" ")
      ElseIf GetGadgetState(#GADGET_BUTTON_boostpower)=1
        SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hppwr"+nr+" ")
      Else
        SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!"+nr+" ")
      EndIf
      If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
        time=1
      EndIf
    EndIf
      
      
  ElseIf EventType()=#PB_EventType_MouseEnter
    nr = RemoveString(nr, ".")
    If GetGadgetState(#GADGET_BUTTON_boostdamage)=1
      Drawbutton(nr,1,0,gadget,22-Len(nr)*3,16)
    ElseIf GetGadgetState(#GADGET_BUTTON_boostrange)=1
      Drawbutton(nr,1,1,gadget,22-Len(nr)*3,16)
    ElseIf GetGadgetState(#GADGET_BUTTON_boostpower)=1
      Drawbutton(nr,1,2,gadget,22-Len(nr)*3,16)
    Else
      Drawbutton(nr,1,3,gadget,22-Len(nr)*3,16)
    EndIf
  ElseIf EventType()=#PB_EventType_MouseLeave
    nr = RemoveString(nr, ".")
    If GetGadgetState(#GADGET_BUTTON_boostdamage)=1
      Drawbutton(nr,0,0,gadget,22-Len(nr)*3,15)
    ElseIf GetGadgetState(#GADGET_BUTTON_boostrange)=1
      Drawbutton(nr,0,1,gadget,22-Len(nr)*3,15)
    ElseIf GetGadgetState(#GADGET_BUTTON_boostpower)=1
      Drawbutton(nr,0,2,gadget,22-Len(nr)*3,15)
    Else
      Drawbutton(nr,0,3,gadget,22-Len(nr)*3,15)
    EndIf
  EndIf
EndProcedure

Procedure targettodefault()
  SetGadgetState(#GADGET_BUTTON_targetdefault,1)
  SetGadgetState(#GADGET_BUTTON_targetlowest,0)
  SetGadgetState(#GADGET_BUTTON_targethighest,0)
  SetGadgetState(#GADGET_BUTTON_targetclosest,0)
  SetGadgetState(#GADGET_BUTTON_targetfront,0)
EndProcedure

Procedure autosend(nix.i)
  While 1=1
    If time >= GetGadgetState(#GADGET_SPIN_Commandautosend)
      time=0
      Debug (GetGadgetState(#GADGET_SPIN_Commandautosend))
      SetGadgetState(#GADGET_PROGRESS_command,0)
      If Len(GetGadgetText(#GADGET_STRING_Command))>0
        Command(GetGadgetText(#GADGET_STRING_Command))
        SetGadgetText(#GADGET_STRING_Command,"")
      EndIf
    EndIf
    
    If time>0
      time+10
      SetGadgetState(#GADGET_PROGRESS_command,time)
    EndIf
    Delay(10)
  Wend
EndProcedure
If IsThread(timethread)=0
  timethread=CreateThread(@autosend(),1)
Else
ResumeThread(timethread)  
EndIf

Procedure Classselsection(command.s,classname.s,gadget.i,red.i,blue.i,green.i,starimage.i)
  If EventType()=#PB_EventType_LeftClick
    If GetGadgetState(#GADGET_CHECKBOX_command)=0
      Command(command)
    Else
      SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+command+" ")
      If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
        time=1
      EndIf
    EndIf
    targettodefault()
    If GetGadgetState(#GADGET_CHECKBOX_autoclose)=1
      HideWindow(#WINDOW_classes,1)
      SetGadgetState(#GADGET_BUTTON_classes,0)
    EndIf
  EndIf
  
  If EventType()=#PB_EventType_MouseEnter
    Drawbuttonclass(classname,1,7,gadget,4,5,red,blue,green,starimage)
  ElseIf EventType()=#PB_EventType_MouseLeave
    Drawbuttonclass(classname,0,7,gadget,5,5,red,blue,green,starimage)
  EndIf
EndProcedure


;******************************************
;INITIAL BUTTON-DRAW
;******************************************
Drawbutton("1",0,3,#GADGET_BUTTON_1,19,15)
Drawbutton("2",0,3,#GADGET_BUTTON_2,19,15)
Drawbutton("3",0,3,#GADGET_BUTTON_3,19,15)
Drawbutton("4",0,3,#GADGET_BUTTON_4,19,15)
Drawbutton("5",0,3,#GADGET_BUTTON_5,19,15)
Drawbutton("6",0,3,#GADGET_BUTTON_6,19,15)
Drawbutton("7",0,3,#GADGET_BUTTON_7,19,15)
Drawbutton("8",0,3,#GADGET_BUTTON_8,19,15)
Drawbutton("9",0,3,#GADGET_BUTTON_9,19,15)
Drawbutton("10",0,3,#GADGET_BUTTON_10,16,15)
Drawbutton("11",0,3,#GADGET_BUTTON_11,16,15)
Drawbutton("12",0,3,#GADGET_BUTTON_12,16,15)

Drawbuttontrain(0,4,#GADGET_BUTTON_train,19,11)
Drawbuttonpower(0,5,#GADGET_BUTTON_p,8,2)
Drawbuttonpower(0,6,#GADGET_BUTTON_pd,8,2)
Drawbuttonaltar(0,18,#GADGET_BUTTON_altar)

Drawbuttonclass("Firemage",0,7,#GADGET_BUTTON_firemage,5,5,210,105,0,99)
Drawbuttonclass("Pyromancer",0,7,#GADGET_BUTTON_pyromancer,5,5,210,105,0,9)
Drawbuttonclass("Bombermage",0,7,#GADGET_BUTTON_bombermage,5,5,210,105,0,11)
Drawbuttonclass("Lightningmage",0,7,#GADGET_BUTTON_lightningmage,5,5,210,105,0,8)
Drawbuttonclass("Archer",0,7,#GADGET_BUTTON_archer,5,5,150,100,0,99)
Drawbuttonclass("Sniper",0,7,#GADGET_BUTTON_sniper,5,5,150,100,0,10)
Drawbuttonclass("Falconeer",0,7,#GADGET_BUTTON_falconeer,5,5,150,100,0,12)
Drawbuttonclass("Frostmage",0,7,#GADGET_BUTTON_frostmage,5,5,30,180,210,99)
Drawbuttonclass("Stormmage",0,7,#GADGET_BUTTON_stormmage,5,5,30,180,210,8)
Drawbuttonclass("Trickster",0,7,#GADGET_BUTTON_trickster,5,5,30,180,210,13)
Drawbuttonclass("Rogue",0,7,#GADGET_BUTTON_rogue,5,5,210,0,210,99)
Drawbuttonclass("Ninja",0,7,#GADGET_BUTTON_ninja,5,5,210,0,210,12)
Drawbuttonclass("Assasin",0,7,#GADGET_BUTTON_assasin,5,5,210,0,210,9)
Drawbuttonclass("Bard",0,7,#GADGET_BUTTON_bard,5,5,90,90,210,99)
Drawbuttonclass("Mimic",0,7,#GADGET_BUTTON_mimic,5,5,90,90,210,11)
Drawbuttonclass("Scout",0,7,#GADGET_BUTTON_scout,5,5,90,90,210,13)
Drawbuttonclass("Alchemist",0,7,#GADGET_BUTTON_alchemist,5,5,20,130,130,99)
Drawbuttonclass("Necromancer",0,7,#GADGET_BUTTON_necromancer,5,5,20,130,130,10)
Drawbuttonclass("Deathdealer",0,7,#GADGET_BUTTON_deathdealer,5,5,20,130,130,12)
Drawbuttonclass("HIGHPRIEST",0,7,#GADGET_BUTTON_highpriest,20,31,200,200,200,99)

If loadedprofiles>1
  For i.i=0 To loadedprofiles-1
    DrawCharselection(150+i,activeprofile(i),1,0)
  Next
EndIf


;******************************************
;POPUP MENU
;******************************************
If CreatePopupMenu(0)
  MenuItem(20, "GOLD")
  MenuItem(21, "GEMS")
  MenuItem(22, "SPECS")
  MenuItem(23, "ESSENCE")
  MenuItem(24, "SPELLS")
  MenuItem(25, "HIGHSCORES")
  MenuItem(26, "STATS")
EndIf


;******************************************
;SHORTCUTS
;******************************************
AddKeyboardShortcut(#WINDOW_main, #PB_Shortcut_Space, 0)
AddKeyboardShortcut(#WINDOW_priestcast, #PB_Shortcut_Space, 0)
AddKeyboardShortcut(#WINDOW_main, #PB_Shortcut_1, 1)
AddKeyboardShortcut(#WINDOW_priestcast, #PB_Shortcut_1, 1)
AddKeyboardShortcut(#WINDOW_classes, #PB_Shortcut_1, 1)
AddKeyboardShortcut(#WINDOW_main, #PB_Shortcut_2, 2)
AddKeyboardShortcut(#WINDOW_priestcast, #PB_Shortcut_2, 2)
AddKeyboardShortcut(#WINDOW_classes, #PB_Shortcut_2, 2)
AddKeyboardShortcut(#WINDOW_main, #PB_Shortcut_3, 3)
AddKeyboardShortcut(#WINDOW_priestcast, #PB_Shortcut_3, 3)
AddKeyboardShortcut(#WINDOW_classes, #PB_Shortcut_3, 3)


;******************************************
;MAINLOOP
;******************************************
Repeat
  EventID = WaitWindowEvent()
  Select EventID
    Case #PB_Event_Menu:
      Select EventMenu()
        Case 0:
          If GetGadgetState(#GADGET_BUTTON_priestcast)=1
          If GetGadgetState(#GADGET_BUTTON_boostdamage)=1
            SetGadgetState(#GADGET_BUTTON_boostdamage,0)
            SetGadgetState(#GADGET_BUTTON_boostpower,1)
            Drawbutton("1",0,2,#GADGET_BUTTON_1,20,15)
            Drawbutton("2",0,2,#GADGET_BUTTON_2,20,15)
            Drawbutton("3",0,2,#GADGET_BUTTON_3,20,15)
            Drawbutton("4",0,2,#GADGET_BUTTON_4,20,15)
            Drawbutton("5",0,2,#GADGET_BUTTON_5,20,15)
            Drawbutton("6",0,2,#GADGET_BUTTON_6,20,15)
            Drawbutton("7",0,2,#GADGET_BUTTON_7,20,15)
            Drawbutton("8",0,2,#GADGET_BUTTON_8,20,15)
            Drawbutton("9",0,2,#GADGET_BUTTON_9,20,15)
            Drawbutton("10",0,2,#GADGET_BUTTON_10,17,15)
            Drawbutton("11",0,2,#GADGET_BUTTON_11,17,15)
            Drawbutton("12",0,2,#GADGET_BUTTON_12,17,15)
          ElseIf GetGadgetState(#GADGET_BUTTON_boostpower)=1
            SetGadgetState(#GADGET_BUTTON_boostpower,0)
            SetGadgetState(#GADGET_BUTTON_boostrange,1)
            Drawbutton("1",0,1,#GADGET_BUTTON_1,20,15)
            Drawbutton("2",0,1,#GADGET_BUTTON_2,20,15)
            Drawbutton("3",0,1,#GADGET_BUTTON_3,20,15)
            Drawbutton("4",0,1,#GADGET_BUTTON_4,20,15)
            Drawbutton("5",0,1,#GADGET_BUTTON_5,20,15)
            Drawbutton("6",0,1,#GADGET_BUTTON_6,20,15)
            Drawbutton("7",0,1,#GADGET_BUTTON_7,20,15)
            Drawbutton("8",0,1,#GADGET_BUTTON_8,20,15)
            Drawbutton("9",0,1,#GADGET_BUTTON_9,20,15)
            Drawbutton("10",0,1,#GADGET_BUTTON_10,17,15)
            Drawbutton("11",0,1,#GADGET_BUTTON_11,17,15)
            Drawbutton("12",0,1,#GADGET_BUTTON_12,17,15)
          ElseIf GetGadgetState(#GADGET_BUTTON_boostrange)=1
            SetGadgetState(#GADGET_BUTTON_boostrange,0)
            SetGadgetState(#GADGET_BUTTON_boostdamage,1)
            Drawbutton("1",0,0,#GADGET_BUTTON_1,20,15)
            Drawbutton("2",0,0,#GADGET_BUTTON_2,20,15)
            Drawbutton("3",0,0,#GADGET_BUTTON_3,20,15)
            Drawbutton("4",0,0,#GADGET_BUTTON_4,20,15)
            Drawbutton("5",0,0,#GADGET_BUTTON_5,20,15)
            Drawbutton("6",0,0,#GADGET_BUTTON_6,20,15)
            Drawbutton("7",0,0,#GADGET_BUTTON_7,20,15)
            Drawbutton("8",0,0,#GADGET_BUTTON_8,20,15)
            Drawbutton("9",0,0,#GADGET_BUTTON_9,20,15)
            Drawbutton("10",0,0,#GADGET_BUTTON_10,17,15)
            Drawbutton("11",0,0,#GADGET_BUTTON_11,17,15)
            Drawbutton("12",0,0,#GADGET_BUTTON_12,17,15)
          EndIf
          EndIf
        Case 1:
          If GetGadgetState(#GADGET_BUTTON_priestcast)=1
            SetGadgetState(#GADGET_BUTTON_boostdamage,1)
            SetGadgetState(#GADGET_BUTTON_boostrange,0)
            SetGadgetState(#GADGET_BUTTON_boostpower,0)
            Drawbutton("1",0,0,#GADGET_BUTTON_1,20,15)
            Drawbutton("2",0,0,#GADGET_BUTTON_2,20,15)
            Drawbutton("3",0,0,#GADGET_BUTTON_3,20,15)
            Drawbutton("4",0,0,#GADGET_BUTTON_4,20,15)
            Drawbutton("5",0,0,#GADGET_BUTTON_5,20,15)
            Drawbutton("6",0,0,#GADGET_BUTTON_6,20,15)
            Drawbutton("7",0,0,#GADGET_BUTTON_7,20,15)
            Drawbutton("8",0,0,#GADGET_BUTTON_8,20,15)
            Drawbutton("9",0,0,#GADGET_BUTTON_9,20,15)
            Drawbutton("10",0,0,#GADGET_BUTTON_10,17,15)
            Drawbutton("11",0,0,#GADGET_BUTTON_11,17,15)
            Drawbutton("12",0,0,#GADGET_BUTTON_12,17,15)
          EndIf
        Case 2:
          If GetGadgetState(#GADGET_BUTTON_priestcast)=1
            SetGadgetState(#GADGET_BUTTON_boostdamage,0)
            SetGadgetState(#GADGET_BUTTON_boostpower,1)
            SetGadgetState(#GADGET_BUTTON_boostrange,0)
            Drawbutton("1",0,2,#GADGET_BUTTON_1,20,15)
            Drawbutton("2",0,2,#GADGET_BUTTON_2,20,15)
            Drawbutton("3",0,2,#GADGET_BUTTON_3,20,15)
            Drawbutton("4",0,2,#GADGET_BUTTON_4,20,15)
            Drawbutton("5",0,2,#GADGET_BUTTON_5,20,15)
            Drawbutton("6",0,2,#GADGET_BUTTON_6,20,15)
            Drawbutton("7",0,2,#GADGET_BUTTON_7,20,15)
            Drawbutton("8",0,2,#GADGET_BUTTON_8,20,15)
            Drawbutton("9",0,2,#GADGET_BUTTON_9,20,15)
            Drawbutton("10",0,2,#GADGET_BUTTON_10,17,15)
            Drawbutton("11",0,2,#GADGET_BUTTON_11,17,15)
            Drawbutton("12",0,2,#GADGET_BUTTON_12,17,15)
          EndIf
        Case 3:
          If GetGadgetState(#GADGET_BUTTON_priestcast)=1
            SetGadgetState(#GADGET_BUTTON_boostpower,0)
            SetGadgetState(#GADGET_BUTTON_boostdamage,0)
            SetGadgetState(#GADGET_BUTTON_boostrange,1)
            Drawbutton("1",0,1,#GADGET_BUTTON_1,20,15)
            Drawbutton("2",0,1,#GADGET_BUTTON_2,20,15)
            Drawbutton("3",0,1,#GADGET_BUTTON_3,20,15)
            Drawbutton("4",0,1,#GADGET_BUTTON_4,20,15)
            Drawbutton("5",0,1,#GADGET_BUTTON_5,20,15)
            Drawbutton("6",0,1,#GADGET_BUTTON_6,20,15)
            Drawbutton("7",0,1,#GADGET_BUTTON_7,20,15)
            Drawbutton("8",0,1,#GADGET_BUTTON_8,20,15)
            Drawbutton("9",0,1,#GADGET_BUTTON_9,20,15)
            Drawbutton("10",0,1,#GADGET_BUTTON_10,17,15)
            Drawbutton("11",0,1,#GADGET_BUTTON_11,17,15)
            Drawbutton("12",0,1,#GADGET_BUTTON_12,17,15)
          EndIf
          
          
        Case 20:
          Command("/w ttdbot !gold")
        Case 21:
          Command("/w ttdbot !gems")
        Case 22:
          Command("/w ttdbot !specs")
        Case 23:
          Command("/w ttdbot !essence")
        Case 24:
          Command("/w ttdbot !spells")
        Case 25:
          Command("/w ttdbot !highscores")
        Case 26:
          Command("/w ttdbot !stats")
      EndSelect

   
    Case #PB_Event_Gadget:
      Select EventGadget()
        Case #GADGET_BUTTON_1:
          button("1",#GADGET_BUTTON_1)
        Case #GADGET_BUTTON_2: 
          button("2",#GADGET_BUTTON_2)
        Case #GADGET_BUTTON_3: 
          button("3",#GADGET_BUTTON_3)
        Case #GADGET_BUTTON_4: 
          button("4",#GADGET_BUTTON_4)
        Case #GADGET_BUTTON_5: 
          button("5",#GADGET_BUTTON_5)
        Case #GADGET_BUTTON_6: 
          button("6",#GADGET_BUTTON_6)
        Case #GADGET_BUTTON_7: 
          button("7",#GADGET_BUTTON_7)
        Case #GADGET_BUTTON_8: 
          button("8",#GADGET_BUTTON_8)
        Case #GADGET_BUTTON_9: 
          button("9",#GADGET_BUTTON_9)
        Case #GADGET_BUTTON_10: 
          button("10",#GADGET_BUTTON_10)
        Case #GADGET_BUTTON_11: 
          button("11",#GADGET_BUTTON_11)
        Case #GADGET_BUTTON_12: 
          button("12",#GADGET_BUTTON_12)
        Case #GADGET_BUTTON_train: 
          If EventType()=#PB_EventType_LeftClick
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!train")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!train ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
          EndIf
          If EventType()=#PB_EventType_MouseEnter
            Drawbuttontrain(1,4,#GADGET_BUTTON_train,19,12)
          ElseIf EventType()=#PB_EventType_MouseLeave
            Drawbuttontrain(0,4,#GADGET_BUTTON_train,19,11)
          EndIf
        Case #GADGET_BUTTON_altar: 
          If EventType()=#PB_EventType_LeftClick
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!a")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!a ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
          EndIf
          If EventType()=#PB_EventType_MouseEnter
            Drawbuttonaltar(1,18,#GADGET_BUTTON_altar)
          ElseIf EventType()=#PB_EventType_MouseLeave
            Drawbuttonaltar(0,18,#GADGET_BUTTON_altar)
          EndIf
        Case #GADGET_BUTTON_p: 
          If EventType()=#PB_EventType_LeftClick
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!p")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!p ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
          EndIf
          If EventType()=#PB_EventType_MouseEnter
            Drawbuttonpower(1,5,#GADGET_BUTTON_p,8,3)
          ElseIf EventType()=#PB_EventType_MouseLeave
            Drawbuttonpower(0,5,#GADGET_BUTTON_p,8,2)
          EndIf
        Case #GADGET_BUTTON_pd: 
          If EventType()=#PB_EventType_LeftClick
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!pd")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!pd ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
          EndIf
          If EventType()=#PB_EventType_MouseEnter
            Drawbuttonpower(1,6,#GADGET_BUTTON_pd,8,3)
          ElseIf EventType()=#PB_EventType_MouseLeave
            Drawbuttonpower(0,6,#GADGET_BUTTON_pd,8,2)
          EndIf
        Case #GADGET_BUTTON_status:
          DisplayPopupMenu(0,WindowID(#WINDOW_main))
        Case #GADGET_BUTTON_leave: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
            Command("!leave")
          Else
            SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!leave ")
            If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
              time=1
            EndIf
          EndIf
          If loadedprofiles=1
            targettodefault()
          EndIf
        Case #GADGET_BUTTON_classes:
            If GetGadgetState(#GADGET_BUTTON_classes)=0
              HideWindow(#WINDOW_classes,1)
            Else
              HideWindow(#WINDOW_classes,0)
            EndIf
        Case #GADGET_BUTTON_shop:
            If GetGadgetState(#GADGET_BUTTON_shop)=0
              HideWindow(#WINDOW_shop,1)
            Else
              HideWindow(#WINDOW_shop,0)
            EndIf
        Case #GADGET_BUTTON_target:
          If GetGadgetState(#GADGET_BUTTON_target)=0
            HideWindow(#WINDOW_target,1)
          Else
            HideWindow(#WINDOW_target,0)
          EndIf
        Case #GADGET_BUTTON_priestcast:
          If GetGadgetState(#GADGET_BUTTON_priestcast)=0
            HideWindow(#WINDOW_priestcast,1)
            SetGadgetState(#GADGET_BUTTON_boostdamage,0)
            SetGadgetState(#GADGET_BUTTON_boostpower,0)
            SetGadgetState(#GADGET_BUTTON_boostrange,0)
            Drawbutton("1",0,3,#GADGET_BUTTON_1,19,15)
            Drawbutton("2",0,3,#GADGET_BUTTON_2,19,15)
            Drawbutton("3",0,3,#GADGET_BUTTON_3,19,15)
            Drawbutton("4",0,3,#GADGET_BUTTON_4,19,15)
            Drawbutton("5",0,3,#GADGET_BUTTON_5,19,15)
            Drawbutton("6",0,3,#GADGET_BUTTON_6,19,15)
            Drawbutton("7",0,3,#GADGET_BUTTON_7,19,15)
            Drawbutton("8",0,3,#GADGET_BUTTON_8,19,15)
            Drawbutton("9",0,3,#GADGET_BUTTON_9,19,15)
            Drawbutton("10",0,3,#GADGET_BUTTON_10,16,15)
            Drawbutton("11",0,3,#GADGET_BUTTON_11,16,15)
            Drawbutton("12",0,3,#GADGET_BUTTON_12,16,15)
          Else
            HideWindow(#WINDOW_priestcast,0)
            SetGadgetState(#GADGET_BUTTON_boostdamage,1)
            Drawbutton("1",0,0,#GADGET_BUTTON_1,19,15)
            Drawbutton("2",0,0,#GADGET_BUTTON_2,19,15)
            Drawbutton("3",0,0,#GADGET_BUTTON_3,19,15)
            Drawbutton("4",0,0,#GADGET_BUTTON_4,19,15)
            Drawbutton("5",0,0,#GADGET_BUTTON_5,19,15)
            Drawbutton("6",0,0,#GADGET_BUTTON_6,19,15)
            Drawbutton("7",0,0,#GADGET_BUTTON_7,19,15)
            Drawbutton("8",0,0,#GADGET_BUTTON_8,19,15)
            Drawbutton("9",0,0,#GADGET_BUTTON_9,19,15)
            Drawbutton("10",0,0,#GADGET_BUTTON_10,16,15)
            Drawbutton("11",0,0,#GADGET_BUTTON_11,16,15)
            Drawbutton("12",0,0,#GADGET_BUTTON_12,16,15)
          EndIf 
        Case #GADGET_BUTTON_settings:
          If GetGadgetState(#GADGET_BUTTON_settings)=0
            HideWindow(#WINDOW_settings,1)
          Else
            HideWindow(#WINDOW_settings,0)
          EndIf 
          
        ;CLASSES
        ;---------
        Case #GADGET_BUTTON_firemage:
          Classselsection("!firemage","Firemage",EventGadget(),210,105,0,99)
        Case #GADGET_BUTTON_pyromancer:
          Classselsection("!pyromancer","Pyromancer",EventGadget(),210,105,0,9)
        Case #GADGET_BUTTON_bombermage:
          Classselsection("!bombermage","Bombermage",EventGadget(),210,105,0,11)
        Case #GADGET_BUTTON_lightningmage:
          Classselsection("!lightningmage","Lightningmage",EventGadget(),210,105,0,8)
        Case #GADGET_BUTTON_archer:
          Classselsection("!archer","Archer",EventGadget(),160,110,0,99)
        Case #GADGET_BUTTON_sniper:
          Classselsection("!sniper","Sniper",EventGadget(),160,110,0,10)
        Case #GADGET_BUTTON_falconeer:
          Classselsection("!falconeer","Falconeer",EventGadget(),160,110,0,12)
        Case #GADGET_BUTTON_frostmage:
          Classselsection("!frostmage","Frostmage",EventGadget(),30,180,210,99)
        Case #GADGET_BUTTON_stormmage:
          Classselsection("!stormmage","Stormmage",EventGadget(),30,180,210,8)
        Case #GADGET_BUTTON_trickster:
          Classselsection("!trickster","Trickster",EventGadget(),30,180,210,13)
        Case #GADGET_BUTTON_rogue:
          Classselsection("!rogue","Rogue",EventGadget(),210,0,210,99)
        Case #GADGET_BUTTON_ninja:
          Classselsection("!ninja","Ninja",EventGadget(),210,0,210,12)
        Case #GADGET_BUTTON_assasin:
          Classselsection("!assassin","Assasin",EventGadget(),210,0,210,9)
        Case #GADGET_BUTTON_bard:
          Classselsection("!bard","Bard",EventGadget(),120,120,210,99)
        Case #GADGET_BUTTON_mimic:
          Classselsection("!mimic","Mimic",EventGadget(),120,120,210,11)
        Case #GADGET_BUTTON_scout:
          Classselsection("!scout","Scout",EventGadget(),120,120,210,13)
        Case #GADGET_BUTTON_alchemist:
          Classselsection("!alchemist","Alchemist",EventGadget(),50,160,160,99)
        Case #GADGET_BUTTON_necromancer:
          Classselsection("!necromancer","Necromancer",EventGadget(),50,160,160,10)
        Case #GADGET_BUTTON_deathdealer: 
          Classselsection("!deathdealer","Deathdealer",EventGadget(),50,160,160,12)
        Case #GADGET_BUTTON_highpriest: 
          If EventType()=#PB_EventType_LeftClick
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!highpriest")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!highpriest ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
            targettodefault()
            If GetGadgetState(#GADGET_CHECKBOX_autoclose)=1
              HideWindow(#WINDOW_classes,1)
              SetGadgetState(#GADGET_BUTTON_classes,0)
            EndIf
          EndIf
          If EventType()=#PB_EventType_MouseEnter
            Drawbuttonclass("HIGHPRIEST",1,7,#GADGET_BUTTON_highpriest,19,31,200,200,200,99)
          ElseIf EventType()=#PB_EventType_MouseLeave
            Drawbuttonclass("HIGHPRIEST",0,7,#GADGET_BUTTON_highpriest,20,31,200,200,200,99)
          EndIf
          
          
        ;SHOP
        ;------
       Case #GADGET_BUTTON_buybowman: 
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specbowman")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specbowman ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buysniper: 
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specsniper")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specsniper ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buyfalconeer: 
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specfalconeer")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specfalconeer ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
            
       Case #GADGET_BUTTON_buyknife: 
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specknifethrower")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specknifethrower ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buyassassin: 
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specassassin")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specassassin ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buyninja: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specninja")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specninja ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
            
       Case #GADGET_BUTTON_buypyromancer: 
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specpyromancer")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specpyromancer ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buybombermage: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specbombermage")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specbombermage ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buylightningmage: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!speclightningmage")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!speclightningmage ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
            
       Case #GADGET_BUTTON_buyicemage: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specicemage")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specicemage ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buytrickster: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!spectrickster")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!spectrickster ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buystormmage: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specstormmage")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specstormmage ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
       Case #GADGET_BUTTON_buyshockmage: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specshockmage")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specshockmage ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
            
        Case #GADGET_BUTTON_buyplaguedoctor: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specplaguedoctor")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specplaguedoctor ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buydeathdealer: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specdeathdealer")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specdeathdealer ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buynecromancer: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specnecromancer")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specnecromancer ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buypotionmaster: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specpotionmaster")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specpotionmaster ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
            
        Case #GADGET_BUTTON_buymistrel:
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specminstrel")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specminstrel ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buymimic: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specmimic")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specmimic ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buyscout: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!specscout")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!specscout ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        
        Case #GADGET_BUTTON_socketruby: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!socketruby")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!socketruby ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_socketemerald: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!socketemerald")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!socketemerald ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_socketcitrine: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!socketcitrine")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!socketcitrine ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_socketonyx: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!socketonyx")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!socketonyx ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
            
        Case #GADGET_BUTTON_buyhaste: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!learnhaste")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!learnhaste ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buyfocus: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!learnfocus")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!learnfocus ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buypower: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!learnpower")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!learnpower ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buyshield: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!learnshield")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!learnshield ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buymeditate: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!learnmeditate")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!learnmeditate ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_buyarm: 
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!learnarmy")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!learnarmy ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
          
        ;PRIESTCAST:
        ;-------------  
        Case #GADGET_BUTTON_boosttraining:
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!hpwis XX")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hpwis ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_boostfreeze:
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!hpfrz XX")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hpfrz ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_shield:
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!hpshd XX")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hpshd ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_haste:
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!hphst XX")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hphst ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_boostarmy:
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!hparm XX")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hparm ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
        Case #GADGET_BUTTON_boostmeditate:
            If GetGadgetState(#GADGET_CHECKBOX_command)=0
              Command("!hpmdt XX")
            Else
              SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!hpmdt ")
              If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
                time=1
              EndIf
            EndIf
         
        Case #GADGET_BUTTON_boostpower:
          If GetGadgetState(#GADGET_BUTTON_boostpower)=1
            SetGadgetState(#GADGET_BUTTON_boostrange,0)
            SetGadgetState(#GADGET_BUTTON_boostdamage,0)
            Drawbutton("1",0,2,#GADGET_BUTTON_1,19,15)
            Drawbutton("2",0,2,#GADGET_BUTTON_2,19,15)
            Drawbutton("3",0,2,#GADGET_BUTTON_3,19,15)
            Drawbutton("4",0,2,#GADGET_BUTTON_4,19,15)
            Drawbutton("5",0,2,#GADGET_BUTTON_5,19,15)
            Drawbutton("6",0,2,#GADGET_BUTTON_6,19,15)
            Drawbutton("7",0,2,#GADGET_BUTTON_7,19,15)
            Drawbutton("8",0,2,#GADGET_BUTTON_8,19,15)
            Drawbutton("9",0,2,#GADGET_BUTTON_9,19,15)
            Drawbutton("10",0,2,#GADGET_BUTTON_10,16,15)
            Drawbutton("11",0,2,#GADGET_BUTTON_11,16,15)
            Drawbutton("12",0,2,#GADGET_BUTTON_12,16,15)
          Else 
            Drawbutton("1",0,3,#GADGET_BUTTON_1,19,15)
            Drawbutton("2",0,3,#GADGET_BUTTON_2,19,15)
            Drawbutton("3",0,3,#GADGET_BUTTON_3,19,15)
            Drawbutton("4",0,3,#GADGET_BUTTON_4,19,15)
            Drawbutton("5",0,3,#GADGET_BUTTON_5,19,15)
            Drawbutton("6",0,3,#GADGET_BUTTON_6,19,15)
            Drawbutton("7",0,3,#GADGET_BUTTON_7,19,15)
            Drawbutton("8",0,3,#GADGET_BUTTON_8,19,15)
            Drawbutton("9",0,3,#GADGET_BUTTON_9,19,15)
            Drawbutton("10",0,3,#GADGET_BUTTON_10,16,15)
            Drawbutton("11",0,3,#GADGET_BUTTON_11,16,15)
            Drawbutton("12",0,3,#GADGET_BUTTON_12,16,15)
          EndIf
        Case #GADGET_BUTTON_boostrange:
          If GetGadgetState(#GADGET_BUTTON_boostrange)=1
            SetGadgetState(#GADGET_BUTTON_boostpower,0)
            SetGadgetState(#GADGET_BUTTON_boostdamage,0)
            Drawbutton("1",0,1,#GADGET_BUTTON_1,19,15)
            Drawbutton("2",0,1,#GADGET_BUTTON_2,19,15)
            Drawbutton("3",0,1,#GADGET_BUTTON_3,19,15)
            Drawbutton("4",0,1,#GADGET_BUTTON_4,19,15)
            Drawbutton("5",0,1,#GADGET_BUTTON_5,19,15)
            Drawbutton("6",0,1,#GADGET_BUTTON_6,19,15)
            Drawbutton("7",0,1,#GADGET_BUTTON_7,19,15)
            Drawbutton("8",0,1,#GADGET_BUTTON_8,19,15)
            Drawbutton("9",0,1,#GADGET_BUTTON_9,19,15)
            Drawbutton("10",0,1,#GADGET_BUTTON_10,16,15)
            Drawbutton("11",0,1,#GADGET_BUTTON_11,16,15)
            Drawbutton("12",0,1,#GADGET_BUTTON_12,16,15)
          Else 
            Drawbutton("1",0,3,#GADGET_BUTTON_1,19,15)
            Drawbutton("2",0,3,#GADGET_BUTTON_2,19,15)
            Drawbutton("3",0,3,#GADGET_BUTTON_3,19,15)
            Drawbutton("4",0,3,#GADGET_BUTTON_4,19,15)
            Drawbutton("5",0,3,#GADGET_BUTTON_5,19,15)
            Drawbutton("6",0,3,#GADGET_BUTTON_6,19,15)
            Drawbutton("7",0,3,#GADGET_BUTTON_7,19,15)
            Drawbutton("8",0,3,#GADGET_BUTTON_8,19,15)
            Drawbutton("9",0,3,#GADGET_BUTTON_9,19,15)
            Drawbutton("10",0,3,#GADGET_BUTTON_10,16,15)
            Drawbutton("11",0,3,#GADGET_BUTTON_11,16,15)
            Drawbutton("12",0,3,#GADGET_BUTTON_12,16,15)
          EndIf
        Case #GADGET_BUTTON_boostdamage:
          If GetGadgetState(#GADGET_BUTTON_boostdamage)=1
            SetGadgetState(#GADGET_BUTTON_boostpower,0)
            SetGadgetState(#GADGET_BUTTON_boostrange,0)
            Drawbutton("1",0,0,#GADGET_BUTTON_1,19,15)
            Drawbutton("2",0,0,#GADGET_BUTTON_2,19,15)
            Drawbutton("3",0,0,#GADGET_BUTTON_3,19,15)
            Drawbutton("4",0,0,#GADGET_BUTTON_4,19,15)
            Drawbutton("5",0,0,#GADGET_BUTTON_5,19,15)
            Drawbutton("6",0,0,#GADGET_BUTTON_6,19,15)
            Drawbutton("7",0,0,#GADGET_BUTTON_7,19,15)
            Drawbutton("8",0,0,#GADGET_BUTTON_8,19,15)
            Drawbutton("9",0,0,#GADGET_BUTTON_9,19,15)
            Drawbutton("10",0,0,#GADGET_BUTTON_10,16,15)
            Drawbutton("11",0,0,#GADGET_BUTTON_11,16,15)
            Drawbutton("12",0,0,#GADGET_BUTTON_12,16,15)
          Else 
            Drawbutton("1",0,3,#GADGET_BUTTON_1,19,15)
            Drawbutton("2",0,3,#GADGET_BUTTON_2,19,15)
            Drawbutton("3",0,3,#GADGET_BUTTON_3,19,15)
            Drawbutton("4",0,3,#GADGET_BUTTON_4,19,15)
            Drawbutton("5",0,3,#GADGET_BUTTON_5,19,15)
            Drawbutton("6",0,3,#GADGET_BUTTON_6,19,15)
            Drawbutton("7",0,3,#GADGET_BUTTON_7,19,15)
            Drawbutton("8",0,3,#GADGET_BUTTON_8,19,15)
            Drawbutton("9",0,3,#GADGET_BUTTON_9,19,15)
            Drawbutton("10",0,3,#GADGET_BUTTON_10,16,15)
            Drawbutton("11",0,3,#GADGET_BUTTON_11,16,15)
            Drawbutton("12",0,3,#GADGET_BUTTON_12,16,15)
          EndIf
          

          
          
        Case #GADGET_BUTTON_profiles
          saveconfig()
          PauseThread(timethread)
          CloseWindow(#WINDOW_main)
          CloseWindow(#WINDOW_classes)
          CloseWindow(#WINDOW_settings)
          CloseWindow(#WINDOW_shop)
          CloseWindow(#WINDOW_target)
          CloseWindow(#WINDOW_priestcast)
          
          Goto Profiles
        ;Settings:
        ;-----------
        Case #GADGET_BUTTON_reconnect:
            For i.i=0 To loadedprofiles-1
              IRC::Connect(i)
              IRC::Login(i,activeprofile(i), activeauth(i))
              IRC::Join(i)
              Delay(1000)
            Next
        Case #GADGET_CHECKBOX_command:
          If GetGadgetState(#GADGET_CHECKBOX_command)=1
            HideWindow(#WINDOW_command,0)
          Else 
            HideWindow(#WINDOW_command,1)
          EndIf
            
        ;Target:
        ;---------
        Case #GADGET_BUTTON_targetfront:
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
            Command("!targetfront")
          Else
            SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!targetfront ")
            If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
              time=1
            EndIf
          EndIf
          If loadedprofiles=1
          SetGadgetState(#GADGET_BUTTON_targetdefault,0)
          SetGadgetState(#GADGET_BUTTON_targetlowest,0)
          SetGadgetState(#GADGET_BUTTON_targethighest,0)
          SetGadgetState(#GADGET_BUTTON_targetclosest,0)
          SetGadgetState(#GADGET_BUTTON_targetfront,1)
          EndIf
        Case #GADGET_BUTTON_targetdefault:
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
            Command("!targetdefault")
          Else
            SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!targetdefault ")
            If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
              time=1
            EndIf
          EndIf
          If loadedprofiles=1
            SetGadgetState(#GADGET_BUTTON_targetdefault,1)
            SetGadgetState(#GADGET_BUTTON_targetlowest,0)
            SetGadgetState(#GADGET_BUTTON_targethighest,0)
            SetGadgetState(#GADGET_BUTTON_targetclosest,0)
            SetGadgetState(#GADGET_BUTTON_targetfront,0)
          EndIf
        Case #GADGET_BUTTON_targetclosest:
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
            Command("!targetclosest")
          Else
            SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!targetclosest ")
            If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
              time=1
            EndIf
          EndIf
          If loadedprofiles=1
            SetGadgetState(#GADGET_BUTTON_targetdefault,0)
            SetGadgetState(#GADGET_BUTTON_targetlowest,0)
            SetGadgetState(#GADGET_BUTTON_targethighest,0)
            SetGadgetState(#GADGET_BUTTON_targetclosest,1)
            SetGadgetState(#GADGET_BUTTON_targetfront,0)
          EndIf
        Case #GADGET_BUTTON_targethighest:  
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
            Command("!targethighest")
          Else
            SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!targethighest ")
            If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
              time=1
            EndIf
          EndIf
          If loadedprofiles=1
            SetGadgetState(#GADGET_BUTTON_targetdefault,0)
            SetGadgetState(#GADGET_BUTTON_targetlowest,0)
            SetGadgetState(#GADGET_BUTTON_targethighest,1)
            SetGadgetState(#GADGET_BUTTON_targetclosest,0)
            SetGadgetState(#GADGET_BUTTON_targetfront,0)
          EndIf
        Case #GADGET_BUTTON_targetlowest:  
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
            Command("!targetlowest")
          Else
            SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!targetlowest ")
            If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
              time=1
            EndIf
          EndIf
          If loadedprofiles=1
            SetGadgetState(#GADGET_BUTTON_targetdefault,0)
            SetGadgetState(#GADGET_BUTTON_targetlowest,1)
            SetGadgetState(#GADGET_BUTTON_targethighest,0)
            SetGadgetState(#GADGET_BUTTON_targetclosest,0)
            SetGadgetState(#GADGET_BUTTON_targetfront,0)
          EndIf
        Case #GADGET_BUTTON_targetlockon:
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
            Command("!targetlockon")
          Else
            SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!targetlockon ")
            If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
              time=1
            EndIf
          EndIf
        Case #GADGET_BUTTON_targetlockoff:
          If GetGadgetState(#GADGET_CHECKBOX_command)=0
            Command("!targetlockoff")
          Else
            SetGadgetText(#GADGET_STRING_Command, GetGadgetText(#GADGET_STRING_Command)+"!targetlockoff ")
            If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
              time=1
            EndIf
          EndIf
          
        ;Send
        Case #GADGET_BUTTON_Command
          Command(GetGadgetText(#GADGET_STRING_Command))
          time=0
          SetGadgetText(#GADGET_STRING_Command,"")
          SetGadgetState(#GADGET_PROGRESS_command,0)
        Case #GADGET_CHECKBOX_Commandautosend
          If GetGadgetState(#GADGET_CHECKBOX_Commandautosend)=1
            DisableGadget(#GADGET_SPIN_Commandautosend,0)
            If Len(GetGadgetText(#GADGET_STRING_Command))>0
              time=1
            EndIf
          Else
            DisableGadget(#GADGET_SPIN_Commandautosend,1)
            If Len(GetGadgetText(#GADGET_STRING_Command))>0
              time=0
              SetGadgetText(#GADGET_STRING_Command,"")
              SetGadgetState(#GADGET_PROGRESS_command,0)
            EndIf
          EndIf
        Case #GADGET_SPIN_Commandautosend
          time=0
          SetGadgetState(#GADGET_PROGRESS_command,0)
          SetGadgetText(#GADGET_STRING_Command,"")
          SetGadgetAttribute(#GADGET_PROGRESS_command,#PB_ProgressBar_Maximum,GetGadgetState(#GADGET_SPIN_Commandautosend))
          
          
      EndSelect
      If EventGadget()>149 And EventGadget()<159
        If EventType()=#PB_EventType_MouseEnter
          DrawCharselection(EventGadget(),activeprofile(EventGadget()-150),activechar(EventGadget()-150),1)
        EndIf
        If EventType()=#PB_EventType_MouseLeave
          DrawCharselection(EventGadget(),activeprofile(EventGadget()-150),activechar(EventGadget()-150),0)
        EndIf
        
        If EventType()=#PB_EventType_LeftClick
          If activechar(EventGadget()-150)=0
            activechar(EventGadget()-150)=1
            DrawCharselection(EventGadget(),activeprofile(EventGadget()-150),1,1)
          Else
            activechar(EventGadget()-150)=0
            DrawCharselection(EventGadget(),activeprofile(EventGadget()-150),0,1)
          EndIf
        ElseIf EventType()=#PB_EventType_RightClick
          For i.i=0 To loadedprofiles-1
            activechar(i)=0
            DrawCharselection(150+i,activeprofile(i),0,0)
          Next
          activechar(EventGadget()-150)=1
          DrawCharselection(EventGadget(),activeprofile(EventGadget()-150),1,1)
        EndIf
        
        
      EndIf
    Case #PB_Event_CloseWindow
      If EventWindow()=#WINDOW_main
        Quit=1
      ElseIf EventWindow()=#WINDOW_classes
        HideWindow(#WINDOW_classes,1)
        SetGadgetState(#GADGET_BUTTON_classes,0)
      ElseIf EventWindow()=#WINDOW_shop
        HideWindow(#WINDOW_shop,1)
        SetGadgetState(#GADGET_BUTTON_shop,0)
      ElseIf EventWindow()=#WINDOW_target
        HideWindow(#WINDOW_target,1)
        SetGadgetState(#GADGET_BUTTON_target,0)
      ElseIf EventWindow()=#WINDOW_priestcast
        HideWindow(#WINDOW_priestcast,1)
        SetGadgetState(#GADGET_BUTTON_priestcast,0)
        SetGadgetState(#GADGET_BUTTON_boostdamage,0)
        SetGadgetState(#GADGET_BUTTON_boostpower,0)
        SetGadgetState(#GADGET_BUTTON_boostrange,0)
        Drawbutton("1",0,3,#GADGET_BUTTON_1,19,15)
        Drawbutton("2",0,3,#GADGET_BUTTON_2,19,15)
        Drawbutton("3",0,3,#GADGET_BUTTON_3,19,15)
        Drawbutton("4",0,3,#GADGET_BUTTON_4,19,15)
        Drawbutton("5",0,3,#GADGET_BUTTON_5,19,15)
        Drawbutton("6",0,3,#GADGET_BUTTON_6,19,15)
        Drawbutton("7",0,3,#GADGET_BUTTON_7,19,15)
        Drawbutton("8",0,3,#GADGET_BUTTON_8,19,15)
        Drawbutton("9",0,3,#GADGET_BUTTON_9,19,15)
        Drawbutton("10",0,3,#GADGET_BUTTON_10,16,15)
        Drawbutton("11",0,3,#GADGET_BUTTON_11,16,15)
        Drawbutton("12",0,3,#GADGET_BUTTON_12,16,15)
      ElseIf EventWindow()=#WINDOW_settings
        HideWindow(#WINDOW_settings,1)
        SetGadgetState(#GADGET_BUTTON_settings,0)
      ElseIf EventWindow()=#WINDOW_command
        HideWindow(#WINDOW_command,1)
        SetGadgetState(#GADGET_CHECKBOX_command,0)
      EndIf
  EndSelect

Until Quit=1
time=0
saveconfig()
For i.i=0 To loadedprofiles-1
 IRC::Leave(i)
Next
End
; IDE Options = PureBasic 5.45 LTS (Windows - x64)
; CursorPosition = 1731
; FirstLine = 1422
; Folding = AAw
; EnableUnicode
; EnableThread
; EnableXP
; UseIcon = icon.ico
; Executable = fertig\v.1.05\SDC\SDC.exe