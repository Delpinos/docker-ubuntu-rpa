FROM ubuntu:20.04

LABEL Author="Alef Delpino"
LABEL Email="alef@delpinos.com"

#DEFAULT ENVIRONMENT VARIABLES
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV LANG='en_US.UTF-8'
ENV LANGUAGE='en_US:en'
ENV LC_ALL='en_US.UTF-8'
ENV TERM='xterm'
ENV TZ='Etc/UTC'
ENV APP_DIR="/app"

#CHROME ENVIRONMENT VARIABLES
ENV CHROME_EXECUTABLE_PATH="/usr/bin/google-chrome-stable"

#FIREFOX ENVIRONMENT VARIABLES
ENV FIREFOX_EXECUTABLE_PATH="/usr/lib/firefox/firefox"

#WORKDIR
RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

#ADD REPOSITORIES
RUN apt-get -qq update && apt-get install -y --no-install-recommends \
  software-properties-common &&\
  apt-add-repository "ppa:deadsnakes/ppa" && \
  apt-add-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"

#CONFIG FONTS
COPY src/fonts/fonts.conf /etc/fonts/local.conf   
RUN  echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

#INSTALL FONTS
RUN apt-get install -y --no-install-recommends \
  fontconfig \
  fonts-freefont-ttf \
  fonts-indic \
  fonts-ipafont-gothic \
  fonts-kacst \
  fonts-liberation \
  fonts-noto-cjk \
  fonts-noto-color-emoji \
  fonts-roboto \
  fonts-thai-tlwg \
  fonts-ubuntu \
  fonts-wqy-zenhei \
  libfontconfig1 \
  msttcorefonts \
  ttf-wqy-zenhei \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-base

#INSTALL ESSENTIALS
RUN apt-get -qq update && apt-get install -y --no-install-recommends --allow-unauthenticated \
  adobe-flashplugin \
  apt-transport-https \
  apt-utils \
  build-essential   \
  bzip2 \
  ca-certificates \
  curl \
  dbus-x11 \
  default-jre \
  dnsutils \
  dumb-init \
  ffmpeg \
  g++ \
  gconf-service \
  gettext \
  gpg-agent \
  gnupg2 \
  libappindicator1 \
  libappindicator3-1 \
  libasound2 \
  libatk1.0-0 \
  libc6 \
  libc6-dev \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libgbm-dev \
  libgcc1 \
  libgconf-2-4 \
  libgdiplus \
  libgdk-pixbuf2.0-0 \
  libglib2.0-0 \
  libgtk-3-0 \
  libllvm8 \
  libnspr4 \
  libnss3 \
  libnss-wrapper \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libssl-dev \
  libstdc++6 \
  libx11-6 \
  libx11-dev \
  libx11-xcb1 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  locales \
  lsb-release \
  nano \
  net-tools  \
  node-gyp \
  pdftk \
  pigz \
  pm-utils \
  python-numpy \
  python-is-python3 \
  python3 \
  python3-pip \
  screen \
  supervisor \
  tcpdump \
  telnet \
  tzdata \
  unzip \
  vim \
  wget \
  x11-xserver-utils \
  xdg-utils \
  xorg \
  xterm \
  xvfb

#FFMPEG
RUN mkdir /usr/local/ffmpeg && ln -s /usr/bin/ffmpeg /usr/local/ffmpeg/ffmpeg

#CHROME
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
 apt-add-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" && \
 apt-get -qq update && apt-get install -y google-chrome-stable

#FIREFOX
RUN apt-add-repository "ppa:ubuntu-mozilla-daily/ppa" && \
  apt-get -qq update && apt-get install -y firefox

#CHROMEDRIVER
RUN CHROME_DRIVER_VERSION=`curl -sS http://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
  wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ && \
  chmod +x /usr/local/bin/chromedriver

#GECKODRIVER
RUN GECKODRIVER_VERSION=`curl https://github.com/mozilla/geckodriver/releases/latest | grep -Po 'v[0-9]+.[0-9]+.[0-9]+'` && \
  wget https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
  tar -zxf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz -C /usr/local/bin && \
  rm -rf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
  chmod +x /usr/local/bin/geckodriver

#NODE JS + NPM
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get -qq update && apt-get install -y nodejs

#.NET CORE 3.1 RUNTIME
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  apt-get -qq update && \
  apt-get install -y aspnetcore-runtime-3.1  

#PYTHON PIP
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1    

#GENERATE LOCALES FOR en_US.UTF-8"
RUN locale-gen en_US.UTF-8

#TIMEZONE
RUN echo $TZ > /etc/timezone && \
  rm /etc/localtime && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

#CLEAN
RUN rm -rf /var/lib/apt/lists/* && apt-get clean

#SUPERVISOR
COPY ./src/supervisor/ /etc/supervisor

#CMD
CMD /usr/bin/supervisord
