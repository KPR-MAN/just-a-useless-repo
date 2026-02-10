# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update \
    && apt-get install -y \
       git \
       python3 \
       python3-pip \
       python3-tomli \
       kpartx \
       sudo \
       lsb-release \
       qemu-user-static \
       binfmt-support

# Create a non-root user
RUN useradd -ms /bin/bash pmuser

# Allow pmuser to run sudo without a password prompt
RUN echo "pmuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/pmuser

# Clone pmbootstrap from Git
RUN git clone --depth=1 https://gitlab.postmarketos.org/postmarketOS/pmbootstrap.git /pmbootstrap

# Create the bin directory
RUN mkdir -p /home/pmuser/.local/bin

# Create the work path with correct permissions
RUN mkdir -p /home/pmuser/.local/var/pmbootstrap \
    && chown -R pmuser:pmuser /home/pmuser/.local

# Create a symbolic link to pmbootstrap.py
RUN ln -s /pmbootstrap/pmbootstrap.py /usr/local/bin/pmbootstrap

# Add /home/pmuser/.local/bin to the PATH for the non-root user
ENV PATH="/home/pmuser/.local/bin:$PATH"

# Switch to the non-root user
USER pmuser

# Set the working directory
WORKDIR /pmbootstrap
