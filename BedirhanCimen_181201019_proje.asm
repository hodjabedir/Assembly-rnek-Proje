
MOV A,#'$'
PUSH A    ;STACK BAŞ ELEMANI OLARAK BELİRLENDİ

START:
MOV 20H,#1 ; DOGRU OLARAK BAŞLA
MOV 21H,#0



LCALL CONFIGURE_LCD
MOV A,#':'
LCALL SEND_DATA
LCALL CONFIGURE_LCD

BACK:
MOV A,20H
JNZ HATASIZ
MOV 21H,#1   ; EĞER 20H BİR KERE YANLIŞ OLURSA DİZİ 
             ;YANLIŞ DEMEK AMA VERİ ALMAYA DEVAM ET 
HATASIZ:


LCALL KEYBOARD
CJNE A,#'A',DEVAM1
MOV A,#'('        ;SOL PARANTEZ GELİRSE STAK E AT   
PUSH A
LCALL SEND_DATA
DEVAM1:CJNE A,#'B',DEVAM2
MOV A,#')'       ;SAĞ PARANTEZ GELİRSE STACKTEN ELEMAN ÇEK VE BAK
LCALL SEND_DATA
POP A
SETB C
LCALL KONTROL

DEVAM2:CJNE A,#'C',DEVAM3
MOV A,#'['           ;SOL KOSELİ PARANTEZ GELİRSE STAK E AT   
PUSH A
LCALL SEND_DATA

DEVAM3:CJNE A,#'D',DEVAM4
MOV A,#']'       ;SAĞ KÖŞELİ PARANTEZ GELİRSE STACKTEN ELEMAN ÇEK VE BAK
INC R3
LCALL SEND_DATA
POP A
CLR C
LCALL KONTROL
DEVAM4:


CJNE A,#'#', BACK

MOV A,#0C0H
LCALL SEND_COMMAND

MOV A,21H    ;21H NİHAİ SONUC
JNZ YANLIS
MOV A,#'Y'
LCALL SEND_DATA
LJMP ENSON
YANLIS:
MOV A,#'D'
LCALL SEND_DATA



ENSON:

lJMP START


KONTROL:
JC NORMAL
CJNE A,#'[',HATALIKOSE
MOV 20H,#0    ;HATA YOK
LJMP FINKONTROL
HATALIKOSE:
MOV 20H,#1    ;HATA VAR 
LJMP FINKONTROL
NORMAL:
CJNE A,#'(',HATALINORMAL
MOV 20H,#0      ;HATA YOK
LJMP FINKONTROL
HATALINORMAL:
MOV 20H,#1       ;HATA VAR

FINKONTROL:
RET 



