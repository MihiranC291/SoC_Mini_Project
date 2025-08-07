# Hybrid Montgomery Multiplier using NTT (SystemVerilog)

This project implements a **1024-bit modular multiplier** using a **Montgomery Multiplication & Number Theoretic Transform (NTT)** approach.


## Overview

The design performs modular multiplication using the following flow:

1. **Forward NTT** on operand `A`
2. **Pointwise multiplication** with operand `B`
3. **Inverse NTT (INTT)** to bring the result back to normal form
4. **Final modular reduction** with modulus `M`


## Top-Level Module: `hybrid_montgomery.sv`

### Parameters
| Parameter | Description |
|----------|-------------|
| `N`      | Operand bit-width (e.g., 1024 bits) |
| `W`      | Word size (e.g., 32 bits per coefficient) |
| `P`      | Prime modulus used for NTT (e.g., 12289) |

### I/O Ports
| Port    | Direction | Description |
|---------|-----------|-------------|
| `clk`   | Input     | Clock signal |
| `rst`   | Input     | Reset signal |
| `start` | Input     | Start the multiplication |
| `done`  | Output    | Indicates completion |
| `A`, `B`| Input     | 1024-bit operands |
| `M`     | Input     | 1024-bit modulus |
| `Y`     | Output    | 1024-bit result of `(A * B) mod M` |


## FSM Stages

| State      | Description                          |
|------------|--------------------------------------|
| `IDLE`     | Wait for the `start` signal          |
| `LOAD`     | Load operands into registers         |
| `NTT`      | Forward NTT on operand `A`           |
| `POINTWISE`| Multiply NTT(A) with `B`             |
| `INTT`     | Inverse NTT to get result            |
| `DONE_ST`  | Final modular reduction and done     |


## Internal Components

### `ntt_engine`
- Performs forward NTT transform
- Converts operand into NTT (frequency) domain

### `pointwise_mult`
- Element-wise multiplication in NTT domain
- Uses modulo `P` for arithmetic

### `intt_engine`
- Performs inverse NTT transform
- Recovers time-domain result


## 🛠Simulation & Testing

This project is structured for simulation on various tools, such as Xilinx Vivado, and EDA Playground.

We use the testbench file to:
- Apply 1024-bit values for `A`, `B`, `M`
- Assert `start`
- Wait for `done`
- Check output `Y`

## Potential Use Cases

- Modular multiplication in RSA, and ECC.
- Lattice-based cryptography.
- Hardware accelerators for large-integer arithmetic.


## Note:
- NTT and INTT modules are simplified for this project.
- Real designs will include:
  - Twiddle factor ROMs
  - Butterfly computation stages
  - Montgomery reduction optimizations
- This version is suitable for concept exploration and academic projects.


## License

This project is released under the MIT License. Feel free to use, modify, and contribute!


## Author

**Mihiran Chakraborty**  
[GitHub](https://github.com/MihiranC291)


## References
[1](https://ieeexplore.ieee.org/document/6296657).
[2](https://ieeexplore.ieee.org/document/7070700).
