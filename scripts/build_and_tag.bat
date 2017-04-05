@ECHO OFF

for /f %%i in ('docker build -q .') do set RESULT=%%i

docker tag %RESULT% mattjc/development_environment:latest
