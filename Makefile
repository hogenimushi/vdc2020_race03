#
# By Hogenimushi
#
PYTHON=python3
SIMULATOR=./DonkeySimLinux/donkey_sim.x86_64

DATASET_10Hz = $(shell find data_10Hz -type d | sed -e '1d' | tr '\n' ' ')
DATASET_05Hz = $(shell find data_05Hz -type d | sed -e '1d' | tr '\n' ' ')

MAIN_DATASET = $(shell find data -type d | sed -e '1d' | tr '\n' ' ')
TEST_DATASET = $(shell find data -type d | sed -e '1d' | tr '\n' ' ')

PREVIOUS_START = $(shell find previous_10Hz -name 'start*_v3' -type d | tr '\n' ' ')
PREVIOUS_PRE = $(shell find previous_10Hz -name 'pre_*' -type d | tr '\n' ' ')
PREVIOUS_LAP = $(shell find previous_10Hz -name 'lap_*' -type d | tr '\n' ' ')

PREVIOUS_MAIN = $(MAIN_DATASET) $(PREVIOUS_START) $(PREVIOUS_PRE) $(PREVIOUS_LAP) 

COMMA=,
EMPTY=
SPACE=$(EMPTY) $(EMPTY)
DATASET_SLOW_ARG=$(subst $(SPACE),$(COMMA),$(DATASET_SLOW))


none:
	@echo "Argument is required."

sim:
	$(SIMULATOR) &
	@echo "Launching simulator..."

run_linear: prebuilt/linear.h5
	$(PYTHON) manage.py drive --model=$< --type=linear --myconfig=configs/myconfig_10Hz.py

record: record10

record05:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_05Hz.py

record10:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_10Hz.py

record20:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_20Hz.py


run_test: models/test.h5
	$(PYTHON) manage.py drive --model=$< --type=linear --myconfig=configs/myconfig_10Hz.py

train_test: models/test.h5
	make models/test.h5

models/test.h5: $(TEST_DATASET)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --myconfig=configs/myconfig_10Hz.py



# This shows how to use trim
trim_crash_001:
	$(PYTHON) scripts/trimming.py --input data_20Hz/crash_001 --output data_generated_20Hz/crash_001 --file data_20Hz/crash_001_trim.txt

clean:
	rm -fr models/*
	rm -rf data/*

install: 
	make DonkeySimLinux/donkey_sim.x86_64

DonkeySimLinux/donkey_sim.x86_64:
	wget -qO- https://github.com/tawnkramer/gym-donkeycar/releases/download/v2020.5.16/DonkeySimLinux.zip | bsdtar -xvf - -C .

models/linear.h5: $(MAIN_DATASET)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --myconfig=configs/myconfig_10Hz.py

models/previous_linear.h5: $(PREVIOUS_MAIN)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --myconfig=configs/myconfig_10Hz.py

dataset:
	make kabe
	make dakou
	make sayu
kabe:
	make kabe_001
	make kabe_002
	make kabe_003
	make kabe_004
kabe_001:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/kabe_001 --output data/previous_kabe_001 --file previous_10Hz/kabe_001.txt

kabe_002:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/kabe_002 --output data/previous_kabe_002 --file previous_10Hz/kabe_002.txt

kabe_003:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/kabe_003 --output data/previous_kabe_003 --file previous_10Hz/kabe_003.txt

kabe_004:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/kabe_004 --output data/previous_kabe_004 --file previous_10Hz/kabe_004.txt

dakou:
	make dakoumigi_001
	make dakoumigi_002
	make dakoumigi_003
	make dakoumigi_004
	make dakoumigi_005
	make dakouhidari_001
	make dakouhidari_002
	make dakouhidari_003
	make dakouhidari_004

dakoumigi_001:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakoumigi_001 --output data/previous_dakoumigi_001 --file previous_10Hz/dakoumigi_001.txt

dakoumigi_002:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakoumigi_002 --output data/previous_dakoumigi_002 --file previous_10Hz/dakoumigi_002.txt

dakoumigi_003:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakoumigi_003 --output data/previous_dakoumigi_003 --file previous_10Hz/dakoumigi_003.txt

dakoumigi_004:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakoumigi_004 --output data/previous_dakoumigi_004 --file previous_10Hz/dakoumigi_004.txt

dakoumigi_005:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakoumigi_005 --output data/previous_dakoumigi_005 --file previous_10Hz/dakoumigi_005.txt

dakouhidari_001:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakouhidari_001 --output data/previous_dakouhidari_001 --file previous_10Hz/dakouhidari_001.txt

dakouhidari_002:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakouhidari_002 --output data/previous_dakouhidari_002 --file previous_10Hz/dakouhidari_002.txt

dakouhidari_003:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakouhidari_003 --output data/previous_dakouhidari_003 --file previous_10Hz/dakouhidari_003.txt

dakouhidari_004:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/dakouhidari_004 --output data/previous_dakouhidari_004 --file previous_10Hz/dakouhidari_004.txt
	
sayu:
	make right
	make left

right:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/right_001/ --output data/previous_trimright --file previous_10Hz/trimright.txt

left:
	$(PYTHON) scripts/trimming.py --input previous_10Hz/left_001/ --output data/previous_trimleft --file previous_10Hz/trimleft.txt
