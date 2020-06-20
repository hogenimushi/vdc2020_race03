#
# By Hogenimushi
#
PYTHON=python3
SIMULATOR=./DonkeySimLinux/donkey_sim.x86_64

DATASET_10Hz = $(shell find data_10Hz -type d | sed -e '1d' | tr '\n' ' ')
DATASET_05Hz = $(shell find data_05Hz -type d | sed -e '1d' | tr '\n' ' ')

#Trimming
HUKKI_01 = data/hukki_1_01.trimmed data/hukki_1_02.trimmed data/hukki_1_03.trimmed data/hukki_1_04.trimmed \
data/hukki_1_05.trimmed data/hukki_1_06.trimmed data/hukki_1_07.trimmed data/hukki_1_08.trimmed \
data/hukki_1_09.trimmed data/hukki_1_10.trimmed
HUKKI_02 = data/hukki_2_01.trimmed data/hukki_2_02.trimmed data/hukki_2_03.trimmed data/hukki_2_04.trimmed \
data/hukki_2_05.trimmed data/hukki_2_06.trimmed data/hukki_2_07.trimmed data/hukki_2_08.trimmed 
HUKKI_03 = data/hukki_3_01.trimmed data/hukki_3_02.trimmed 
HUKKI_04 = data/hukki_4_01.trimmed data/hukki_4_02.trimmed data/hukki_4_03.trimmed \
data/hukki_4_04.trimmed data/hukki_4_05.trimmed 
HUKKI_05 = data/hukki_5_01.trimmed data/hukki_5_02.trimmed data/hukki_5_03.trimmed
HUKKI_06 = data/hukki_6_01.trimmed data/hukki_6_02.trimmed data/hukki_6_03.trimmed data/hukki_6_04.trimmed data/hukki_6_05.trimmed data/hukki_6_06.trimmed data/hukki_6_07.trimmed data/hukki_6_08.trimmed data/hukki_6_09.trimmed data/hukki_6_10.trimmed
HUKKI_07 = data/hukki_7_01.trimmed data/hukki_7_02.trimmed
HUKKI_08 = data/hukki_8_01.trimmed data/hukki_8_02.trimmed data/hukki_8_03.trimmed data/hukki_8_04.trimmed data/hukki_8_05.trimmed
HUKKI_09 = data/hukki_9_01.trimmed data/hukki_9_02.trimmed
TRM_HUKKI = $(HUKKI_01) $(HUKKI_02) $(HUKKI_03) $(HUKKI_04) $(HUKKI_05) $(HUKKI_06) $(HUKKI_07) $(HUKKI_08) $(HUKKI_09)
TRM_KABE = data/kabe_001.trimmed data/kabe_002.trimmed data/kabe_003.trimmed data/kabe_004.trimmed 
TRM_DAKOU = data/dakoumigi_001.trimmed data/dakoumigi_002.trimmed data/dakoumigi_003.trimmed \
data/dakoumigi_004.trimmed data/dakoumigi_005.trimmed data/dakouhidari_001.trimmed \
data/dakouhidari_002.trimmed data/dakouhidari_003.trimmed data/dakouhidari_004.trimmed
TRM_SAYU = data/left_001.trimmed data/right_001.trimmed
TRM_ALT = data/alt_03_001.trimmed data/alt_03_002.trimmed data/alt_03_003.trimmed data/alt_03_004.trimmed 
TRM_ALL = $(TRM_HUKKI) $(TRM_KABE) $(TRM_DAKOU) $(TRM_SAYU) $(TRM_ALT)

#
GENERATED_DATASET = $(shell find data -type d | sed -e '1d' | tr '\n' ' ')
TEST_DATASET = $(shell find data -type d | sed -e '1d' | tr '\n' ' ')


CURRENT_DATASET = $(shell find data_10Hz -type d | sed -e '1d' | tr '\n' ' ')

PREVIOUS_START = $(shell find previous_10Hz -name 'start*_v3' -type d | tr '\n' ' ')
PREVIOUS_PRE = $(shell find previous_10Hz -name 'pre_*' -type d | tr '\n' ' ')
PREVIOUS_LAP = $(shell find previous_10Hz -name 'lap_*' -type d | tr '\n' ' ')

START_DATA = $(shell find data_10Hz -name 'start*' -type d | tr '\n' ' ')
LAP = $(shell find data_10Hz -name 'lap*' -type d | tr '\n' ' ')

PREVIOUS_MAIN = $(GENERATED_DATASET) $(PREVIOUS_START) $(PREVIOUS_PRE) $(PREVIOUS_LAP) 

MAIN_DATASET = $(GENERATED_DATASET) $(PREVIOUS_START) $(PREVIOUS_PRE) $(START_DATA) \
$(PREVIOUS_LAP) $(LAP)

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



dataset: $(TRM_ALL)


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

models/rnn3.h5: $(MAIN_DATASET)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq3.py

models/rnn2.h5: $(MAIN_DATASET)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq2.py

models/previous_linear.h5: $(PREVIOUS_MAIN)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --myconfig=configs/myconfig_10Hz.py


## Trimming rules
## Target: data/xxx.trimmed 
## Data directory:data_10Hz/xxx 
## Trim file: data_10Hz/xxx.trim
## Generated dir: data/xxx.trimmed_<num>

.PHONY: .trimmed
data/%.trimmed: data_10Hz/%.trim
	$(PYTHON) scripts/trimming.py --input $(<D)/$* --output $@ --file $<

testaaa: $(TRM_ALL)
