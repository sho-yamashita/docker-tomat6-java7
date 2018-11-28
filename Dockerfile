FROM java:7-jre

EXPOSE 8080 8778

ENV TOMCAT_VERSION 6.0.44
ENV DEPLOY_DIR /maven


# Get and Unpack Tomcat
RUN wget http://archive.apache.org/dist/tomcat/tomcat-6/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz && tar xzf /tmp/catalina.tar.gz -C /usr/local && mv /usr/local/apache-tomcat-${TOMCAT_VERSION} /usr/local/tomcat && rm /tmp/catalina.tar.gz

# Add roles
ADD tomcat-users.xml /usr/local/tomcat/conf/

# Set Encode
ADD server.xml /usr/local/tomcat/conf/server.xml

# Startup script
ADD deploy-and-run.sh /usr/local/tomcat/bin/

# Remove unneeded apps
RUN rm -rf /usr/local/tomcat/webapps/examples /usr/local/tomcat/webapps/docs 

VOLUME ["/usr/local/tomcat/logs", "/usr/local/tomcat/work", "/usr/local/tomcat/temp", "/tmp/hsperfdata_root" ]

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

# install ps command(for confirm java_opts)
RUN apt-get update && apt install -y procps

# set timezone
RUN cp /usr/share/zoneinfo/Japan /etc/localtime
ENV JAVA_OPTS="-Duser.timezone=Asia/Tokyo -Duser.language=ja -Duser.country=JP"

# set memory space
ENV JAVA_OPTS=$JAVA_OPTS"-Xms2g -Xmx2g -XX:MaxPermSize=256m -XX:PermSize=256m -XX:+HeapDumpOnOutOfMemoryError"

# for remote debug 
ENV JPDA_ADDRESS="8000"
ENV JPDA_TRANSPORT="dt_socket"
EXPOSE 8080

CMD /usr/local/tomcat/bin/deploy-and-run.sh
