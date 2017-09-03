; ��������� �����, ���� � ���������� ������� ���������(�� ����� 3-� ������ ������ �����).
; ����� � ����������������� ������� ���������.
.386
.MODEL FLAT, STDCALL
OPTION CASEMAP: NONE
; ��������� ������� ������� (��������) ����������� ���������� EXTERN, 
; ����� ����� @ ����������� ����� ����� ������������ ����������,
; ����� ��������� ����������� ��� �������� ������� � ���������
EXTERN  GetStdHandle@4: PROC
EXTERN  WriteConsoleA@20: PROC
EXTERN  CharToOemA@8: PROC
EXTERN  ReadConsoleA@20: PROC
EXTERN  ExitProcess@4: PROC; ������� ������ �� ���������
EXTERN  lstrlenA@4: PROC; ������� ����������� ����� ������
EXTERN  wsprintfA: PROC; �.�. ����� ���������� ������� �� �����������,
			; ������������ ����������, �������� �������� ������� ���� 
			; ���������� ���������
.DATA; ������� ������
STRN_1 DB "������� ������ �����: ",13,10,0; ��������� ������, � ����� ���������
; ����������� �������: 13 � ������� �������, 10 � ������� �� ����� 
; ������, 0 � ����� ������; � �������������� ��������� DB 
; ������������� ������ ������
STRN_2 DB "������� ������ �����: ",13,10,0; ��������� ������, � ����� ���������
; ����������� �������: 13 � ������� �������, 10 � ������� �� ����� 
; ������, 0 � ����� ������; � �������������� ��������� DB 
; ������������� ������ ������
FMT DB "�������� ���������: %d", 0; ������ �� ������� �������� ��� ������� wsprintfA
DIN DD ?; ���������� �����; ��������� DD ����������� ������ �������
; 32 ���� (4 �����), ���� �?� ������������ ��� �������������������� ������
DOUT DD ?; ���������� ������
BUF_1  DB 200 dup (?); ����� ��� ��������/��������� ����� ������ 200 ������
BUF_2  DB 200 dup (?); ����� ��� ��������/��������� ����� ������ 200 ������
RESULT  DB 200 dup (?); ����� ��� ��������/��������� ����� ������ 200 ������
LENS_1 DD ?; ���������� ��� ���������� ���������� ��������
LENS_2 DD ?; ���������� ��� ���������� ���������� ��������
TEMP DW ?
COUNT DD 0
.CODE; ������� ���� 
MAIN PROC; ������ �������� ��������� � ������ MAIN

;______________________________________________________________________________________

; ������������ ������ STRN
MOV  EAX, OFFSET STRN_1;	�������� MOV  �������� ������� �������� 
; ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX
CALL CharToOemA@8; ����� �������
; ������������ ������ FMT
MOV  EAX, OFFSET FMT
PUSH EAX 
PUSH EAX
CALL CharToOemA@8; ����� �������
; ������� ���������� ����� 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; ����������� ��������� �� �������� EAX 
; � ������ ������ � ������ DIN
; ������� ���������� ������
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX 
; ��������� ����� ������ STRN
PUSH OFFSET STRN_1; � ���� ���������� ����� ������
CALL lstrlenA@4; ����� � EAX
; ����� ������� WriteConsoleA ��� ������ ������ STRN
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS_1; 4-� ��������
PUSH EAX; 3-� ��������
PUSH OFFSET STRN_1; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20

; ���� ������
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS_1; 4-� ��������
PUSH 200; 3-� ��������
PUSH OFFSET BUF_1; 2-� ��������
PUSH DIN; 1-� ��������
CALL ReadConsoleA@20 ; �������� ��������: LENS ������ ����� ���������
; �������� �� ���, ������������� ��������� �������: 13 � ������� ������� � 
; 10 � ������� �� ����� ������
; ����� ���������� ������

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

MOV  EAX, OFFSET STRN_2;	�������� MOV  �������� ������� �������� 
; ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX
CALL CharToOemA@8; ����� �������
; ������������ ������ FMT
MOV  EAX, OFFSET FMT
PUSH EAX 
PUSH EAX
CALL CharToOemA@8; ����� �������
; ������� ���������� ����� 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; ����������� ��������� �� �������� EAX 
; � ������ ������ � ������ DIN
; ������� ���������� ������
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX 
; ��������� ����� ������ STRN
PUSH OFFSET STRN_2; � ���� ���������� ����� ������
CALL lstrlenA@4; ����� � EAX
; ����� ������� WriteConsoleA ��� ������ ������ STRN
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS_2; 4-� ��������
PUSH EAX; 3-� ��������
PUSH OFFSET STRN_2; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20

; ���� ������
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS_2; 4-� ��������
PUSH 200; 3-� ��������
PUSH OFFSET BUF_2; 2-� ��������
PUSH DIN; 1-� ��������
CALL ReadConsoleA@20 ; �������� ��������: LENS ������ ����� ���������
; �������� �� ���, ������������� ��������� �������: 13 � ������� ������� � 
; 10 � ������� �� ����� ������
; ����� ���������� ������
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
PUSH COUNT; ����� �������� ������
PUSH OFFSET RESULT
PUSH DOUT
CALL WriteConsoleA@20


;______________________________________________________________________________________

CALL ExitProcess@4
MAIN ENDP; ���������� �������� ��������� � ������ MAIN
END MAIN; ���������� �������� ������ � ��������� ������ ����������� ���������
;______________________________________________________________________________________