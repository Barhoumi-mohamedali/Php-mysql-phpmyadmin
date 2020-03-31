FROM php:7.0.30-apache
RUN docker-php-ext-install mysqli



COPY  ./www /var/www/html/

#Adding current user to www-data
RUN adduser root www-data

#change ownership to user:www-data and 
RUN chown -R root:root /var/www/html/
RUN chown root:www-data -R /var/www/html
RUN chmod u=rwX,g=srX,o=rX -R /var/www/html

#change file permissions of existing files and folders to 755/644
RUN find /var/www/html -type d -exec chmod g=rwxs "{}" \;
RUN find /var/www/html -type f -exec chmod g=rws "{}" \;

#RUN chown -R root:root /var/www/html/
#RUN chmod -R 755 /var/www/html/
#RUN chmod a+r /var/www/html/*

RUN rm -f /etc/apache2/apache2.conf
ADD  apache2.conf /etc/apache2/


RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN rm -f /etc/apache2/sites-available/000-default.conf
ADD  000-default.conf /etc/apache2/sites-available/

RUN rm -f /etc/apache2/sites-enabled/000-default.conf
ADD  000-default.conf /etc/apache2/sites-enabled/

Run a2enmod rewrite 
RUN rm -f /var/run/apache2/apache2.pid
RUN /etc/init.d/apache2 restart 

CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]



#RUN rm -f /var/run/apache2/apache2.pid
#RUN /etc/init.d/apache2 stop 
#RUN /etc/init.d/apache2 start 
#RUN /etc/init.d/apache2 reload 








EXPOSE 80



#RUN echo "ServerName localhost" >> /etc/apache2/sites-available/000-default.conf



# Copy apache vhost file to proxy php requests to php-fpm container
#COPY demo.apache.conf /usr/share/apache2/demo.apache.conf
#RUN echo "Include /usr/local/apache2/demo.apache.conf" \
#   >> /etc/apache2/sites-available/000-default.conf

