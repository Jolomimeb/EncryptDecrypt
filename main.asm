	section .data
extern display
extern readHelper
extern caesar
extern return_message
extern displayEE
;extern printf, fgets, strcspn, isupper, strlen, strcpy
extern decrypt_message
stringsArray dq string1, string2, string3, string4, string5, string6, string7, string8, string9, string10

format db "%s\n", 0
string1 dq "This is the original message1", 10
string2 dq "This is the original message2", 10
string3 dq "This is the original message3", 10
string4 dq "This is the original message4", 10
string5 dq "This is the original message5", 10
string6 dq "This is the original message6", 10
string7 dq "This is the original message7", 10
string8 dq "This is the original message8", 10
string9 dq "This is the original message9", 10
string10 dq "This is the original message10.", 10

size		equ 10

prompt_menu     db "Encryption menu options:", 10
                db "s - show current messages", 10
                db "r - read new message", 10
                db "c - caesar cipher", 10
                db "f - frequency decrypt", 10
                db "q - quit program", 10
                db "enter option letter -> ", 10
len_pm              equ $-prompt_menu

text1               db  "Current message: "
len_t1              equ $-text1

text2               db  "Caesar encryption: "
len_t2              equ $-text2

user_numb           db  "Enter a shift value between -25 and 25 (included)", 10
len_n               equ $-user_numb

location_number     db 	"Enter string location:", 10
len_ln		    equ 	$-location_number

test_string	db 	"ABCD EFGH abcd efgh.", 10
len_ts		equ	$-test_string

new_line            db  10

min                 db  -25
max                 db  25

count		  db 	0

;numb_len    equ     4

invalid_input_msg   db  "Invalid input, ", 10
invalid_input_msg_len   equ $-invalid_input_msg

	section .bss
user_choice     resb    4
numb_buff       resb    4
string_buff     resb    100
len_sb          equ     $-string_buff
string_location resb	4

	section .text

	global main

main:
    call get_input

exit:
    	mov rax, 60
    	xor edi, edi
    	syscall

invalid_input:
    	;print error message for invalid input
    	mov rax, 1
    	mov rdi, 1
   	mov rsi, invalid_input_msg
    	mov rdx, invalid_input_msg_len
    	syscall
	jmp get_input

get_input:
    	;print prompt_menu message
    	mov rax, 1
    	mov rdi, 1
    	mov rsi, prompt_menu
    	mov rdx, len_pm
    	syscall

    	; stores user number input
    	mov rax, 0
    	mov rdi, 0
    	mov rsi, user_choice
    	mov rdx, 4
    	syscall

	;check if user entered 'q' or 'Q' to exit
	movzx rax, byte [user_choice]
    	cmp al, 'q'
    	je exit
    	cmp al, 'Q'
    	je exit

	;handle user input
	cmp al, 's'
    	je show_message

	cmp al, 'r'
        je read_message

	cmp al, 'c'
	je caesar_cipher

	cmp al, 'f'
        je frequency_decrypt

	cmp al, 'z'
	je easter_egg

	;handle invalid input
    	call invalid_input

    	jmp get_input  ;Jump back to get_input
    ret

show_message:
	;pass the parameters to the function and call the function
	mov rdi, stringsArray
        mov rsi, size

    	call display
	jmp get_input
	ret
read_message:
	;pass the parameters to the function and call the function
	mov rdi, stringsArray
        mov rsi, size

    	call readHelper
	jmp get_input
	ret
frequency_decrypt:
	;pass the array into the return message function
	mov rdi, stringsArray
        call return_message

	;pass the string into the secrypt function
	mov rdi, rax
	call decrypt_message

	;jump back to get_input
	jmp get_input
        ret

caesar_cipher:

	;return message at given location
	;mov rcx, rax
	mov rdi, stringsArray
	call return_message

	;store returned address in rbx
	mov rbx, rax

	; print user_numb message
        mov rax, 1
        mov rdi, 1
        mov rsi, user_numb
        mov rdx, len_n
        syscall

        ; stores user number input
        mov rax, 0
        mov rdi, 0
        mov rsi, numb_buff
        mov rdx, 4
        syscall

      	call convert_to_int
        ;check if the shift value is within the valid range
        mov rax, [numb_buff]
        cmp rax, -25
        jl invalid_input2
        cmp rax, 25
        jg invalid_input2

	;mov rsi, rbx ;test_string
	;mov rdi, rbx ;test_string
	;mov rdx, numb_buff
        ;call caesar

        jmp get_input
        ret

invalid_input2:
        ;print error message for invalid input
        mov rax, 1
        mov rdi, 1
        mov rsi, invalid_input_msg
        mov rdx, invalid_input_msg_len
        syscall
	jmp caesar_cipher

	ret

easter_egg:
	cmp byte [count], 0
	je easter_helper

	cmp byte [count], 1
	je easter_helper

	cmp byte [count], 2
	je easter_helper

	cmp byte [count], 3

        ;print easter_egg message
        call displayEE
	mov byte [count], 0
	jmp get_input
easter_helper:
        inc byte [count]
	jmp invalid_input

convert_to_int:
        ; Convert numb_buff to an integer
        xor rax, rax
        xor rbx, rbx        ;rbx will be used as a flag to indicate if the number is negative
        mov rcx, 4
        mov rdi, numb_buff

        ; Check if the first character is a minus sign
        movzx rdx, byte [edi]
        cmp rdx, '-'
        jne start_convert_loop
        inc rdi             ; Skip the minus sign
        mov rbx, 1          ; Set the negative flag
start_convert_loop:
        convert_loop:
        movzx rdx, byte [edi]
        cmp rdx, '0'
        jl end_convert_loop
        cmp rdx, '9'
        jg end_convert_loop
        sub rdx, '0'
        imul rax, 10
        add rax, rdx
        inc rdi
        loop convert_loop

end_convert_loop:
        ; Multiply the result by -1 if the negative flag is set
        test rbx, rbx
        jz skip_negate
        neg rax

skip_negate:
        ; Exit the program and move int value to numb_buff
        mov [numb_buff], rax
        ret
