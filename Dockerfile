FROM timveil/oo-docker-base:latest

LABEL maintainer="tjveil@gmail.com"

# the url that containers used to communicate with each other
ENV HOST_URL=server

# the url that clients like a web browser
ENV FRONTEND_URL=http://localhost:8080

RUN curl -o takipi-server-java.tar.gz \
    -L https://s3.amazonaws.com/app-takipi-com/deploy/takipi-server/takipi-server-java.tar.gz \
    && tar xvf takipi-server-java.tar.gz \
    && rm -rf takipi-server-java.tar.gz

ADD conf/my.server.properties takipi-server/conf/tomcat/shared/my.server.properties

# update allows remote connections to H2 for curiosity and debugging
RUN sed -i "s/-tcp /-tcp -tcpAllowOthers -webAllowOthers /" takipi-server/bin/takipi-server.sh

ADD run.sh /run.sh
RUN chmod a+x /run.sh

# h2 console
EXPOSE 8082

# web gui
EXPOSE 8080

CMD ["/run.sh"]