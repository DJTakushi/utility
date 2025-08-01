sudo apt install -y \
  doxygen \
  git \
  gparted 

# TODO : 
# sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGE
# pip3 install --upgrade pip
# pip3 install mysql-connector
# pip3 install iotedgedev
# # possibly required for rmqcp.py error : ModuleNotFoundError: No module named 'urllib3.packages.six'"
# pip3 uninstall urllib3
# pip3 install urllib3

sudo snap install curl
# sudo snap install brave # suggested to not use snap yet
curl -fsS https://dl.brave.com/install.sh | sh
# sudo snap install --classic code # download .deb and install manually
# sudo snap install firefox # installed by default
sudo snap install postman
sudo snap install telegram-desktop
sudo snap install cmake --classic
# sudo snap install sublime-text --classic
sudo snap install vlc
sudo apt install net-tools
sudo snap install gimp
# sudo snap install tusk
# discord # download .deb & install manually

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
# https://www.omgubuntu.co.uk/2021/01/how-to-install-edge-on-ubuntu-linuxsudo apt update && sudo apt install microsoft-edge-stable
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
# sudo rm microsoft.gpg
# sudo apt update && sudo apt install microsoft-edge-stable

git config --global user.email "dannytakushi@gmail.com"
git config --global user.name "danny"


# Note, screen sharing in teams gave me trouble. 
# Check out this thread: https://askubuntu.com/questions/1407494/screen-share-not-working-in-ubuntu-22-04-in-all-platforms-zoom-teams-google-m 
## First option worked, but X11 performed poorly on my hardware setup (4k monitor)
## vr4u's comment on enabling Additional Drivers worked perfectly for me

# docker snap seems to have some trouble; using suggested apt configuration
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
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Add the repository to Apt sources:
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update

# To install the latest version, run:
# sudo aptd-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# not in the official instructions, but seems very important
# sudo apt-get install -y docker-compose


# if network drivers need to be loaded for r8125, see https://askubuntu.com/questions/1423298/ethernet-controller-realtek-r8125-not-working-with-kernel-5-15
sudo apt update 
sudo apt install r8125-dkms

sudo tee -a /etc/modprobe.d/blacklist-r8169.conf > /dev/null <<EOT
# To use r8125 driver explicitly
blacklist r8169
EOT

# apply the blacklisted driver
sudo update-initramfs -u

# Dropbox
https://www.dropbox.com/install-linux
```
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
```


# dotnet
sudo apt-get update &&  sudo apt-get install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0

# rsa key for j4
ssh-keygen -t rsa
