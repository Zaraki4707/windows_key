Set WshShell = CreateObject("WScript.Shell")
regKey = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DigitalProductId"
DigitalProductId = WshShell.RegRead(regKey)
ProductName = WshShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName")
ProductID = WshShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductID")
ProductKey = ConvertToKey(DigitalProductId)
MsgBox "ProductName: " & ProductName & vbNewLine & "ProductID: " & ProductID & vbNewLine & vbNewLine & "Installed Key: " & ProductKey, 0, "Your Windows 8.1 Key Backup"

Function ConvertToKey(Key)
    Const KeyOffset = 52
    isWin8 = (Key(66) \ 6) And 1
    Key(66) = (Key(66) And &HF7) Or ((isWin8 And 2) * 4)
    i = 24
    Chars = "BCDFGHJKMPQRTVWXY2346789"
    Do
        Cur = 0
        X = 14
        Do
            Cur = Cur * 256
            Cur = Key(X + KeyOffset) + Cur
            Key(X + KeyOffset) = (Cur \ 24)
            Cur = Cur Mod 24
            X = X -1
        Loop While X >= 0
        i = i -1
        KeyOutput = Mid(Chars, Cur + 1, 1) & KeyOutput
        Last = Cur
    Loop While i >= 0
    If (isWin8 = 1) Then
        keypart1 = Mid(KeyOutput, 2, Last)
        insert = "N"
        KeyOutput = Replace(KeyOutput, keypart1, keypart1 & insert, 2, 1, 0)
        If Last = 0 Then KeyOutput = insert & KeyOutput
    End If
    a = Mid(KeyOutput, 1, 5)
    b = Mid(KeyOutput, 6, 5)
    c = Mid(KeyOutput, 11, 5)
    d = Mid(KeyOutput, 16, 5)
    e = Mid(KeyOutput, 21, 5)
    ConvertToKey = a & "-" & b & "-" & c & "-" & d & "-" & e
End Function
