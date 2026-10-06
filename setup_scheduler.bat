@echo off
set TASK_NAME=GitAutoCommit_lmao
set SCRIPT_PATH=%~dp0auto_commit_silent.vbs

echo Dang cai dat Windows Scheduled Task '%TASK_NAME%' chay moi 30 phut...
schtasks /Create /TN "%TASK_NAME%" /TR "wscript.exe \"%SCRIPT_PATH%\"" /SC MINUTE /MO 30 /F

if %ERRORLEVEL% equ 0 (
    echo.
    echo Cai dat thanh cong! Task se tu dong chay ngam moi 30 phut.
) else (
    echo.
    echo Cai dat that bai. Vui long kiem tra lai quyen truy cap.
)
pause
