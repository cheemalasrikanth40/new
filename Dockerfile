FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt install nginx php7.4 php7.4-fpm php7.4-cli php7.4-json php7.4-intl php7.4-soap php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath mysql-server default-jdk -y curl sudo gnupg -y &&\
apt-get update && apt remove apache2 -y && apt-get purge apache2 -y && apt-get autoremove apache2 -y && apt autoclean apache2 -y &&\ 
#apt update && apt install mysql-client && ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'kspl@1234'; CREAT DATABASE srikanth; CREATE USER 'srikanthc'@'localhost' IDENTIFIED BY 'kspl@1234'; GRANT ALL PRIVILEGES ON *.* TO 'srikanthc'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES; &&\
service mysql start && mysql -h localhost -u root -p123456789 -e "CREATE DATABASE kanthu; CREATE USER 'srikanth'@'localhost' IDENTIFIED BY '123456789';  GRANT ALL PRIVILEGES ON *.* TO 'srikanth'@'localhost' WITH GRANT OPTION;  FLUSH PRIVILEGES;" &&\ 
#curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - &&\
#echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list && apt update && apt install elasticsearch -y &&\
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - &&\
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list &&\
apt update -y && apt install elasticsearch -y &&\  
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"  &&\ 
php composer-setup.php && php -r "unlink('composer-setup.php');" &&\ 
mv composer.phar /usr/local/bin/composer 
#curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.16 
COPY Magento.sh / 
COPY auth.json /root/.config/composer/auth.json 
COPY php.ini /etc/php/7.4/fpm/php.ini 
COPY default /etc/nginx/sites-available/ 
COPY elasticsearch.yml /etc/elasticsearch/ 
ENTRYPOINT ["/Magento.sh"] 
EXPOSE 22 80 3306 9000 9200 
