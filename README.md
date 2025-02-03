# goaddeploy
script for deploy LAB GOAD

# install packages
apt install vagrant ansible pip python3-pip git

# download script
git clone https://github.com/ljamel/goaddeploy.git

# deploy
bash goaddeploy/deploygoad.sh -p virtualbox

