FROM odaniait/docker-base-java:latest
MAINTAINER Mike Petersen <mike@odania-it.de>

# Build openhab2
RUN mkdir /opt/src
WORKDIR /opt/src
RUN git clone https://github.com/cdjackson/openhab2.git .
RUN git checkout zwave-master
RUN mvn clean package

# Install openhab2
RUN mkdir /opt/openhab2
RUN unzip -q /opt/src/distribution/target/distribution-2.0.0-SNAPSHOT-runtime.zip -d /opt/openhab2
RUN unzip -n -q /opt/src/distribution/target/distribution-2.0.0-SNAPSHOT-addons.zip -d /opt/openhab2

# Install habmin2
RUN wget -q -P /opt/openhab/addons/ https://github.com/cdjackson/HABmin2/blob/master/output/HABmin2-0.0.15-release.zip

# Copy conf
RUN mkdir /opt/openhab2/conf-default
RUN cp -r /opt/openhab2/conf /opt/openhab2/conf-default

# Create service
RUN mkdir /etc/service/openhab
COPY runit/openhab.sh /etc/service/openhab/run

WORKDIR /opt/openhab2
VOLUME ['/opt/openhab2/conf']
EXPOSE 8080 8443
