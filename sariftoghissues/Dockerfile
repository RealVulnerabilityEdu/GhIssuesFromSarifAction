# Set the base image to use for subsequent instructions
FROM python:3-alpine

# Set the working directory inside the container
WORKDIR /usr/src

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 py3-pip

# Instsall GitHub Cli
RUN apk add --no-cache git github-cli

# Copy any source file(s) required for the action
COPY entrypoint.sh /entrypoint.sh
COPY run_toolkit.sh /run_toolkit.sh

# Configure the container to be run as an executable
ENTRYPOINT ["/entrypoint.sh"]
