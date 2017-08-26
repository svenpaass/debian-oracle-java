FROM svenpaass/debian-minimal:stable
MAINTAINER Sven Paaß <sven@paass.net>

ENV VERSION=8 \
    UPDATE=144 \
    BUILD=01 \
    SIG=090f390dda5b47b9b721c7dfaa008135 \
    URL=http://download.oracle.com/otn-pub/java \
    JAVA_HOME=/opt/java

ENV JRE_HOME=${JAVA_HOME}/jre

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install --assume-yes --no-install-recommends ca-certificates curl \
 && curl --silent --location --retry 3 --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
      ${URL}/jdk/${VERSION}u${UPDATE}-b${BUILD}/${SIG}/server-jre-${VERSION}u${UPDATE}-linux-x64.tar.gz \
      | tar xz -C /tmp \
 && mkdir -p /usr/lib/jvm \
 && mv /tmp/jdk1.${VERSION}.0_${UPDATE} ${JAVA_HOME} \
 && chown -R 0:0 ${JAVA_HOME} \
 && apt-get autoclean \
 && apt-get --purge --assume-yes autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN update-alternatives --install /usr/bin/java java ${JRE_HOME}/bin/java 1 \
 && update-alternatives --install /usr/bin/javac javac ${JAVA_HOME}/bin/javac 1 \
 && update-alternatives --set java ${JRE_HOME}/bin/java \
 && update-alternatives --set javac ${JAVA_HOME}/bin/javac

RUN apt-get update \
 && apt-get install unzip --assume-yes --no-install-recommends \
 && curl --silent --location --retry 3 --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
      "${URL}"/jce/8/jce_policy-8.zip -o /tmp/jce_policy-8.zip \
 && unzip /tmp/jce_policy-8.zip -d /tmp \
 && cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar "${JRE_HOME}"/lib/security/ \
 && apt-get remove --purge --auto-remove --assume-yes unzip \
 && apt-get autoclean && apt-get --purge --assume-yes autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
