; Compiles to nearly exact copy of "M25 - Getaway 1.1.atr" and 100% identical binary to a
; pirated executable version (probably based on that same disk image) that circulated in the
; early 80's. None of the sources in the Kevin Savetz release of January 22, 2017 would build
; precisely to this state, so this is a mix between disk images M11 and M14 from that release
; with some changes based on the binaries.

; The code in this version is set to start at address $1000, to fit in a 32K machine. Since
; that would overwrite DOS, and the goal of the original cracker was to create a version that
; would load under DOS, it's set to load higher in memory then get copied to the correct location
; once loading is done. See ENTRYPOINT at the end of this source file.

;       .TITLE 'GETAWAY.ASM  Ver 1.0'
;       .SUBTTL 'Mark Reid  Aug 82'
; GETAWAY.ASM  Version 1.0
;
; Use file EQUATES.LIS
       .INCLUDE equates.lis
;
; Other equates
;
PLYFLD =   $3000      ;playfield addr (size: $4000)
SCRNLF =   45         ;screen borders
SCRNRT =   203
SCRNTP =   16
SCRNBT =   103
ROADS  =   ~01110000  ;bit mask
;
; Page zero variables
;
       *=  $0080
TEMP   .DS 2
VTEMP  .DS 2
HTEMP  .DS 2
BTCOLR .DS 1
BKCOLR .DS 1
;
; Other variables (and P/M workspace)
;
       *=  $7000
PMRAM  =   *
LEVEL  .DS 1
GAS    .DS 1
SPEED  .DS 1
TIME   .DS 1
HITS   .DS 1
SAFETY .DS 1
PRIZ   .DS 1
SOUND  .DS 1
DURATN .DS 1
NDOLR  .DS 1
NPRIZ  .DS 1
SKILL  .DS 1
PATHS  .DS 1
SDELAY .DS 1
DIR    .DS 5
HPOSF  .DS 5
HPOS   .DS 5
VPOSF  .DS 5
VPOS   .DS 5
HDELTA .DS 5
HSIGN  .DS 5
VDELTA .DS 5
VSIGN  .DS 5
HSCRN  .DS 5
VSCRNF .DS 5
VSCRN  .DS 5
RADAR  .DS 5
PAUSE  .DS 1
OLDDIR .DS 5
OLDPTH .DS 5
OLDL   .DS 5
OLDH   .DS 5
FLASH  .DS 4
SIREN2 .DS 1
SIRFR2 .DS 1
SIREN3 .DS 1
SIRFR3 .DS 1
;
; Beginning of Program Area
;
       .bank
       *=  $F80
       .SET 6, $1B00 ; Load in $2a80 (code is moved later)

START_DATA_SRC = *+$1B00
START_DATA_DST
       ; data present in first sector of boot disk, and also found in pirated binary.
	   .word $c100, START_DATA_DST, STEAL
START_DATA_INIT
	   clc
	   rts
	   ; padding
	   .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	   .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	   .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	   .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	   .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	   .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	   .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	   .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	   ; padding should bring us to $1000
	   .if * <> $1000
	   .error "Bad padding!"
	   .endif
	   
;
; Use file GETAWAY.DAT, which contains

;  definitions of character sets, P/M
;  shapes, animation sets, title data,

;  messages, scorelines, and sound
;  tables.
;
;      LIST I
       .INCLUDE getaway.dat
;
; Display lists and DLISRs
;
;   Title display list
;
TDLIST .BYTE  DLBL8,DLBL8,DLBL8,DLBL8
       .BYTE  DLMAP9+DLLMS
       .WORD  TITLE
       .BYTE  DLMAP9,DLMAP9,DLMAP9,DLMAP9

       .BYTE  DLMAP9,DLMAP9,DLMAP9
       .BYTE  DLBL8
       .BYTE  DLCHR2
       .BYTE  DLCHR2
       .BYTE  DLBL1+DLINT
       .BYTE  DLBL1
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$201
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$301
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$401
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$501
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$601
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$701
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$801
       .BYTE  DLCHR5+DLLMS+DLHSCR+DLINT
       .WORD  PLYFLD+$901
       .BYTE  DLMAPE+DLLMS
       .WORD  BLKLIN
       .BYTE  DLBL3
       .BYTE  DLCHR6+DLLMS
       .WORD  MSGSTA
       .BYTE  DLBL4
       .BYTE  DLJVB
       .WORD  TDLIST
;
;   Playfield display list
;
PDLIST .BYTE  DLBL8,DLBL8,DLBL6
       .BYTE  DLCHR6+DLLMS+DLINT
TOPLMS .WORD  TOPLIN
       .BYTE  DLBL1
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$2BA5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$2CA5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$2DA5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$2EA5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$2FA5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$30A5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$31A5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$32A5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$33A5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$34A5
       .BYTE  DLCHR5+DLLMS+DLVSCR+DLHSCR
       .WORD  PLYFLD+$35A5
       .BYTE  DLCHR5+DLLMS+DLHSCR+DLINT
       .WORD  PLYFLD+$36A5
       .BYTE  DLMAPE+DLLMS
       .WORD  BLKLIN
       .BYTE  DLCHR6+DLLMS
BOTLMS .WORD  BOTLIN
       .BYTE  DLJVB
       .WORD  PDLIST
;
;   Display list service routines
;
DLISR1 PHA
       LDA #$14       ;brown
       EOR COLRSH
       AND DRKMSK
       STA WSYNC
       STA COLPF0
       LDA #>CHSET1
       STA CHBASE
       LDA #$86       ;blue
       EOR COLRSH
       AND DRKMSK
       STA COLPF1
       LDA #$02       ;black
       EOR COLRSH
       AND DRKMSK
       STA COLPF2
       LDA BKCOLR     ;light green
       EOR COLRSH
       AND DRKMSK
       STA WSYNC
       STA COLBK
       LDA #<DLISR2
       STA VDBLST
       LDA #>DLISR2
       STA VDBLST+1
       PLA
       RTI
;
DLISR2 PHA
       LDA BTCOLR
       EOR COLRSH
       AND DRKMSK
       NOP
       NOP
       NOP
       NOP
       NOP
       STA WSYNC
       STA COLBK
       LDA #>CHSET2
       STA CHBASE
       LDA #$0C       ;white
       EOR COLRSH
       AND DRKMSK
       STA COLPF0
       LDA #$6C       ;light purple
       EOR COLRSH
       AND DRKMSK
       STA COLPF1
       LDA #<DLISR1
       STA VDBLST
       LDA #>DLISR1
       STA VDBLST+1
       PLA
       RTI
;
; Miscellaneous tables
;
;   Masks for setting VDELAY bits
;
ORMSK  .BYTE  0,16,32,64,128
ANDMSK .BYTE  0,239,223,191,127
;
;   Direction table for COPMOV routine

;
DIRTAB .BYTE  8,2,1,4
       .BYTE  8,1,2,4
       .BYTE  4,2,1,8
       .BYTE  4,1,2,8
       .BYTE  2,8,4,1
       .BYTE  2,4,8,1
       .BYTE  1,8,4,2
       .BYTE  1,4,8,2
;
;   Initial variable value table
;
INITAB .BYTE  0,0,0,0,0  ;DIR
       .BYTE  0,0,0,0,0  ;HPOSF
       .BYTE  184,170,198,182,194;HPOS
       .BYTE  0,0,0,0,0  ;VPOSF
       .BYTE  +>PLYFLD, 48,51,50,46,45;VPOS
       ; note: the "+>PLYFLD" means add the value of the high byte of PLYFLD to each byte.
;
; Subroutine CLEAR clears P/M RAM,
;  variables, and roads
;

CLEAR  LDA #<PMRAM ;clear PM & vars
       STA TEMP
       LDA #>PMRAM
       STA TEMP+1
       LDX #4         ;clear 4 pages
       LDY #0
       TYA
CLR010 STA (TEMP),Y   ;clear byte
       DEY
       BNE CLR010     ;page done?
       INC TEMP+1
       DEX
       BNE CLR010     ;4 pages done?
       LDA #<PLYFLD;clear roads
       STA TEMP
       LDA #>PLYFLD+5
       STA TEMP+1
       LDX #54        ;check 54 pages
       LDY #0
CLR020 LDA (TEMP),Y   ;get byte
       CMP #120       ;if >= 120
       BCC CLR030
       CMP #128       ;and < 128
       BCS CLR030
       LDA #112       ;set to road
       STA (TEMP),Y
CLR030 DEY
       BNE CLR020     ;line done?
       INC TEMP+1
       DEX
       BNE CLR020     ;screen done?
       LDX #20        ;clr scorelines
CLR040 LDA STASLN-1,X
       STA TOPLIN-1,X
       LDA CASHLN-1,X
       STA BOTLIN-1,X
       DEX
       BNE CLR040
       LDA #<TOPLIN
       STA TOPLMS
       LDA #>TOPLIN
       STA TOPLMS+1
       LDA #<BOTLIN
       STA BOTLMS
       LDA #>BOTLIN
       STA BOTLMS+1 
       LDA #118       ;reset hideout
       STA PLYFLD+12476
       LDA #119
       STA PLYFLD+12477
       LDA #33
       STA PLYFLD+12479
       LDA #34
       STA PLYFLD+12480
       RTS
;
; Subroutine PATHFInd
;  returns valid PATHS based on POS
;
PATHFI LDA OLDPTH,X
       STA PATHS
       LDA VPOSF,X    ;if not at notch

       BNE PTH999     ; then done
       LDA HPOSF,X
       BNE PTH999
       LDA #0         ;clear PATHS
       STA PATHS
       LDA HPOS,X     ;get POSition
       STA TEMP
       INC TEMP
       INC TEMP
       LDA VPOS,X
       STA TEMP+1
CHECKR LDY #4         ;if road right,
       LDA (TEMP),Y
       AND #ROADS
       CMP #ROADS
       BNE CHECKL
       LDA #8         ; set right PATH

       ORA PATHS
       STA PATHS
CHECKL LDY #0         ;if road left,
       LDA (TEMP),Y
       AND #ROADS
       CMP #ROADS
       BNE CHECKD
       LDA #4         ; set left PATH
       ORA PATHS
       STA PATHS
CHECKD LDY #2         ;if road down,
       INC TEMP+1
       LDA (TEMP),Y
       AND #ROADS
       CMP #ROADS
       BNE CHECKU
       LDA #2         ; set down PATH
       ORA PATHS
       STA PATHS
CHECKU DEC TEMP+1     ;if road up,
       DEC TEMP+1
       LDA (TEMP),Y
       AND #ROADS
       CMP #ROADS
       BNE PTH999
       LDA #1         ; set up PATH
       ORA PATHS
       STA PATHS
PTH999 LDA PATHS
       STA OLDPTH,X
       RTS
;
; Subroutine MOVE
;  changes POSition based on DIRection

;
MOVE   LDA DIR,X      ;if DIR=right,
       AND #8
       BEQ MOV010
       DEC HPOSF,X    ; move right
       LDA HPOSF,X
       AND #$F8
       BEQ MOV999
       LDA #7         ;overflow
       STA HPOSF,X
       INC HPOS,X
       INC HPOS,X
       JMP MOV999
MOV010 LDA DIR,X      ;if DIR=left,
       AND #4
       BEQ MOV020
       INC HPOSF,X    ; move left
       LDA HPOSF,X
       AND #$F8
       BEQ MOV999
       LDA #0         ;overflow
       STA HPOSF,X
       DEC HPOS,X
       DEC HPOS,X
       JMP MOV999
MOV020 LDA DIR,X      ;if DIR=down,
       AND #2
       BEQ MOV030
       INC VPOSF,X    ; move down
       LDA VPOSF,X
       AND #$F0
       BEQ MOV999
       LDA #0         ;overflow
       STA VPOSF,X
       INC VPOS,X
       JMP MOV999
MOV030 LDA DIR,X      ;if DIR=up,
       AND #1
       BEQ MOV999
       DEC VPOSF,X    ; move up
       LDA VPOSF,X
       AND #$F0
       BEQ MOV999
       LDA #15        ;overflow
       STA VPOSF,X
       DEC VPOS,X
MOV999 RTS
;
; Subroutine to check random road spot

;
RNSPOT LDA RANDOM     ;pick spot
       AND #~00111111
       ORA #~01000000
       SEC
       SBC #$10
       STA TEMP+1
       LDA RANDOM
       AND #~11111110
       STA TEMP       ;TEMP=addr
       CMP #226
       BCS RNS100
       LDY #0
       LDA (TEMP),Y
       CMP #112
       BNE RNS100
       INY
       LDA (TEMP),Y
       CMP #112
       BNE RNS100
       SEC            ;its road
       JMP RNS999
RNS100 CLC            ;its not road
RNS999 RTS
;
; Subroutine to increase cash & skill
;
ADCASH LDY LEVEL      ;add to skill
       INY
       TYA
       ASL A
       ASL A
       ASL A
       ASL A
       ASL A
       CLC
       ADC SKILL
       BCC ADC100
       LDA #255
       STA SKILL
ADC100 DEX
       TYA            ;add to cash
       CLC
       ADC BOTLIN+14,X
       CMP #26
       BCS ADC110
       STA BOTLIN+14,X
       JMP ADC999
ADC110 SEC
       SBC #10
       STA BOTLIN+14,X
       DEX
ADC120 LDA BOTLIN+14,X
       CMP #25
       BEQ ADC130
       INC BOTLIN+14,X
       JMP ADC999
ADC130 LDA #16
       STA BOTLIN+14,X
       DEX
       BNE ADC120
ADC999 RTS
; Subroutine ANMDOL
; animates dollars,stoplights & prizes

;
ANMDOL LDA RTCLOK+2   ;dollars
       AND #32
       BNE ANM020
       LDY #16
ANM010 LDA DOLLAR-1,Y
       STA CHSET1+126*8-1,Y
       DEY
       BNE ANM010
       JMP ANMSTP
ANM020 LDY #16
ANM030 LDA DOLLAR+16-1,Y
       STA CHSET1+126*8-1,Y
       DEY
       BNE ANM030
ANMSTP LDA RTCLOK+2   ;stoplights
       AND #64
       BNE ANM050
       LDA #$FF
       LDY #16
ANM040 STA CHSET1+124*8-1,Y
       DEY
       BNE ANM040
       JMP ANMPRZ
ANM050 LDY #16
ANM060 LDA STOPLI-1,Y
       STA CHSET1+124*8-1,Y
       DEY
       BNE ANM060
ANMPRZ LDA RTCLOK+2   ;prizes
       AND #~00011100 ;shape offset
       ASL A          ;based on LEVEL
       ASL A          ;and RTCLOK
       ASL A
       STA TEMP
       LDA LEVEL
       BEQ ANM065
       SEC
       SBC #1
ANM065 LSR A
       STA TEMP+1
       ROR TEMP
       CLC
       LDA #<[PRIZES-1]
       ADC TEMP
       STA TEMP
       LDA #>[PRIZES-1]
       ADC TEMP+1
       STA TEMP+1
       LDY #16
ANM070 LDA (TEMP),Y
       STA CHSET1+120*8-1,Y
       DEY
       BNE ANM070
       RTS
;
; Subroutine FLASHS
;  flashes COPs
;
FLASHS LDA RTCLOK+2
       AND #~00000011
       BEQ FLS999
       TAX
       LDA FLASH,X
       BNE FLS010
       LDA PCOLR0-1,X
       CLC
       ADC #2
       STA PCOLR0-1,X
       AND #~00001111
       CMP #10
       BNE FLS999
       LDA #1
       STA FLASH,X
FLS010 LDA PCOLR0-1,X
       SEC
       SBC #2
       STA PCOLR0-1,X
       AND #~00001111
       CMP #2
       BNE FLS999
       LDA #0
       STA FLASH,X
FLS999 RTS
;
; Sound subroutine
;
SOUNDS LDA SOUND      ;sound=0, done
       BEQ SND999
       LDA DURATN
       BNE SND090
       INC SOUND
       LDX SOUND
       LDA AUDC,X
       BNE SND100
       LDA #0
       STA SOUND
       JMP SND999
SND090 DEC DURATN
       JMP SND999
SND100 STA AUDC1
       LDA AUDF,X
       STA AUDF1
       LDA DUR,X
       STA DURATN
SND999 RTS
;
; Initialize Program
;
STEAL  LDA #<RESET ;steal reset
       STA DOSVEC
       LDA #>RESET
       STA DOSVEC+1
       LDA #$3C
       STA PACTL
       RTS
RESET  JSR CLEAR      ;clear vars & PM

       LDA #$3       ;clear SO.2&3
       STA SKCTL
       STA SSKCTL
       LDA #0
       STA AUDCT
       LDA #1         ;clear boot flag

       STA BOOTQ
       LDA RTCLOK+2
RES010 CMP RTCLOK+2   ;wait for Vblank

       BEQ RES010
       LDA #0         ;turn off ANTIC
       STA SDMCTL
       STA DMACTL
       LDA #<TDLIST
       STA SDLSTL
       STA DLISTL
       LDA #>TDLIST
       STA SDLSTH
       STA DLISTH
       LDA #<DLISR1
       STA VDBLST
       LDA #>DLISR1
       STA VDBLST+1
       LDA #192       ;enable DLI
       STA NMIEN
       LDA #$B6       ;dark green
       STA COLOR3
       LDA #$70       ;deep blue
       STA COLOR4
       STA COLOR2
       STA PCOLR2
       LDA #$28       ;orange
       STA COLOR0
       LDA #$0C       ;white
       STA COLOR1
       STA PCOLR3
       LDA #$44       ;red
       STA PCOLR0
       LDA #$D8       ;yellow
       STA PCOLR1
       LDA #$F0       ;maroon
       STA BTCOLR
       LDA #$BA       ;light green
       STA BKCOLR
       LDA #>PMRAM
       STA PMBASE
       LDA #~00010001
       STA GPRIOR
       STA PRIOR
       LDA #~00000011
       STA GRACTL
       LDA #0
       STA SIZEP0
       STA SIZEP1
       STA SIZEP2
       STA SIZEP3
       STA SIZEM
       STA HPOSP0
       STA HPOSP1
       STA HPOSP2
       STA HPOSP3
       STA HITCLR
       STA HSCROL
       STA VSCROL
       LDY #PMLEFT+22*4
       TYA            ;put CAR in mid
       STA HSCRN
       LDA #73
       STA VSCRN
       LDA #1
       STA VSCRNF
       STY HPOSM3
       INY
       INY
       STY HPOSM2
       INY
       INY
       STY HPOSM1
       INY
       INY
       STY HPOSM0
       LDA #$F0
       STA SDELAY
       STA VDELAY
       LDA #~00101110 ;turn on ANTIC
       STA SDMCTL
       STA DMACTL
;
; Demo Mode
;
DEMO   JSR RNSPOT     ;put car at rand

       BCC DEMO
       LDA TEMP+1
       STA VPOS
       LDA TEMP
       SEC
       SBC #4
       STA HPOS
       LDA #183        ;play tune
       STA SOUND
DMLOOP LDX #0
       JSR PATHFI
       LDA HPOSF      ;if not at notch

       ORA VPOSF      ; same DIRection

       BNE DEM300
       LDA DIR
       AND #3
       BEQ DEM210
       EOR #3
       JMP DEM220
DEM210 LDA DIR
       AND #12
       BEQ DEM220
       EOR #12
DEM220 EOR #$FF
       AND PATHS
       STA PATHS
DEM230 LDA RANDOM     ;rand DIRection
       AND #3
       TAY
       LDA #0
       SEC
       INY
DEM240 ROL A
       DEY
       BNE DEM240
       BIT PATHS
       BEQ DEM230
       STA DIR
DEM300 JSR MOVE
       LDA RTCLOK+2   ;wait for Vblank

DEM310 CMP RTCLOK+2
       BEQ DEM310
       LDA HPOS       ;scroll
       SEC
       SBC #19
       STA TEMP
       LDA VPOS
       SEC
       SBC #3
       TAY
       LDX #20
DEM350 LDA TEMP
       STA TDLIST,X
       INX
       TYA
       STA TDLIST,X
       INY
       INX
       INX
       CPX #44
       BCC DEM350
       LDA VPOSF      ;fine scroll
       STA VSCROL
       LDA HPOSF
       STA HSCROL
       LDA DIR        ;PM shape offset

       STA VTEMP
       CLC
       LDA #0
DEM370 ROR VTEMP
       BCS DEM380
       ADC #8
       JMP DEM370
DEM380 CLC
       ADC #<PMDATA
       STA TEMP
       LDA #0
       ADC #>PMDATA
       STA TEMP+1
       CLC            ;PM RAM offset
       LDA VSCRN
       ADC #<[PMRAM+384]
       STA VTEMP
       LDA #0
       ADC #>[PMRAM+384]
       STA VTEMP+1
       LDY #8         ;load PM RAM
DEM390 DEY
       LDA (TEMP),Y
       STA (VTEMP),Y
       TYA
       BNE DEM390
       JSR SOUNDS     ;make sounds
       LDA SOUND
       BNE DEM400
       LDA #183
       STA SOUND
DEM400 LDA CONSOL     ;check for START

       AND #SWSTRT
       BEQ START
       LDA STRIG0
       BEQ START
       JMP DMLOOP

;
; Initialize Game
;
START  JSR CLEAR      ;clear vars & PM

       LDX #25        ;init vars from
STA010 LDA INITAB-1,X ; value table
       STA DIR-1,X
       DEX
       BNE STA010
       LDA #PMLEFT+22*4
       STA HSCRN
       LDA #59
       STA VSCRN
       LDA #1
       STA VSCRNF
       LDA #$FF
       STA SDELAY
       STA VDELAY
       LDA #190
       STA SIRFR3
       LDA #8
       STA OLDDIR
       LDA #255
       STA GAS
       STA SAFETY
       LDA #0
       STA ATRACT
       LDA RTCLOK+2
STA030 CMP RTCLOK+2   ;wait for Vblank

       BEQ STA030
       LDA #0         ;turn off ANTIC
       STA SDMCTL
       STA DMACTL
       LDA #<PDLIST
       STA SDLSTL
       STA DLISTL
       LDA #>PDLIST
       STA SDLSTH
       STA DLISTH
       LDA #<DLISR1
       STA VDBLST
       LDA #>DLISR1
       STA VDBLST+1
       LDA #>CHSET2
       STA CHBAS
       STA CHBASE
       LDA #$F0       ;maroon
       STA COLOR4
       STA BTCOLR
       LDA #$BA       ;light green
       STA BKCOLR
       LDA #$1C       ;yellow
       STA COLOR0
       LDA #$5C       ;pink
       STA COLOR1
       LDA #$0C       ;white
       STA COLOR2
       LDA #~00101110 ;turn on ANTIC
       STA SDMCTL
       STA DMACTL
       LDX #10        ;put out 10 $'s
STA040 JSR RNSPOT     ;get spot
       BCC STA040
       LDA #127
       STA (TEMP),Y
       DEY
       LDA #126
       STA (TEMP),Y
       DEX
       BNE STA040
;
; Main Loop of Program
;
MNLOOP NOP
;
; Calculate car movement
;
CARMOV LDX #0
       LDA STRIG0     ;if TRIG,
       BNE CAR005
       LDA #0         ; DIR=0 & done
       STA DIR
       JMP CAR999
CAR005 JSR PATHFI
       LDA HPOSF      ;if not at notch

       BEQ CAR006     ; mask sideways
       LDA #12       ; out of PATHS
       STA PATHS
       JMP CAR008
CAR006 LDA VPOSF
       BEQ CAR008
       LDA #3
       STA PATHS
CAR008 LDA #$0F       ;invert STICK
       EOR STICK0
       AND PATHS      ;mask invalids
       BEQ CAR050     ;if zero, done
       LDY #9         ;clear all but
       CLC            ; rightmost bit
CAR010 DEY
       ROR A
       BCC CAR010
       DEY
       ROR A
CAR015 CLC
       ROR A
       DEY
       BNE CAR015
       STA DIR
       LDA #0         ;reset ATRACT
       STA ATRACT
       JMP CAR080
CAR050 LDA DIR
       AND PATHS
       STA DIR
CAR080 LDA SPEED
       BNE CAR200
       LDA GAS        ;if out of GAS
       BNE CAR100     ;only move every

       LDA RTCLOK+2   ;other tic
       AND #1
       BNE CAR999
CAR100 JSR MOVE
       JMP CAR999
CAR200 JSR MOVE
       LDA GAS
       BEQ CAR999
       JSR MOVE
CAR999 NOP
;
; Calculate Cop and Van Movement
;
COPMOV LDA #0         ;VTEMP=VPOS*16
       STA VTEMP+1    ;      +VPOSF
       LDA VPOS       ; (scan lines)
       STA VTEMP
       LDY #4
COP005 ASL VTEMP
       ROL VTEMP+1
       DEY
       BNE COP005
       LDA VPOSF
       CLC
       ADC VTEMP
       STA VTEMP
       LDA #0         ;HTEMP=HPOS*4+7
       STA HTEMP+1    ;      -HPOSF
       LDA HPOS       ; (color clocks)

       STA HTEMP
       ASL HTEMP
       ROL HTEMP+1
       ASL HTEMP
       ROL HTEMP+1
       LDA HTEMP
       CLC
       ADC #7
       SEC
       SBC HPOSF
       STA HTEMP
       LDX #4         ;Start with Van
COP020 JSR PATHFI
       LDA HPOSF,X    ;if not at notch

       ORA VPOSF,X    ; don't change
       BEQ COP023     ; DIRection
       JMP COP505
COP023 LDA DIR,X      ;Mask backwards
       AND #3
       BEQ COP025
       EOR #3
       JMP COP030
COP025 LDA DIR,X
       AND #12
       BEQ COP030
       EOR #12
COP030 EOR #$FF
       AND PATHS
       STA PATHS
       CPX #4         ;Van is dumb
       BCS DUMB
       LDA RANDOM     ;if SKILL>RANDOM

       CMP SKILL      ; COPs smart
       BCC SMART
DUMB   LDA RANDOM     ;Y=3*RND(0)
       AND #3
       TAY
       LDA #0         ;set bit Y
       SEC
       INY
COP040 ROL A
       DEY
       BNE COP040
       BIT PATHS      ;if not in PATHS

       BEQ DUMB       ; try again
       JMP COP500
SMART  LDY #3         ;Find COP pos.
COP050 LDA HDELTA,X   ; relative to
       SEC            ; CAR and get
       SBC VDELTA,X   ; DIR from table

       BCC COP090     ; (Y=priority)
       LDA HSIGN,X
       BNE COP070
       LDA VSIGN,X
       BNE COP060
       LDA DIRTAB+0,Y ;H>=V,H>=0,V>=0
       JMP COP200
COP060 LDA DIRTAB+4,Y ;H>=V,H>=0,V<0
       JMP COP200
COP070 LDA VSIGN,X
       BNE COP080

       LDA DIRTAB+8,Y ;H>=V,H<0,V>=0
       JMP COP200
COP080 LDA DIRTAB+12,Y;H>=V,H<0,V<0
       JMP COP200
COP090 LDA VSIGN,X
       BNE COP110
       LDA HSIGN,X
       BNE COP100
       LDA DIRTAB+16,Y;V>H,V>=0,H>=0
       JMP COP200
COP100 LDA DIRTAB+20,Y;V>H,V>=0,H<0
       JMP COP200
COP110 LDA HSIGN,X
       BNE COP120
       LDA DIRTAB+24,Y;V>H,V<0,H>=0
       JMP COP200
COP120 LDA DIRTAB+28,Y;V>H,V<0,H<0
COP200 BIT PATHS      ;if valid PATH
       BNE COP500     ; then done
       TYA            ;if last prior.
       BEQ COP500     ; then done
       DEY            ;decrease prior.

       JMP COP050     ;and try again

COP500 STA DIR,X      ;save new DIR
COP505 JSR MOVE
       LDA SPEED
       BEQ COP508
       JSR MOVE
COP508 LDA #0         ;calc VDELTA
       STA TEMP+1     ;TEMP=VPOS*16
       LDA VPOS,X     ;     +VPOSF
       STA TEMP
       LDY #4
COP510 ASL TEMP
       ROL TEMP+1
       DEY
       BNE COP510
       LDA VPOSF,X
       CLC
       ADC TEMP
       STA TEMP
       SEC            ;TEMP=TEMP-VTEMP

       LDA TEMP
       SBC VTEMP
       STA TEMP
       LDA TEMP+1
       SBC VTEMP+1
       STA TEMP+1
       LDA #0         ;if carry set
       STA VSIGN,X    ; then VSIGN=pos

       BCS COP520
       LDA #1         ; else VSIGN=neg

       STA VSIGN,X
       SEC            ;TEMP=-TEMP
       LDA #0
       SBC TEMP
       STA TEMP
       LDA #0
       SBC TEMP+1
       STA TEMP+1
COP520 LDA TEMP       ;VDELTA=TEMP
       STA VDELTA,X
       LDA TEMP+1     ;if TEMP>255,
       BEQ COP530
       LDA #255       ; VDELTA=255
       STA VDELTA,X
COP530 LDA #0         ;Calc HDELTA
       STA TEMP+1     ;TEMP=HPOS*4+7
       LDA HPOS,X     ;     -HPOSF
       STA TEMP
       ASL TEMP
       ROL TEMP+1
       ASL TEMP
       ROL TEMP+1
       LDA TEMP
       CLC
       ADC #7
       SEC
       SBC HPOSF,X
       STA TEMP
       SEC            ;TEMP=TEMP-HTEMP

       LDA TEMP
       SBC HTEMP
       STA TEMP
       LDA TEMP+1
       SBC HTEMP+1
       STA TEMP+1
       LDA #0         ;if carry set
       STA HSIGN,X    ; then HSIGN=pos

       BCS COP540
       LDA #1         ; else HSIGN=neg

       STA HSIGN,X
       SEC            ;TEMP=-TEMP
       LDA #0
       SBC TEMP
       STA TEMP
       LDA #0
       SBC TEMP+1
       STA TEMP+1
COP540 LDA TEMP       ;HDELTA=TEMP
       STA HDELTA,X
       LDA TEMP+1     ;if TEMP>255,
       BEQ COP550
       LDA #255       ; HDELTA=255
       STA HDELTA,X
;
COP550 LDA #0         ;calc screen pos

       STA RADAR,X    ; based on DELTA

       STA HSCRN,X    ; and SIGN
       LDA HDELTA,X
       CMP #255
       BCC COP560
       LDA #2         ;offscreen
       STA RADAR,X
       JMP COP900
COP560 LDA VDELTA,X
       CMP #255
       BCC COP570
       LDA #2         ;offscreen
       STA RADAR,X
       JMP COP900
COP570 LDA HSIGN,X    ;calc HSRCN
       BNE COP600
       CLC            ;right half
       LDA HSCRN
       ADC HDELTA,X
       BCS COP580
       STA HSCRN,X
       CMP #SCRNRT
       BCC COP590
COP580 LDA #SCRNRT
       STA HSCRN,X
       LDA #1
       STA RADAR,X
COP590 JMP COP650
COP600 SEC            ;left half
       LDA HSCRN
       SBC HDELTA,X
       BCC COP610
       STA HSCRN,X
       CMP #SCRNLF
       BCS COP650
COP610 LDA #SCRNLF
       STA HSCRN,X
       LDA #1
       STA RADAR,X
COP650 LDA VSIGN,X    ;calc VSCRN
       BNE COP700
       LDA VSCRN      ;bottom half
       ASL A
       CLC
       ADC VSCRNF
       CLC
       ADC VDELTA,X
       BCS COP660
       STA TEMP
       AND #1
       STA VSCRNF,X
       LDA TEMP
       LSR A
       STA VSCRN,X
       CMP #SCRNBT
       BCC COP670
COP660 LDA #SCRNBT
       STA VSCRN,X
       LDA #0
       STA VSCRNF,X
       LDA #1
       STA RADAR,X
COP670 JMP COP900
COP700 LDA VSCRN      ;left half
       ASL A
       CLC
       ADC VSCRNF
       SEC
       SBC VDELTA,X
       BCC COP710
       STA TEMP
       AND #1
       STA VSCRNF,X
       LDA TEMP
       LSR A
       STA VSCRN,X
       CMP #SCRNTP
       BCS COP900
COP710 LDA #SCRNTP
       STA VSCRN,X
       LDA #1
       STA VSCRNF,X
       STA RADAR,X
COP900 DEX            ;do next COP
       BEQ COP999
       JMP COP020
COP999 NOP            ;done
;
; Check CONSOL and space bar
;
SWCHEK LDA CONSOL
       AND #SWSTRT
       BNE SWC010
       JMP START
SWC010 LDA CH
       CMP #33        ;space bar
       BNE SWC020
       LDA PAUSE
       EOR #$FF
       STA PAUSE
       LDA #$FF       ;reset keybuffer

       STA CH
SWC020 LDA STICK0
       CMP #15
       BEQ SWC030
       LDA #0
       STA PAUSE
SWC030 LDA PAUSE
       BNE SWCHEK
;
; Draw Screen
;
WAITVB LDA RTCLOK+2   ;wait for VBlank

WTLOOP CMP RTCLOK+2
       BEQ WTLOOP
       STA HITCLR     ;clear collision

SCROLL LDA HPOS       ;TEMP=HPOS-19
       SEC
       SBC #19
       STA TEMP
       LDA VPOS       ;Y=VPOS-5
       SEC
       SBC #5
       TAY
       LDX #8
SCR010 LDA TEMP       ;loop loads LMSs

       STA PDLIST,X
       INX
       TYA
       STA PDLIST,X
       INY
       INX
       INX
       CPX #44
       BCC SCR010
       LDA VPOSF      ;fine scrolling
       STA VSCROL
       LDA HPOSF
       STA HSCROL
;
; Draw PM Shapes
;
DRAWPM LDX #4         ;loop for each
DRA010 LDA RADAR,X
       CMP #2         ;RADAR=2,BLANKS
       BCC DRA020
       LDA #<BLANKS
       STA TEMP
       LDA #>BLANKS
       STA TEMP+1
       JMP DRA100
DRA020 CMP #1         ;RADAR=1,BLIP
       BCC DRA030
       LDA #<BLIP
       STA TEMP
       LDA #>BLIP
       STA TEMP+1
       JMP DRA100
DRA030 TXA            ;RADAR=0, calc
       ASL A          ; shape offset
       ASL A          ; based on X
       ASL A          ; and DIR
       ASL A
       ASL A
       STA TEMP
       LDA DIR,X
       BNE DRA035     ;if DIR=0
       LDA OLDDIR,X   ;then DIR=OLDDIR

       JMP DRA038
DRA035 STA OLDDIR,X   ;else OLDDIR=DIR

DRA038 STA VTEMP
       CLC
       LDA TEMP
DRA040 ROR VTEMP
       BCS DRA050
       ADC #8
       JMP DRA040
DRA050 CLC
       ADC #<PMDATA
       STA TEMP
       LDA #0
       ADC #>PMDATA
       STA TEMP+1
DRA100 CLC            ;calc PM RAM
       LDA VSCRN,X    ; offset based
       ADC #<PMRAM ; on X and VSCRN

       STA VTEMP
       LDA #1
       ADC #>PMRAM
       STA VTEMP+1
       TXA
       TAY
       INY
DRA110 CLC
       LDA VTEMP
       ADC #128
       STA VTEMP
       LDA VTEMP+1
       ADC #0
       STA VTEMP+1
       DEY
       BNE DRA110
       LDA OLDL,X
       STA HTEMP
       LDA OLDH,X
       STA HTEMP+1
       LDA VTEMP
       STA OLDL,X
       LDA VTEMP+1
       STA OLDH,X
       LDA #0         ;erase player
       LDY #8
DRA112 DEY
       STA (HTEMP),Y
       CPY #0
       BNE DRA112
DRA115 LDY #8         ;load PM RAM
DRA120 DEY
       LDA (TEMP),Y
       STA (VTEMP),Y
       TYA
       BNE DRA120
       TXA            ;if X=0, done
       BEQ DRA999
       LDA HSCRN,X    ;load HPOSP
       STA HPOSP0-1,X
       LDA VSCRNF,X   ;set VDELAY bit
       BNE DRA130
       LDA ANDMSK,X
       AND SDELAY
       JMP DRA140
DRA130 LDA ORMSK,X
       ORA SDELAY
DRA140 STA SDELAY
       STA VDELAY
       DEX            ;do next car
       JMP DRA010
DRA999 NOP
;
; Second Part of Program
;

;
; Animate dollars, stoplights & prizes
;
       JSR ANMDOL
;
; Add roadblocks and stoplights
;
ROADBL LDA RTCLOK+2
       BNE RBL999
       LDA LEVEL
       TAX
       INX
       LDA #~01111111
RBL010 LSR A
       DEX
       BNE RBL010
       AND RTCLOK+1
       BNE RBL999
       JSR RNSPOT
       BCC RBL100
       LDA #123
       STA (TEMP),Y
       DEY
       LDA #122
       STA (TEMP),Y
RBL100 JSR RNSPOT
       BCC RBL999
       LDA #125
       STA (TEMP),Y
       DEY
       LDA #124
       STA (TEMP),Y
RBL999 NOP
;
; Flash COPS
;
       JSR FLASHS
;
; Sirens
;
SIRENS LDX #3
       LDY #4
SRN005 LDA HDELTA,X   ;set volume=dist

       ASL A
       BCC SRN007
       ROR A
SRN007 CLC
       ADC VDELTA,X
       BCS SRN010
       CMP #128
       BCC SRN020
SRN010 LDA #127
SRN020 LSR A
       LSR A
       LSR A
       LSR A
       EOR #~00000111
       ORA #$A0
       STA AUDC2,Y
       DEY
       DEY
       DEX
       BNE SRN005
       LDA RTCLOK+2   ;set pitch for
       AND #~00100000 ;1st siren
       BNE SRN030
       LDA #50
       STA AUDF2
       JMP SRN040
SRN030 LDA #100
       STA AUDF2
SRN040 LDA SIREN2     ;2nd siren
       BNE SRN050
       INC SIRFR2
       INC SIRFR2
       LDA SIRFR2
       STA AUDF3
       CMP #48
       BNE SRN060
       LDA #1
       STA SIREN2
       JMP SRN060
SRN050 DEC SIRFR2
       DEC SIRFR2
       LDA SIRFR2
       STA AUDF3
       CMP #16
       BNE SRN060
       LDA #0
       STA SIREN2
SRN060 LDA RTCLOK+2   ;3rd siren
       AND #1
       BNE SRN999
       LDA SIREN3
       BNE SRN070
       INC SIRFR3
       LDA SIRFR3
       STA AUDF4
       CMP #200
       BNE SRN999
       LDA #1
       STA SIREN3
       JMP SRN999
SRN070 DEC SIRFR3
       LDA SIRFR3
       STA AUDF4
       CMP #100
       BNE SRN999
       LDA #0
       STA SIREN3
SRN999 NOP
;
; Decrease gas and make engine sound
;
DEGAS  LDA GAS
       BEQ DGS500
       LDA DIR
       BEQ DGS010
       DEC GAS
       BEQ DGS015
DGS010 LDA GAS
       SEC
       SBC HITS
       STA GAS
       BEQ DGS015
       BCS DGS500
DGS015 LDA #100
       STA GAS
       LDA BOTLIN+6
       CMP #17
       BCS DGS030
       LDA BOTLIN+5
       CMP #17
       BCS DGS020
       LDA #0
       STA GAS
       JMP DGS500
DGS020 DEC BOTLIN+5
       LDA #25
       STA BOTLIN+6
       JMP DGS500
DGS030 DEC BOTLIN+6
DGS500 LDA SOUND
       BNE DGS999
       LDA DIR
       BNE DGS550
       LDA #0
       STA AUDC1
       JMP DGS999
DGS550 LDA #100       ;engine
       STA AUDF1
       LDA #$21
       STA AUDC1
       LDA GAS        ;sputter
       BNE DGS999
       LDA #200
       STA AUDF1
DGS999 NOP
;
; If low on gas, flash bottom color
;
LOWGAS LDA BOTLIN+5
       CMP #16
       BNE LOW100
       LDA RTCLOK+2
       AND #~00010000
       BNE LOW100
       LDA #$46       ;red
       JMP LOW200
LOW100 LDA #$F0       ;maroon
LOW200 STA BTCOLR
       LDA #$BF       ;reset gas pump
       STA CHSET1+35*8+1
;
; Increment TIME and adjust background

;  color and SKILL
;
TIMER  LDA RTCLOK+2
       BNE TIM999
       INC TIME
       LDA TIME
       BNE TIM100
       LDA #255
       STA TIME
TIM100 CMP #50
       BCC TIM999
       CMP #55
       BCC TIM200
       CMP #60
       BCC TIM300
       CMP #65
       BCC TIM400
       JMP TIM500
TIM200 LDA #$B8
       STA BKCOLR
       LDA #159
       JMP TIM800
TIM300 LDA #$B4
       STA BKCOLR
       LDA #191
       JMP TIM800
TIM400 LDA #$B2
       STA BKCOLR
       LDA #223
       JMP TIM800
TIM500 LDA #$B0
       STA BKCOLR
       LDA #255
TIM800 CMP SKILL
       BCC TIM999
       STA SKILL
TIM999 NOP
;
; Check for road collisions
;
HITANY LDA HPOSF      ;if not at notch

       ORA VPOSF      ; done
       BEQ HIT010
       JMP HIT999
HIT010 LDA HPOS       ;look under car
       STA TEMP
       LDA VPOS
       STA TEMP+1
       LDY #4
       LDA (TEMP),Y
       STA VTEMP+1
       CMP #112       ;if road, done
       BNE HITGAS
       LDA DIR
       BEQ HIT015
       LDA #255
       STA SAFETY
       LDA #118
       STA PLYFLD+12476
       LDA #119
       STA PLYFLD+12477
       LDA #33
       STA PLYFLD+12479
       LDA #34
       STA PLYFLD+12480
HIT015 JMP HIT999
;
HITGAS CMP #116       ;gas station?
       BNE HITDOL
       LDA #100
       STA GAS
       LDA #0         ;stop car
       STA DIR
       LDA #0         ;fix tank
       STA HITS
       LDA RTCLOK+2   ;add to gas
       AND #7
       BEQ HIT020
       JMP HIT999
HIT020 LDA BOTLIN+6
       CMP #25
       BEQ HIT100
       INC BOTLIN+6
       AND #~00111111 ;animate pump
       ORA #~10000000
       STA CHSET1+35*8+1
       JMP HIT999
HIT100 LDA BOTLIN+5
       CMP #25
       BNE HIT110
       JMP HIT999
HIT110 LDA #16
       STA BOTLIN+6
       INC BOTLIN+5
       AND #~00111111 ;animate pump
       ORA #~10000000
       STA CHSET1+35*8+1
       LDA #1         ;make sound
       STA SOUND
       JMP HIT999
;
HITDOL CMP #126       ;dollar sign?
       BNE HITHID
       LDA #129       ;make sound
       STA SOUND
       LDA #112       ;erase dollar
       STA (TEMP),Y
       INY
       STA (TEMP),Y
       INC NDOLR      ;draw new dollar

       LDX #4         ;add to skill
       JSR ADCASH     ; and cash
       JMP HIT999
;
HITHID CMP #118       ;hideout?
       BEQ HIT200
       JMP HITPRZ
;
; Decrement SAFETY and animate hideout

;
HIT200 LDA RTCLOK+2
       AND #7
       BNE SAF999
       LDA SAFETY
       BEQ SAF900
       DEC SAFETY
       LDA SAFETY
       CMP #20
       BCS SAF999
       AND #1
       BEQ SAF100
       LDA #33
       STA PLYFLD+12479
       LDA #34
       STA PLYFLD+12480
       JMP SAF999
SAF100 LDA #0
       STA PLYFLD+12479
       STA PLYFLD+12480
       JMP SAF999
SAF900 LDA #112
       STA PLYFLD+12476
       STA PLYFLD+12477
SAF999 NOP
       LDX #4         ;if no cash,done

HIT210 LDA BOTLIN+14,X
       CMP #16
       BNE HIT220
       DEX 
       BNE HIT210
       JMP HIT999
HIT220 LDA LEVEL      ;reset skill
       ASL A
       ASL A
       ASL A
       ASL A
       ASL A
       ORA #31
       STA SKILL
       LDA #17        ;make sound
       STA SOUND
       LDX #4         ;stash+cash
       LDA #0
       STA TEMP
HIT310 LDA BOTLIN+14,X;get cash digit
       CLC
       ADC TOPLIN+13,X;add to stash
       ADC TEMP       ;plus carry
       SEC
       SBC #16
       CMP #26
       BCC HIT320
       SEC
       SBC #10
       STA TOPLIN+13,X
       LDA #1
       STA TEMP
       JMP HIT330
HIT320 STA TOPLIN+13,X
       LDA #0
       STA TEMP
HIT330 DEX
       BNE HIT310
       LDA TEMP
       BEQ HIT390
       LDA TOPLIN+13
       CMP #25
       BNE HIT350
       LDA #16
       STA TOPLIN+13
       LDA TOPLIN+12
       CMP #25
       BNE HIT340
       LDA #16
       STA TOPLIN+12
       JMP HIT390
HIT340 INC TOPLIN+12
       JMP HIT390
HIT350 INC TOPLIN+13
HIT390 LDA #16        ;clear cash
       LDX #4
HIT395 STA BOTLIN+14,X
       DEX
       BNE HIT395
       JMP HIT999
HITPRZ CMP #120       ;prize?
       BNE HITRBL
       LDA #112       ;erase prize
       STA (TEMP),Y
       INY
       STA (TEMP),Y
       LDX #3
       JSR ADCASH
       DEC TOPLIN+19
       DEC PRIZ
       BNE HIT410     ;last prize?
       LDA #33        ;make sound
       STA SOUND
       LDA #186       ;van indicator
       STA TOPLIN+19
       JMP HIT999
HIT410 LDA #49        ;make sound
       STA SOUND
       JMP HIT999
;
HITRBL CMP #122       ;roadblock?
       BNE HITSTP
       LDA #112       ;erase roadblock

       STA (TEMP),Y
       INY
       STA (TEMP),Y
       INC HITS
       LDA HITS
       CMP #10
       BCC HIT510
       LDA #10
       STA HITS
HIT510 LDA #113         ;make sound
       STA SOUND
       JMP HIT999
;
HITSTP CMP #124       ;stoplight?
       BNE HIT999
       LDA RTCLOK+2   ;light on?
       AND #64
       BEQ HIT999
       LDA #112       ;erase stoplight

       STA (TEMP),Y
       INY
       STA (TEMP),Y
       LDA LEVEL      ;reset skill
       ASL A
       ASL A
       ASL A
       ASL A
       ASL A
       ORA #31
       STA SKILL
       LDA #16        ;clear cash
       LDX #4
HIT610 STA BOTLIN+14,X
       DEX
       BNE HIT610
       LDA #81         ;make sound
       STA SOUND
HIT999 NOP
;
; Van and cop collisions
;
HITVAN LDA #122       ;wait to midscrn

HTV005 CMP VCOUNT
       BCC HTV005
       LDA #88
HTV010 CMP VCOUNT
       BCS HTV010
       LDA HPOSF      ;hideout safe
       ORA VPOSF
       BNE HTV030
       LDA VTEMP+1
       CMP #118
       BNE HTV030
       JMP HTC999
HTV030 LDA M0PL       ;van collision
       ORA M1PL
       ORA M2PL
       ORA M3PL
       STA VTEMP
       AND #~00001000
       BNE HTV050     ;if no hit, done

       JMP HITCOP
HTV050 JSR RNSPOT     ;move van
       BCC HTV050
       LDA TEMP+1
       STA VPOS+4
       LDA TEMP
       SEC
       SBC #4
       STA HPOS+4
       LDA #0
       STA VPOSF+4
       STA HPOSF+4
       STA DIR+4
       LDA #255
       STA SKILL
       LDA PRIZ       ;last prize?
       BEQ HTV100
       LDA #49        ;make sound
       STA SOUND
       LDX #3         ;add cash/skill
       JSR ADCASH
       JMP HITCOP
HTV100 LDA #3         ;reset prizes
       STA PRIZ
       LDA #19+128
       STA TOPLIN+19
       INC LEVEL      ;increment level

       LDA LEVEL
       CMP #7         ;limit to 6
       BCC HTV120
       LDA #6
       STA LEVEL
       LDA SPEED
       BNE HTV120
       LDA #1         ;double speed!
       STA SPEED
       LDX #4
HTV110 LDA #~11111110
       AND VPOSF,X
       STA VPOSF,X
       LDA #~11111110
       AND HPOSF,X
       STA HPOSF,X
       DEX
       CPX #255
       BNE HTV110
HTV120 LDA LEVEL       ;level marker
       CLC
       ADC #25+64
       STA TOPLIN+18
       INC NPRIZ      ;draw new prizes

       INC NPRIZ
       INC NPRIZ
       LDX #3         ;add cash/skill
       JSR ADCASH
       LDA #0
       STA TIME
       LDA #$BA
       STA BKCOLR
       LDA LEVEL
       CMP #5
       BNE HTV300
       LDA #65
       STA SOUND
       LDX #3         ;bonus life
HTV200 LDA TOPLIN,X
       CMP #192
       BEQ HTV250
       DEX
       BNE HTV200
       JMP HITCOP
HTV250 LDA #200
       STA TOPLIN,X
       JMP HITCOP
HTV300 LDA #65
       STA SOUND
;
HITCOP LDA VTEMP      ;cop collisions
       AND #~00000111
       BEQ HTC999
       LDA #0
       STA AUDC1
       STA AUDC2
       STA AUDC3
       STA AUDC4
       JMP CAUGHT
HTC999 NOP
;
; Add dollars and prizes
;
ADPRIZ LDA NPRIZ
       BEQ ADDOLR
       JSR RNSPOT
       BCC ADDOLR
       LDA #121
       STA (TEMP),Y
       DEY
       LDA #120
       STA (TEMP),Y
       DEC NPRIZ
ADDOLR LDA NDOLR
       BEQ ADD999
       JSR RNSPOT
       BCC ADD999
       LDA #127
       STA (TEMP),Y
       DEY
       LDA #126
       STA (TEMP),Y
       DEC NDOLR
ADD999 NOP
;
; Sound routine
;
       JSR SOUNDS
;
; Jump to beginning of loop
;
       JMP MNLOOP
;
; Caught by the COPs!
;
CAUGHT LDX #1         ;any cars left?
CAU010 LDA TOPLIN,X
       CMP #200
       BEQ CAU100
       INX
       CPX #4
       BNE CAU010
       JMP ENDGAM
CAU100 LDA LEVEL      ;reset skill
       ASL A
       ASL A
       ASL A
       ASL A
       ASL A
       ORA #31
       STA SKILL
       LDA #0
       STA HITS
       LDA #100
       STA GAS
       LDA #0         ;car to hideout
       STA HPOSF
       STA VPOSF
       STA DIR
       LDA #184
       STA HPOS
       LDA #>PLYFLD + 48
       STA VPOS
       LDA #161       ;play tune
       STA SOUND
CALOOP LDA RTCLOK+2   ;wait for Vblank

CAU200 CMP RTCLOK+2
       BEQ CAU200
       LDA RTCLOK+2   ;move lost car
       AND #~00000111
       BNE CAU300
       LDA TOPLIN,X
       CMP #199
       BEQ CAU250
CAU230 CPX #0
       BEQ CAU250
       INC TOPLIN-1,X
CAU250 INC TOPLIN,X
       LDA TOPLIN,X
       CMP #207
       BNE CAU300
       LDA #192
       STA TOPLIN,X
       DEX
       CPX #255
       BNE CAU300
       JMP CAU900     ;loop done
CAU300 TXA
       PHA
       JSR ANMDOL
       JSR FLASHS
       JSR SOUNDS
       PLA
       TAX
       LDA CONSOL
       AND #SWSTRT
       BNE CAU350
       JMP START
CAU350 JMP CALOOP
CAU900 LDA #0
       STA TIME
       LDA #$BA
       STA BKCOLR
       LDA #255
       STA SAFETY
       LDA #118
       STA PLYFLD+12476
       LDA #119
       STA PLYFLD+12477
       LDA #33
       STA PLYFLD+12479
       LDA #34
       STA PLYFLD+12480
       LDY #20        ;reset gas/cash
CAU950 LDA CASHLN-1,Y
       STA BOTLIN-1,Y
       DEY
       BNE CAU950
       JMP MNLOOP
;
; End of game
;
ENDGAM LDX #0         ;score>high?
END050 LDA HILINE+12,X
       CMP TOPLIN+12,X
       BCC END100
       BNE END200
       INX 
       CPX #6
       BNE END050
END100 LDX #10        ;high=score
END110 LDA TOPLIN+9,X
       STA HILINE+9,X
       DEX
       BNE END110
END200 LDA #137       ;play tune
       STA SOUND
       LDA #0
       STA HTEMP
ENLOOP LDA RTCLOK+2   ;wait for Vblank

END310 CMP RTCLOK+2
       BEQ END310
       JSR ANMDOL
       JSR FLASHS
       JSR SOUNDS
       LDA RTCLOK+2   ;put messages
       BEQ END312
       JMP END500
END312 INC HTEMP
       LDA HTEMP
       CMP #8
       BNE END315
       LDA #1
       STA HTEMP
END315 CMP #1
       BEQ END350
       CMP #2
       BEQ END320
       CMP #3
       BEQ END410
       CMP #4
       BEQ END420
       CMP #5
       BEQ END430
       CMP #6
       BNE END317
       JMP END440
END317 JMP END450
END320 LDA #<HILINE
       STA TOPLMS
       LDA #>HILINE
       STA TOPLMS+1
       JMP END500
END350 LDA #<TOPLIN
       STA TOPLMS
       LDA #>TOPLIN
       STA TOPLMS+1
       JMP END500
END410 LDA #<MSGEND
       STA TOPLMS
       LDA #>MSGEND
       STA TOPLMS+1
       JMP END500
END420 LDA #<[MSGEND+20]
       STA TOPLMS
       LDA #>[MSGEND+20]
       STA TOPLMS+1
       JMP END500
END430 LDX LEVEL
       INX
       LDA SPEED
       BEQ END432
       INX
END432 LDA #0
       CLC
END435 ADC #20
       DEX
       BNE END435
       SEC
       SBC #20
       CLC
       ADC #<MSGRAT
       STA TOPLMS
       LDA #0
       ADC #>MSGRAT
       STA TOPLMS+1
       JMP END500
END440 LDA #<[MSGEND+40]
       STA TOPLMS
       LDA #>[MSGEND+40]
       STA TOPLMS+1
       JMP END500
END450 LDA #<[MSGEND+60]
       STA TOPLMS
       LDA #>[MSGEND+60]
       STA TOPLMS+1
END500 LDA CONSOL
       AND #SWSTRT
       BNE END600
       JMP START
END600 LDA STRIG0
       BNE END700
       JMP START
END700 JMP ENLOOP
;
; End of Program
;

	; garbage data to fill space until playfield data
	.word $02e0, $02e1, STEAL
	.byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
	.byte $0e, $0e, $0e, $0e, $0e

	; Import playfield data. Note that the file is not expected to contain binary headers.
	.if * <> PLYFLD
	.error "Bad padding!"
	.endif
	.INCBIN playfield.dat

ENDOFDATA

; this code disassembled from end of pirate version. Runs without relocation, so disable "set6".
	*=  *+$1B00
	.SET 6, 0
ENTRYPOINT
	LDY #$00
	LDX #>(ENDOFDATA-START_DATA_DST)+1 ; size of data to copy. +1 is just a lazy method to round up
COPYLOOP
MD1	LDA START_DATA_SRC,Y
MD2	STA START_DATA_DST,Y
	INY
	BNE COPYLOOP
	INC MD1+2
	INC MD2+2
	DEX
	BNE COPYLOOP
	LDA #$00
	STA CASINI
	STA DOSINI
	LDA #$00
	STA CASINI+1
	STA DOSINI+1
	JSR START_DATA_INIT
	JSR STEAL
	JMP (DOSVEC)
	
	.BANK
	*= $2E0
	.WORD ENTRYPOINT
