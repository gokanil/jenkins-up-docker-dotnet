@ECHO OFF
CD files
IF NOT EXIST ngrok.exe (
curl -o ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-386.zip
powershell Expand-Archive ngrok.zip -DestinationPath ./
del ngrok.zip /f /q
)
ngrok http 8080