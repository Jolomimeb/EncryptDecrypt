section .text

global caesar

caesar:
    ; Parameters
    mov rsi, rsi       ; First parameter (string_buff) in RSI
    mov rdi, rdi       ; Second parameter (numb_buff) in RDI
    mov rdx, rdx
    ; Add numb_buff to each alphabetical letter in the string
    add_loop:
        lodsb
        cmp al, 0
        je end_add_loop

        cmp al, 'A'
        jb not_alphabetical
        cmp al, 'Z'
        jbe shift_capital
        cmp al, 'a'
        jb not_alphabetical
        cmp al, 'z'
        jbe shift_small

    not_alphabetical:
        stosb
        jmp add_loop

    shift_capital:
        add al,byte [rdx]
        cmp al, 'A'
        jl wrap_around_capital
        cmp al, 'Z' + 1
        jle is_alphabetical
        jmp wrap_around_capital

    shift_small:
        add al,byte [rdx]
        cmp al, 'a'
        jl wrap_around_small
        cmp al, 'z' + 1
        jl is_alphabetical
        jmp wrap_around_small

    wrap_around_capital:
        add al, 26
        jmp is_alphabetical

    wrap_around_small:
        sub al, 26
        jmp is_alphabetical

    is_alphabetical:
        stosb
        jmp add_loop

    end_add_loop:
        mov byte [rsi], 0  ;Null-terminate the modified string
    ret
