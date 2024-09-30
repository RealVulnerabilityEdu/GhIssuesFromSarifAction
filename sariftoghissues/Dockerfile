# Set the base image to use for subsequent instructions
FROM alpine:3.20

# Set the working directory inside the container
WORKDIR /usr/src

# Copy any source file(s) required for the action
COPY entrypoint.sh /entrypoint.sh
COPY run_toolkit.sh /run_toolkit.sh

# Configure the container to be run as an executable
ENTRYPOINT ["/entrypoint.sh"]
