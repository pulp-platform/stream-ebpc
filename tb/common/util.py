# Copyright 2019 ETH Zurich, Lukas Cavigelli and Georg Rutishauser
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.


from cocotb.binary import BinaryValue
import random
import numpy as np

def zero_pad_bitstr(bitstr, length):
    bitstr += ('0'*((-len(bitstr))%length))
    return bitstr

def zero_pad_list(lst, length):
    lst += ([0]*((-len(lst))%length))
    return lst

def split_str(string, width):
    assert len(string) % width == 0, "Error: Tried to split string into substrings of incompatible length"
    return [string[k*width:(k+1)*width] for k in range(len(string)//width)]

def int_list_to_binval_list(intlist, n_bits, signed):
    binrep = 2 if signed else 0
    return [BinaryValue(value=val, n_bits=n_bits, binaryRepresentation=binrep, bigEndian=False) for val in intlist]

def random_vals(n, data_w):
    vals = [random.randint(-2**(data_w-1), 2**(data_w-1)-1) for k in range(n)]
    return vals
def get_random_nonzero_in_range(lo, hi):
    choice = 0
    while choice == 0:
        choice = np.random.randint(lo, hi)
    return int(choice)
