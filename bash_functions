#!/bin/zsh

_clone-repos(){
cd ~/repos/ ; \
git clone https://github.com/colszowka/linux-typewriter.git ; \
git clone https://github.com/KittyKatt/screenFetch ; \
git clone https://github.com/alexdantas/yetris ; \
git clone https://github.com/drwetter/testssl.sh ; \
git clone https://github.com/jarun/buku/ ; \
git clone https://github.com/jarun/googler/ ; \
git clone https://github.com/narenaryan/Govie ; \
echo done
}

# git branch for PS1
parse_git_branch_and_add_brackets() {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

# tunnelkill
_tunnel-kill() {
tunnel_kill_list=`ps axuf \
| grep " ssh " \
| grep "\-f" \
| awk '{print $2}'`
echo killing $tunnel_kill_list
kill $tunnel_kill_list
}

# tunnelmake
_tunnel-manual() {
echo enter remote machine
read remotemachine
echo enter remote port
read remoteport
echo enter env dev or prod
read env

port=$(( ( RANDOM % 1024 )  + 60000 ))
if [ $env == "prod" ] ;then
jump=
elif [ $env == "corp" ] ;then
jump=$jump_corp
fi

echo localport is $port
echo jump is $jump
echo remotemachine is $remotemachine
echo remoteport is $remoteport

ssh -f -A ec2-user@$jump -L $port:$remotemachine:$remoteport -N
_tunnel-list
}

_tunnel-list() {
ps axuf | grep " ssh " | grep -v grep | grep "\-f"
}

_tunnel-example() {
echo ssh -f -A youruser@jump -L localport:remotemachine:remoteport -N
}

_tunnel-db(){
if [ $1 == "sandbox" ] || [ $1 == "qa" ] || [ $1 == "staging" ] ; then
jump=jump-dev.$organization.com
db=dbrw.$1.$organization.com
elif [ $1 == "prod" ] || [ $1 == "production" ] ; then
jump=jump-prod.$organization.com
db=dbrw.$organization.com
fi
port=$(( ( RANDOM % 1024 )  + 60000 ))
ssh -f -A ec2-user@$jump -L $port:$db:5432 -N
_tunnel-list
}

# Extract
_extract()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

_down() {
wget -qO - "http://www.downforeveryoneorjustme.com/$1" | sed "/just you/!d;s/<[^>]*>//g";
}

_cert-remote() {
openssl s_client -showcerts -connect $1:443 </dev/null | openssl x509 -noout -text  | grep DNS
}

_cert-local() {
openssl x509 -in $1 -text -noout
}

_package-firefox() {
wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
bunzip2 firefox.tar.bz2
tar xvf firefox.tar
rm -f firefox.tar
}

_package-firefox_prereqs(){
sudo apt-get install -y bzip2 libasound2 libdbus-glib-1-2 libgtk2.0-0
sudo apt-get install -y pepperflashplugin-nonfree # flashplugin-nonfree
}

_package-wm(){
sudo apt-get install -y \
dwm \
xorg
}

_package-daemons(){
sudo apt-get update
sudo apt-get install -y \
cifs-utils \
dictd \
dict-gcide \
dict-moby-thesaurus \
nfs-common \
openssh-server

}

_package-pip-packages(){
sudo pip install --upgrade \
pip \
awscli \
bpython \
demjson \
doge \
dotfiles \
gcalcli \
kube-shell \
modernize \
monica \
moviemon \
flake8 \
rtv \
socli \
speedtest-cli \
thefuck \
youtube-dl
}

_package-intellij(){
wget -P ~/ https://download.jetbrains.com/idea/ideaIC-2018.1.1.tar.gz
tar zxvf ideaIC-2018.1.1.tar.gz
rm -f ideaIC-2018.1.1.tar.gz
}

_wallpaper(){
while true
do
feh --bg-scale --randomize ~/desktops
sleep 60
done
}

_wallpaper_reddit(){
wget -q -O - -- $(wget -q -O - http://www.reddit.com/r/wallpaper | grep -Eo 'https?://\w+\.imgur\.com[^"&]+(jpe?g|png|gif)' | shuf -n 1) | feh --bg-fill -
}

_wallpaper_imgur(){
wget -q -O- https://imgur.com/a/EYCTw | grep jpg | grep thumb | sed 's/.*src="\/\///g' | sed 's/" alt="" \/>//g' | shuf -n 1 | xargs wget -q -O- | feh --bg-fill -
}

_wallpaper_hubblesite(){
IMAGE=$(wget -q -O- http://hubblesite.org/gallery/wallpaper/ | grep imgsrc.hubblesite.org | sed 's/^.*imgsrc/imgsrc/g' | sed 's/-wallpaper_thumb.jpg.*$//g' | sed 's/imgsrc.hubblesite.org\/hu\/db\/images\///g' | shuf -n 1)
wget -q -O- http://imgsrc.hubblesite.org/hu/db/images/$IMAGE-2560x1024_wallpaper.jpg | feh --bg-fill -
}

_package-vagrant(){
wget -P /tmp/ https://releases.hashicorp.com/vagrant/1.8.7/vagrant_1.8.7_x86_64.deb
sudo dpkg -i /tmp/vagrant_1.8.7_x86_64.deb
}

_package-virtualbox(){
VERSION=`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`
PACKAGE=`curl -s https://download.virtualbox.org/virtualbox/$VERSION/ | grep rpm | grep el7 | sed 's/rpm.*/rpm/g' | sed 's/.*Virt/Virt/g'`
sudo yum install https://download.virtualbox.org/virtualbox/$VERSION/$PACKAGE
}

_psql_list(){
_tunnel-list | awk '{print $16}'
}

_psql_env(){
echo ex. psql_env ro
ENV=$1
USER=$2
port=`_tunnel-list | grep $ENV | sed s/.*ssh/ssh/g | awk '{print $6}' | sed 's/:.*//g'`
echo command is psql -h localhost -U $organization_$USER -d $organization_db -p $port
psql -h localhost -U $organization_$USER -d $organization_db -p $port
}

_information-package_size(){
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n
}

_start-sonar(){
mono --debug /opt/NzbDrone/NzbDrone.exe
}

_start-radarr(){
cd ~/Radarr.develop.0.2.0.596.linux ; mono Radarr.exe
}

_package-sonarr(){
sudo apt-get install -y dirmngr
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list
sudo apt-get update
sudo apt-get install -y nzbdrone
}

_package-radarr(){
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
sudo apt-get update
sudo apt-get install mono-devel mediainfo sqlite3 libmono-cil-dev -y
wget https://github.com/Radarr/Radarr/releases/download/v0.2.0.596/Radarr.develop.0.2.0.596.linux.tar.gz
tar zxvf Radarr.develop.0.2.0.596.linux.tar.gz
}

_package-debian(){
sudo apt-get update
sudo apt-get install \
alsa-utils \
arandr \
aspell \
atril \
bash-completion \
cmus \
curl \
dnsutils \
dstat \
feh \
git \
htop \
iftop \
ipcalc \
irssi \
kpcli \
keepass2 \
lftp \
links2 \
lolcat \
mcomix \
mdp \
mpv \
mupdf \
mutt \
nethogs \
newsbeuter \
p7zip \
pwgen \
python \
python-pip \
ranger \
rsync \
rtorrent \
scrot \
sshfs \
stterm \
suckless-tools \
tig \
tmux \
toilet \
typespeed \
unrar \
vim \
weather-util \
whois \
wicd \
xcowsay \
xfishtank \
xterm
}

_brightness(){
echo $1 | sudo tee --append /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness
}

_package-jdk(){
wget -P ~/ https://download.java.net/java/GA/jdk10/10.0.1/fb4372174a714e6b8c52526dc134031e/10/openjdk-10.0.1_linux-x64_bin.tar.gz
tar zxvf openjdk-10.0.1_linux-x64_bin.tar.gz
rm -f openjdk-10.0.1_linux-x64_bin.tar.gz
}

_package-visualvm(){
wget https://java.net/projects/visualvm/downloads/download/release138/visualvm_138.zip
}

_package-translate(){
wget git.io/trans
}

_package-go(){
cd /var/tmp
curl -LO https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz
tar zxvf go1.7.linux-amd64.tar.gz
}

_kubeconfig(){
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
}

bssh() {
  ~/bssh.py dsloan "$@"
}
