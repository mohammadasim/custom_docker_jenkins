FROM jenkins:2.60.3

USER root
# Installing python3.8
RUN apt-get update && apt-get install -y \
    build-essential \ 
    zlib1g-dev \ 
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \ 
    wget

# Get python tar file
RUN curl -O https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tar.xz && tar -xvf Python-3.8.0.tar.xz  

RUN cd Python-3.8.0 && ./configure --enable-optimizations && \
    make && \
    make altinstall

# Drop back to jenkins user
USER jenkins