# vdc2020_race03
This is a dataset for virtual donkey car race #3, tested on Ubuntu 16/18/20  

# Requirement
Donkeycar, gym-donkey, (tensorflow 1.15.0), and DonkeySimLinux

# Learning
1. "make clean" : removes all the files in models/ and data/ 
2. "make dataset" : picks out images from some tubs needed to correct driving
3. "make models/linear.h5": trains the network

# Inference
1. "make run_linear":  launches the simulator installed in DonkeySimLinux/ (try make install).

# Others 
See Makefile
