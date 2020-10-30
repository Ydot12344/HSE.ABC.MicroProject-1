format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        ;Ввод N
        strVecSize   db 'Input size of vector: ', 0
        ;При неверном входном N
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        ;Ввод элементов матрицы
        strVecElemI  db '[%d] = ', 0
        ;Считываание int
        strScanInt   db '%d', 0
        ;Вывод определителя
        DetOut       db 'Det = %d', 0

        ;Размер массива
        vec_size     dd 0
        ;Временная переменная для сохранения счетчика при считывании массива
        i            dd ?
        ;Переменные для сохранения промежуточных вычислений определителя
        tmp          dd ?
        tmp2         dd ?
        tmp3         dd ?
        ;Матрица записанная по строкам
        vec          rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) Ввод матрицы
        call VectorInput
        mov eax, [vec_size]
; 2) Выбор нужной функции в соответствии с N
        cmp eax, 1
        je PrintDet1
        cmp eax, 4
        je PrintDet2
        cmp eax, 9
        je PrintDet3
        cmp eax, 16
        je PrintDet4
finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jle  FinishError
        cmp eax, 4
        jg FinishError
        imul eax, eax
        mov [vec_size], eax
        jmp getVector
;If vec_size <= 0 || vec_size > 4
FinishError:
        push [vec_size]
        push strIncorSize
        call [printf]
        call [getch]
        push 0
        call [ExitProcess]

getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector       ; to end of loop

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
PrintDet1:
;N = 1, Det = v[0]
        push [vec]
        push DetOut
        call [printf]
        jmp finish
;--------------------------------------------------------------------------
PrintDet2:
;N = 2, Det = v[0]*v[3] - v[1]*v[2]
        mov eax, [vec]
        imul eax, [vec + 12]
        mov [tmp], eax
        mov eax, [vec + 8]
        imul eax, [vec + 4]
        sub [tmp], eax

        push [tmp]
        push DetOut
        call [printf]
        jmp finish
;--------------------------------------------------------------------------
PrintDet3:
;N = 3, Det = v[0]*(v[4]*v[8]-v[5]*v[7])-v[1]*(v[3]*v[8]-v[6]*v[5])+v[2]*(v[3]*v[7]-v[4]*v[6])
        mov eax, [vec + 4*4]
        imul eax, [vec + 4*8]
        mov [tmp], eax
        mov eax, [vec + 4*5]
        imul eax, [vec + 4*7]
        sub [tmp], eax
        mov eax, [tmp]
        imul eax, [vec]
        mov [tmp], eax
        mov eax, [vec + 4*3]
        imul eax, [vec + 4*8]
        mov [tmp2], eax
        mov eax, [vec + 4*5]
        imul eax, [vec + 4*6]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4]
        sub [tmp], eax
        mov eax, [vec + 4*3]
        imul eax, [vec + 4*7]
        mov [tmp2], eax
        mov eax, [vec + 4*4]
        imul eax, [vec + 4*6]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*2]
        add [tmp], eax


        push [tmp]
        push DetOut
        call [printf]
        jmp finish
;--------------------------------------------------------------------------
PrintDet4:
;N = 4, Det = v[0]*A0 + v[1]*A1 + v[2]*A2 + v[3]*A3, где Ai - алгебраическое дополнение элемента v[i]
        mov eax, [vec + 4*10]
        imul eax, [vec + 4*15]
        mov [tmp], eax
        mov eax, [vec + 4*14]
        imul eax, [vec + 4*11]
        sub [tmp], eax
        mov eax, [tmp]
        imul eax, [vec + 5*4]
        mov [tmp], eax
        mov eax, [vec + 4*9]
        imul eax, [vec + 4*15]
        mov [tmp2], eax
        mov eax, [vec + 4*11]
        imul eax, [vec + 4*13]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*6]
        sub [tmp], eax
        mov eax, [vec + 4*9]
        imul eax, [vec + 4*14]
        mov [tmp2], eax
        mov eax, [vec + 4*10]
        imul eax, [vec + 4*13]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*7]
        add [tmp], eax
        mov eax, [tmp]
        imul eax, [vec]
        mov [tmp3], eax

        mov eax, [vec + 4*10]
        imul eax, [vec + 4*15]
        mov [tmp], eax
        mov eax, [vec + 4*11]
        imul eax, [vec + 4*14]
        sub [tmp], eax
        mov eax, [tmp]
        imul eax, [vec + 4*4]
        mov [tmp], eax
        mov eax, [vec + 4*8]
        imul eax, [vec + 4*15]
        mov [tmp2], eax
        mov eax, [vec + 4*11]
        imul eax, [vec + 4*12]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*6]
        sub [tmp], eax
        mov eax, [vec + 4*8]
        imul eax, [vec + 4*14]
        mov [tmp2], eax
        mov eax, [vec + 4*10]
        imul eax, [vec + 4*12]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*7]
        add [tmp], eax
        mov eax, [tmp]
        imul eax, [vec + 4]
        sub [tmp3], eax

        mov eax, [vec + 4*9]
        imul eax, [vec + 4*15]
        mov [tmp], eax
        mov eax, [vec + 4*11]
        imul eax, [vec + 4*13]
        sub [tmp], eax
        mov eax, [tmp]
        imul eax, [vec + 4*4]
        mov [tmp], eax
        mov eax, [vec + 4*8]
        imul eax, [vec + 4*15]
        mov [tmp2], eax
        mov eax, [vec + 4*11]
        imul eax, [vec + 4*12]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*6]
        sub [tmp], eax
        mov eax, [vec + 4*8]
        imul eax, [vec + 4*13]
        mov [tmp2], eax
        mov eax, [vec + 4*9]
        imul eax, [vec + 4*12]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*7]
        add [tmp], eax
        mov eax, [tmp]
        imul eax, [vec + 8]
        add [tmp3], eax

        mov eax, [vec + 4*9]
        imul eax, [vec + 4*14]
        mov [tmp], eax
        mov eax, [vec + 4*10]
        imul eax, [vec + 4*13]
        sub [tmp], eax
        mov eax, [tmp]
        imul eax, [vec + 4*4]
        mov [tmp], eax
        mov eax, [vec + 4*8]
        imul eax, [vec + 4*14]
        mov [tmp2], eax
        mov eax, [vec + 4*10]
        imul eax, [vec + 4*12]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*5]
        sub [tmp], eax
        mov eax, [vec + 4*8]
        imul eax, [vec + 4*13]
        mov [tmp2], eax
        mov eax, [vec + 4*9]
        imul eax, [vec + 4*12]
        sub [tmp2], eax
        mov eax, [tmp2]
        imul eax, [vec + 4*6]
        add [tmp], eax
        mov eax, [tmp]
        imul eax, [vec + 3*4]
        sub [tmp3], eax

        push [tmp3]
        push DetOut
        call [printf]
        jmp finish

;--------------------------------------------------------------------------
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'