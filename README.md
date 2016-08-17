# nginx-update
script to update self compiled nginx versions

You have to provide to the script the new version of nginx you wish to install. The command sequence is as follows:
nginxupd.sh --prepare #.##.##
nginxupd.sh --upgrade
Then please test that the configuration is working and the service on the server are runnig.
If the test is successful, finish the installation with
nginxupd.sh --complete