echo "make sure to run with sudo"
sudo apt update
sudo apt install build-essential luarocks libgirepository-2.0-dev libglib2.0-dev 
apt install lua5.3 liblua5.3-dev luarocks
luarocks install pegasus luajson luagobject linenoise copas
