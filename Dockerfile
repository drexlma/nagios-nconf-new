FROM ubuntu:14.04
ENV env prod
ENV  DEBIAN_FRONTEND noninteractive
MAINTAINER <Talson Thomas>
RUN apt-get update

RUN groupadd nagcmd
RUN useradd nagios
RUN usermod -a -G nagcmd nagios

RUN apt-get install  -y libapache2-mod-auth-mysql php5-mysql bsd-mailx libmailtools-perl lockfile-progs mime-support postfix procmail bind9-host
RUN apt-get install -y wget vim curl build-essential s3cmd  php5 libapache2-mod-php5 php5-mcrypt supervisor apache2 iputils-ping locate telnetd 
RUN apt-get update \
    && apt-get install -y debconf-utils \
    && echo mysql-server-5.5 mysql-server/root_password password Nag123 | debconf-set-selections \
    && echo mysql-server-5.5 mysql-server/root_password_again password Nag123 | debconf-set-selections \
    && apt-get install -y mysql-server-5.5 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
    && apt-get install -y net-tools --fix-missing \
    && rm -rf /var/lib/apt/lists/* 

RUN curl -L -O  http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
RUN tar xvf nagios-*.tar.gz
RUN cd nagios-*&&./configure --with-nagios-group=nagios --with-command-group=nagcmd 
RUN cd nagios-*&&make all
RUN cd nagios-*&&make install
RUN cd nagios-*&&make install-commandmode
RUN cd nagios-*&&make install-init
RUN cd nagios-*&&make install-config
RUN cd nagios-*&&/usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf
RUN usermod -G nagcmd www-data
RUN curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
RUN tar xvf nagios-plugins-*.tar.gz
RUN cd nagios-plugins-*&&./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
RUN cd nagios-plugins-*&& make
RUN cd nagios-plugins-*&&make install
RUN a2enmod rewrite
RUN a2enmod cgi
RUN ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/
RUN touch /usr/local/nagios/etc/htpasswd.users
RUN echo "nagiosadmin:\$apr1\$Y.bXZGQu\$l6K/SiJ5Y/wMqH76PtWGo0">/usr/local/nagios/etc/htpasswd.users
RUN chmod a+x  /usr/local/nagios/bin/nagios
COPY create_database.sql /
COPY nagios.cfg /
COPY startup.sh /
COPY postfix.sh /
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY check_graphite_data /usr/local/nagios/libexec/
COPY check_http_for_keys /usr/local/nagios/libexec/
COPY check_port.pl /usr/local/nagios/libexec/
COPY .s3cfg /
 
RUN wget http://sourceforge.net/projects/nconf/files/nconf/1.3.0-0/nconf-1.3.0-0.tgz -O nconf.tgz
RUN tar xzvf nconf.tgz -C /var/www
RUN chown -R www-data:www-data /var/www/nconf
RUN wget https://bootstrap.pypa.io/ez_setup.py -O - | python
RUN easy_install pip
RUN pip install argparse requests
COPY event_publisher.py /usr/local/bin/
COPY deploy_local.sh /var/www/nconf/ADD-ONS/
COPY check_ping /usr/local/nagios/libexec/
COPY postfix/* /etc/postfix/
RUN chown -R www-data:www-data /usr/local/nagios/etc/resource.cfg
CMD ["/usr/bin/supervisord"]

EXPOSE 80
