@echo off
title DispSwitch - Display Name Switcher by noskating
cls
>nul 2>&1 reg query HKCU\Console | find "VirtualTerminalLevel" || reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f

echo.
echo DispSwitch, by noskating
echo.
echo according to number, type in what LOCAL account you want to edit the display of.
echo.

setlocal enabledelayedexpansion
set count=0

for /f "delims=" %%D in ('dir "C:\Users" /b /a:d') do (
    set /a count+=1
    set "user[!count!]=%%D"
)

for /L %%i in (1,1,%count%) do (
    set "current=!user[%%i]!"
    set "lower=!current!"
    if /i "!lower!"=="Default" (
        call :redEcho %%i. !current!
    ) else if /i "!lower!"=="Public" (
        call :redEcho %%i. !current!
    ) else if /i "!lower!"=="Default User" (
        call :redEcho %%i. !current!
    ) else if /i "!lower!"=="All Users" (
        call :redEcho %%i. !current!
    ) else (
        echo %%i. !current!
    )
)

echo.
set /p sel=Select user number: 
set "selected=!user[%sel%]!"

if not defined selected (
    echo Invalid selection.
    pause
    exit /b
)

for %%S in ("Default" "Default User" "All Users" "Public") do (
    if /i "%selected%"==%%~S (
        echo.
        if /i "%%~S"=="Public" (
            echo this is just a folder for storing other content and is not a user.
        ) else (
            echo no
        )
        pause
        exit /b
    )
)

echo.
echo Enter the new display name for "%selected%".
echo Type "nevermind11" to cancel.
set /p newname=New display name: 

if /i "%newname%"=="nevermind11" (
    echo.
    echo Operation canceled.
    pause
    exit /b
)

echo.
echo Changing "%selected%" to display name "%newname%"...
wmic useraccount where name="%selected%" set FullName="%newname%" >nul 2>&1

if %errorlevel% equ 0 (
    echo Success! Display name updated.
) else (
    echo.
    echo Access denied or user not found. Make sure you're running this script as administrator.
)

pause
exit /b

:redEcho
<nul set /p="[91m%*[0m"
echo.
goto :eof
