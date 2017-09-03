; Вычитание чисел, ввод в десятичной системе счиселния(не менее 3-х знаков каждое число).
; Вывод в шестнадцатеричной системе счисления.
.386
.MODEL FLAT, STDCALL
OPTION CASEMAP: NONE
; прототипы внешних функций (процедур) описываются директивой EXTERN, 
; после знака @ указывается общая длина передаваемых параметров,
; после двоеточия указывается тип внешнего объекта – процедура
EXTERN  GetStdHandle@4: PROC
EXTERN  WriteConsoleA@20: PROC
EXTERN  CharToOemA@8: PROC
EXTERN  ReadConsoleA@20: PROC
EXTERN  ExitProcess@4: PROC; функция выхода из программы
EXTERN  lstrlenA@4: PROC; функция определения длины строки
EXTERN  wsprintfA: PROC; т.к. число параметров функции не фиксировано,
			; используется соглашение, согласно которому очищает стек 
			; вызывающая процедура
.DATA; сегмент данных
STRN_1 DB "Введите первое число: ",13,10,0; выводимая строка, в конце добавлены
; управляющие символы: 13 – возврат каретки, 10 – переход на новую 
; строку, 0 – конец строки; с использованием директивы DB 
; резервируется массив байтов
STRN_2 DB "Введите второе число: ",13,10,0; выводимая строка, в конце добавлены
; управляющие символы: 13 – возврат каретки, 10 – переход на новую 
; строку, 0 – конец строки; с использованием директивы DB 
; резервируется массив байтов
FMT DB "Резуьтат вычитания: %d", 0; строка со списком форматов для функции wsprintfA
DIN DD ?; дескриптор ввода; директива DD резервирует память объемом
; 32 бита (4 байта), знак «?» используется для неинициализированных данных
DOUT DD ?; дескриптор вывода
BUF_1  DB 200 dup (?); буфер для вводимых/выводимых строк длиной 200 байтов
BUF_2  DB 200 dup (?); буфер для вводимых/выводимых строк длиной 200 байтов
RESULT  DB 200 dup (?); буфер для вводимых/выводимых строк длиной 200 байтов
LENS_1 DD ?; переменная для количества выведенных символов
LENS_2 DD ?; переменная для количества выведенных символов
TEMP DW ?
COUNT DD 0
.CODE; сегмент кода 
MAIN PROC; начало описания процедуры с именем MAIN

;______________________________________________________________________________________

; перекодируем строку STRN
MOV  EAX, OFFSET STRN_1;	командой MOV  значение второго операнда 
; перемещается в первый, OFFSET – операция, возвращающая адрес
PUSH EAX; параметры функции помещаются в стек командой PUSH
PUSH EAX
CALL CharToOemA@8; вызов функции
; перекодируем строку FMT
MOV  EAX, OFFSET FMT
PUSH EAX 
PUSH EAX
CALL CharToOemA@8; вызов функции
; получим дескриптор ввода 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; переместить результат из регистра EAX 
; в ячейку памяти с именем DIN
; получим дескриптор вывода
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX 
; определим длину строки STRN
PUSH OFFSET STRN_1; в стек помещается адрес строки
CALL lstrlenA@4; длина в EAX
; вызов функции WriteConsoleA для вывода строки STRN
PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LENS_1; 4-й параметр
PUSH EAX; 3-й параметр
PUSH OFFSET STRN_1; 2-й параметр
PUSH DOUT; 1-й параметр
CALL WriteConsoleA@20

; ввод строки
PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LENS_1; 4-й параметр
PUSH 200; 3-й параметр
PUSH OFFSET BUF_1; 2-й параметр
PUSH DIN; 1-й параметр
CALL ReadConsoleA@20 ; обратите внимание: LENS больше числа введенных
; символов на два, дополнительно введенные символы: 13 – возврат каретки и 
; 10 – переход на новую строку
; вывод полученной строки

MOV DI, 10
MOV ECX, LENS_1
SUB ECX, 2
MOV ESI, OFFSET BUF_1
XOR BX, BX
XOR AX, AX
CONVERT1:
	MOV BL, [ESI]
	SUB BL, '0'
	MUL DI
	ADD AX, BX
	INC ESI
LOOP CONVERT1
MOV TEMP, AX

;______________________________________________________________________________________

MOV  EAX, OFFSET STRN_2;	командой MOV  значение второго операнда 
; перемещается в первый, OFFSET – операция, возвращающая адрес
PUSH EAX; параметры функции помещаются в стек командой PUSH
PUSH EAX
CALL CharToOemA@8; вызов функции
; перекодируем строку FMT
MOV  EAX, OFFSET FMT
PUSH EAX 
PUSH EAX
CALL CharToOemA@8; вызов функции
; получим дескриптор ввода 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; переместить результат из регистра EAX 
; в ячейку памяти с именем DIN
; получим дескриптор вывода
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX 
; определим длину строки STRN
PUSH OFFSET STRN_2; в стек помещается адрес строки
CALL lstrlenA@4; длина в EAX
; вызов функции WriteConsoleA для вывода строки STRN
PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LENS_2; 4-й параметр
PUSH EAX; 3-й параметр
PUSH OFFSET STRN_2; 2-й параметр
PUSH DOUT; 1-й параметр
CALL WriteConsoleA@20

; ввод строки
PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LENS_2; 4-й параметр
PUSH 200; 3-й параметр
PUSH OFFSET BUF_2; 2-й параметр
PUSH DIN; 1-й параметр
CALL ReadConsoleA@20 ; обратите внимание: LENS больше числа введенных
; символов на два, дополнительно введенные символы: 13 – возврат каретки и 
; 10 – переход на новую строку
; вывод полученной строки
MOV DI, 10
MOV ECX, LENS_2
SUB ECX, 2
MOV ESI, OFFSET BUF_2
XOR BX, BX
XOR AX, AX
CONVERT2:
	MOV BL, [ESI]
	SUB BL, '0'
	MUL DI
	ADD AX, BX
	INC ESI
LOOP CONVERT2

;______________________________________________________________________________________

MOV DX, TEMP
SUB DX, AX
MOV AX, DX

;______________________________________________________________________________________

XOR EBX, EBX
MOV BL, 16
while_begin:
	CMP AX, 16
	JLE while_end
	INC COUNT
	DIV BL
	PUSH AX
	CBW
	JMP while_begin
while_end:



XOR BX, BX
MOV ESI, OFFSET RESULT
MOV ECX, COUNT
CMP AL, 10
	JL translate_e1
	translate_s1:
		ADD AL, 7
	translate_e1:
	ADD AL, 48
	MOV [ESI], AL
	INC ESI
XOR AX, AX
HEX:
	POP BX
	CMP BH, 10
	JL translate_e2
	translate_s2:
		ADD BH, 7
	translate_e2:
	ADD BH, 48
	MOV [ESI], BH
	INC ESI
LOOP HEX

;______________________________________________________________________________________
PUSH 0
INC COUNT
PUSH OFFSET COUNT
PUSH COUNT; длина вводимой строки
PUSH OFFSET RESULT
PUSH DOUT
CALL WriteConsoleA@20


;______________________________________________________________________________________

CALL ExitProcess@4
MAIN ENDP; завершение описания процедуры с именем MAIN
END MAIN; завершение описания модуля с указанием первой выполняемой процедуры
;______________________________________________________________________________________