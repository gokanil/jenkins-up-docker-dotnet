@ECHO OFF
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
PAUSE >NUL