# Bootloader And Kernel

This is a bootloader written in assembly, designed to be placed in the first sector of a bootable disk and executed during the boot process.In addition to the bootloader, I wrote a simple kernel written in C, with minimal features. Both the bootloader and  linked it with a linker script. 

## Table of Contents
1. [Overview](#overview)
2. [Feature](#commands)
3. [Requirements](#requirements)
4. [Build & Run](#build_&_run)

## Overview

This project demonstrates:
- A 16-bit bootloader written in assembly.
- A 32-bit kernel in C (enters protected mode)
- Designed for x86 real mode

## Features

## Build & Run
- qemu-system-x86_64 -hda bin/os.bin 
