ASM=nasm
FLAGS= -g -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc -m32 -fno-pie

BUILD_DIR=build
SRC_DIR=src
BIN_DIR=bin

FILES=$(BUILD_DIR)/kernel.asm.o $(BUILD_DIR)/kernel.o

all:
	$(ASM) -f bin $(SRC_DIR)/boot.asm -o $(BIN_DIR)/boot.bin
	$(ASM) -f elf32 -g $(SRC_DIR)/kernel.asm -o $(BUILD_DIR)/kernel.asm.o
	gcc -I$(SRC_DIR) $(FLAGS) -std=gnu99 -c $(SRC_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o
	ld -m elf_i386 -g -relocatable $(FILES) -o $(BUILD_DIR)/f_kernel.o
	gcc $(FLAGS) -T $(SRC_DIR)/linker.ld -o $(BIN_DIR)/kernel.bin -ffreestanding -O0 -nostdlib $(BUILD_DIR)/f_kernel.o

	dd if=$(BIN_DIR)/boot.bin >> $(BIN_DIR)/os.bin
	dd if=$(BIN_DIR)/kernel.bin >> $(BIN_DIR)/os.bin
	dd if=/dev/zero bs=512 count=8 >> $(BIN_DIR)/os.bin

clean:
	rm -f $(BIN_DIR)/*
	rm -f $(BUILD_DIR)/*
