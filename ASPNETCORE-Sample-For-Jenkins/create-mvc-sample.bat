@ECHO OFF
:thnx: https://stackoverflow.com/questions/2541767/what-is-the-proper-way-to-test-if-a-parameter-is-empty-in-a-batch-file
SET "dockerhub=%~1"
SET "param2=%~2"
setlocal EnableDelayedExpansion
IF "!dockerhub!"=="" (
IF "!param2!"=="" (
SET /p dockerhub="Enter your dockerhub repository name for docker-compose: "
))
RMDIR sample-mvc /S/Q
dotnet new mvc --language C# --output sample-mvc\sample-mvc --name sample-mvc -f net5.0
dotnet add sample-mvc\sample-mvc package Microsoft.VisualStudio.Azure.Containers.Tools.Targets --version 1.11.1
PowerShell.exe -Command "& {(Get-Content 'files\docker-compose.yml').replace('<image>', '!dockerhub!') | Set-Content 'sample-mvc/docker-compose.yml'}"
ENDLOCAL
XCOPY files\.dockerignore sample-mvc /Y
XCOPY files\Dockerfile sample-mvc /Y
XCOPY files\jenkinsfile sample-mvc /Y
curl -o sample-mvc/.gitignore https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore --ssl-no-revoke