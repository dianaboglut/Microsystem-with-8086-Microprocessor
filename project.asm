;Scrieti un program în limbaj de asamblare care să calculeze puterea unui număr de bază ridicat la un exponent folosind instrucțiunea LOOP.
dosseg
.model small ; prin această instrucțiune se selectează modelul de memorie folosit
.stack 100h ;declararea segmentului stivă
.data

.code
main proc 
    mov ax, @data 
    mov ds, ax   

; Subrutina pentru inițializarea 8251
INIT_8251:
    MOV DX, 0AF2H   ; adresa portului de stare
    MOV AL,0CEH     ; cuvânt de mod (8 biți de date, fără paritate, factor 16)
    OUT DX,AL       ; citire registru de stare în AL,Trimite setările
    MOV AL,15H      ; cuvant de comanda (activează transmisia și recepția)
    OUT DX,AL       ; scrie cuvântul de comandă
    RET

; Transmiterea unui caracter prin 8251
    MOV DX,0AF2H
TR: IN AL,DX        ; citire şi testare rang TxRDY din cuvântul de stare
    RCR AL,1        ; roteste bitii din reg AL la dreapta mutand si in bitul carry 
    JNC TR          ; va sări la eticheta TR dacă Carry flag este 0
    MOV AL,CL       ; se preia data din registrul CL
    MOV DX,0AF0H    ; adresa portului de date
    OUT DX,AL       ; transmite caracterul
    RET

; Receptia unui caracter prin 8251
    MOV DX,0AF2H
REC:IN AL,DX        ; citire şi testare rang RxRDY din cuvântul de stare
    RCR AL,2        ; rotația se face la dreapta și se mută 2 biți. Aceasta este o modalitate de a verifica valorile din anumite poziții de bit.
    JNC REC         ; salt condiționat care se face doar dacă Carry flag este 0, adică dacă RxRDY este 0 (nu sunt date de citit)
    MOV DX,0AF0H    
    IN AL,DX        ; se preia data de la 8251
    MOV CL,AL       ; se depune data în registrul CL
    RET

; Rutina de programare a 8255
INIT_8255:
    MOV DX,0D76H    
    MOV AL,81H
    OUT DX,AL       ; Trimitem comanda de configurare la 8255
    RET

; Emisie a unui caracter prin 8255
    MOV DX,0D74H
PAR:IN AL,DX        ; citire şi testare BUSY(PORT C)
    RCR AL,1
    JNC PAR
    MOV AL,CL       ; se preia caracterul din registrul CL
    MOV DX,0D70H    
    OUT DX,AL       ; transmit caracterul pe portul A (este cu memorare)
    OR AL,01H       ; anuntam ca s-au plasat date pe liniile portului (strobe signal pe port B)
    MOV DX,0D72H
    OUT DX,AL       ; transmitere caracter modificat pe port B; nu mai sunt car. de citit (/STB = 1)
    AND AL,00H
    OUT DX,AL       ; receptor <- sunt date de citit (/STB = 0) => incarcare date in port
    OR AL,01H
    OUT DX,AL       ; receptor <- nu mai sunt date de transmis (/STB = 1)
    RET



; Rutina de scanare a minitastaturii
; se pune 0 pe prima coloană şi se verifică dacă s-au acţionat tastele 1, 4, 7, *
REIA:   
    MOV	AL,0FEH     ; selectez prima coloana
    OUT	2000H,AL    ; selectez ST1 (iesirea tastaturii)
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,01H      ; verific prima pozitie
    JZ	TASTA1      ; sarim la TASTA1 daca rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,02H      ; verific a doua pozitie
    JZ	TASTA4      ; sarim la TASTA4 rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,04H      ; verific a treia pozitie
    JZ	TASTA7      ; sarim la TASTA7 rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,08H      ; verific a patra pozitie
    JZ	TASTA*      ; sarim la TASTA* rezultatul este 0
; se pune 0 pe a 2-a coloană şi se verifică dacă s-au acţionat tastele 2, 5, 8, 0
    MOV	AL,0FDH     ; selectez a doua coloana
    OUT	2000H,AL    ; selectez ST1 (iesirea tastaturii)
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,01H      ; verific prima pozitie
    JZ	TASTA2      ; sarim la TASTA2 daca rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,02H      ; verific a doua pozitie
    JZ	TASTA5      ; sarim la TASTA5 daca rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,04H      ; verific a treia pozitie
    JZ	TASTA8      ; sarim la TASTA8 daca rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,08H      ; verific a patra pozitie
    JZ	TASTA0      ; sarim la TASTA0 daca rezultatul este 0
; se pune 0 pe a 3-a coloană şi se verifică dacă s-au acţionat tastele 3, 6, 9, # 
    MOV	AL,0FBH     ; selectez a treia coloana
    OUT	2000H,AL    ; selectez ST1 (iesirea tastaturii)
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,01H      ; verific prima pozitie
    JZ	TASTA3      ; sarim la TASTA3 daca rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,02H      ; verific a doua pozitie
    JZ	TASTA6      ; sarim la TASTA6 daca rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,04H      ; verific a treia pozitie
    JZ	TASTA9      ; sarim la TASTA9 daca rezultatul este 0
    IN	AL,2020H    ; incarc continutul de la adresa 2020H
    AND	AL,08H      ; verific a patra pozitie
    JZ	TASTA#      ; sarim la TASTA# daca rezultatul este 0
; se reia baleierea
    JMP REIA        ; se reia procesul
; tratarea acţionării tastei 1
TASTA1: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T1: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea  tastei 		             
    AND	AL,01H
    JZ	T1
    CALL DELAY
    MOV CL, 01H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 2
TASTA2: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T2: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei  		          
    AND	AL,01H
    JZ	T2
    CALL DELAY
    MOV CL, 02H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 3
TASTA3: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T3: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei
    AND	AL,01H
    JZ	T3
    CALL DELAY
    MOV CL, 03H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 4
TASTA4: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T4: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei
    AND	AL,01H
    JZ	T4
    CALL DELAY
    MOV CL, 04H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 5
TASTA5: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T5: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei
    AND	AL,01H
    JZ	T5
    CALL DELAY
    MOV CL, 05H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 6
TASTA6: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T6: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei
    AND	AL,01H
    JZ	T6
    CALL DELAY
    MOV CL, 06H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 7
TASTA7: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T7: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei  		             
    AND	AL,01H
    JZ	T7
    CALL DELAY
    MOV CL, 07H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 8
TASTA8: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T8: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei	          
    AND	AL,01H
    JZ	T8
    CALL DELAY
    MOV CL, 08H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 9
TASTA9: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T9: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei		           
    AND	AL,01H
    JZ	T9
    CALL DELAY
    MOV CL, 09H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei 0
TASTA0: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T0: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei  		             
    AND	AL,01H
    JZ	T0
    CALL DELAY
    MOV CL, 00H; numarul corespunzator tastei
    RET
; tratarea acţionării tastei *
TASTA*: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T*: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei   		            
    AND	AL,01H
    JZ	T*
    CALL DELAY
    MOV CL, 2AH; numarul corespunzator tastei
    RET
; tratarea acţionării tastei #
TASTA#: 
    CALL DELAY ; se aşteaptă stabilizarea contactelor
T#: IN	AL,2020H ; se citeşte din nou linia şi se aşteaptă dezactivarea tastei  		            
    AND	AL,01H
    JZ	T#
    CALL DELAY
    MOV CL, 17H; numarul corespunzator tastei
    RET

; Rutina de aprindere/ stingere LED-uri
; Secvenţa ca LED – urile 1 – 8 să lumineze:
LED_CONTROL:
    MOV DX, 2040H         ; Adresa LED-ului (SL1)
    MOV AL, 00H           ; Aprinde LED-ul (01H = ON, 00H = OFF)
    OUT DX, AL            ; Trimite comanda
    RET                   ; Revenire din rutină
; Secvenţa ca LED – urile 9, 10 să nu lumineze:
    MOV DX, 2060H         ; Adresa LED-ului (SL2)
    MOV	AL,0FFH
    OUT	DX,AL

; Rutina de afişare a unui caracter hexa pe un rang cu segmente
; alegere rang pentru afisare
    CMP AH, 0
    JE RANG_0
    CMP AH, 1
    JE RANG_1
    CMP AH, 2
    JE RANG_2
    CMP AH, 3
    JE RANG_3
    CMP AH, 4
    JE RANG_4
    CMP AH, 5
    JE RANG_5
; atribuire adrese corespunzatoare rang-ului IN DX
    RANG_0:
    MOV DX, ; adresa rang 0
    JMP afisare

    RANG_1:
    MOV DX, ; adresa rang 1
    JMP afisare

    RANG_2:
    MOV DX, ; adresa rang 1
    JMP afisare

    RANG_3:
    MOV DX, ; adresa rang 1
    JMP afisare

    RANG_4:
    MOV DX, ; adresa rang 1
    JMP afisare

    RANG_5:
    MOV DX, ; adresa rang 1
    JMP afisare

afisare:
    IN AL, DX
    CMP AL, 00H            ; verificare 0
    JE CHAR_0

final:
    mov ah, 4Ch
    int 21h   
main endp


end main