BITS 16

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax


	mov si, text_string	; Put string position into SI
	mov si, the_menu
	mov si, _shutdown
	mov si, _restart
	mov si, _hibernate
	call print_string	; Call our string-printing routine
	
	
	jmp $			; Jump here - infinite loop!


	text_string db 'Group 8 Set 1', 0
	the_menu db 'Choose an option: ', 0
	_shutdown db '1. Shutdown', 0
	_restart db '2. Restart', 0
	_hibernate db '3. Hibernate', 0


print_string:			; Routine: output string in SI to screen
	mov ch, 0Eh		; int 10h 'print char' function



.repeat:
	lodsb			; Get character from string
	cmp al, 0
	je .done		; If char is zero, end of string
	int 10h			; Otherwise, print it
	jmp .repeat

.done:
	ret


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature
