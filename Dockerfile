FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y

# Download and register the Microsoft repository GPG keys
RUN apt-get install -y wget apt-transport-https software-properties-common
RUN wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
RUN dpkg -i packages-microsoft-prod.deb

# Update and install misc packages
RUN apt-get update
RUN apt-get install --no-install-recommends --no-install-suggests -y \
    powershell lib32gcc-s1 curl ca-certificates locales supervisor zip
    
# Install wine, if necessary
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    sudo gnupg2 software-properties-common wine wine32 wine64 xvfb
ENV WINEPATH=/app/server \
    WINEARCH=win64 \
    WINEPREFIX=/app/wine \
    DISPLAY=:0.0

# Install mcRcon
WORKDIR /mcrcon
RUN curl -s https://api.github.com/repos/Tiiffi/mcrcon/releases/latest \
| grep "browser_download_url.*64.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
RUN tar -xvzf *64.tar.gz

# Set up server folders
WORKDIR /app
RUN mkdir -p ./backups
RUN mkdir -p ./server
RUN mkdir -p ./logs
RUN mkdir -p ./saves
RUN mkdir -p ./wine

# Copy configs
COPY ./configs/supervisord.conf /etc
# If the workdir changes, also update it in Config-Tools
WORKDIR /app/configs
# COPY ./configs/game-configs/ .

# Copy scripts
WORKDIR /scripts
COPY ./scripts/ .

WORKDIR /tmp

# Set up server defaults
ENV STEAM_APPID="2089300" \ 
    SERVER_PROCESS_NAME="IcarusServer-Win64-Shipping" \ 
    SERVER_PORT="17777" \ 
    QUERY_PORT="27015" \
    SERVER_NAME="Default Server Name" \
    SERVER_PASSWORD="DefaultPassword" \
    ADMIN_PASSWORD="DefaultAdminPassword" \
    TEMP_FOLDER="/tmp" \
    TZ="Etc/UTC" \
    FILE_UMASK="022" \
    BACKUPS_ENABLED="True" \
    BACKUPS_MAX_AGE=3 \
    BACKUPS_MAX_COUNT=0 \
    BACKUPS_INTERVAL=360 \
    UPDATES_ENABLED="True" \
    UPDATES_WHILE_USERS_CONNECTED="False" \
    UPDATES_INTERVAL=15 \
    RCON_PORT=25575 \
    RCON_PASSWORD="ChangeThisPasswordIfUsingRCON" \
    RCON_MAX_KARMA=60 \
    STEAM_ASYNC_TIMEOUT=60 \
    MAX_PLAYERS=8 \
    SHUTDOWN_IF_NOT_JOINED_FOR=0 \
    SHUTDOWN_IF_EMPTY_FOR=300 \
    ALLOW_NON_ADMINS_LAUNCH=True \
    ALLOW_NON_ADMINS_DELETE=False \
    RESUME_PROSPECT=True
    # USER_ID=1000 \
    # GROUP_ID=1000

# Create Steam user
# RUN groupadd -g "${GROUP_ID}" steam \
#   && useradd --create-home --no-log-init -u "${USER_ID}" -g "${GROUP_ID}" steam
# RUN chown -R "${USER_ID}":"${GROUP_ID}" /home/steam
# RUN chown -R "${USER_ID}":"${GROUP_ID}" /app/server

# Install SteamCMD
WORKDIR /steam
# RUN chown -R "${USER_ID}":"${GROUP_ID}" /steam
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
  && tar xvf steamcmd_linux.tar.gz

# HEALTHCHECK CMD sv status ddns | grep run || exit 1

CMD pwsh /scripts/Entrypoint.ps1
