# goaddeploy
script for deploy LAB GOAD

# install packages
apt install vagrant ansible pip python3-pip git

# download script
git clone https://github.com/ljamel/goaddeploy.git

# deploy
bash goaddeploy/deploygoad.sh 

# start LAB
cd /opt/goad/ &&
bash goad.sh -p virtualbox

