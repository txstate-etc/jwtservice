FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apache2 libapache2-mod-perl2 build-essential cpanminus
RUN apt-get clean && rm -rf /tmp/* /var/tmp* /var/lib/apt/lists/*

RUN cpanm AuthCAS CGI Crypt::JWT DateTime DateTime::Format::Strptime

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

COPY cmd.sh /cmd.sh
COPY public/ /var/www/html/
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD https://raw.githubusercontent.com/txstate-etc/SSLConfig/master/SSLConfig-TxState.conf /etc/apache2/conf-enabled/ZZZ-SSLConfig-TxState.conf
RUN rm /var/www/html/index.html

EXPOSE 80
CMD ["/cmd.sh"]
