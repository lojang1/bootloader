# Bootloader And Kernel

This is a bootloader written in assembly, designed to be placed in the first sector of a bootable disk and executed during the boot process.In addition to the bootloader, I wrote a simple kernel written in C, with minimal features. Both the bootloader and  linked it with a linker script. 

## Table of Contents
1.
2. [Project Structure](#project_structure)
3. [Commands](#commands)
4.

## Project Structure
`
/boot/
│   ├── src/  
│   │   ├── boot.asm      # Stage 1 bootloader
│   │   ├── kernel.h
│   │   └── kernel.c      # Main kernel logic 
│   ├── build/  
│   └── bin/  
├── Makefile              # Builds disk image
└── docs/                 # Schematics (optional)
`

## Commands
- qemu-system-x86_64 -hda bin/os.bin 
