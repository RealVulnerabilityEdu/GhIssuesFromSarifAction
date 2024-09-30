# Set the base image to use for subsequent instructions
FROM alpine:3.20

# Set the working directory inside the container
WORKDIR /usr/src

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN apk add --no-cache py3-pip
RUN pip3 install --no-cache --upgrade pip setuptools

# Instsall GitHub Cli
RUN apk add --no-cache git github-cli

# Copy any source file(s) required for the action
COPY entrypoint.sh /entrypoint.sh
COPY run_toolkit.sh /run_toolkit.sh

# Configure the container to be run as an executable
ENTRYPOINT ["/entrypoint.sh"]
