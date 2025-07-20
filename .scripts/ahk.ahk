#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

::!date::
; Get current components
FormatTime, hourMin,, H:mm
FormatTime, day,, d
FormatTime, monthYear,, MMMM yyyy

; Convert day to number
dayNum := day + 0

; Determine suffix
if (dayNum = 11 or dayNum = 12 or dayNum = 13)
    suffix := "th"
else if (Mod(dayNum, 10) = 1)
    suffix := "st"
else if (Mod(dayNum, 10) = 2)
    suffix := "nd"
else if (Mod(dayNum, 10) = 3)
    suffix := "rd"
else
    suffix := "th"

; Construct final output
sendInput, {#} %hourMin% - %dayNum%%suffix% of %monthYear%
return

::!day:: ;Prints the current date with a dash, used for organizing my archives
    FormatTime, time, A_now, yyyy.MM.dd-
        sendInput, %time%
    return
::!dal:: ;Full Spelled out month and day
    FormatTime, time, A_now, MMMM dd, yyyy
        sendInput, %time%
    return
::!time:: ;Prints out current time
    FormatTime, time, A_now, h:mm
        sendInput, %time%
    return

::!r::

;Simple Snippets (Keyword, to chunk of text)
::!clear::clear;source ~/.zprofile
::!j::nvim /mnt/c/Users/macke/Dropbox/writing/journal/volume-7.md
::!commit::git add -A; git commit -m "new entry" 
::!e::mackenziegcriswell@gmail.com
::!apt::sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
;^^^^Fixing Ubuntu's update nonesense. I use a WSL subsystem on Win10, and this makes life so much easier^^^^^^

;A handy script I've borrowed from Fatima Wahab at Addictive Tips that will automatically toggle the
;taskbar in Windows 10 with a keyboard shortcut
;https://www.addictivetips.com/windows-tips/toggle-the-taskbar-keyboard-shortcut-windows-10/
VarSetCapacity(APPBARDATA, A_PtrSize=4 ? 36:48)
::!t::
    NumPut(DllCall("Shell32\SHAppBarMessage", "UInt", 4 ; ABM_GETSTATE
        , "Ptr", &APPBARDATA
        , "Int")
    ? 2:1, APPBARDATA, A_PtrSize=4 ? 32:40) ; 2 - ABS_ALWAYSONTOP, 1 - ABS_AUTOHIDE
    , DllCall("Shell32\SHAppBarMessage", "UInt", 10 ; ABM_SETSTATE
        , "Ptr", &APPBARDATA)
    KeyWait, % A_ThisHotkey
    Return
