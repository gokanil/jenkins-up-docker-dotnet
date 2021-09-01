@ECHO OFF
SET /P github="Enter your github repository url: "
SET /P dockerhub="Enter your dockerhub repository name: "
ECHO Setup is started...
docker-compose down /Q
RMDIR jenkins_data /S/Q
XCOPY jobs jenkins_data\jobs /Y/I/E
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
ECHO | CALL jenkins-get-first-key.bat
ECHO[
PAUSE
