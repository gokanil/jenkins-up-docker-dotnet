@ECHO OFF
SET /P github="Enter your github repository url: "
SET /P dockerhub="Enter your dockerhub repository name: "
SET githubProject=%github:~0,-4%
ECHO Setup is started...
docker-compose down
RMDIR jenkins_data /S/Q
XCOPY jobs jenkins_data\jobs /Y/I/E
FOR /R jenkins_data\jobs %%i IN (config.xml) DO (
IF EXIST %%i (
ECHO %%i
PowerShell.exe -Command "& {(Get-Content %%i).replace('<github>', '%github%').replace('<dockerhub>', '%dockerhub%').replace('<githubproject>', '%githubProject%') | Set-Content %%i}"))
))
docker-compose up -d --build
CD ASPNETCORE-Sample-For-Jenkins
CALL create-mvc-sample.bat %dockerhub% dockerhub
CALL github-push-sample.sh "%github%"
START %githubproject%/settings/hooks
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
