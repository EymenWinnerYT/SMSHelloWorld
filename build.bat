@echo off
del helloworld.lst
del helloworld.rom
"zasm-4.4.9-Windows64/zasm.exe" helloworld.asm
del helloworld.sms
ren helloworld.rom helloworld.sms
py cscalc.py
pause