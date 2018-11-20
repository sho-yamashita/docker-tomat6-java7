FROM java:7-jre

EXPOSE 8080 8778

ENV TOMCAT_VERSION 6.0.44
ENV DEPLOY_DIR /maven


# Get and Unpack Tomcat
RUN wget http://archive.apache.org/dist/tomcat/tomcat-6/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz && tar xzf /tmp/catalina.tar.gz -C /opt && mv /usr/local/apache-tomcat-${TOMCAT_VERSION} /usr/local/tomcat && rm /tmp/catalina.tar.gz

# Add roles
ADD tomcat-users.xml /usr/local/tomcat/conf/

# Startup script
ADD deploy-and-run.sh /usr/local/tomcat/bin/

# Remove unneeded apps
RUN rm -rf /usr/local/tomcat/webapps/examples /usr/local/tomcat/webapps/docs 

VOLUME ["/usr/local/tomcat/logs", "/usr/local/tomcat/work", "/usr/local/tomcat/temp", "/tmp/hsperfdata_root" ]

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

CMD /usr/local/tomcat/bin/deploy-and-run.sh
