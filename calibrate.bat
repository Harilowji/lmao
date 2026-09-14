@echo off
title lmao - Calibrate Neutral Face
cd /d "%~dp0"
call .venv\Scripts\activate.bat
python lmao.py --calibrate
if errorlevel 1 pause
