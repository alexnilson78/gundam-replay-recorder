#include <Misc.au3>
#include <WinAPISys.au3>

Global $doneColor = 0x400000
Global $recordingHotKey = "{BACKSPACE}"
Global $stopRecordingHotKey = "{BACKSPACE}"
Global $ps4MacroPath = "PS4Macro_0_5_2/PS4Macro.exe"
Global $ps4MacroWindowName = "PS4 Macro - v0.5.2 (BETA)"
Global $captureWindowName = "Game Capture HD"

Global $macroWindow = LaunchPs4Macro();
Global $recorder = FindRecorder()

While Not isLastReplay($recorder)
   RecordNextMatch()
WEnd

Func RecordNextMatch()
   SendUpX($macroWindow)
   StartRecording()

   While 1 ; wait for match to end by checking for the return to replay list dialog
	  If isMatchOver() = 1 Then
		 ;Beep(200, 100) ; for debugging issues with failing to detect match end
		 SendDownX($macroWindow)
		 StopRecording()
		 ExitLoop
	  EndIf

	  If _IsPressed("24") Then ExitLoop ; Home button on keyboard will escape this loop just in case
   WEnd

   Sleep(7000) ; wait for replay list to load again
EndFunc

Func LaunchPs4Macro()
   Run($ps4MacroPath)

   Return WinWait($ps4MacroWindowName, "", 10)
EndFunc

Func FindRecorder()
   Return WinWait($captureWindowName, "", 10)
EndFunc

Func SendUpX($window)
   OpenAndRunScript($window, "up-x.xml")
EndFunc

Func SendDownX($window)
   OpenAndRunScript($window, "down-x.xml")
EndFunc

Func OpenAndRunScript($window, $script)
   ControlSend($window, "", "", "^o")

   Send($script)
   Send("{ENTER}")

   Sleep(200)

   ControlSend($window, "", "", "{ENTER}")

   Sleep(1000) ;tighten this up?

   ControlSend($window, "", "", "{TAB}{TAB}{ENTER}{TAB}{TAB}{TAB}")
EndFunc

Func StartRecording()
   Send($recordingHotKey)
EndFunc

Func StopRecording()
   Send($stopRecordingHotKey)
EndFunc

Func isMatchOver() ; might need to make this better?
   Local $upperLeftPixel = PixelGetColor(980, 211); 0x2e363b
   Local $lowerRightPixel = PixelGetColor(1158, 324); 0x2d353c
   Local $upperButtonLeftSide = PixelGetColor(1020, 257); 0xfefe00
   Local $upperButtonRightSide = PixelGetColor(1120, 254853, 366); 0fecf00

   Local $yellowColor = 0xfc0000
   Local $greyLowerBound = 0x2B0000
   Local $greyUpperBound = 0x2F0000

   If ($upperLeftPixel > $greyLowerBound) And ($upperLeftPixel  < $greyUpperBound) And ($lowerRightPixel > $greyLowerBound) And ($lowerRightPixel < $greyUpperBound) And ($upperButtonLeftSide > $yellowColor) And ($upperButtonRightSide > $yellowColor) Then
	  Return 1
   Else
	  Return 0
   EndIf
EndFunc

Func isLastReplay($recorderWindow)
   $checkPixel = PixelGetColor(1324, 133, $recorderWindow) ; 0x0b131d

   If $checkPixel > $doneColor Then
	  Return 1
   Else
	  Return 0
   EndIf
EndFunc