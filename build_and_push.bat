@ECHO OFF

for /f %%i in ('docker build -q .') do set RESULT=%%i

docker tag %RESULT% mattjc/linux_dev_environment:latest
docker push mattjc/linux_dev_environment:latest
