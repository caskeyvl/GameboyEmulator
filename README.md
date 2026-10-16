# GameboyEmulator

A Game Boy CPU core and (eventually) full system, written in SystemVerilog and
targeting an FPGA — not a software emulator. Long-term goal is a from-scratch
FPGA Game Boy with its own PCB and hardware upgrades (Bluetooth link cable,
etc.) rather than a 1:1 clone.

## Target hardware

- **FPGA:** Lattice ECP5 (open toolchain: yosys + nextpnr + Project Trellis —
  no vendor license needed, and no licensing issues if this ever becomes a
  board others can buy/build).
- Dev board TBD (e.g. OrangeCrab / ULX3S) before moving to a custom PCB.
- Wireless features (BLE link cable, save sync, etc.) will come from a
  companion MCU/radio (ESP32 or nRF52) on the same PCB talking to the FPGA
  over SPI/UART — not implemented on the FPGA fabric itself.

## Current state

Early bring-up of the SM83 (Game Boy CPU) datapath:

- `src/sm83_pkg.sv` — shared types: ALU op enum, flags struct, register
  selector enums.
- `src/registers.sv` — SM83 register file (A/F/B/C/D/E/H/L, SP, PC), muxed
  8-bit/16-bit read/write. Resets to post-boot-ROM state.
- `src/alu.sv` — ALU; core 8-bit ops (ADD/ADC/SUB/SBC/AND/XOR/OR/CP/INC/DEC)
  implemented. 16-bit math, rotates/shifts, bit ops, DAA/CPL are stubs or
  not yet started.

Nothing is wired together yet — no instruction decoder/control unit, no
memory bus, no simulation testbench, no PPU, no APU, no top-level module,
and no board target.

## Roadmap

1. **CPU core**
   - Finish ALU (16-bit ops, rotates/shifts, bit ops, DAA/CPL)
   - Instruction decoder + control unit (fetch/decode/execute state machine)
   - Memory bus interface
   - Interrupt handling (IE/IF, EI/DI, HALT/STOP)
   - Testbench against a known-good instruction trace (e.g. a Blargg test
     ROM or SM83 JSON test vectors) before trusting the core
2. **Memory + cartridge**
   - WRAM/VRAM/OAM/HRAM as block RAM
   - Boot ROM
   - MBC support (start with MBC1/MBC3) for real cartridge dumps
3. **Video (PPU)**
   - Background/window/sprite rendering, scanline timing matched to real HW
   - Simulated output first (frame dump to PNG), then real display out
4. **Audio (APU)**
   - 4 channels, mixed output to a DAC or PWM
5. **Top-level + first real hardware run**
   - Wire CPU + bus + PPU + APU together on the chosen dev board
   - Button input, display output, audio output
6. **Custom PCB**
   - ECP5 + flash + power + cartridge slot + display/audio I/O
   - Companion MCU/radio for Bluetooth (link cable over BLE, save sync, etc.)
7. **Upgrades beyond stock Game Boy**
   - Ideas to evaluate once the base system works: save states, rewind,
     higher-res/GBC-aware PPU mode, USB/BLE link cable, battery + charging
     circuit for a portable build

## Building / simulation

Not set up yet. Planned: `yosys` + `nextpnr-ecp5` for synthesis, and a
SystemVerilog-capable simulator (Verilator or similar) for testbenches,
once the decoder and bus exist and there's something worth simulating.
