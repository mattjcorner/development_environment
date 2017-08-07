@ECHO OFF

SET HOSTNAME=mattdev
SET DRIVELETTER=u
SET USERHOME=/%DRIVELETTER%%HOMEPATH%
SET DOWNLOADSFOLDER=/e/Users/mattjc/Downloads

REM Set TERM to cygwin to enable scrolling in apps like vim
SET TERM=cygwin
SET ANSICON=true

docker run -ti -e TERM=%TERM% -v /var/run/docker.sock:/var/run/docker.sock^
 -v %USERHOME:\=/%/.docker:/root/.docker:rw^
 -v %USERHOME:\=/%/Projects:/root/Projects^
 -v %USERHOME:\=/%/.ssh:/tmp/.ssh:ro^
 -v %USERHOME:\=/%/.gitconfig:/root/.gitconfig^
 -v %USERHOME:\=/%/.aws:/root/.aws:rw^
 -v %USERHOME:\=/%/.pypirc:/root/.pypirc:ro^
 -p 80:80^
 -p 8001:8001^
 -p 8080:8080^
 -p 8081:8081^
 --hostname %HOSTNAME%^
 %* mattjc/development_environment:latest /bin/bash
