format PE console
entry start

include 'D:\fasm\INCLUDE\win32a.inc'

section '.data' data readable writable
    input_msg db "Enter a natural number: ", 0
    output_msg db "Sum of even divisors: ", 0
    wait_msg db "Press Enter to exit...", 0
    number dd 0          ; Variable to store the entered number
    sum_even_divisors dd 0 ; Variable to store the sum of even divisors

section '.code' code readable executable
start:
    ; Display the message to enter a number
    push input_msg
    call [printf]
    add esp, 4

    ; Read the number from the console
    push number
    push format_d
    call [scanf]
    add esp, 8

    ; Initialize variables
    mov ecx, 2                  ; Start checking from 2 (the first even divisor)
    mov edx, [number]           ; Load the number into EDX
    xor ebx, ebx                ; Clear EBX (sum of even divisors)

find_even_divisors:
    cmp ecx, edx                ; Check if we have exceeded the number
    jg print_result             ; If yes, proceed to display the result

    mov eax, edx                ; Divide the number by the current divisor
    xor edx, edx
    div ecx

    test edx, edx               ; Check the remainder of the division
    jnz next_divisor            ; If remainder != 0, move to the next divisor

    test ecx, 1                 ; Check if the divisor is even
    jnz next_divisor            ; If odd, move to the next divisor

    add ebx, ecx                ; If even, add it to the sum

next_divisor:
    inc ecx                     ; Move to the next divisor
    jmp find_even_divisors

print_result:
    mov [sum_even_divisors], ebx ; Save the sum in the variable

    ; Display the result message
    push output_msg
    call [printf]
    add esp, 4

    push dword [sum_even_divisors]
    push format_d
    call [printf]
    add esp, 8

    ; Wait for user input before exiting
    push wait_msg
    call [printf]
    add esp, 4

    call [getchar]              ; Wait for the first key press (to clear the buffer)
    call [getchar]              ; Wait for the second key press (Enter key)

    ; Exit the program
    push 0
    call [ExitProcess]

section '.idata' import data readable
    library kernel32, 'kernel32.dll', \
            msvcrt, 'msvcrt.dll'

    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', \
           scanf, 'scanf', \
           getchar, 'getchar'

section '.rdata' data readable
    format_d db "%d", 0