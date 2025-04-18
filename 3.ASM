format PE console
entry start

include 'D:\FASM\INCLUDE\win32a.inc'

section '.data' data readable writable
    a            dd 10          ; ������ ��������� (����� ��������)
    b            dd 50          ; ����� ��������� (����� ��������)
    max_divisors dd 0           ; ������������ ���������� ���������
    result       dd 0           ; ����� � ������������ ����������� ���������
    temp         dd 0           ; ��������� ���������� ��� �������� ���������
    i            dd 0           ; ������� �����
    j            dd 0           ; ������ ������� �����
    message      db "Number with the most divisors: %d", 10, 0
    wait_message db "Press Enter to exit...", 10, 0
    format_str   db "%d", 0

section '.code' code readable executable
start:
    mov ecx, [a]                ; ��������� ������ ��������� � ECX
    mov edx, [b]                ; ��������� ����� ��������� � EDX

find_max_divisors:
    cmp ecx, edx                ; ���������, �� ����� �� �� ������� ���������
    jg print_result             ; ���� ��, ��������� � ������ ����������

    mov ebx, ecx                ; EBX = ������� �����
    xor eax, eax                ; EAX = ������� ���������
    mov esi, 1                  ; ESI = ��������, ������� � 1

count_divisors:
    cmp esi, ebx                ; ���� �������� ������ �����, ��������� �������
    jg check_max_divisors
    mov edi, ebx                ; EDI = ������� �����
    xor edx, edx                ; �������� EDX ��� �������
    div esi                     ; ����� EDI �� ESI
    test edx, edx               ; ��������� ������� �� �������
    jnz next_divisor            ; ���� ������� �� ����, ��������� � ���������� ��������
    inc eax                     ; ����������� ������� ���������

next_divisor:
    inc esi                     ; ��������� � ���������� ��������
    jmp count_divisors          ; ���������� �������

check_max_divisors:
    cmp eax, [max_divisors]     ; ���������� ���������� ��������� � ������������
    jl next_number              ; ���� ������, ��������� � ���������� �����
    mov [max_divisors], eax     ; ��������� ������������ ���������� ���������
    mov [result], ebx           ; ��������� ������� ����� ��� ���������

next_number:
    inc ecx                     ; ��������� � ���������� �����
    jmp find_max_divisors       ; ���������� �����

print_result:
    lea eax, [message]          ; ��������� ����� ������ ���������
    push dword [result]         ; �������� ��������� � ����
    push eax                    ; �������� ����� ������ � ����
    call [printf]               ; �������� ������� printf
    add esp, 8                  ; ������� ����

    ; ������� ��������� ��������
    lea eax, [wait_message]     ; ��������� ����� ������ ��������
    push eax                    ; �������� ����� ������ � ����
    call [printf]               ; �������� ������� printf
    add esp, 4                  ; ������� ����

    ; ��� ������� ������� Enter
    call [getchar]              ; �������� getchar ��� �������� �����

exit_program:
    push 0                      ; ��� ������
    call [ExitProcess]          ; ��������� ���������

section '.idata' import data readable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', getchar, 'getchar'