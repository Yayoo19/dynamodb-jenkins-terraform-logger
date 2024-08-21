# Use the official Jenkins LTS image as the base
FROM jenkins/jenkins:lts

# Switch to root to install additional packages
USER root

# Update the package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI from the official repository
RUN apt-get update && apt-get install -y \
    awscli


# Switch back to the Jenkins user
USER jenkins

# Copy the Groovy script to the init directory
COPY create-job.groovy /usr/share/jenkins/ref/init.groovy.d/create-job.groovy

# Expose Jenkins port
EXPOSE 8080

# Start Jenkins
ENTRYPOINT ["jenkins.sh"]

