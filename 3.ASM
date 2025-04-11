format PE console
entry start

include 'D:\FASM\INCLUDE\win32a.inc'

section '.data' data readable writable
    a            dd 10          ; Начало интервала (можно изменить)
    b            dd 50          ; Конец интервала (можно изменить)
    max_divisors dd 0           ; Максимальное количество делителей
    result       dd 0           ; Число с максимальным количеством делителей
    temp         dd 0           ; Временная переменная для подсчёта делителей
    i            dd 0           ; Счётчик цикла
    j            dd 0           ; Второй счётчик цикла
    message      db "Number with the most divisors: %d", 10, 0
    wait_message db "Press Enter to exit...", 10, 0
    format_str   db "%d", 0

section '.code' code readable executable
start:
    mov ecx, [a]                ; Загружаем начало интервала в ECX
    mov edx, [b]                ; Загружаем конец интервала в EDX

find_max_divisors:
    cmp ecx, edx                ; Проверяем, не вышли ли за пределы интервала
    jg print_result             ; Если да, переходим к выводу результата

    mov ebx, ecx                ; EBX = текущее число
    xor eax, eax                ; EAX = счётчик делителей
    mov esi, 1                  ; ESI = делитель, начиная с 1

count_divisors:
    cmp esi, ebx                ; Если делитель больше числа, завершаем подсчёт
    jg check_max_divisors
    mov edi, ebx                ; EDI = текущее число
    xor edx, edx                ; Обнуляем EDX для деления
    div esi                     ; Делим EDI на ESI
    test edx, edx               ; Проверяем остаток от деления
    jnz next_divisor            ; Если остаток не ноль, переходим к следующему делителю
    inc eax                     ; Увеличиваем счётчик делителей

next_divisor:
    inc esi                     ; Переходим к следующему делителю
    jmp count_divisors          ; Продолжаем подсчёт

check_max_divisors:
    cmp eax, [max_divisors]     ; Сравниваем количество делителей с максимальным
    jl next_number              ; Если меньше, переходим к следующему числу
    mov [max_divisors], eax     ; Обновляем максимальное количество делителей
    mov [result], ebx           ; Сохраняем текущее число как результат

next_number:
    inc ecx                     ; Переходим к следующему числу
    jmp find_max_divisors       ; Продолжаем поиск

print_result:
    lea eax, [message]          ; Загружаем адрес строки сообщения
    push dword [result]         ; Помещаем результат в стек
    push eax                    ; Помещаем адрес строки в стек
    call [printf]               ; Вызываем функцию printf
    add esp, 8                  ; Очищаем стек

    ; Выводим сообщение ожидания
    lea eax, [wait_message]     ; Загружаем адрес строки ожидания
    push eax                    ; Помещаем адрес строки в стек
    call [printf]               ; Вызываем функцию printf
    add esp, 4                  ; Очищаем стек

    ; Ждём нажатия клавиши Enter
    call [getchar]              ; Вызываем getchar для ожидания ввода

exit_program:
    push 0                      ; Код выхода
    call [ExitProcess]          ; Завершаем программу

section '.idata' import data readable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', getchar, 'getchar'