FROM ubuntu:26.04

# Install basic programs
RUN apt-get update && apt-get install -y curl wget git bash jq python3 neovim
SHELL ["/usr/bin/bash", "-c"]

# Install go
RUN wget https://go.dev/dl/go1.27.2.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.27.2.linux-amd64.tar.gz

# Install rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
RUN source "$HOME/.nvm/nvm.sh" && nvm install 24

# Install pi
RUN source "$HOME/.nvm/nvm.sh" && npm install -g --ignore-scripts @earendil-works/pi-coding-agent

ENTRYPOINT ["/usr/bin/bash"]
