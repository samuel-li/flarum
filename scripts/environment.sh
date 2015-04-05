#! /bin/bash

su - vagrant
### Setup NPM globals and create necessary directories ###
sudo apt-get install -y phantomjs zsh exuberant-ctags
mkdir /home/vagrant/npm
mkdir -p /opt/flarum/flarum/core
sudo chown -R vagrant:vagrant /home/vagrant

cp /opt/flarum/scripts/aliases ~/.aliases

### Create rc file ###
if [ -e "/home/vagrant/.zshrc" ]
then
    echo "source ~/.aliases" >> ~/.zshrc
else
    echo "source ~/.aliases" >> ~/.bashrc
fi

### Set up environment files and database ###
cp /opt/flarum/.env.example /opt/flarum/.env
mysql -u root -plihl198073, -e 'create database flarum'

### Setup flarum/core and install dependencies ###
cd /opt/flarum/core
composer install --prefer-dist
cd /opt/flarum
composer install --prefer-dist
composer dump-autoload

mkdir /opt/flarum/core/public
cd /opt/flarum/core/ember/common
npm install
bower install
ember build
cd /opt/flarum/core/ember/forum
npm install
bower install
ember build
cd /opt/flarum/core/ember/admin
npm install
bower install
ember build

### Prepare the database
cd /opt/flarum
php artisan flarum:install
php artisan flarum:seed
