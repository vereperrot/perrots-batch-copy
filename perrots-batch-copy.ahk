Gui,+AlwaysOnTop

; Create file menu
Menu, FileMenu, Add, &Save As`tCtrl+S, MenuFileSaveAs
Menu, FileMenu, Add  ; Separator line.
Menu, FileMenu, Add, E&xit`tAlt+F4, MenuFileExit
Menu, MyMenuBar, Add, &File, :FileMenu  

; Create edit menu
Menu, EditMenu, Add, C&lear All`tCtrl+L, MenuEditClearAll  
Menu, EditMenu, Add, &Copy All`tCtrl+C, MenuEditCopyAll
Menu, EditMenu, Add  ; Separator line.
Menu, EditMenu, Add, Select &All`tCtrl+A, MenuEditSelectAll
Menu, EditMenu, Add, &Delete Selected`tCtrl+D, MenuEditDeleteSelected
Menu, EditMenu, Add, Copy Selected`tCtrl+Y, MenuEditCopySelected
Menu, MyMenuBar, Add, &Edit, :EditMenu  

; Create tool menu
Menu, ToolMenu, Add, Enable &Batch Copy`tWin+B, MenuToolEnableBatchCopy
Menu, ToolMenu, Add, Enable Half &Transparent`tCtrl+T, MenuToolEnableHalfTransparent
Menu, MyMenuBar, Add, &Tools, :ToolMenu 

; Create help menu
 Menu, HelpMenu, Add, Help Contents`tShift+F1, MenuHelpHelpContents
 Menu, HelpMenu, Add  ; Separator line.
 Menu, HelpMenu, Add, About Perrot's Batch Copy`tF1, MenuHelpAbout
 Menu, MyMenuBar, Add, &?, :HelpMenu 

; Create menu bar
Gui, Menu, MyMenuBar 

; Create listview and status bar
Gui, Add, ListView,h470 Multi gListViewMain, No.|Clipboard Text
Gui, Add, StatusBar,, 

; Initail behavior
InitialVariable()
ReadAllClipboardText()

; Create about dialog
Gui, 2:+Owner1
Gui, 2:Add, Link,, Perrot's Batch Copy`nVersion:`t1.8.0`nAuthor:`t<a href="https://github.com/perrot">Perrot</a>`nHome Page:`t<a href="https://github.com/perrot/perrots-batch-copy">https://github.com/perrot/perrots-batch-copy</a>
Gui, 2:Add, GroupBox,r7 w400 h800, GNU General Public License
;gui,2:add,radio,xp+10 yp+20 r1,radio 1
Gui, 2:Add, Edit,Wrap xp+10 yp+20 w380 h800 r8 vMyEdit, This program is free software: you can redistribute it and/or modifyit under the terms of the GNU General Public License as published bythe Free Software Foundation, either version 3 of the License, or(at your option) any later version.`n`nThis program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty ofMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See theGNU General Public License for more details.`n`nYou should have received a copy of the GNU General Public Licensealong with this program.  If not, see <http://www.gnu.org/licenses/>.
Gui, 2:Add, Button,xp+160 yp+140  Default, OK

; Show main window
Gui, Show, h500 X0 Y0,Perrot's Batch Copy
return

MenuHelpHelpContents:
	Run,https://github.com/perrot/perrots-batch-copy
return

MenuHelpAbout:
	Gui, +Disabled
	Gui, 2:Show
return

OpacityFlag=0
MenuToolEnableHalfTransparent:
	WinGet, currentWindow, ID, A
	;msgbox %currentWindow%
	global OpacityFlag
	if(OpacityFlag=1){
		OpacityFlag=0
		%currentWindow% = 255
		SB_SetText("Tra: Off",2) 
	}
	else{
		OpacityFlag=1
		%currentWindow% = 127
		SB_SetText("Tra: On",2) 
	}
		
	WinSet, Transparent, % %currentWindow%, ahk_id %currentWindow%
return

ListViewMain:
	if A_GuiEvent = DoubleClick
	{
		LV_GetText(RowText, A_EventInfo,2)  ; Get the text from the row's first field.
		clipboard=%RowText%
	}
return

InitialVariable()
{
	global EnableFlag
	EnableFlag=1
	global OpacityFlag
	OpacityFlag=0
	SB_SetParts(50, 50,60) 
	SB_SetText("Bat: On",1) 
	SB_SetText("Tra: Off",2) 
}

No=0
ReadAllClipboardText()
{
	global No
	FileRead, OutputVar, CLIPBOARD_TEXT.txt
	;msgbox %OutputVar%
	Loop, parse, OutputVar, `r`n
	{
		Len := StrLen(A_LoopField)
		;msgbox %Len%
		if (Len <> 0)
		{
			;MsgBox Add item %A_Index% is %A_LoopField%.
			No+=1
			Temp=%No%
			if(No>9) 
			Temp=.
			LV_Add(,Temp,A_LoopField)
		}
	}
	return
}

SaveAllClipboardText(SelectedFile)
{
	;msgbox %SelectedFile%
	MyString = 
	Loop % LV_GetCount()
	{
		LV_GetText(RetrievedText, A_Index,2)
		MyString = %MyString%`r`n%RetrievedText%
	} 
	FileAppend, %MyString%`r`n, %SelectedFile%
	str=Append all clipboard text to file: %SelectedFile%
	ShowToolTip(str)
}

SaveAs()
{
	FileSelectFile, SelectedFile, S	3, , Save a file, Text Documents (*.txt)
	if SelectedFile =
		MsgBox, The user didn't select anything.
	else
		;MsgBox, The user selected the following:`n%SelectedFile%
		SaveAllClipboardText(SelectedFile)
	return
}

; =========== save as ===========  
; save all items of the listview to user specified text file.
MenuFileSaveAs:
	SaveAs()
return

ButtonSaveAs:
	SaveAs()
return

; =========== exit =========== 
MenuFileExit:
	ExitApp
return

ClearAll()
{
	global No
	LV_Delete()
	No=0
    return  ; "Return" expects an expression.
} 

; =========== clear all =========== 
; clear all items of the listview
MenuEditClearAll:
	ClearAll()
return

ButtonClearAll:
	ClearAll()
return

CopyAll()
{
	MyString = 
	Loop % LV_GetCount()
	{
		LV_GetText(RetrievedText, A_Index,2)
		MyString = %MyString%`r`n%RetrievedText%
	} 
	clipboard=%MyString%
	return
}

; =========== copy all =========== 
; Copy all items of the listview to the system's clipboard
MenuEditCopyAll:
	CopyAll()
return

ButtonCopyAll:
	CopyAll()
return 

MenuFileOpen:
	ClearAll()
return

SelectAll()
{
	LV_Modify(0, "Select")   ; Select all.
	return
}

; =========== select all =========== 
; Select all items of the listview
MenuEditSelectAll:
	SelectAll()
return

ButtonSelectAll:
	SelectAll()
return

RefreshNo()
{
	global No
	Loop % LV_GetCount()
	{
		LV_GetText(RetrievedText, A_Index)
		LV_Modify(A_Index,,A_Index)
	}
	LVCount=0
	Loop % LV_GetCount()
	{
		LVCount+=1
	}
	No=%LVCount%
}

DeleteSelected()
{
	RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber-1)  ; Resume the search at the row after that found by the previous iteration.
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		LV_Delete(RowNumber)
	} 
	RefreshNo()
	return
}

; =========== delete selected =========== 
; Delete the selected items of the listview
MenuEditDeleteSelected:
	DeleteSelected()
return

ButtonDeleteSelected:
	DeleteSelected()
return

CopySelected()
{
	RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
	MyString=
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		LV_GetText(Text, RowNumber,2)
		MyString = %MyString%`r`n%Text%
	;    MsgBox The next selected row is #%RowNumber%, whose first field is "%Text%".
	}
	clipboard=%MyString%
	return
}

; =========== copy selected =========== 
; Copy the selected items to the system's clipboard
MenuEditCopySelected:
	CopySelected()
return

ButtonCopySelected:
	CopySelected()
return

; =========== Enable the batch copy function =========== 
MenuToolEnableBatchCopy:
	EnableBatchCopy()
return

; Utility
ShowToolTip(text)
{
	ToolTip %text%
	Sleep 1000
	ToolTip  ; Turn off the tip.
	return
}

GuiClose:
	FileDelete, CLIPBOARD_TEXT.txt
	SaveAllClipboardText("CLIPBOARD_TEXT.txt")
	ExitApp

#Persistent
return
EnableFlag=1
OnClipboardChange:
	global EnableFlag
	global No
	;msgbox C%EnableFlag%
	if(EnableFlag=1)
	{
		;ToolTip %Clipboard% data type: %A_EventInfo%
		ToolTip %Clipboard%
		Sleep 1000
		ToolTip  ; Turn off the tip.
		No+=1
		Temp=%No%
		if(No>9) 
		Temp=.
		LV_Add("", Temp,clipboard)
		LVCount=0
		Loop % LV_GetCount()
		{
			LVCount+=1
		}
		STR=Ln: %LVCount%
		SB_SetText(STR,3) 
		
	}
return

EnableBatchCopy()
{
	global EnableFlag
	if(EnableFlag=1){
		ShowToolTip("Disable batch copy")
		EnableFlag=0
		SB_SetText("Bat: Off",1) 
	}
	else{
		ShowToolTip("Enable batch copy")
		EnableFlag=1
		SB_SetText("Bat: On",1) 
	}
	return
}

#b::
	EnableBatchCopy()
return

; About dialog behavior
ButtonWindow2:

return

2ButtonOK:
	Gui, 1:-Disabled
	Gui, Hide
return

2GuiClose:
	Gui, 1:-Disabled
	Gui, Hide
return

delete::
	DeleteSelected()
return

CopyRecordByRowNumber(num)
{
	LV_GetText(Text, num,2)
	;EnableFlag=0
	;msgbox A%EnableFlag%
	clipboard=%Text%
	Send ^{V}
	;EnableFlag=1
	;msgbox B%EnableFlag%
}

^+1::
	CopyRecordByRowNumber(1)
return

^+2::
	CopyRecordByRowNumber(2)
return

^+3::
	CopyRecordByRowNumber(3)
return

^+4::
	CopyRecordByRowNumber(4)
return

^+5::
	CopyRecordByRowNumber(5)
return

^+6::
	CopyRecordByRowNumber(6)
return

^+7::
	CopyRecordByRowNumber(7)
return

^+8::
	CopyRecordByRowNumber(8)
return

^+9::
	CopyRecordByRowNumber(9)
return
