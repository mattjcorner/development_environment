@ECHO OFF

SET HOSTNAME=mattdev
SET TERM=cygwin
SET ANSICON=true
docker run -ti -e TERM=%TERM% -v /var/run/docker.sock:/var/run/docker.sock -v /c/Users/%USERNAME%/Projects:/root/Projects -v /c/Users/%USERNAME%/.ssh:/root/.ssh -v /c/Users/%USERNAME%/.gitconfig:/root/.gitconfig --hostname %HOSTNAME% mattjc/linux_dev_environment:latest /bin/bash
