# Prerequisites
sudo apt update
sudo apt upgrade

sudo apt install build-essential clang bison flex libreadline-dev \
                 gawk tcl-dev libffi-dev git mercurial graphviz   \
                 xdot pkg-config python python3 libftdi-dev gperf \
                 libboost-program-options-dev autoconf libgmp-dev \
                 cmake gnat gtkwave

# Yosys
git clone https://github.com/YosysHQ/yosys
cd yosys
make
sudo make install
cd ..
  
git clone https://github.com/YosysHQ/SymbiYosys
cd SymbiYosys
sudo make install
cd ..

git clone https://github.com/SRI-CSL/yices2
cd yices2
autoconf
./configure
make
sudo make install
cd ..

# GHDL
git clone https://github.com/ghdl/ghdl
cd ghdl
./configure --prefix=/usr/local
make
sudo make install
cd ..
  
git clone https://github.com/ghdl/ghdl-yosys-plugin
cd ghdl-yosys-plugin
make
sudo make install
cd ..
