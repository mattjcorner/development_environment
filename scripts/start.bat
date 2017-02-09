@ECHO OFF

SET HOSTNAME=mattdev
SET USERHOME=%HOME%

REM Set TERM to cygwin to enable scrolling in apps like vim
SET TERM=cygwin
SET ANSICON=true

docker run -ti -e TERM=%TERM% -v /var/run/docker.sock:/var/run/docker.sock^
 -v %USERHOME:\=/%/.docker:/root/.docker:ro^
 -v %USERHOME:\=/%/Projects:/root/Projects^
 -v %USERHOME:\=/%/.ssh/id_rsa:/tmp/id_rsa:ro^
 -v %USERHOME:\=/%/.gitconfig:/root/.gitconfig^
 -v %USERHOME:\=/%/.aws:/root/.aws:ro^
 --hostname %HOSTNAME%^
 mattjc/linux_dev_environment:latest /bin/bash
