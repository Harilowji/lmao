@echo off
title lmao - Meme Reactions
cd /d "%~dp0"
call .venv\Scripts\activate.bat
python lmao.py %*
if errorlevel 1 pause
