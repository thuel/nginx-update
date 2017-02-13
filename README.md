# nginx-update
script to update self compiled nginx versions

You have to provide to the script the new version of nginx you wish to install. The command sequence is as follows:
nginxupd.sh --prepare #.##.##
nginxupd.sh --upgrade
Then please test that the configuration is working and the service on the server are runnig.
If the test is successful, finish the installation with
nginxupd.sh --complete

If the test is not successful, transisson back to the old master process with
sudo kill -s HUP $(cat /run/nginx.pid.oldbin)
Then stop the buggy master process with
sudo kill -s QUIT $(cat /run/nginx.pid)

If the above does not work for any reason, you can try just sending the new master server the TERM signal, 
which should initiate a shutdown. This should stop the new master and any workers while automatically kicking 
over the old master to start its worker processes. If there are serious problems and the buggy workers are 
not exiting, you can send each of them a KILL signal to clean up. This should be viewed as a last resort, 
however, as it will cut off connections.
After transitioning back to the old binary, remember that you still have the new version installed on your 
system. You should remove the buggy version and roll back to your previous version so that Nginx will run 
without issues on reboot.
