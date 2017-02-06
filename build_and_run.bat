@ECHO OFF

for /f %%i in ('docker build -q .') do set RESULT=%%i

docker run -ti -v /var/run/docker.sock:/var/run/docker.sock %RESULT% /bin/bash
