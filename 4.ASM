format PE console
entry start

include 'D:\FASM\INCLUDE\win32a.inc'

section '.data' data readable writable
    a            dd 10          ; ������ ��������� (����� ��������)
    b            dd 50          ; ����� ��������� (����� ��������)
    message      db "Prime numbers in range [%d, %d]: ", 10, 0
    format_str   db "%d ", 0
    newline      db 10, 0       ; ������� ������
    wait_message db "Press Enter to exit...", 10, 0

section '.code' code readable executable
start:
    ; ������� ��������� � ������ ������ ������� �����
    lea eax, [message]
    push dword [b]
    push dword [a]
    push eax
    call [printf]
    add esp, 12

    mov ecx, [a]                ; ��������� ������ ��������� � ECX
    mov edx, [b]                ; ��������� ����� ��������� � EDX

find_primes:
    cmp ecx, edx                ; ���������, �� ����� �� �� ������� ���������
    jg print_newline            ; ���� ��, ��������� � ����������

    mov ebx, ecx                ; EBX = ������� �����
    cmp ebx, 1                  ; ����� <= 1 �� �������� �������
    jle next_number

    cmp ebx, 2                  ; ����� 2 �������� �������
    je print_prime

    mov esi, 2                  ; ESI = ��������, ������� � 2

check_divisors:
    mov eax, ebx                ; EAX = ������� �����
    xor edx, edx                ; �������� EDX ��� �������
    div esi                     ; ����� EAX �� ESI
    test edx, edx               ; ��������� ������� �� �������
    jz next_number              ; ���� ������� ��� �������, ����� �� �������

    mov eax, ebx                ; EAX = ������� �����
    mov edi, esi                ; EDI = ������� ��������
    imul edi, edi               ; EDI = ������� ��������
    cmp edi, ebx                ; ���� ������� �������� > �����, ����� �������
    jge print_prime

    inc esi                     ; ��������� � ���������� ��������
    jmp check_divisors          ; ���������� ��������

print_prime:
    ; ������� ������� �����
    push ebx
    lea eax, [format_str]
    push eax
    call [printf]
    add esp, 8

next_number:
    inc ecx                     ; ��������� � ���������� �����
    jmp find_primes             ; ���������� �����

print_newline:
    ; ������� ������� ������
    lea eax, [newline]
    push eax
    call [printf]
    add esp, 4

    ; ������� ��������� ��������
    lea eax, [wait_message]
    push eax
    call [printf]
    add esp, 4

    ; ��� ������� ������� Enter
    call [getchar]

exit_program:
    push 0                      ; ��� ������
    call [ExitProcess]          ; ��������� ���������

section '.idata' import data readable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', getchar, 'getchar'