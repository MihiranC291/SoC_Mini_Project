# SoC_Mini_Project
Was assigned the Montgomery Multiplication algorithm for a hardware design project. 

## Background
Montgomery Multiplication avoids direct division that is computationally expensive by using its special conversion of data into a ‘montgomery form’. 
This concept refers to a space in which the computationally efficient right shift operation can be used.
It involves the use of radix representation of data, and the use of a modular parameter to facilitate reduction using bitwise shifts.
This algorithm draws interest due to:
- It’s efficient modular multiplication.
- It’s comparatively low latency operations.
- It's scalability for higher bit size data.
Despite these qualities, it suffers from high hardware complexity, and the necessity of hardware changes for different bit sizes.
This algorithm still finds application in secure microcontrollers, low power design considerations, and is easily ported to FPGA.

## Algorithm
The basic steps are as follows:
Step 1: Precompute R as 2^n where n is the bit length of data input, and M’ as -M^-1 mod R.
Step 2: Initialise T=0.
Step 3: Iterate over bits. For each bit bi of B from least to most significant,
* Compute the partial product T.
* Compute q.
* Compute updated T.
Step 4: If T>= M, subtract M from it to ensure that the output is within the limit [0, M-1]

