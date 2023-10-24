sudo apt install -y \
  curl \
  doxygen \
  git \
  gparted \
  python3-distutils \
  python3-pip \
  vlc
pip3 install --upgrade pip
python3 -m pip install mysql-connector

sudo snap install --classic code
sudo snap install firefox
sudo snap install postman

#sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

# Radio
# https://github.com/gqrx-sdr/gqrx
git clone https://github.com/gqrx-sdr/gqrx.git gqrx.git
cd gqrx.git
mkdir build
cd build
cmake ..
make install
sudo ldconfig
sudo cp ../rtl-sdr.rules /etc/udev/rules.d/
sudo bash -c 'echo "blacklist dvb_usb_rtl28xxu" >> \
  /etc/modprobe.d/blacklist-rtl.conf'

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
