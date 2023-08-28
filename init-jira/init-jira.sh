#!/bin/bash

# Specify Jira version
jira_version="9.4.9"

# Generate folder name based on Jira version
folder_name="jira-$(echo $jira_version | tr -d '.')"

# Create directory structure with the appropriate permissions and ownership
mkdir -p $folder_name/shared-home $folder_name/local-home $folder_name/pg-data
sudo chown $USER:$USER $folder_name/shared-home $folder_name/local-home $folder_name/pg-data

# Generate dbconfig.xml
cat <<EOL > $folder_name/local-home/dbconfig.xml
<?xml version="1.0" encoding="UTF-8"?>
<jira-database-config>
  <name>defaultDS</name>
  <delegator-name>default</delegator-name>
  <database-type>postgres72</database-type>
  <schema-name>public</schema-name>
  <jdbc-datasource>
    <url>jdbc:postgresql://postgres:5432/jira_db</url>
    <driver-class>org.postgresql.Driver</driver-class>
    <username>jira_user</username>
    <password>jira_password</password>
    <pool-min-size>20</pool-min-size>
    <pool-max-size>20</pool-max-size>
    <pool-max-wait>30000</pool-max-wait>
    <pool-max-idle>20</pool-max-idle>
    <pool-remove-abandoned>true</pool-remove-abandoned>
    <pool-remove-abandoned-timeout>300</pool-remove-abandoned-timeout>
  </jdbc-datasource>
</jira-database-config>
EOL

# Generate jira-config.properties
cat <<EOL > $folder_name/local-home/jira-config.properties
jira.websudo.is.disabled=true
EOL

# Change ownership back to 2001:2001 for Jira container
sudo chown 2001:2001 $folder_name/shared-home $folder_name/local-home
sudo chown -R 999:999 $folder_name/pg-data

# Create docker-compose.yml
cat <<EOL > $folder_name/docker-compose.yml
version: '3'

services:
  jira:
    image: atlassian/jira-software:$jira_version
    environment:
      - JIRA_HOME=/var/atlassian/application-data/jira/local-home
      - JIRA_SHARED_HOME=/var/atlassian/application-data/jira/shared-home
      - JVM_MAXIMUM_MEMORY=2048M
    volumes:
      - ./shared-home:/var/atlassian/application-data/jira/shared-home
      - ./local-home:/var/atlassian/application-data/jira/local-home
    ports:
      - "8080:8080"
    depends_on:
      - postgres

  postgres:
    image: postgres
    environment:
      POSTGRES_DB: jira_db
      POSTGRES_USER: jira_user
      POSTGRES_PASSWORD: jira_password
    volumes:
      - ./pg-data:/var/lib/postgresql/data

EOL

# Run docker-compose
cd $folder_name
docker-compose up