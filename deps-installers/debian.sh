echo "make sure to run with sudo"
apt update
apt install build-essential luarocks libgirepository-2.0-dev libglib2.0-dev 
apt install lua5.3 liblua5.3-dev 
apt install luarocks git
apt install wget curl
mdkir -p /usr/lcoal/lib/lua/5.3
wget https://raw.githubusercontent.com/pkulchenko/serpent/refs/heads/master/src/serpent.lua -O /usr/local/lib/lua/5.3/serpent.lua
luarocks install pegasus
luarocks install luajson
luarocks install luagobject
luarocks install linenoise
luarocks install copas

