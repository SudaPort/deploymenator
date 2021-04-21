#!/bin/bash
RED=`tput setaf 1`
GREEN=`tput setaf 2`
NC=`tput sgr0`
chmod u+r+w+x ./logo.sh
./logo.sh
DEPLOYMENATOR_DIR=${PWD}
SEEDS_FILE="seeds.txt"
PROJECT_NAME="Gurosh"
RIAK_PORT=8098

DEFAULT_NETWORK_PASSPHRASE="Gurosh Network ; April 2021"
DEFAULT_SMTP_HOST="smtp.gmail.com"
DEFAULT_SMTP_PORT=465
DEFAULT_SMTP_SECURITY="ssl"
DEFAULT_SMTP_USERNAME="openbankit.notifications.test@gmail.com"
DEFAULT_SMTP_PASSWORD="k1Yu^(>=]2)C[](+nH7o" 

DOCKER_RIAK_REPO="github.com/SudaPort/docker-riak.git"
DOCKER_NODE_REPO="github.com/SudaPort/docker-node.git"
NGINX_PROXY_REPO="github.com/SudaPort/nginx-proxy.git"
MICRO_REPOS=(
    "github.com/SudaPort/abs.git"
    "github.com/SudaPort/api.git"
    "github.com/SudaPort/cards-bot.git"
    "github.com/SudaPort/merchant-bot.git"
    "github.com/SudaPort/exchange.git"
    "github.com/SudaPort/frontend.git"
)

PROTOCOL_HOST_REGEX='(https?:\/\/(www\.)?[-a-zA-Z0-9]{2,256}\.[a-z]{2,6})|((https?:\/\/)?([0-9]{1,3}\.){3}([0-9]{1,3}))(\:?[0-9]{1,5})?(\/)?'

# $1 - repository address (for instance: https://github.com/SudaPort/deploymenator)
# $2 - branch (or tag) to be cloned (main)
function download_repo {
    dir=$(basename "$1" ".git")
    dir=${DEPLOYMENATOR_DIR}/../${dir}
    if [[ -d "$dir" ]]; then
        echo "Folder $dir already exists"
    else
        git clone -b $2 "https://$1" $dir
    fi

    echo "$dir"
}

function makeconfig {
    cd $1 && cp -f ${DEPLOYMENATOR_DIR}/default.env .env
}

# Getting necessary information from user input =====================================================
# ip address of the host
while true
do
    read -ra HOST_IP -p "${GREEN}Enter the IP address of the host (must be available for other nodes): ${NC}"
    HOST_IP=${HOST_IP,,}
    HOST_IP=${HOST_IP#http://}
    HOST_IP=${HOST_IP#https://}
    if [[ ! $HOST_IP =~ $PROTOCOL_HOST_REGEX ]]; then
        echo "Error: address [$HOST_IP] is not valid!"
        continue
    else
        read -ra response -p "${GREEN}Confirm the IP address: ${HOST_IP}? [Y/n]${NC} "
        if [[ -z $response || $response = [yY] ]]; then
            break 
        fi 
    fi
done

echo "-------------------------------------------------------------------------------------------------------------"
# domain for all services
while true
do
    read -ra DOMAIN -p "${GREEN}Enter the domain name for all services (without port and protocol):${NC} "
    read -ra response -p "${GREEN}Confirm the domain name: ${DOMAIN}? [Y/n]${NC} "
    if [[ -z $response || $response = [yY] ]]; then
        break 
    fi
done

echo "-------------------------------------------------------------------------------------------------------------"
# SMTP credentials

read -ra response -p "${GREEN}Use default SMTP?: [Y/n]${NC} "
    if [[ -z $response || $response = [yY] ]]; then 
      smtp_host=$DEFAULT_SMTP_HOST
      smtp_port=$DEFAULT_SMTP_PORT
      smtp_security=$DEFAULT_SMTP_SECURITY
      smtp_user=$DEFAULT_SMTP_USERNAME
      smtp_pass=$DEFAULT_SMTP_PASSWORD
    else
      read -p "${GREEN}Enter SMTP host:${NC}" smtp_host;
      read -p "${GREEN}Enter SMTP port:${NC}" smtp_port;
      read -p "${GREEN}Enter SMTP security:${NC}" smtp_security;
      read -p "${GREEN}Enter SMTP username:${NC}" smtp_user;
      read -p "${GREEN}Enter SMTP password:${NC}" smtp_pass;
    fi
echo "Using the default SMTP server configuration."
echo "SMTP host: ${smtp_host}"
echo "SMTP port: ${smtp_port}"
echo "SMTP security: ${smtp_security}"
echo "SMTP username: ${smtp_user}"

echo "-------------------------------------------------------------------------------------------------------------"

read -ra response -p "${GREEN}Press Enter to continue setup…${NC} "
apt-get install build-essential

echo " =============================Checking for Docker============================================================="

if [ -x "$(command -v docker)" ]; then
    echo "***************************Docker is installed************************************************************"
    service docker start
else
    echo "*****************************Installing docker***********************************************************"
    
    read -ra response -p "${GREEN}Press Enter to continue setup…${NC} "
    apt -y install dirmngr --install-recommends
    apt -y install git curl make apt-transport-https ca-certificates gnupg lsb-release
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker "$SUDO_USER"
    service docker start
fi

echo " =============================Installing Docker Compose======================================================="
  
  read -ra response -p "${GREEN}Press Enter to continue setup…${NC} "
  curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  current_user=''
  if [ "$SUDO_USER" ];
  then
    current_user="$SUDO_USER"
  elif [ $USER != "root" ];
  then
    current_user="$USER"
  else
    echo "Input your user name, please:"
    read current_user
   fi
# Giving non-root access (optional)
groupadd docker
gpasswd -a "$current_user" docker
service docker restart

echo "===============================Building docker-riak=============================================================" 

read -ra response -p "${GREEN}Press Enter to continue setup…${NC} "
GIT_BRANCH='main'

dir=$(download_repo $DOCKER_RIAK_REPO $GIT_BRANCH)

cd "$dir"
rm -f ./.env
echo "RIAK_HOST=$HOST_IP" >> ./.env
echo "DOMAIN=$HOST_IP" >> ./.env
echo "HOST=$HOST_IP" >> ./.env

make build
sleep 3
make status

cd "$DEPLOYMENATOR_DIR"


echo "=================================Building Gurosh-core docker =========================================" 

read -ra response -p "${GREEN}Press Enter to continue setup…${NC} "
GIT_BRANCH='main'

dir=$(download_repo $DOCKER_NODE_REPO $GIT_BRANCH)
cd "$dir"
sed -i -e "s/NETWORK_PASSPHRASE=.*$/NETWORK_PASSPHRASE=${DEFAULT_NETWORK_PASSPHRASE}/g" ./.env

# building node
echo "Starting to build Node, this may take nearly 40 minutes"
sleep 3
make build
sleep 3
# generating seed for master and fee agent accounts
echo "*********************************Generating seeds *********************************************************"
GENSEED="$(docker run --rm crypto/core src/stellar-core --genseed)"
MASTER_SEED=${GENSEED:13:56}
MASTER_PUBLIC_KEY=${GENSEED:82:56}

GENSEED="$(docker run --rm crypto/core src/stellar-core --genseed)"
COMISSION_SEED=${GENSEED:13:56}
COMISSION_PUBLIC_KEY=${GENSEED:82:56}

rm -f ${DEPLOYMENATOR_DIR}/${SEEDS_FILE}
echo "MASTER_SEED=${MASTER_SEED}" >> ${DEPLOYMENATOR_DIR}/${SEEDS_FILE}
echo "MASTER_PUBLIC_KEY=${MASTER_PUBLIC_KEY}" >> ${DEPLOYMENATOR_DIR}/${SEEDS_FILE}
echo "" >> ${DEPLOYMENATOR_DIR}/${SEEDS_FILE}
echo "FEE_AGENT_SEED=${COMISSION_SEED}" >> ${DEPLOYMENATOR_DIR}/${SEEDS_FILE}
echo "FEE_AGENT_PUBLIC_KEY=${COMISSION_PUBLIC_KEY}" >> ${DEPLOYMENATOR_DIR}/${SEEDS_FILE}

echo $'\n'
echo "Master's and Fee Agent's credentials were written to ${DEPLOYMENATOR_DIR}/${SEEDS_FILE}"
echo $'\n'
sleep 3

# creating validator
echo "*****************************************************Creating validator ****************************************"
GENSEED="$(docker run --rm crypto/core src/stellar-core --genseed)"
NODE_SEED=${GENSEED:13:56}
NODE_PUBLIC_KEY=${GENSEED:82:56}

IS_VALIDATOR='true'
RIAK_PROTOCOL_HOST_PORT="http://${HOST_IP}:${RIAK_PORT}" 

echo "Using Master Public Key: ${MASTER_PUBLIC_KEY}"
echo "Using Fee Agent Public Key: ${COMISSION_PUBLIC_KEY}"
echo "Using Riak host: ${RIAK_PROTOCOL_HOST_PORT}"
sleep 3
rm -f ./.core-cfg
sleep 1

cd "$DEPLOYMENATOR_DIR"

echo "=========================================Building nginx-proxy ==================================================="

read -ra response -p "${GREEN}Press Enter to continue setup…${NC} "
GIT_BRANCH='main'

dir=$(download_repo $NGINX_PROXY_REPO $GIT_BRANCH)

cd "$dir"
chmod u+x+r+w ./docker/nginx/entrypoint.sh
rm -f ./.env
echo "DOMAIN=${DOMAIN}" >> ./.env
echo "HORIZON_NP_HOST=${HOST_IP}" >> ./.env
echo "RIAK_NP_HOST=${HOST_IP}" >> ./.env
echo "SERVICES_NP_HOST=${HOST_IP}" >> ./.env

make build
sleep 1
make start
sleep 3
make state

cd "$DEPLOYMENATOR_DIR"


echo " =====================================Building microservices======================================================"

read -ra response -p "${GREEN}Press Enter to continue setup…${NC} "
GIT_BRANCH="main"

rm -f ./clear.env
echo "MASTER_KEY=${MASTER_PUBLIC_KEY}" >> ./clear.env
echo "HORIZON_HOST=http://sehab.${DOMAIN}" >> ./clear.env
echo "EMISSION_HOST=http://emission.${DOMAIN}" >> ./clear.env
echo "EMISSION_PATH=issue" >> ./clear.env
echo "RIAK_HOST=riak.${DOMAIN}" >> ./clear.env
echo "RIAK_PORT=80" >> ./clear.env
echo "API_HOST=http://api.${DOMAIN}" >> ./clear.env
echo "INFO_HOST=http://info.${DOMAIN}" >> ./clear.env
echo "EXCHANGE_HOST=http://exchange.${DOMAIN}" >> ./clear.env
echo "HELP_URL=http://${DOMAIN}/docs/api-reference" >> ./clear.env
echo "WELCOME_HOST=http://welcome.${DOMAIN}" >> ./clear.env
echo "MERCHANT_HOST=http://merchant.${DOMAIN}" >> ./clear.env
echo "STELLAR_NETWORK=${DEFAULT_NETWORK_PASSPHRASE}" >> ./clear.env
echo "DOMAIN=${DOMAIN}" >> ./clear.env
echo "HOST=${HOST_IP}" >> ./clear.env
echo "PROJECT_NAME=${PROJECT_NAME}" >> ./clear.env

cp -f ./clear.env default.env

echo "SMTP_HOST=$smtp_host" >> ./default.env;
echo "SMTP_PORT=$smtp_port" >> ./default.env;
echo "SMTP_SECURITY=$smtp_security" >> ./default.env;
echo "SMTP_USER=$smtp_user" >> ./default.env;
echo "SMTP_PASS=$smtp_pass" >> ./default.env;

for i in "${MICRO_REPOS[@]}"
do
   dir=$(basename "$i" ".git")
   dir=${DEPLOYMENATOR_DIR}/../${dir}

   if [[ -d "$dir" ]]; then
       cd $dir && echo "*******************************Installing $dir ********************************" && makeconfig $dir && make build && cd ${DEPLOYMENATOR_DIR}/..
   else
       dir=$(download_repo $i $GIT_BRANCH)
       cd $dir && echo "********************************Installing $dir ********************************" && makeconfig $dir && make build && cd ${DEPLOYMENATOR_DIR}/..
   fi
done

echo "***************************************************make indexes on api...*******************************"
cd ${DEPLOYMENATOR_DIR}/../api && sleep 1 && make indexes
echo "*******************************************************************************************************************"
echo "*                 Complete                 Complete                 Complete                 Complete             *"
echo "*                 Complete                 Complete                 Complete                 Complete             *"
echo "*******************************************************************************************************************"