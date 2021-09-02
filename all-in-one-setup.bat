@ECHO OFF
SET /P github="Enter your github repository url: "
SET /P dockerhub="Enter your dockerhub repository name: "
ECHO Setup is started...
docker-compose down /Q
RMDIR jenkins_data /S/Q
SETLOCAL EnableDelayedExpansion
FOR /R jobs %%i IN (config.xml) DO (
IF EXIST %%i (
ECHO %%i
FOR %%x IN (%%i) DO SET path=%%~dpx
set path=!path:~0,-1!
FOR %%y IN (!path!) DO SET parent=%%~nxy
MKDIR jenkins_data\jobs\!parent!
FOR /F "tokens=* delims= " %%a IN (%%i) DO (
 SET str=%%a
 SET str=!str:^<github^>=%github%!
 SET str=!str:^<dockerhub^>=%dockerhub%!
 ECHO !str!>>jenkins_data\jobs\!parent!\config.xml
)))
ENDLOCAL
docker-compose up -d --build
CD ASPNETCORE-Sample-For-Jenkins
RMDIR sample-mvc /S/Q
CALL create-mvc-sample.bat %dockerhub% dockerhub
CALL github-push-sample.sh "%github%"
START %github:~0,-4%/settings/hooks
START bind-ngrok.bat
ECHO -----------------------------------------------------
ECHO After ngrok application starts, you can add webhook from https://github.com/[USER]/test/settings/hooks
ECHO template: [ngrokurl]/github-webhook/
CD..
echo waiting initialAdminPassword . . .
:WaitForPassword
ECHO | CALL jenkins-get-first-key.bat >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 goto :WaitForPassword
ECHO | CALL jenkins-get-first-key.bat
ECHO[
PAUSE
