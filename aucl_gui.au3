;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.


#include <TrayConstants.au3>
#include <GUIConstantsEx.au3>

Global $Paused = True
Global $clicks = 8
Global $TimeBetweenClicks = Int(1000/$clicks)

HotKeySet("+!d", "TogglePause")
HotKeySet("+!f", "Terminate")
HotKeySet("+!w", "IncreaseClicks")
HotKeySet("+!s", "DecreaseClicks")

Opt("GUIOnEventMode", 1)

CreateGUI()


Autoclicking()

; Creation of GUI
Func CreateGUI()
   Local $guiHandle = GUICreate("Gruz' Clicker", 300, 400)



   ; CPS Input
   GUICtrlCreateLabel("Clicks per second: ", 30, 10, 100, 20)
   Global $G_CPSInput = GUICtrlCreateInput("", 150, 10, 100, 20)

   ; MouseClickDelay and MouseClickDownDelay
   GUICtrlCreateLabel("MouseClickDelay: ", 30, 40, 100, 20)
   Global $G_MouseClickDelayInput = GUICtrlCreateInput("", 150, 40, 100, 20)

   GuiCtrlCreateLabel("MouseClickDownDelay: ", 30, 70, 150, 20)
   Global $G_MouseClickDownDelayInput = GUICtrlCreateInput("", 150, 70, 100, 20)

   ; Save values
   Local $G_SetValuesButton = GUICtrlCreateButton("Set values", 150, 100, 100, 20)

   ; Set events
   GUISetOnEvent($GUI_EVENT_CLOSE, "Terminate")
   GUICtrlSetOnEvent($G_SetValuesButton, "SetValues")

   ; Set states of GUI
   GUISetState(@SW_SHOW, $guiHandle)
EndFunc

Func CheckEntry($value)
   if $value < 1 Then
	  MsgBox(0, "Input error", "Only values greater than 0 allowed")
	  Return False
   Else
	  return True
   EndIf
EndFunc

; autoclicking function
Func Autoclicking()
   While $Paused
   sleep(500)
WEnd


While Not $Paused
   MouseClick("left")
   Sleep($TimeBetweenClicks)
WEnd

EndFunc

; Toggles pause state for autoclicking
Func TogglePause()
   $Paused = Not $Paused

   If $Paused Then
	  ToolTip("Aucl pausiert..")
	  sleep("250")
	  ToolTip("")
   Else
	  ToolTip("Aucl fortgesetzt..")
	  sleep("250")
	  ToolTip("")
   EndIf

   While $Paused
	  sleep(250)
   WEnd
EndFunc

; Sets clicks per second with event
Func SetValues()
   $cpsInputValue = Int(GUICtrlRead($G_CPSInput))
   $mouseClickDelay = Int(GUICtrlRead($G_MouseClickDelayInput))
   $mouseClickDownDelay = Int(GUICtrlRead($G_MouseClickDownDelayInput))
   if CheckEntry($cpsInputValue) And CheckEntry($mouseClickDelay) And CheckEntry($mouseClickDownDelay) Then
	  ; set cps
	  $clicks=$cpsInputValue
	  $TimeBetweenClicks=Int(1000/$clicks)

	  ; set MouseDelay and MouseDownDelay
	  Opt("MouseClickDelay", $mouseClickDelay)
	  Opt("MouseClickDownDelay", $mouseClickDownDelay)

	  ToolTip("Values set")
	  Sleep("500")
	  ToolTip("")
   EndIf
EndFunc

; Increases clicks per second
Func IncreaseClicks()
   $clicks=$clicks+1
   $TimeBetweenClicks=Int(1000/$clicks)
   ToolTip("Clicks increased to " & $clicks)
   Sleep("500")
   ToolTip("")
   ;TrayTip("","Clicks increased to " & $clicks, 2,$TIP_ICONASTERISK)
EndFunc

; Decreases clicks per second
Func DecreaseClicks()
   if $clicks > 1 Then
	  $clicks=$clicks-1
	  $TimeBetweenClicks=Int(1000/$clicks)
	  ToolTip("Clicks decreased to " & $clicks)
	  Sleep("500")
	  ToolTip("")
	  ;TrayTip("","Clicks decreased to " & $clicks, 2,$TIP_ICONASTERISK)
   EndIf
EndFunc

; Terminates the application
Func Terminate()
   Exit 0
EndFunc