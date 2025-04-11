format PE console
entry start

; Добавляем путь к INCLUDE
include 'D:\fasm\INCLUDE\win32ax.inc'  ; Импортируем макросы и библиотеки из указанного пути

section '.data' data readable writeable
    prompt_x db "Enter the first number (x): ", 0       ; Сообщение для ввода x
    prompt_y db "Enter the second number (y): ", 0     ; Сообщение для ввода y
    format_input db "%d", 0                            ; Формат ввода для scanf
    format_output db "Result: %d", 10, 0               ; Формат вывода для printf
    x dd 0                                             ; Переменная для хранения x
    y dd 0                                             ; Переменная для хранения y
    result dd 0                                        ; Переменная для хранения результата

section '.code' code readable executable
start:
    ; Запрашиваем ввод первого числа (x)
    cinvoke printf, prompt_x                           ; Выводим сообщение "Enter the first number (x): "
    lea eax, [x]                                       ; Загружаем адрес переменной x
    cinvoke scanf, format_input, eax                   ; Считываем значение x

    ; Запрашиваем ввод второго числа (y)
    cinvoke printf, prompt_y                           ; Выводим сообщение "Enter the second number (y): "
    lea eax, [y]                                       ; Загружаем адрес переменной y
    cinvoke scanf, format_input, eax                   ; Считываем значение y

    ; Вычисляем произведение x * y с использованием сложения
    mov ecx, [y]                                       ; Загружаем значение y в регистр ECX (счетчик цикла)
    mov eax, 0                                         ; Обнуляем регистр EAX (аккумулятор для результата)
    mov ebx, [x]                                       ; Загружаем значение x в регистр EBX

multiply_loop:
    add eax, ebx                                       ; Добавляем x (EBX) к результату (EAX)
    loop multiply_loop                                 ; Уменьшаем ECX на 1 и повторяем цикл, пока ECX != 0

    mov [result], eax                                  ; Сохраняем результат в переменную result

    ; Выводим результат
    cinvoke printf, format_output, eax                 ; Выводим результат в консоль

    ; Ожидание нажатия клавиши перед выходом
    cinvoke printf, "Press any key to exit...", 10, 0  ; Выводим сообщение "Press any key to exit..."
    call [getch]                                       ; Ждем нажатия клавиши

    ; Завершение программы
    push 0                                             ; Код завершения программы
    call [ExitProcess]                                 ; Вызываем функцию ExitProcess

section '.idata' import data readable
    library kernel32, 'kernel32.dll', \
            msvcrt, 'msvcrt.dll'

    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', \
           scanf, 'scanf', \
           getch, '_getch'                             ; Импортируем функции printf, scanf и _getchортируем функцию _getch