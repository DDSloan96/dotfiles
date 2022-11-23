/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
xcode-select --install
# Get brew.  OSX is pretty much useless without it.
############# Install applications and dependencies #############

# With brew in, use it to install some other stuff.
# testing purposes: PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
brew install slack
brew install --cask google-chrome
brew install git
brew install awscli
brew install aws-iam-authenticator
brew install tfenv
brew install kubectl
brew install kubectx
brew install docker
brew install pyenv
brew install vscode
# For helmenv
brew tap little-angry-clouds/homebrew-my-brews
brew install helmenv
brew install jq
brew install go
brew install python3
brew install --cask visual-studio-code
brew install slack
#funstuff
brew install spotify

printf "Installing awsume and awsume console plugin with pip\n"
pip3 install awsume awsume-console-plugin

sudo pip3 install dotfiles
dotfiles --repo ~/git/dotfiles/ --sync --force
