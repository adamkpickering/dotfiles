FROM debian:trixie-slim

# Install basic programs
RUN apt-get update && apt-get install -y curl git bash jq
SHELL ["/usr/bin/bash", "-c"]

# Install nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
RUN source "$HOME/.nvm/nvm.sh" && nvm install 24

# Install pi
RUN source "$HOME/.nvm/nvm.sh" && npm install -g --ignore-scripts @earendil-works/pi-coding-agent

ENTRYPOINT ["/usr/bin/bash"]
