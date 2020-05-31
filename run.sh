#!/bin/bash
# GET ALL USER INPUT
tput setaf 4; echo "Welcome to nodejs/spa nginx server on Ubuntu 18.04 install bash script!"; sleep 2;
tput setaf 2;
read -n 1 -p "Install the server compontents? Usually needed only on fresh system. (y/n) " INSTALL;
echo
tput setaf 3;
echo "Domain Name (eg. example.com)?"
read DOMAIN
echo "Your Email-Address for important letsencrypt account notifications?"
read EMAIL
echo "Setup an nodejs App or an SPA (like Angular)? (node/spa)"
read TYPE
if [ "$TYPE" == "node" ] ;then
  echo "How to name the nodejs start file? E.g. app.js, index.js, main.js,..."
  read NAME
  echo "The internal port on which the nodejs App should run. E.g. 3000. This port must not be used yet!"
  read PORT
fi
echo "Where should the app be placed? E.g. /var/www/html or $(pwd). Make sure all path segments are chmod 755!"
read FOLDER

# If blank server install software components
if [ "$INSTALL" == "y" ] ;then
  tput setaf 2;
  read -n 1 -p "Install MongoDb as well? (y/n) " MONGO;
  echo
  echo
  tput sgr0;
	echo "Installing..."; sleep 1;
	sudo add-apt-repository -y ppa:certbot/certbot
  if [ "$MONGO" == "y" ] ;then
	  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
	  echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
	fi
  sudo apt-get update
	sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  if [ "$MONGO" == "y" ] ;then
	  sudo apt-get install -y nodejs nginx software-properties-common python-certbot-nginx mongodb-org
	  sudo service mongod start
	  sudo systemctl enable mongod.service
  else
    sudo apt-get install -y nodejs nginx software-properties-common python-certbot-nginx
  fi
	sudo mv /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-available/nginx.conf.backup
	sudo cp $(pwd)/nginx.conf /etc/nginx/
  sudo unlink /etc/nginx/sites-enabled/default
	sudo systemctl reload nginx
	tput setaf 2; echo "Downloading ssl_dhparam from mozilla.org..."; sleep 1;
	tput sgr0
	sudo curl https://ssl-config.mozilla.org/ffdhe2048.txt > /etc/ssl/ffdhe4096.pem
	tput setaf 2; echo "Installing PM2 globally..."; sleep 1;
	tput sgr0
  if [ "$MONGO" != "y" ] ;then
	    npm install -g mongodb-runner --no-optional --no-shrinkwrap
  fi
  sudo npm install -g pm2@latest --no-optional --no-shrinkwrap
  sudo pm2 set pm2:autodump true
  sudo pm2 startup
	tput setaf 4; echo "Installation of packages complete."; sleep 3;
	tput sgr0
fi

# Create the hello world app
if [ "$TYPE" == "node" ] ;then
  tput setaf 2; echo "Configuring the nodejs hello world app."; sleep 1;
else
  tput setaf 2; echo "Configuring the spa hello world app."; sleep 1;
fi
echo
tput sgr0
mkdir $FOLDER/$DOMAIN
if [ "$TYPE" == "node" ] ;then
  cp $(pwd)/hello-world.app.js $FOLDER/$DOMAIN/$NAME
  sed -i -e "s/PORT/$PORT/" $FOLDER/$DOMAIN/$NAME
  pm2 start --name $DOMAIN $FOLDER/$DOMAIN/$NAME
  pm2 save
else
  cp $(pwd)/hello-world.html $FOLDER/$DOMAIN/index.html
fi

# Setup the domain
tput setaf 2; echo "Configuring your domain $DOMAIN."; sleep 2;
echo
tput sgr0
if [ "$TYPE" == "node" ] ;then
  sudo cp $(pwd)/nginx-virtual.node.conf /etc/nginx/sites-available/$DOMAIN.conf
  sudo sed -i -e "s/PORT/$PORT/" /etc/nginx/sites-available/$DOMAIN.conf
else
  sudo cp $(pwd)/nginx-virtual.spa.conf /etc/nginx/sites-available/$DOMAIN.conf
  sudo sed -i -e "s+FOLDER+$FOLDER+" /etc/nginx/sites-available/$DOMAIN.conf
fi
sudo sed -i -e "s/example.com/$DOMAIN/" /etc/nginx/sites-available/$DOMAIN.conf
sudo ln -s /etc/nginx/sites-available/$DOMAIN.conf /etc/nginx/sites-enabled/
sudo systemctl reload nginx

tput setaf 2; echo "Setting up SSL..." sleep 1;
tput sgr0
sudo certbot --nginx --agree-tos -n -m $EMAIL -d $DOMAIN
sudo systemctl reload nginx

tput setaf 4;  echo "Installation & configuration succesfully finished. Happy coding."
echo
sleep 1;
tput setaf 2; echo "Need app or backend development in germany? See https://www.vanedler.de"
sleep 1;
echo "E-mail: mail@romanstark.de"
echo "Bye!"
echo
tput sgr0