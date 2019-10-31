# Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

from common.data import genStimFiles
import os
import random
import numpy as np

class StimuliParams:
    def __init__(self, network, fm_frac, batch_size, n_batches, data_w, modules, max_zrle_len, block_size, dataset_path, num_words_width, debug_file=None):
        self.net = network
        self.frac = fm_frac
        self.bs = batch_size
        self.nb = n_batches
        self.data_w = data_w
        self.modules = modules
        self.max_zrle_len = max_zrle_len
        self.block_size = block_size
        self.dataset_path = dataset_path
        self.debug_file = debug_file
        self.nww = num_words_width

    def write(self, base_dir):
        stim_dirs = {mod:os.path.join(base_dir, mod, self.net) for mod in self.modules}
        for sd in stim_dirs.values():
            if not os.path.exists(sd):
                try:
                    os.makedirs(sd)
                except:
                    print("Problem creating directory {} - attempting to continue".format(sd))

        if self.net not in ['all_zeros', 'random']:
            filenames = {mod:os.path.join(stim_dirs[mod], self.net) + '_' +\
                         'f{}_'.format(self.frac) + 'bs{}_'.format(self.bs) +\
                         'nb{}_'.format(self.nb) + 'ww{}'.format(self.data_w) for mod in self.modules}
        else:
            filenames = {mod:os.path.join(stim_dirs[mod], self.net) for mod in self.modules}
        genStimFiles(file_prefixes=filenames, modules=self.modules,
                       max_zrle_len=self.max_zrle_len, block_size=self.block_size,
                       model=self.net, dataset_path=self.dataset_path, data_w=self.data_w,
                       num_batches=self.nb, batch_size=self.bs, fmap_frac=self.frac, debug_file=self.debug_file)
