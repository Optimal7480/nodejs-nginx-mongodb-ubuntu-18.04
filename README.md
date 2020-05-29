# Automated installation of nodejs project with nginx proxy on Ubuntu-18.04 LTS

Shell scripts and config files to install nodejs with nginx proxy on Ubuntu 18.04 LTS

# Howto

Clone this repository into your home folder and run the shell script.
On a fresh Ubuntu 18.04 installation please install git before you start.
You need to setup A-Records for you domain. E.g. \*.example.com or the named subdomains you are going to choose during setup. Don't use AAAA records as they will cause letsencrypt failing the verification. You are asked if you want installation as a first question. This is only required the first time.

```
git clone https://github.com/romanstark/nodejs-nginx-mongodb-ubuntu-18.04.git
cd ./nodejs-nginx-mongodb-ubuntu-18.04
./run.sh
```

Wou will be asked if you want to install the server components (nodejs nginx software-properties-common python-certbot-nginx, pm2), if you want MongoDb (mongodb-org, mongodb-runner) as well. Then you eill need to anwer your domain, email, port of nodejs app and the path where the app folder will be created. You need sudo rigths.

## Features

> Letsencrypt SSL certbot@0.27.0

> mongodb-runner@4.8.0

> nginx@1.14.0

> nodejs@12.17.0

> npm@6.14.4

> pm2@4.4.0

## Author

Roman Stark

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/romanstark)

## Need App Development?

Please see https://www.vanedler.de

## NEED HELP?

Support via Email

email: mail@romanstark.de
web: https://www.romanstark.de

## Thanks

Roman Stark