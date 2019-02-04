FROM rocker/tidyverse:latest

ARG LABKEY_MACHINE
ARG LABKEY_NETRC_LOGIN
ARG LABKEY_NETRC_KEY

# Create .netrc file
RUN echo "machine $LABKEY_MACHINE\nlogin $LABKEY_NETRC_LOGIN\npassword $LABKEY_NETRC_KEY" > ~/.netrc

# Adds tidyverse & devtools to RStudio

RUN install2.r --error \
    --deps TRUE \
    Rlabkey
