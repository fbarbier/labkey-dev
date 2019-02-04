Labkey Docker Image
==========

**IMPORTANT:** This image is intended for local development and testing, and comes with no warranty of any kind.

## Usage (Please refer to https://www.labkey.org/Documentation/list-grid.view?listId=634&query.sort=-releaseVersion to get LABKEY last version) :

### Create your .env file with (the default settings):
    # Set LabKey Admin User
    DB_NAME=labkey
    DB_USER=SA
    DB_PASSWORD=labkeyDB

    # Set Pgadmin Access
    PGADMIN_DEFAULT_EMAIL=pgadmin4@pgadmin.org
    PGADMIN_DEFAULT_PASSWORD=pgadmin

    # Get LABKEY last version https://www.labkey.org/Documentation/list-grid.view?listId=634&query.sort=-releaseVersion
    LABKEY_VERSION=18.3
    LABKEY_DIST=18.3-61163.720-community

    # Find labkey.xml as labkey/conf/labkey-postgresql.xml (refer to DB choice)
    LABKEY_XML=labkey-postgresql.xml

    # Create RStudio Password
    RSTUDIO_PASSWORD=letmein

    # Helper to Create a netrc file
    LABKEY_MACHINE=labkey:8080/labkey
    LABKEY_NETRC_LOGIN=user@labkey.org
    LABKEY_NETRC_KEY=letmeinlabkey

Please save your .env file in your root folder.

### Create the image
To create the image you will need do the following (Source file are already available in the git repository)

Build the image with LABKEY version and distribution arguments :

    docker build labkey --build-arg LABKEY_VERSION=18.3 LABKEY_DIST=18.3-61163.720-community

### Running LabKey Server Standalone in a container via docker-compose default config :

To run the image

    ## Run Labkey with postgresql, pgadmin4 and RStudio
    docker-compose up -d



After few seconds, open [http://<host>:8080](http://<host>:8080) to see the tomcat setup page.
To Access labkey server use this URL : localhost:8080/labkey/

### Pgadmin Config

    URL : localhost:5050/browser
    Host : postgresql
    Port : 5432
    Maintenance DB : labkey
    User : SA
    Password : labkeyDB
