@ECHO OFF
SET security=false
SET message=Security is disabled.
docker exec jenkins true
IF %ERRORLEVEL% NEQ 0 EXIT /B
FOR /F "delims=" %%i IN ('docker exec jenkins grep "<useSecurity>true<\/useSecurity>" "/var/jenkins_home/config.xml" ') DO SET "result=%%i"
IF "%result%"=="" (
   SET security=true
   SET message=Security is enabled.
)
docker exec jenkins sed -i "s/<useSecurity>\(.*\)<\/useSecurity>/<useSecurity>%security%<\/useSecurity>/g" /var/jenkins_home/config.xml
ECHO %message%
PAUSE >NUL
