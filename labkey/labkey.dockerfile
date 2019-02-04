FROM tomcat:latest as labkey

MAINTAINER fabien.barbier@u-bordeaux.fr

ARG LABKEY_VERSION
ARG LABKEY_DIST
ARG LABKEY_XML



COPY /tomcat/manager.xml /usr/local/tomcat/conf/Catalina/localhost/manager.xml
COPY /tomcat/tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
# COPY /tomcat/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY /conf/$LABKEY_XML /usr/local/tomcat/conf/Catalina/localhost/labkey.xml

#
# Install the Labkey Server and Configure
#
RUN mkdir -p /labkey/src/labkey && \
    mkdir -p /labkey/bin && \
    cd /labkey/src && \
    wget --no-verbose http://labkey.s3.amazonaws.com/downloads/general/r/$LABKEY_VERSION/LabKey$LABKEY_DIST-bin.tar.gz && \
    tar xzf /labkey/src/LabKey$LABKEY_DIST-bin.tar.gz && \
    mkdir -p /usr/local/labkey/modules && \
    cp -f LabKey$LABKEY_DIST-bin/modules/*.module /usr/local/labkey/modules/ && \
    cp -R LabKey$LABKEY_DIST-bin/labkeywebapp /usr/local/labkey && \
    cp -R LabKey$LABKEY_DIST-bin/pipeline-lib /usr/local/labkey && \
    cp -f LabKey$LABKEY_DIST-bin/tomcat-lib/*.jar /usr/local/tomcat/lib/ && \
    mkdir /usr/local/labkey/files
    # chown -R tomcat.tomcat /usr/local/labkey && \
    #rm -rf Labkey$LABKEY_DIST-bin && \
    #rm Labkey$LABKEY_DIST-bin.tar.gz

#
# ADD R and littler to Labkey
#
FROM labkey as rlabkey
## Now install R and littler, and create a link for littler in /usr/local/bin
RUN apt-get update \
    && apt-get install -y --fix-missing \
    	littler \
    	r-cran-littler \
    	r-base \
    	r-base-dev \
    	r-recommended \
    && echo 'local({r <- getOption("repos"); r["CRAN"] <- "https://cloud.r-project.org"; options(repos=r)})' > ~/.Rprofile \
    # && echo "r <- getOption('repos'); r['CRAN'] <- 'https://cran.cnr.berkeley.edu'; options(repos = r);" > ~/.Rprofile \
    && ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
    && ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
    && ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
    && ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
    && install.r docopt \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

#
# ADD Bioconductor to Labkey
#


FROM rlabkey as luminexModule
COPY /packages/Ruminex_0.1.0.zip /usr/local/lib/R/site-library/Ruminex_0.1.0.zip
RUN cd /usr/local/lib/R/site-library/ && \
unzip Ruminex_0.1.0.zip && rm Ruminex_0.1.0.zip
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
## for cairo
libcairo2-dev \
libxt-dev \
## for RGL
libcgal-dev \
libglu1-mesa-dev \
libglu1-mesa-dev \
# for curl
libcurl4-openssl-dev \
# for open openssl
libssl-dev \
&& install2.r --error \
  --deps TRUE \
  Rlabkey
