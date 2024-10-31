@echo off
python "%~dp0\hcompiler.py" %1 "a.rasm"
python "%~dp0\assemblerimport.py" "a.rasm" %2