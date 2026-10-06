@echo off
set TASK_NAME=GitAutoCommit_lmao

echo Dang go bo Windows Scheduled Task '%TASK_NAME%'...
schtasks /Delete /TN "%TASK_NAME%" /F

if %ERRORLEVEL% equ 0 (
    echo.
    echo Da huy kich hoat va go bo task thanh cong!
) else (
    echo.
    echo Khong tim thay task hoac that bai.
)
pause
