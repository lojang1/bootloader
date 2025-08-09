# Bootloader And Kernel

This is a bootloader written in assembly, designed to be placed in the first sector of a bootable disk and executed during the boot process.In addition to the bootloader, I wrote a simple kernel written in C, with minimal features. Both the bootloader and  linked it with a linker script. 

## Overview

This project demonstrates:
- A 16-bit bootloader written in assembly.
- A 32-bit kernel in written C (enters protected mode).
- Designed for x86 real mode

## Features

1. **Power-On and BIOS Execution**

When the computer powers on:

  - The BIOS (Basic Input/Output System) performs hardware checks (POST - Post-On Self-Test).
  - The BIOS locates a bootable device (e.g. hard disk, USB or CD-ROM) and loads the first 512 bytes (MBR - Master Boot Record) into memory at 0x7C00.
  - The CPU starts executions in 16-bit Real Mode, default mode for x86 processors at boot.

2. **Bootloader Execution in Real Mode**

The bootloader begins execution at 0x7C00 in Real Mode (16-bit, 1 MB addressable memory, segmented memory model).

Key Steps in Real Mode:

   1. Disable Interrupts (cli)
      - Prevents interrupts from interfering with the mode switch.    
   2. Set Up Segments
      - Initialize segment register (DS, ES, SS) to ensure proper memory access.
   3. Enable A20 Line
      - Allows access to memory beyond 1 MB (required for Protected Mode).
      - Fast A20 Gate (port 0x92)
   4. Load the Global Descriptor Table (GDT)
      - The GDT defines memory segment and their attributes for Protected Mode.
      - A minimal GDT typically includes:
          - Null descriptor
          - Code segment descriptor (32-bit, executable)
          - Data segment descriptor (32-bit, readable/writable)
      - The GDT is loaded using LGDT [gdt_descriptor].

3. **Switch to Protected Mode**

To enter 32-bit Protected Mode:

  1. Set the Protected Enable (PE) Bit in CR0
      - `mov eax, cr0`
      - `or al, 1       ; Set PE bit (bit 0)`
      - `mov cr0, eax`
      - This switches the CPU to protected mode, but still uses 16-bit segments.
  2. Far Jump to Flush Pipeline
      - A far jump forces the CPU to reload the CS (code segment) with a 32-bit segment selector from the GDT.
      -
      - This ensures the CPU is fully in 32-bit mode.


4. **Switch to Protected Mode**



## Requirements

## Build & Run
- qemu-system-x86_64 -hda bin/os.bin 
