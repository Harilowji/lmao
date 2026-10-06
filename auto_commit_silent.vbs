' Script chạy ngầm auto_commit_push.ps1 không hiện cửa sổ command/console
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
psScript = scriptDir & "\auto_commit_push.ps1"
WshShell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & psScript & """", 0, False
