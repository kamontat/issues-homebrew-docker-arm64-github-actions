FROM ubuntu:latest

RUN apt update \
  && apt install -y --no-install-recommends software-properties-common gnupg-agent \
  && add-apt-repository -y ppa:git-core/ppa \
  && apt update \
  && apt install -y --no-install-recommends \
    acl \
    bzip2 \
    ca-certificates curl \
    file fonts-dejavu-core \
    g++ gawk git gpg \
    less locales \
    make \
    netbase \
    openssh-client \
    patch \
    sudo \
    unzip uuid-runtime \
    tzdata \
    jq \
    zsh \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

ENV USER="kamontat"
ENV SHELL="/bin/bash"
ENV USER_HOME="/home/$USER"
ENV BREW_HOME="/home/linuxbrew"
ENV DEBIAN_FRONTEND=noninteractive NONINTERACTIVE=true

RUN useradd --create-home --uid 5000 --group sudo --shell $SHELL $USER \
  && echo "%$USER ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/$USER-group" \
  && mkdir -p "$BREW_HOME"

USER $USER
WORKDIR $USER_HOME

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

RUN "$BREW_HOME/.linuxbrew/bin/brew" config
RUN "$BREW_HOME/.linuxbrew/bin/brew" doctor
RUN "$BREW_HOME/.linuxbrew/bin/brew" cleanup

ENTRYPOINT [ "bash" ]
