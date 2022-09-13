#!/bin/bash 
useradd -m -d /home/admin srikanth 
echo "srikanth:srikanth" | chpasswd 
echo "srikanth ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers &&\ 
service mysql start -y && service elasticsearch start -y && service nginx start -y && service php7.4-fpm start -y &&\ 
composer create-project --no-interaction --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.3 /var/www/html/magento 
php bin/magento setup:install \ 
--base-url=http://srikanthc.com \ 
--db-host=localhost \ 
--db-name=kanthu \ 
--db-user=srikanth \ 
--db-password=123456789 \ 
--admin-firstname=admin \ 
--admin-lastname=admin \ 
--admin-email=admin@admin.com \ 
--admin-user=admin \ 
--admin-password=admin123 \ 
--language=en_US \ 
--currency=USD \ 
--timezone=America/Chicago \ 
--use-rewrites=1 \ 
--search-engine=elasticsearch7 \ 
--elasticsearch-host=localhost \ 
--elasticsearch-port=9200 
php bin/magento setup:di:compile && php bin/magento setup:static-content:deploy -f && php bin/magento c:c && php bin/magento c:f 
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + && chown -R :www-data . && chmod u+x bin/magento && chmod -R 777 var generated 
 
