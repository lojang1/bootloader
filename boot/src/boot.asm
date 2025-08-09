[BITS 16]                    ; Set the code to 16-bit mode
[ORG 0x7c00]                 ; Set the origin (starting address) to x7c00

; Define segment offset for code and data
CODE_OFFSET equ 0x8          ; Set the code segment offset to 0x8
DATA_OFFSET equ 0x10         ; Set the data segment offset to 0x10

start:
    cli                      ; Clear interrupts, disabling all maskable interrupts
    mov ax, 0x00             ; Load immediate value 0x00 into register AX
    mov ds, ax               ; Set data segment (DS) to 0x00
    mov es, ax               ; Set extra segment (ES) to 0x00 
    mov ss, ax               ; Set stack segment (SS) to 0x00
    mov sp, 0x7c00           ; Set stack pointer (SP) to 0x7c00
    sti                      ; Enable interrupts

load_PM:
    cli                                ; Clear interrupts, before protected mode
    lgdt [gdt_descriptor]              ; Load the Global Descriptor Table using its descriptor
    mov eax, cr0                       ; Move the contents of control register CR0 into EAX
    or al, 1                           ; Set the lowest bit of EAX to 1 to enable protected mode
    mov cr0, eax                       ; Move the modified value back into the CR0, enabling protected mode
    jmp CODE_OFFSET:PModeMain          ; Far jmp to switch to the new code segment defined in the GDT

; GDT (Global Descriptor Table) Implementation
gdt_start:
    dd 0x0                   ; Null descriptor
    dd 0x0                   ; Continuation of the null descriptor

    ; Code segment
    dw 0xFFFF                ; Segment limit (4 KB)
    dw 0x0000                ; Base address (low 16 bits)
    db 0x00                  ; Base address (next 8 bits)
    db 10011010b             ; Access byte: present, ring 0, executable, readable
    db 11001111b             ; Flags: 4 KB, 32-bit segment
    db 0x00                  ; Base address (high 8 bits)

    ; Data segment descriptor
    dw 0xFFFF                ; Segment limit (same as code segment)
    dw 0x0000                ; Base address (low 16 bits)
    db 0x00                  ; Base address (next 8 bits)
    db 10010010b             ; Access byte: present, ring 0, writable
    db 11001111b             ; Flags: 4 KB, 32-bit segment
    db 0x00                  ; Base address (high 8 bits)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1         ; Size of GPT minus 1 (size of field for LGDT)
    dd gdt_start                       ; Address of the start of the GDT

[BITS 32]                    ; Switch to 31-bit mode (protected mode)
PModeMain:
    mov ax, DATA_OFFSET      ; Load the data segment offset (0x10) into AX
    mov ds, ax               ; Set DS to the new data segment selector
    mov es, ax               ; Set ES to the new data segment selector
    mov fs, ax               ; Set FS to the new data segment selector
    mov ss, ax               ; Set SS to the new data segment selector
    mov gs, ax               ; Set GS to the new data segment selector
    mov ebp, 0x9C00          ; Set base pointer to 0x9C00
    mov esp, ebp             ; Set stack pointer to the same as EBP, initializing the stack

    in al, 0x92              ; Read the value from I/O port 0x92 (system control port)
    or al, 2                 ; SEt bit 1 of AL to enable A20 line
    out 0x92, al             ; WRite the modified value back to I/O port 0x92

    jmp$

times 510 - ($ - $$) db 0   ; Fill the rest of the boot sector with zeros up to 510 bytes

dw 0xAA55   ; Boot sector signature, required for the BIOS to recognize this as a valid boot sector
