# Set timezone locale
echo "Australia/Perth" | sudo tee /etc/timezone
export LANGUAGE=en_AU.utf-8
export LANG=en_AU.utf-8
export LC_ALL=en_AU.utf-8
sudo locale-gen en_AU.utf-8
sudo dpkg-reconfigure --frontend noninteractive tzdata locales

echo 'gem: --no-ri --no-rdoc' > .gemrc


sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get update
sudo apt-get -y install mysql-server-5.5 php5-mysql libsqlite3-dev apache2 php5 php5-dev build-essential php-pear curl


# Setup database
if [ ! -f /var/log/databasesetup ];
then
    echo "DROP DATABASE IF EXISTS test" | mysql -uroot -proot
    echo "CREATE USER 'devdb'@'localhost' IDENTIFIED BY 'devdb'" | mysql -uroot -proot
    echo "CREATE DATABASE devdb" | mysql -uroot -proot
    echo "GRANT ALL ON devdb.* TO 'devdb'@'localhost'" | mysql -uroot -proot
    echo "flush privileges" | mysql -uroot -proot

    sudo touch /var/log/databasesetup

    if [ -f /var/sqldump/database.sql ];
    then
        mysql -uroot -proot devdb < /var/sqldump/database.sql
    fi
fi


# Apache changes
if [ ! -f /var/log/webserversetup ];
then
    echo "ServerName localhost" | sudo tee /etc/apache2/httpd.conf > /dev/null
    sudo a2enmod rewrite
    sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default

    sudo touch /var/log/webserversetup
fi


# Install Mailcatcher
if [ ! -f /var/log/mailcatchersetup ];
then
    sudo /opt/vagrant_ruby/bin/gem install mailcatcher

    sudo touch /var/log/mailcatchersetup
fi


# Install xdebug
if [ ! -f /var/log/xdebugsetup ];
then
    sudo pecl install xdebug
    XDEBUG_LOCATION=$(find / -name 'xdebug.so' 2> /dev/null)

    sudo touch /var/log/xdebugsetup
fi


# Configure PHP
if [ ! -f /var/log/phpsetup ];
then
    sudo sed -i '/;sendmail_path =/c sendmail_path = "/opt/vagrant_ruby/bin/catchmail"' /etc/php5/apache2/php.ini
    sudo sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
    sudo sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/apache2/php.ini
    sudo sed -i '/html_errors = Off/c html_errors = On' /etc/php5/apache2/php.ini
    echo "zend_extension='$XDEBUG_LOCATION'" | sudo tee -a /etc/php5/apache2/php.ini > /dev/null

    sudo touch /var/log/phpsetup
fi

# Install drush
if [ ! -f /var/log/drushsetup ];
then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    composer global require drush/drush:6.*
    sed -i '1i export PATH="$HOME/.composer/vendor/bin:$PATH"' $HOME/.bashrc

    sudo touch /var/log/drushsetup
fi


# Make sure things are up and running as they should be
mailcatcher --http-ip=192.168.56.102
sudo service apache2 restart
