FROM debian:stable-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget lsb-release gnupg ca-certificates sudo --no-install-recommends
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb
RUN dpkg -i mysql-apt-config_0.8.13-1_all.deb && rm -f mysql-apt-config_0.8.13-1_all.deb
RUN apt-get update
RUN echo package_version: `apt-cache show mysql-router | grep Version | awk 'NR==1{ print $2 }'`
RUN apt-get -y install mysql-router --no-install-recommends && apt-get clean
COPY mysqlrouter_bootstrap.sh /opt
RUN chown -R mysqlrouter:mysqlrouter /opt && chmod +x /opt/mysqlrouter_bootstrap.sh
USER mysqlrouter
CMD /opt/mysqlrouter_bootstrap.sh ${MYSQLHOST} ${USER} ${PASSWORD} && /opt/mysqlrouter/start.sh && tail -f /opt/mysqlrouter/log/mysqlrouter.log
EXPOSE 6446 6447 64460 64470