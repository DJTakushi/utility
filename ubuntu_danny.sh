sudo apt install -y \
  curl \
  doxygen \
  git \
  cmake \
  gparted \
  python3-pip \
  vlc \
  net-tools
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
pip3 install --upgrade pip
pip3 install mysql-connector
pip3 install iotedgedev

sudo snap install --classic code
sudo snap install firefox
sudo snap install postman
sudo snap install telegram-desktop

#sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

# Radio
# https://github.com/gqrx-sdr/gqrx
# git clone https://github.com/gqrx-sdr/gqrx.git gqrx.git
# cd gqrx.git
# mkdir build
# cd build
# cmake ..
# make install
# sudo ldconfig
# sudo cp ../rtl-sdr.rules /etc/udev/rules.d/
# sudo bash -c 'echo "blacklist dvb_usb_rtl28xxu" >> \
#   /etc/modprobe.d/blacklist-rtl.conf'
sudo apt install gqrx-sdr


# Edge for teams (chromium seems to not work nicely with Brave, and --google)
# https://www.omgubuntu.co.uk/2021/01/how-to-install-edge-on-ubuntu-linux
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo rm microsoft.gpg
sudo apt update && sudo apt install microsoft-edge-stable

# Brave from official instructions
# https://brave.com/linux/
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

git config user.email "dannytakushi@gmail.com"
git config user.name "danny"


# Note, screen sharing in teams gave me trouble. 
# Check out this thread: https://askubuntu.com/questions/1407494/screen-share-not-working-in-ubuntu-22-04-in-all-platforms-zoom-teams-google-m 
## First option worked, but X11 performed poorly on my hardware setup (4k monitor)
## vr4u's comment on enabling Additional Drivers worked perfectly for me


# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# To install the latest version, run:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# not in the official instructions, but seems very important
sudo apt-get install docker-compose


# if network drivers need to be loaded for r8125, see https://askubuntu.com/questions/1402709/how-to-install-ethernet-driver-on-ubuntu-server-20-04-4-lts
