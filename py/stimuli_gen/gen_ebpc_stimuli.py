# Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

from stimuli_params import StimuliParams
import random
import numpy as np

random.seed(12)
np.random.seed(13)


FM_FRAC = 0.01
BATCH_SIZE = 1
N_BATCH = 4
DATA_W = 8
LOG_MAX_WORDS = 24
MAX_ZRLE_LEN = 16
BLOCK_SIZE = 8
#Adjust these to your needs - it's recommended to use absolute paths.
BASE_STIM_DIRECTORY = '/home/georgr/projects/stream-ebpc/simvectors'
DATASET_PATH = '/scratch2/georgr/imagenet/imgs'
DEBUG_FILE = '/home/georgr/projects/stream-ebpc/simvectors/dbg.rpt'

MODULES = ['encoder', 'decoder']
#NETS = ['vgg16', 'resnet34', 'mobilenet2', 'random', 'all_zeros']
NETS = ['random', 'all_zeros']
#import pydevd_pycharm
#pydevd_pycharm.settrace('localhost', port=9100, stdoutToServer=True, stderrToServer=True)

stims = []
for net in NETS:
    dbg_f = DEBUG_FILE if net == 'vgg16' else None
    stims.append(StimuliParams(network=net, fm_frac=FM_FRAC, batch_size=BATCH_SIZE, modules=MODULES, n_batches=N_BATCH, data_w=DATA_W, max_zrle_len=MAX_ZRLE_LEN, block_size=BLOCK_SIZE, dataset_path=DATASET_PATH, num_words_width=LOG_MAX_WORDS, debug_file=dbg_f))

for stim in stims:
    stim.write(BASE_STIM_DIRECTORY)
