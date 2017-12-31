DeclareModule IRC
  #DefaultChannel = "#archonthewizard" ;"#mokator87"
  ;#DefaultChannel = "#klrpatrickstar" ; You can use your personal twitch channel for testing if you want
  #DefaultServer= "irc.chat.twitch.tv" ;"irc.chat.twitch.tv"
  #DefaultPort = 6667
  
  Declare Init()
  Declare Connect(nr.i, Server.s=#DefaultServer, Port.l=#DefaultPort)
  Declare Login(nr.i,Nick.s, Auth.s, Server.s=#DefaultServer)
  Declare Join(nr.i,Channel.s=#DefaultChannel)
  Declare Leave(nr.i,Channel.s=#DefaultChannel)
  Declare Send(nr.i,Text.s, Channel.s=#DefaultChannel)
EndDeclareModule

Module IRC
  Global Dim Connection(10)
  Global ConnectionID.l 
  Global Endln.s = Chr(13)+Chr(10) 
  
  Procedure Init()
    InitNetwork()
  EndProcedure
  
  Procedure Connect(nr.i,Server.s=#DefaultServer, Port.l=#DefaultPort)
    Connection(nr) = OpenNetworkConnection(Server, Port)
    Debug ("connected:"+ nr)
    ;ProcedureReturn Connection
  EndProcedure
  
  Procedure Login(nr.i,Nick.s, Auth.s, Server.s=#DefaultServer)
    If Connection(nr) <> 0
      ConnectionID = Connection(nr)
    EndIf
    PassStr.s = "PASS " + Auth + Endln
    NickStr.s = "NICK " + Nick + Endln
    UserStr.s = "USER " + Nick + " " + Server + " " + "bla" + " :" + Endln
    PrivStr.s = "PRIVMSG nickserv :identify " + Nick + " " + Auth + Endln
    CaprStr.s = "CAP REQ :twitch.tv/commands" + Endln

    SendNetworkString(ConnectionID, PassStr)
    SendNetworkString(ConnectionID, NickStr)
    SendNetworkString(ConnectionID, UserStr)
    SendNetworkString(ConnectionID, PrivStr)
    SendNetworkString(ConnectionID, CaprStr)
    Debug ("login:"+ nr +"-"+Nick+"-"+Auth)
  EndProcedure
  
  Procedure Join(nr.i,Channel.s=#DefaultChannel)
    If Connection(nr) <> 0
      ConnectionID = Connection(nr)
    EndIf
    SendNetworkString(ConnectionID,"JOIN " + Channel + Endln )
  EndProcedure
  
  Procedure Leave(nr.i,Channel.s=#DefaultChannel)
    If Connection(nr) <> 0
      ConnectionID = Connection(nr)
    EndIf
    SendNetworkString(ConnectionID,"PART "+Channel+ Endln )
  EndProcedure
  
  Procedure Send(nr.i,Text.s, Channel.s=#DefaultChannel)
    If Connection(nr) <> 0
      ConnectionID = Connection(nr)
    EndIf
    Debug ("ConnectionID "+Connection(nr))
    If SendNetworkString(ConnectionID,"PRIVMSG " + Channel + " :" + Text + Endln)
     ProcedureReturn 5
    EndIf
   
  EndProcedure
EndModule

; IDE Options = PureBasic 5.42 LTS (Windows - x64)
; CursorPosition = 67
; FirstLine = 34
; Folding = --
; EnableUnicode
; EnableXP