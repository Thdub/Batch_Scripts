@echo off

mode 100,3
cd /d "%~dp1"
echo Type folder name and press "Enter":
set /p "NF="
	mkdir "%NF%"
	for %%A in (%*) do (
		move %%A  "%NF%"
		) >NUL 2>&1
exit /b