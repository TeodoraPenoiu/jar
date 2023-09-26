@echo off
setlocal

:: Iterate through all arguments, looking for the -user and -wp flags
:loop
IF "%1"=="" GOTO :end_loop

IF /I "%1"=="-user" (
  REM Set the username of the github account
  set "USERNAME=%2"
) ELSE IF /I "%1"=="-wp" (
  REM Remove the "-wp" prefix
  set "WORKSPACE_PATH=%2"
)

SHIFT
SHIFT
GOTO :loop

:end_loop

REM Check if the provided path exists and is a directory
if not exist "%WORKSPACE_PATH%" (
  echo The provided workspace path is not valid.
  exit /b
)

REM Ensure the workspace path ends with a backslash and *
if not "%WORKSPACE_PATH:~-1%"=="\" (
  set "WORKSPACE_PATH=%WORKSPACE_PATH%\*"
) else (
  set "WORKSPACE_PATH=%WORKSPACE_PATH%*"
)


REM Change to the workspace directory
cd /d "%WORKSPACE_PATH%"

REM Set a flag to track how many repositories have been successfully parsed through
set "PARSED_REPOSITORIES=0"
REM Set a flag to get the total number of repositories in the folder
set "NBM_OF_REPOSITORIES=0"

REM Iterate through each subdirectory (assumed to be Git repositories)
for /D %%REPO in (%WORKSPACE_PATH%) do (
  if exist "%%REPO\.git" (
    set /a "NBM_OF_REPOSITORIES+=1"
  )
  REM Check if the repository directory exists
  if exist "%%REPO" (
    echo Updating repository: %%REPO
    cd /d "%%REPO"
  
    REM Run git pull and display the output
    for /f "delims=" %%A in ('git pull 2^>^&1') do (
      echo %%A
    )

    cd /d "%WORKSPACE_PATH%"
ech
    REM Set the flag to true if the repository was parse
    set /a "PARSED_REPOSITORIES+=1"
  ) else (
    echo Repository %%REPO does not exist.
  )
)

REM Echo the final message only if updates were performed
if "%PARSED_REPOSITORIES%"=="%NBM_OF_REPOSITORIES%" (
  echo All repositories have been accesed.
)

endlocal