# Set the base image to use for subsequent instructions
FROM alpine:3.20.3

# Set the working directory inside the container
WORKDIR /usr/src

# Install python/pip and GitHub Cli
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3=3.12.6-r0 py3-pip=24.0-r2 git=2.45.2-r0 github-cli=2.47.0-r4 bash=5.2.26-r0

# Copy any source file(s) required for the action
COPY entrypoint.sh /entrypoint.sh
COPY run_toolkit.sh /run_toolkit.sh

# Configure the container to be run as an executable
ENTRYPOINT ["/entrypoint.sh"]
