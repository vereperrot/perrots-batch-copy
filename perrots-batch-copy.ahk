
Gui,+AlwaysOnTop
Gui, Add, Button, Default, &ClearAll
Gui, Add, Button, Default, Copy&All
Gui, Add, ListView,h400 vCC, Clipboard Text
Gui, Show, h500 X0 Y0,Perrot's Batch Copy
return

ButtonClearAll:
LV_Delete()  ; Clear all rows.
return

ButtonCopyAll:
MyString = 
Loop % LV_GetCount()
{
    LV_GetText(RetrievedText, A_Index)
    MyString = %MyString%`r`n%RetrievedText%
} 
clipboard=%MyString%
return 

GuiClose:
ExitApp

#Persistent
return

OnClipboardChange:
ToolTip %Clipboard%
Sleep 1000
ToolTip  ; Turn off the tip.
str=%clipboard%
LV_Add("", clipboard)
return
