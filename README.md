Copyright (c) 2019 ETH Zurich, Georg Rutishauser, Lukas Cavigelli, Luca Benini


# Extended Bit-Plane Compression Hardware Implementation

This repository contains the open-source release of the hardware
implementation of the **Extended Bit-Plane Compression** scheme described in the
paper "[EBPC: Extended Bit-Plane Compression for Deep Neural Network Inference
and Training Accelerators](https://arxiv.org/abs/1908.11645)". Two top-level modules are provided: An encoder and
a decoder. The implementation language is SystemVerilog.


If you find this work useful in your research, please cite

```
@article{epbc2019,
  title={{EBPC}: {E}xtended {B}it-{P}lane {C}ompression for {D}eep {N}eural {N}etwork {I}nference and {T}raining {A}ccelerators},
  author={Cavigelli, Lukas and Rutishauser, Georg and Benini, Luca},
  year={2019}
}
@inproceedings{cavigelli2018bitPlaneCompr,
  title={{E}xtended {B}it-{P}lane {C}ompression for {C}onvolutional {N}eural {N}etwork {A}ccelerators},
  author={Cavigelli, Lukas and Benini, Luca},
  booktitle={Proc. IEEE AICAS}, year={2018}
}
```
The paper is available on arXiv at https://arxiv.org/abs/1908.11645.

The code to reproduce the non-hardware experimental results 
is available at https://github.com/lukasc-ch/ExtendedBitPlaneCompression. 

## Table of Contents


1.  [Architecture](#orgb835e23)
    1.  [Encoder](#org11f3715)
    2.  [Decoder](#orga89bc33)
    3.  [Interfaces](#org7fc1d72)
    4.  [Parameters](#orgd3f466b)
        1.  [Constraints on parameters](#org1b59181)
2.  [Operation](#org9c5317c)
    1.  [Encoder](#org6a7701d)
        1.  [Padding](#orgfd86d11)
    2.  [Decoder](#orgb9a798e)
    3.  [Encoded Stream Format](#orga20eb8f)
3.  [Simulating the Designs](#org4b3c093)
4.  [Contact](#org85ed66f)






<a id="orgb835e23"></a>

## Architecture

The variable-length nature of the encoding means that the hardware needs to
concatenate words of variable lengths. This is achieved by using "streaming
registers" and barrel shifters, which make up most of the logic resources
the implementation takes up. A streaming register is a register of twice
the word width of the streamed words. Variable-length data items are placed
in the streaming register from the MSB downwards. If the streaming register
is already partially filled, further items must thus be logically
right-shifted in order not to overwrite with the contents already present.
This process is illustrated [the following figure](#orgc54b914). Once a streaming register
is full, no more items can be added until the upper half is streamed out. At
this point, the contents of the lower half must be left shifted by a word
width (in the example, 16 bits).

![img](./fig/stream_reg.png "Streaming Register")


<a id="org11f3715"></a>

### Encoder

![img](./fig/encoder_doc.png "Encoder Architecture")

The encoder takes a stream of input words and outputs two streams: 

-   A **BPC Stream** of the encoded non-zero input words
-   A **ZNZ Stream** of the zero runlength (ZRL) encoded zero/nonzero (ZNZ)
    stream

Along with the input words, the encoder takes a signal `last_i` indicating whether
the word that is currently being input is the last word of a transmission.
This will cause the encoder to flush the BPC and ZRL encoders.


<a id="orga89bc33"></a>

### Decoder

![img](./fig/decoder_doc.png "Decoder Architecture") 
The decoder is fundamentally a dual of the encoder -
it takes as its inputs the BPC and ZNZ streams produced by the encoder and
streams out the decoded words. To prevent outputting the zero-padding added
in the encoding process, it must also know the number of unencoded words in
the transmission.


<a id="org7fc1d72"></a>

### Interfaces

Inputs and outputs are transmitted with **valid/ready** handshake interfaces,
illustrated in the following figure. A transaction occurs on rising clock
edge where the ready signal from the consumer and the valid signal from the
producer are high. Generally, a producer is not allowed to deassert the
valid signal before the corresponding transaction has been completed, i.e.
before the consumer has asserted its valid signal. The word width of input
words and output words is always equal.

    None

![img](fig/wave/handshake.svg)


<a id="orgd3f466b"></a>

### Parameters

All architecture parameters are defined in the `src/ebpc_pkg.sv` file:

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Parameter</th>
<th scope="col" class="org-left">Function</th>
<th scope="col" class="org-left">Tested Values</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">`LOG_DATA_W`</td>
<td class="org-left">log2ceil of the word width of the input/output data streams</td>
<td class="org-left">3, 4</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">`BLOCK_SIZE`</td>
<td class="org-left">Bit plane compression block size</td>
<td class="org-left">8, 16</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">`LOG_MAX_WORDS`</td>
<td class="org-left">log2ceil of the maximum number of uncompressed words in a single transmission</td>
<td class="org-left">24</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">`LOG_MAX_ZRLE_LEN`</td>
<td class="org-left">log2ceil of the maximum length of a zero runlength encoding block</td>
<td class="org-left">4</td>
</tr>
</tbody>
</table>


<a id="org1b59181"></a>

#### Constraints on parameters

-   `DATA_W` = `2^LOG_DATA_W` >= `BLOCK_SIZE`
-   `LOG_DATA_W` >= `3`


<a id="org9c5317c"></a>

## Operation


<a id="org6a7701d"></a>

### Encoder

1.  Stream in the data to be encoded with the `data_i`, `last_i`, `vld_i`,
    `rdy_o` interface. When the last word is transmitted, assert `last_i`.
2.  In parallel, read the output streams:
    -   **ZNZ Stream**: `znz_o`, `znz_vld_o`, `znz_rdy_i`.
    -   **BPC Stream**: `bpc_o`, `bpc_vld_o`, `bpc_rdy_i`.
3.  When `idle_o` is asserted (after `last_i` was asserted, i.e. input
    streaming has finished), output streaming has concluded and the next
    input transmission may begin.


<a id="orgfd86d11"></a>

#### Padding

The last word of the ZNZ stream will be zero-padded. The input to the
internal BPC encoding block will be stuffed with zeros to a full block
size, i.e. if the number of nonzero words in the input stream is not
divisible by the block size, zero words will be inserted.


<a id="orgb9a798e"></a>

### Decoder

1.  Tell the block number of words to expect in the decoded transmission:
    `num_words_i`, `num_words_vld_i`, `num_words_rdy_o`.
2.  Stream in the encoded words:
    -   **ZNZ Stream**: `znz_i`, `znz_vld_i`, `znz_rdy_o`.
    -   **BPC Stream**: `bpc_i`, `bpc_vld_i`, `bpc_rdy_o`.
3.  In parallel, read the decoded output stream:
    `data_o`, `vld_o`, `rdy_i`, `last_o`.
    `last_o` will be asserted on the last output word. The next transmission
    may only be started after `last_o` has been asserted.


<a id="orga20eb8f"></a>

### Encoded Stream Format

BPC encoding is a variable-length encoding scheme and the encoded symbols
are packed into words, so the encoded stream looks like this:

![img](./fig/out_streams.png)


<a id="org4b3c093"></a>

## Simulating the Designs

Our testbenches are written in Python using [cocotb](https://github.com/cocotb/cocotb). There are testbenches
supplied for 4 design entities in the `tb/coco_tests` folder:

-   `bpc_encoder` - this block performs bit-plane encoding on the input stream
-   `ebpc_encoder` - this top-level encoder block combines the BPC encoder and
    a zero runlength encoder
-   `bpc_decoder` - this block decodes a stream of bit-plane encoded data
-   `ebpc_decoder` - this top-level decoder block combines the BPC decoder
    block with a zero runlength decoder.

Makefiles are supplied for each testbench, along with wave view scripts for
Mentor Graphics QuestaSim. The makefiles set the cocotb environment variable
`SIM_ARGS` with QuestaSim-specific options, so for use with another simulator
they will have to be adjusted slightly. To step-debug the testbenches with
[PyCharm](https://www.jetbrains.com/pycharm/), copy the Pycharm debug egg (`pydevd-pycharm.egg`) to the `tb`
folder, uncomment the line in the Makefile augmenting the `PYTHONPATH`
environment variable and uncomment the lines in the testbench file that look
like this:
`#import pydevd_pycharm`
`#pydevd_pycharm.settrace('localhost', port=9100, stdoutToServer=True, stderrToServer=True)`
Follow the [guide](https://www.jetbrains.com/help/pycharm/remote-debugging-with-product.html) by JetBrains to set up remote debugging. You will need
PyCharm Professional for this to work.


<a id="org85ed66f"></a>

## Contact

For information or in case of questions, write a mail to [Georg Rutishauser](mailto:georgr@iis.ee.ethz.ch).
If you find a bug, don't hesitate to open a GitHub issue!

