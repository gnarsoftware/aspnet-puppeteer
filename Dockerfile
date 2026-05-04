ARG DOTNET_VERSION=10.0
FROM mcr.microsoft.com/dotnet/aspnet:${DOTNET_VERSION} AS runtime-base
COPY sshd_config /etc/ssh/

#####################
#PUPPETEER RECIPE
#####################

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai, and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get -f install && apt-get -y install wget gnupg2 apt-utils
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libgdiplus \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-unstable

#####################
#END PUPPETEER RECIPE
#####################

# enable SSH
RUN apt-get update \
    && apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd

EXPOSE 8080 2222
