format PE console
entry start

include 'D:\FASM\INCLUDE\win32a.inc'

section '.data' data readable writable
    a            dd 10          ; Начало интервала (можно изменить)
    b            dd 50          ; Конец интервала (можно изменить)
    message      db "Prime numbers in range [%d, %d]: ", 10, 0
    format_str   db "%d ", 0
    newline      db 10, 0       ; Перенос строки
    wait_message db "Press Enter to exit...", 10, 0

section '.code' code readable executable
start:
    ; Выводим сообщение о начале вывода простых чисел
    lea eax, [message]
    push dword [b]
    push dword [a]
    push eax
    call [printf]
    add esp, 12

    mov ecx, [a]                ; Загружаем начало интервала в ECX
    mov edx, [b]                ; Загружаем конец интервала в EDX

find_primes:
    cmp ecx, edx                ; Проверяем, не вышли ли за пределы интервала
    jg print_newline            ; Если да, переходим к завершению

    mov ebx, ecx                ; EBX = текущее число
    cmp ebx, 1                  ; Число <= 1 не является простым
    jle next_number

    cmp ebx, 2                  ; Число 2 является простым
    je print_prime

    mov esi, 2                  ; ESI = делитель, начиная с 2

check_divisors:
    mov eax, ebx                ; EAX = текущее число
    xor edx, edx                ; Обнуляем EDX для деления
    div esi                     ; Делим EAX на ESI
    test edx, edx               ; Проверяем остаток от деления
    jz next_number              ; Если делится без остатка, число не простое

    mov eax, ebx                ; EAX = текущее число
    mov edi, esi                ; EDI = текущий делитель
    imul edi, edi               ; EDI = квадрат делителя
    cmp edi, ebx                ; Если квадрат делителя > числа, число простое
    jge print_prime

    inc esi                     ; Переходим к следующему делителю
    jmp check_divisors          ; Продолжаем проверку

print_prime:
    ; Выводим простое число
    push ebx
    lea eax, [format_str]
    push eax
    call [printf]
    add esp, 8

next_number:
    inc ecx                     ; Переходим к следующему числу
    jmp find_primes             ; Продолжаем поиск

print_newline:
    ; Выводим перенос строки
    lea eax, [newline]
    push eax
    call [printf]
    add esp, 4

    ; Выводим сообщение ожидания
    lea eax, [wait_message]
    push eax
    call [printf]
    add esp, 4

    ; Ждём нажатия клавиши Enter
    call [getchar]

exit_program:
    push 0                      ; Код выхода
    call [ExitProcess]          ; Завершаем программу

section '.idata' import data readable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', getchar, 'getchar'