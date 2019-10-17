





Copyright (c) 2019 ETH Zurich, Georg Rutishauser, Lukas Cavigelli, Luca
Benini

# Extended Bit-Plane Compression Hardware Architecture

This repository contains the open-source release of the hardware
implementation of the **Extended Bit-Plane Compression** scheme
described in the paper "[EBPC: Extended Bit-Plane Compression for Deep
Neural Network Inference and Training
Accelerators](https://arxiv.org/abs/1908.11645)". Two top-level modules
are provided: An encoder and a decoder. The implementation language is
SystemVerilog.

If you find this work useful in your research, please cite

``` example
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

The Paper is available on arXiv at <https://arxiv.org/abs/1908.11645>.

The code to reproduce the non-hardware experimental results is available
at <https://github.com/lukasc-ch/ExtendedBitPlaneCompression>.

## Architecture

The variable-length nature of the encoding means that the hardware needs
to concatenate words of variable lengths. This is achieved by using
"streaming registers" and barrel shifters, which make up most of the
logic resources the implementation takes up. A streaming register is a
register of twice the word width of the streamed words. Variable-length
data items are placed in the streaming register from the MSB downwards.
If the streaming register is already partially filled, further items
must thus be logically right-shifted in order not to overwrite with the
contents already present. This process is illustrated
[1](#fig:streamreg). Once a streaming register is full, no more items
can be added until the upper half is streamed out. At this point, the
contents of the lower half must be left shifted by a word width (in the
example, 16 bits).

![Figure 1: <span id="fig:streamreg"></span>Streaming
Register](./fig/stream_reg.png "streamreg")

### Encoder

![Figure 2: <span id="fig:encoder"></span>Encoder
Architecture](./fig/encoder_doc.png "encoder")

The encoder takes a stream of input words and outputs two streams:

  - A **BPC Stream** of the encoded non-zero input words
  - A **ZNZ Stream** of the zero runlength (ZRL) encoded zero/nonzero
    (ZNZ) stream

Along with the input words, the encoder takes a signal `last_i`
indicating whether the word that is currently being input is the last
word of a transmission. This will cause the encoder to flush the BPC and
ZRL encoders.

### Decoder

![](./fig/decoder_doc.png) The decoder is fundamentally a dual of the
encoder - it takes as its inputs the BPC and ZNZ streams produced by the
encoder and streams out the decoded words. To prevent outputting the
zero-padding added in the encoding process, it must also know the number
of unencoded words in the transmission.

### Interfaces

Inputs and outputs are transmitted with **valid/ready** handshake
interfaces, illustrated in the following figure. A transaction occurs on
rising clock edge where the ready signal from the consumer and the valid
signal from the producer are high. Generally, a producer is not allowed
to deassert the valid signal before the corresponding transaction has
been completed, i.e. before the consumer has asserted its valid signal.
The word width of input words and output words is always equal.

![](fig/wave/handshake.svg)

### Parameters

All architecture parameters are defined in the `src/ebpc_pkg.sv`
file:

| Parameter          | Function                                                                      | Tested Values |
| ------------------ | ----------------------------------------------------------------------------- | ------------- |
| `LOG_DATA_W`       | log2ceil of the word width of the input/output data streams                   | 3, 4          |
| `BLOCK_SIZE`       | Bit plane compression block size                                              | 8, 16         |
| `LOG_MAX_WORDS`    | log2ceil of the maximum number of uncompressed words in a single transmission | 24            |
| `LOG_MAX_ZRLE_LEN` | log2ceil of the maximum length of a zero runlength encoding block             | 4             |

#### Constraints on parameters

  - `DATA_W` = `2^LOG_DATA_W` \>= `BLOCK_SIZE`
  - `LOG_DATA_W` \>= `3`

## Operation

### Encoder

1.  Stream in the data to be encoded with the `data_i`, `last_i`,
    `vld_i`, `rdy_o` interface. When the last word is transmitted,
    assert `last_i`.
2.  In parallel, read the output streams:
      - **ZNZ Stream**: `znz_o`, `znz_vld_o`, `znz_rdy_i`.
      - **BPC Stream**: `bpc_o`, `bpc_vld_o`, `bpc_rdy_i`.
3.  When `idle_o` is asserted (after `last_i` was asserted, i.e. input
    streaming has finished), output streaming has concluded and the next
    input transmission may begin.

#### Padding

The last word of the ZNZ stream will be zero-padded. The input to the
internal BPC encoding block will be stuffed with zeros to a full block
size, i.e. if the number of nonzero words in the input stream is not
divisible by the block size, zero words will be inserted.

### Decoder

1.  Tell the block number of words to expect in the decoded
    transmission: `num_words_i`, `num_words_vld_i`, `num_words_rdy_o`.
2.  Stream in the encoded words:
      - **ZNZ Stream**: `znz_i`, `znz_vld_i`, `znz_rdy_o`.
      - **BPC Stream**: `bpc_i`, `bpc_vld_i`, `bpc_rdy_o`.
3.  In parallel, read the decoded output stream: `data_o`, `vld_o`,
    `rdy_i`, `last_o`. `last_o` will be asserted on the last output
    word. The next transmission may only be started after `last_o` has
    been asserted.

### Encoded Stream Format

BPC encoding is a variable-length encoding scheme and the encoded
symbols are packed into words, so the encoded stream looks like this:

![](./fig/out_streams.png)

## Simulating the Designs

Our testbenches are written in Python using
[cocotb](https://github.com/cocotb/cocotb). There are testbenches
supplied for 4 design entities in the `tb` folder:

  - `bpc_encoder` - this block performs bit-plane encoding on the input
    stream
  - `ebpc_encoder` - this top-level encoder block combines the BPC
    encoder and a zero runlength encoder
  - `bpc_decoder` - this block decodes a stream of bit-plane encoded
    data
  - `ebpc_decoder` - this top-level decoder block combines the BPC
    decoder block with a zero runlength decoder.

Makefiles are supplied for each testbench, along with wave view scripts
for Mentor Graphics QuestaSim. The makefiles set the cocotb environment
variable `SIM_ARGS` with QuestaSim-specific options, so for use with
another simulator they will have to be adjusted slightly. To step-debug
the testbenches with [PyCharm](https://www.jetbrains.com/pycharm/), copy
the Pycharm debug egg (`pydevd-pycharm.egg`) to the `tb` folder,
uncomment the line in the Makefile augmenting the `PYTHONPATH`
environment variable and uncomment the lines in the testbench file that
look like this: `#import pydevd_pycharm`
`#pydevd_pycharm.settrace('localhost', port=9100, stdoutToServer=True,
stderrToServer=True)` Follow the
[guide](https://www.jetbrains.com/help/pycharm/remote-debugging-with-product.html)
by JetBrains to set up remote debugging. You will need PyCharm
Professional for this to work.

### Feature Map Tests

The EBPC encoder testbench contains a (commented-out) test
(`fmap_inputs`) which can be used to automatically generate intermediate
feature maps of a variety of networks, as defined in the `data.getModel`
function and feed them to the compressor hardware. The python code uses
the popular [PyTorch](https://pytorch.org/) library. In order for it to
work with QuestaSim and CocoTB, you will have to use [my CocoTB
fork](https://github.com/da-gazzi/cocotb), which allows to pass the
`-noautoldlibpath` argument to QuestaSim in the makefile using the
`PRE_SIM_ARGS` make variable - otherwise, Questa will prepend the
included GCC distributions to the `LD_LIBRARY_PATH`, which are too old
to support PyTorch. To run the tests, you will have to download a
dataset of your choice (e.g. the ImageNet validation set). The code uses
the TorchVision `ImageFolder` data loader, which expects the images to
be located in folders corresponding to their labels. Thus,
`IMAGE_LOCATION` in `ebpc_encoder_tests.py` needs to be set to the
parent folder containing only a subfolder which in turn contains the
images. Note that even just a single images produces massive amounts of
stimuli data, so only a fraction of the feature maps are actually fed to
the hardware (the fraction can be changed with the `FMAP_FRAC`
variable).

## Contact

For information or in case of questions, write a mail to [Georg
Rutishauser](mailto:georgr@iis.ee.ethz.ch). If you find a bug, don't
hesitate to open a GitHub issue\!
