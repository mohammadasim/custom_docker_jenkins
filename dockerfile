FROM jenkins/jenkins:lts

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
    libsqlite3-dev \
    xvfb \
    wget

# Get python tar file
RUN curl -O https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tar.xz && tar -xvf Python-3.8.0.tar.xz  

RUN cd Python-3.8.0 && ./configure --enable-optimizations --enable-loadable-sqlite-extensions && \
    make && \
    make altinstall

# Google Chrome stable-lates
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub \
    | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google.list \
    && apt-get -qy update \
    && apt-get -qy install -y google-chrome-stable \
    && apt-get -qyy autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -qyy clean \
    && echo google-chrome-stable --version

# Chrome webdriver installation
ENV CHROME_DRIVER_VERSION="2.38" \
    CHROME_DRIVER_BASE="chromedriver.storage.googleapis.com" \
    CPU_ARCH="64"
ENV CHROME_DRIVER_FILE="chromedriver_linux${CPU_ARCH}.zip"
ENV CHROME_DRIVER_URL="https://${CHROME_DRIVER_BASE}/${CHROME_DRIVER_VERSION}/${CHROME_DRIVER_FILE}"
RUN  wget -nv -O chromedriver_linux${CPU_ARCH}.zip ${CHROME_DRIVER_URL} \
    && unzip chromedriver_linux${CPU_ARCH}.zip \
    && rm chromedriver_linux${CPU_ARCH}.zip \
    && chmod 755 chromedriver \
    && mv chromedriver /usr/local/bin/ \
    && chromedriver --version
# Drop back to jenkins user
USER jenkins

# Copy plugins.txt
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install the plugins
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt