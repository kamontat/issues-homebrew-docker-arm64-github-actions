FROM ubuntu:latest


RUN apt update \
  && apt install -y locales tzdata curl gpg sudo zsh \
  && apt upgrade -y \
  && apt install -y git build-essential file procps unzip \
  && apt clean

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

RUN /home/linuxbrew/.linuxbrew/bin/brew config || true \
  && /home/linuxbrew/.linuxbrew/bin/brew doctor || true

ENTRYPOINT [ "bash" ]
