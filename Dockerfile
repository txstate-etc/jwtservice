FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apache2 libapache2-mod-perl2 build-essential cpanminus
RUN apt-get clean && rm -rf /tmp/* /var/tmp* /var/lib/apt/lists/*

RUN cpanm AuthCAS CGI Crypt::JWT DateTime DateTime::Format::Strptime

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
RUN a2enmod ssl
RUN a2enmod authnz_ldap
RUN a2enmod headers

RUN mkdir /ssl
RUN openssl req -newkey rsa:4096 -nodes -keyout /ssl/jwtservice.key.pem -out /ssl/jwtservice.csr -subj "/CN=localhost"
RUN openssl x509 -req -days 365 -in /ssl/jwtservice.csr -signkey /ssl/jwtservice.key.pem -out /ssl/jwtservice.cert.pem

COPY cmd.sh /cmd.sh
COPY entrypoint.sh /entrypoint.sh
COPY public/ /var/www/html/
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD https://raw.githubusercontent.com/txstate-etc/SSLConfig/master/SSLConfig-TxState.conf /etc/apache2/conf-enabled/ZZZ-SSLConfig-TxState.conf
RUN rm /var/www/html/index.html
RUN a2disconf security

RUN apt-get update && apt-get install libcgi-fast-perl libapache2-mod-fcgid -y

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]
