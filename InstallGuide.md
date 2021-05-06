HERE MUST BE INSTALLATION GUIDE


sudo -s
clear
docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq)
rm -r abs  api  cards-bot  docker-node  docker-riak  exchange  frontend  gurosh  merchant-bot  nginx-proxy
git clone https://github.com/SudaPort/gurosh
cd gurosh
chmod u+x start.sh
./start.sh
