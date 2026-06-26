# 4-Bit ALU using Verilog HDL

A simple 4-Bit Arithmetic Logic Unit (ALU) implemented in Verilog HDL. The ALU performs basic arithmetic and logical operations on two 4-bit inputs using a 3-bit opcode. This project is intended for learning digital design, Verilog programming, and simulation.

## Features

- 4-bit combinational ALU
- Arithmetic operations: Addition, Subtraction, Increment, Decrement
- Logic operations: AND, OR, XOR, NOT
- Carry and Zero flag generation
- Verilog testbench included

## Project Structure

```
├── alu.v
├── alu_tb.v
└── README.md
```

## Supported Operations

| Opcode | Operation |
|:------:|-----------|
| 000 | Addition |
| 001 | Subtraction |
| 010 | AND |
| 011 | OR |
| 100 | XOR |
| 101 | NOT |
| 110 | Increment |
| 111 | Decrement |

## Simulation

```bash
iverilog -o alu alu.v alu_tb.v
vvp alu
gtkwave dump.vcd
```

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- ModelSim / Vivado
