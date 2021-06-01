FROM tomcat:8.5.16-jre8-alpine

MAINTAINER Tavishgandhi

COPY ./target/testproject1.war /usr/local/tomcat/webapps

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
