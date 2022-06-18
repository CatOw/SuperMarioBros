; -CODE GUIDANCE-
; 0. Constants: lines 19-25
; 1. Data Segment: lines 31-276
; 2. Main: lines 282-340
; 3. Game: lines 348-603
; 4. System: lines 6011-777
; 5. Physics: lines 785-1029
; 6. Hitboxes: lines 1037-1295
; 7. Keyboard: lines 1303-1367
; 8. Graphics: lines 1375-2136
; 9. Bitmap: lines 2144-2346
; 10. Time: lines 2354-2480

IDEAL

MODEL small
STACK 100h

;============CONSTANT============
Pink				= 0EFh
Aqua				= 0EBh
DosBoxWidth			= 320
DosBoxHeight		= 200
GameLengthSeconds	= 300
DefaultPX			= 42
DefaultPY			= 168
;============CONSTANT============

;================================================
;==================DATA SEGMENT==================
;================================================
DATASEG
	;=============BITMAP=============
	ScrLine			db DosBoxWidth dup (0) ; One Color line read buffer
	
	; BMP File Data
	FileHandle		dw ?
	Header			db 54   dup(0)
	Palette			db 400h dup(0)
	
	ScreenX			dw ? ; Where to print on screen
	ScreenY			dw ? ; Where to print on screen
	ScreenColSize	dw ? ; Total horizontal length to take from file and put on screen
	ScreenRowSize	dw ? ; Total vertical length to take from file and put on screen
	BMPWidth		dw ? ; Total width of the BMP file
	BMPISOff		dw ? ; Where to take from BMP
	BMPSOff			dw ? ; Where to take from BMP
	HowMuchToSub	dw ? ; Used to stabilize BMPWidth when is odd
	ChromaKeyBool	db ? ; 0 = no, 1 = yes
	
	; BMP File Names
	OpeningScr		db "opening.bmp",	0
	ClearScr		db "clearscr.bmp",	0
	Goodbye			db "goodbye.bmp",	0
	Black			db "black.bmp",		0
	
	; Game
	LoadingScreen	db "loadscr.bmp",	0
	GameOverWin		db "gmovwin.bmp",	0
	GameOverLose	db "gmovlose.bmp",	0
	SkyStats		db "skystats.bmp",	0
	SkyNumbers		db "skynum.bmp",	0
	Lives			db "lives.bmp",		0
	VictoryFlag		db "flag.bmp",		0
	FlagPole		db "pole.bmp",		0
	World1			db "wrld1.bmp",		0
	Castle			db "castle.bmp",	0
	PoleTop			db "poletop.bmp",	0
	Coin			db "coin.bmp",		0
	
	; Characters
	SmallMarioRight	db "smrgt.bmp",		0
	SmallMarioLeft	db "smlft.bmp",		0
	;===========BITMAP END===========
	
	
	;============SYSTEM============
	IntString		db 7 dup (' '), "$"
	IntStringPos	dw 0
	PlaceNumber		dw 0
	Digits			db 5 dup (?) ; Digits[0] = 5th digit
	TotalD			db ?
	DigitXStart		dw ?
	;==========SYSTEM END==========
	
	
	;==============GAME==============
	OpeningExitCode	db 0
	GameOver		db 0 ; 0 = Continue, 1 = Break Loop
	GameOverCode	db ? ; 0 = Lose, 1 = Win
	LastTimeSeconds	db ?
	
	; Statistics
	PlayerScore		dw 0
	PlayerCoins		db 0
	World			db 1
	Time			dw GameLengthSeconds
	PlayerLives		db 3
	
	; Counting from top left
	PlayerDirection	db 0 ; 0 = Right, 1 = Left
	PlayerX			dw 42
	PlayerY			dw 168
	PlayerXProgress	dw 42 ; 0 to world width
	;============GAME END============
	
	
	;=========KEYBOARD INPUT=========
	RightArrowPress	db 0
	LeftArrowPress	db 0
	UpArrowPress	db 0
	;=======KEYBOARD INPUT END=======


	;==========GAME PHYSICS==========
	; Used for Momentum and Movements
	PMovesRight		db 0
	PMovesLeft		db 0
	PMovesUp		db 0
	PMovesDown		db 0
	ImpactOutput	db ? ; Output of Impact Detection
	UpVelocity		dw 0 ; Jump Movement Velocity Management
	DownVelocity	dw 0 ; Gravity Pull Velocity Management
	;========GAME PHYSICS END========


	;===========ANIMATIONS===========
	Momentum		dw 0
	PRightForm      db 0
	PLeftForm       db 0
	FlagX			dw 3160
	FlagY			dw 40 ; max 151
	VictoryForm 	db 0 ; 0-1 or 2-3
	ShowCoin		dw 0
	CoinXPos		dw ?
	CoinYPos		dw ?
	;===========ANIMATIONS===========
	
	
	;============HITBOXES============
	ImpactCheck		dw 0 ; Like an Array of Hitboxes

	; Surprise Amount: 13
	Surprise		dw 256, 120
					dw 336, 120
					dw 368, 120
					dw 1248, 120
					dw 1696, 120
					dw 1744, 120
					dw 1792, 120
					dw 2720, 120
					dw 352, 56
					dw 1504, 56
					dw 1744, 56
					dw 2064, 56
					dw 2080, 56
	
	; Bricks Amount: 30
	Brick			dw 320, 120
					dw 352, 120
					dw 384, 120
					dw 1232, 120
					dw 1264, 120
					dw 1504, 120
					dw 1600, 120
					dw 1616, 120
					dw 1888, 120
					dw 2064, 120
					dw 2080, 120
					dw 2688, 120
					dw 2704, 120
					dw 2736, 120
					dw 1280, 56
					dw 1296, 56
					dw 1312, 56
					dw 1328, 56
					dw 1344, 56
					dw 1360, 56
					dw 1376, 56
					dw 1392, 56
					dw 1456, 56
					dw 1472, 56
					dw 1488, 56
					dw 1936, 56
					dw 1952, 56
					dw 1968, 56
					dw 2048, 56
					dw 2096, 56

	; Upper Pipes Amount: 12
	UpperPipe		dw 448, 152
					dw 464, 152
					dw 608, 136
					dw 624, 136
					dw 736, 120
					dw 752, 120
					dw 912, 120
					dw 928, 120
					dw 2608, 152
					dw 2624, 152
					dw 2864, 152
					dw 2880, 152
	
	; Upper Stairs Amount: 27
	UpperStair		dw 2144, 168
					dw 2288, 168
					dw 2368, 168
					dw 2528, 168
					dw 2896, 168
					dw 3168, 168
					dw 2160, 152
					dw 2272, 152
					dw 2384, 152
					dw 2512, 152
					dw 2912, 152
					dw 2176, 136
					dw 2256, 136
					dw 2400, 136
					dw 2496, 136
					dw 2928, 136
					dw 2192, 120
					dw 2240, 120
					dw 2416, 120
					dw 2432, 120
					dw 2480, 120
					dw 2944, 120
					dw 2960, 104
					dw 2976, 88
					dw 2992, 72
					dw 3008, 56
					dw 3024, 56
	
	; Side Pipes Amount: 18
	PipeSideImpact	dw 448, 168
					dw 464, 168
					dw 608, 168
					dw 624, 168
					dw 736, 168
					dw 752, 168
					dw 912, 168
					dw 928, 168
					dw 2608, 168
					dw 2624, 168
					dw 2864, 168
					dw 2880, 168
					dw 608, 152
					dw 624, 152
					dw 736, 152
					dw 752, 152
					dw 912, 152
					dw 928, 152
	
	; Side Stairs Amount: 19
	StairSideImpact	dw 2192, 168
					dw 2240, 168
					dw 2448, 168
					dw 2480, 168
					dw 3024, 168
					dw 3168, 168
					dw 2192, 152
					dw 2240, 152
					dw 2432, 152
					dw 2480, 152
					dw 3024, 152
					dw 2192, 136
					dw 2240, 136
					dw 2432, 136
					dw 2480, 136
					dw 3024, 136
					dw 3024, 120
					dw 3024, 104
					dw 3024, 88
	;==========HITBOXES END==========
;================================================
;================DATA SEGMENT END================
;================================================

CODESEG
;================================================
;======================MAIN======================
;================================================

START:
	mov ax, @data
	mov ds, ax
	
	call SetGraphic
	
	OpeningScreen:
		call opening_screen
		cmp [OpeningExitCode], 1
		jz EXIT
	
	StartGame:
		call game_init
	
	GameLoop:
		call Game
		cmp [GameOver], 0
		jz GameLoop
		cmp [GameOverCode], 1
		jz VictoryEvent
		
	DeathEvent:
		call Death
		cmp [PlayerLives], 0
		jz GameLost
		jmp Next
		
	VictoryEvent:
		call Victory
		jmp GameVictory
		
	Next:
		jmp StartGame
		
	GameVictory:
		call game_over_win
		jmp OpeningScreen
	
	GameLost:
		call game_over_lose
		jmp OpeningScreen
	
	
EXIT:
	call ExitScreen
	push 30
	call Sleep
	
	mov ax, 4C00h ; returns control to dos
  	int 21h
	
	mov ah,0
	int 16h
	
	mov ax,2
	int 10h
	
	mov ax, 4c00h
	int 21h
;================================================
;====================MAIN END====================
;================================================

;================================================
;======================GAME======================
;================================================
; Handle the most significant functions
proc Game

	; Get Updated Time
	call UpdateTime
	
	; Get User Input
	call GetUserInput
	
	; Apply Physics
	call ApplyPhysics
	
	; Update Screen
	call UpdateScreen
	
	; Look for Game Break Statements
	call CheckGameOver
	
	ret
endp Game

; Reset Data
; Game Loading Screen
; Initialize World 1
; Get Start Time
proc game_init
	
	call ResetData
	call show_loading_screen
	call init_world1
	
	; Get Start Time in Seconds
	mov ah, 2Ch
	int 21h
	mov [LastTimeSeconds], dh
	
	ret
endp game_init

; Shows World1 and Mario
proc init_world1
	
	; Load World 1
	mov dx, offset World1
	mov [ScreenX], 0
	mov [ScreenY], 31
	mov [ScreenColSize], 320
	mov [ScreenRowSize], 169
	mov [BMPWidth], 3584
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	; Load Mario
	mov dx, offset SmallMarioRight
	mov ax, [PlayerX]
	mov [ScreenX], ax
	mov ax, [PlayerY]
	mov [ScreenY], ax
	mov [ScreenColSize], 12
	mov [ScreenRowSize], 16
	mov [BMPWidth], 223
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], -1
	mov [ChromaKeyBool], 1
	call OpenShowBMP
	
	ret
endp init_world1

; Checks for Game Loop Break Statements
; Input: None
; Output: DS:[GameOver] = 0 OR 1, DS:[GameOverCode] = 0 OR 1 OR None
proc CheckGameOver
	
	; Game Loop Break Statements:
	; 1. [Time] = 0; Exit Code 0
	; 2. [PlayerY] = 200; Exit Code 0
	; 3. [PlayerXProgress, PlayerY] = [3169, range(0, 152)]; Exit Code 1

	; Game Countdown
	cmp [Time], 0
	jz @@GameOverLost
	
	; Player in Void
	cmp [PlayerY], 184
	jz @@GameOverLost
	
	; Player reaches Flag
	cmp [PlayerXProgress], 3163
	jb @@Exit
	cmp [PlayerY], 152
	jbe @@GameOverWin
	
	; Break - Exit Code 0
	@@GameOverLost:
		mov [GameOver], 1
		mov [GameOverCode], 0
		jmp @@Exit

	; Break - Exit Code 1
	@@GameOverWin:
		mov [GameOver], 1
		mov [GameOverCode], 1
	
	@@Exit:
		ret
endp CheckGameOver

; Set Game Loop Break Victory
; Mario Victory Animation
proc Victory
	
	mov [PlayerLives], 3
	mov [GameOver], 0
	mov [PlayerX], 164
	mov [PlayerXProgress], 3168
	mov [FlagY], 40
	
	call UpdateScreen

	@@FlagDown:
		; Show Stats
		call ShowStats

		cmp [PlayerY], 64
		jb @@SkipPullingFlag
		inc [FlagY]

		@@SkipPullingFlag:
		call FlagAniDraw
		call Sleep25ms

		call MarioFlagAni
		call Sleep25ms
		cmp [PlayerY], 150
		jge @@Continue
		inc [PlayerY]
		
		@@Continue:
		cmp [FlagY], 120
		jne @@FlagDown
	
	; Repair Flag and Pole
	call FlagPoleDraw
	call FlagAniDraw
	
	; Mario walks into Castle animation
	call MarioCastleAni
	
	push 30
	call Sleep
	
	ret
endp Victory

; Set Game Loop Break Death
; Decrement Player Lives
; Mario Death Animation
; Output: DS:[PlayerLives]
proc Death
	
	mov [GameOver], 0
	dec [PlayerLives]
	
	cmp [PlayerY], 168 ; void death - no animation
	jg @@Continue
	
	mov [Momentum], 1
	mov cx, 32
	cmp [PlayerY], 31
	jb @@Down
	@@DeathAnimationUp:
		push cx
		call DeathAniDraw
		; Repeat with delay
		mov cx, [Momentum]
		@@DeathSleep1:
			call MomentumSleep1
			loop @@DeathSleep1
		inc [Momentum]
		dec [PlayerY]
		pop cx
		loop @@DeathAnimationUp
	
	@@Down:
	mov cx, 185
	sub cx, [PlayerY]
	mov [Momentum], cx
	@@DeathAnimationDown:
		push cx
		call DeathAniDraw
		; Repeat with delay
		mov cx, [Momentum]
		@@DeathSleep2:
			call MomentumSleep2
			loop @@DeathSleep2
		dec [Momentum]
		inc [PlayerY]
		pop cx
		loop @@DeathAnimationDown
	
	@@Continue:
	call ShowStats
	push 5
	call Sleep
		
	ret
endp Death

; Reset the Game's Data Variables
proc ResetData
	
	; Introduction and Game Loop
	mov [OpeningExitCode], 0
	mov [GameOver], 0
	
	; Stats
	mov [PlayerScore], 0
	mov [PlayerCoins], 0
	
	; Game
	mov [World], 1
	mov [Time], GameLengthSeconds

	; if Lives = 0 reset lives
	cmp [PlayerLives], 0
	jnz @@SkipLives
	mov [PlayerLives], 3
	
	@@SkipLives:
	mov [PlayerDirection], 0
	mov [PlayerX], DefaultPX
	mov [PlayerY], DefaultPY
	mov [PlayerXProgress], DefaultPX
	
	; Animations
	mov [Momentum], 0
	mov [PRightForm], 0
	mov [PLeftForm], 0
	mov [FlagX], 3160
	mov [FlagY], 40
	mov [VictoryForm], 0

	; Movement and Momentum
	mov [PMovesRight], 0
	mov [PMovesLeft], 0
	mov [PMovesUp], 0
	mov [PMovesDown], 0
	mov [UpVelocity], 0
	mov [DownVelocity], 0
	
	ret
endp ResetData
;================================================
;====================GAME END====================
;================================================

;================================================
;=====================SYSTEM=====================
;================================================
; Convert Integer to String
; Input: ax
; Output: DS:[IntString]
proc int_to_string
	
	push ax
	push bx
	push cx
	push dx
	
	xor cx, cx ; times push counter
	mov bx, 10 ; divider
	
	put_mode_to_stack:
		xor dx, dx
		div bx
		add dl, '0' ; current LSB digit
		push dx
		inc cx
		cmp ax, 9 ; check if it's the last time to divide
		jg put_mode_to_stack
		
		cmp ax, 0
		jz pop_next ; jump if ax was totally 0
		add al, '0'
		xor si, si
		mov [IntString], al
		inc si
	
	pop_next:
		pop ax ; remove all rest LIFO (reverse) (MSB to LSB)
		
		mov [IntString + si], al
		inc si
		loop pop_next
		
		mov [IntString + si], 13
		mov [IntString + si + 1], 10
		
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
endp int_to_string

; Convert ax to an Array of Decimal Number
; Input: ax = range(10, 0FFFFh)
; Output in DS as Digits separately and Length
; Gets every digit of a number
proc SplitAXDecimal
	
	push ax
	push bx
	push cx
	push dx
	
    mov cx, 0  ; will count how many time we did push
    mov bx, 10 ; the divider
	
	; Set default values
	mov [TotalD], 1
	mov [Digits], 0
	mov [Digits + 1], 0
	mov [Digits + 2], 0
	mov [Digits + 3], 0
	mov [Digits + 4], 0
	
	@@put_mode_to_stack:
    xor dx, dx
    div bx
	; we cant push only dl so we push all dx
    push dx
    inc cx
    cmp ax, 9   ; check if it is the last time to div
    jg @@put_mode_to_stack
	
	get_length:
	inc [TotalD]
    loop get_length

	; al is the first digit
	cmp [TotalD], 2
	jz SaveD2 ; save the 2nd
	cmp [TotalD], 3
	jz SaveD3 ; save the 3rd
	cmp [TotalD], 4
	jz SaveD4 ; save the 4th
	
	; save the 5th digit
	SaveD5:
		mov [Digits + 4], al
		jmp SaveOthers

	SaveD4:
		mov [Digits + 3], al
		jmp SaveOthers

	SaveD3:
		mov [Digits + 2], al
		jmp SaveOthers

	SaveD2:
		mov [Digits + 1], al
	
	SaveOthers:
	cmp [TotalD], 2
	jz SaveTotal2
	cmp [TotalD], 3
	jz SaveTotal3
	cmp [TotalD], 4
	jz SaveTotal4
	SaveTotal5:
		; this runs if TotalD = 5
		pop ax
		mov [Digits + 3], al
		; it will now continue to the next digits
		
	SaveTotal4:
		; saves the 4th digit
		pop ax
		mov [Digits + 2], al

	SaveTotal3:
		; saves the 3rd digit
		pop ax
		mov [Digits + 1], al

	SaveTotal2:
		; saves the 2nd digit
		pop ax
		mov [Digits], al
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
endp SplitAXDecimal

; Convert Coordinates to Pixels
; Input: X, Y
; Output: ax = pixels
proc coords_to_pix
    push bp
    mov bp, sp

    x equ [bp+6]
    y equ [bp+4]

    push dx
    push bx

    mov ax, y
    mov bx, 320
    xor dx, dx
    mul bx
    add ax, x

    pop bx
    pop dx

    pop bp
    ret 4
endp coords_to_pix
;================================================
;===================SYSTEM END===================
;================================================

;================================================
;================MOVEMENT PHYSICS================
;================================================
; Applies Physics to the Game's Player
proc ApplyPhysics

	; 1. if Player pressed Right Arrow:
	; [PMovesRight] = 1
	; 2. if Player pressed Left Arrow:
	; [PMovesLeft] = 1
	; 3. if Player pressed Up Arrow:
	; if Player not in Jumping Motion:
	; [PMovesUp] = 1
	; else continue
	; Apply Forces
	; -=- Player -=-
	cmp [RightArrowPress], 0
	jz @@CheckLeftArrow
	mov [PMovesRight], 1 ; Define Movement
	jmp @@CheckUpArrow

	@@CheckLeftArrow:
	cmp [LeftArrowPress], 0
	jz @@CheckUpArrow
	mov [PMovesLeft], 1 ; Define Movement

	@@CheckUpArrow:
	; Reset Up Movement if:
	; 1. Up Arrow Key Pressed
	; 2. PMovesUp = 0
	; 3. PMovesDown = 0
	cmp [UpArrowPress], 0
	jz @@ApplyForcesPlayer
	cmp [PMovesUp], 0
	ja @@ApplyForcesPlayer
	cmp [PMovesDown], 0
	ja @@ApplyForcesPlayer
	mov [PMovesUp], 1 ; Reset Jump Momentum
	
	; Apply Forces
	@@ApplyForcesPlayer:
	; Up Movement Momentum
	call UpMovementMomentum
	; Right
	call ForcePlayerRight
	; Left
	call ForcePlayerLeft
	; Down
	call DownMovementMomentum

	@@Exit:
	ret
endp ApplyPhysics

; Up Movement Momentum
; Input: None
; Output: Player Movement Upwards on Screen
proc UpMovementMomentum

	; Up Movement Momentum
	@@UpVelocity:
	cmp [UpVelocity], 1
	je @@Exit
	cmp [UpVelocity], 30
	jbe @@UpPullMomentum2
	cmp [UpVelocity], 70
	jbe @@UpPullMomentum1
	@@UpPullMomentum2:
	call ForcePlayerUp
	@@UpPullMomentum1:
	call ForcePlayerUp

	@@Exit:
	inc [UpVelocity]
	ret
endp UpMovementMomentum

; Down Movement Momentum
; Register Usage: ax, bx
; Input: None
; Output: Player Movement Downwards on Screen
proc DownMovementMomentum

	; Down Movement Momentum
	cmp [DownVelocity], 1
	jbe @@NoFlying
	cmp [DownVelocity], 20 ; Air-Time
	jbe @@SkipForcePlayer
	@@NoFlying:
	mov ax, [DownVelocity]
	mov bl, 1 ; Velocity defined here. 1 = Fastest
	div bl
	cmp ah, 0
	je @@PDownPullMovement1
	jmp @@SkipForcePlayer
	@@PDownPullMovement1:
	call ForcePlayerDown
	
	@@SkipForcePlayer:
	inc [DownVelocity]

	@@Exit:
	ret
endp DownMovementMomentum

; Forces Player Rightwards
; Input: None
; Output: Player Movement Rightwards on Screen
proc ForcePlayerRight

	; Force Player Right if:
	; 1. PMovesRight > 0
	; 2. PMovesRight < 4
	; 3. ImpactDetectionRight returns 0
	; -1-
	cmp [PMovesRight], 0
	jz @@ForcePlayerBreak
	; -2-
	cmp [PMovesRight], 10
	jae @@ForcePlayerBreak
	; -3-
	call ImpactDetectionRight
	cmp ax, 1
	jz @@ForcePlayerBreak

	@@ForcePlayerRight:
	add [PRightForm], 4
	mov [PlayerDirection], 0
	inc [PMovesRight]
	inc [PlayerXProgress]
	cmp [PlayerX], 160
	jae @@Exit
	inc [PlayerX]
	jmp @@Exit

	@@ForcePlayerBreak:
	mov [PMovesRight], 0

	@@Exit:
	ret
endp ForcePlayerRight

; Forces Player Leftwards
; Input: None
; Output: Player Movement Leftwards on Screen
proc ForcePlayerLeft
	
	; Force Player Left if:
	; 1. PMovesLeft > 0
	; 2. PMovesLeft < 4
	; 3. ImpactDetectionLeft returns 0
	; -1-
	cmp [PMovesLeft], 0
	jz @@ForcePlayerBreak
	; -2-
	cmp [PMovesLeft], 10
	jae @@ForcePlayerBreak
	; -3-
	call ImpactDetectionLeft ; PlayerType = -1 already
	cmp ax, 1
	jz @@ForcePlayerBreak

	@@ForcePlayerLeft:
	add [PLeftForm], 10
	mov [PlayerDirection], 1
	inc [PMovesLeft]
	dec [PlayerXProgress]
	dec [PlayerX]
	jmp @@Exit

	@@ForcePlayerBreak:
	mov [PMovesLeft], 0

	@@Exit:
	ret
endp ForcePlayerLeft

; Forces Player Upwards
; Input: None
; Output: Player Movement Upwards on Screen
proc ForcePlayerUp

	; -=- Player -=-
	; Force Player Up if:
	; 1. PMovesDown = 0
	; 2. ImpactDetectionUp returns 0
	; 3. PMovesUp > 0
	; 4. PMovesUp < 80
	@@Player:
	; -1-
	cmp [PMovesDown], 0
	ja @@ForcePlayerBreak
	; -2-
	call ImpactDetectionUp ; PlayerType = -1 already
	cmp ax, 1
	jz @@ForcePlayerBreak
	; -3-
	cmp [PMovesUp], 0
	jz @@ForcePlayerBreak
	; -4-
	cmp [PMovesUp], 80
	jae @@ForcePlayerBreak

	@@ForcePlayerUp:
	inc [PMovesUp]
	dec [PlayerY]
	jmp @@Exit

	@@ForcePlayerBreak:
	mov [UpVelocity], 0
	mov [PMovesUp], 0

	@@Exit:
	ret
endp ForcePlayerUp

; Forces Player Downwards
; Input: None
; Output: Player Movement Downwards on Screen
proc ForcePlayerDown

	; Force Player Down if:
	; 1. PMovesUp = 0
	; 2. ImpactDetectionDown returns 0
	; 3. PlayerY != 184
	; -1-
	cmp [PMovesUp], 0
	ja @@ForcePlayerBreak
	; -2-
	call ImpactDetectionDown ; PlayerType = -1 already
	cmp ax, 1
	jz @@ForcePlayerBreak
	; -3-
	cmp [PlayerY], 184
	jz @@ForcePlayerBreak

	@@ForcePlayerLeft:
	inc [PMovesDown]
	inc [PlayerY]
	jmp @@Exit

	@@ForcePlayerBreak:
	mov [DownVelocity], 0
	mov [PMovesDown], 0

	@@Exit:
	ret
endp ForcePlayerDown
;================================================
;==============MOVEMENT PHYSICS END==============
;================================================

;================================================
;================HITBOX DETECTION================
;================================================
; Check Player Impact on Right Side
; Input: None
; Output: ax = 0 || 1
proc ImpactDetectionRight

    ; Impact Detected if:
    ; 1. [ImpactCheck + si] - [PlayerXProgress] = 12
    ; OR
    ; 2. [ImpactCheck + si + 2] - [PlayerY] = range(-15, 15)
	; OR
	; 3. if [PlayerY] > 168:
	; [PlayerXProgress] = 1124
	; OR [PlayerXProgress] = 1412
	; OR [PlayerXProgress] = 2468
	; Go over Array of Hitboxes
    mov cx, 118
    mov si, 2	
    @@PImpactCheck:
	; -1-
	mov ax, [ImpactCheck + si]
	sub ax, [PlayerXProgress]
	cmp ax, 12
	jne @@RepeatP

    ; -2-
    mov ax, [ImpactCheck + si + 2]
	sub ax, [PlayerY]
	cmp ax, -15
	jl @@RepeatP
	cmp ax, 15
	jg @@RepeatP
	jmp @@PImpactDetected

    ; No Impact Detected - Repeat
    @@RepeatP:
    add si, 4
    loop @@PImpactCheck

	; -3-
	cmp [PlayerY], 168
	jbe @@PNoImpactDetected
	cmp [PlayerXProgress], 1124
	je @@PImpactDetected
	cmp [PlayerXProgress], 1412
	je @@PImpactDetected
	cmp [PlayerXProgress], 2468
	je @@PImpactDetected

    ; No Impact Detected
	@@PNoImpactDetected:
    xor ax, ax
    jmp @@Exit

    @@PImpactDetected:
    mov ax, 1

	@@Exit:
	ret
endp ImpactDetectionRight

; Check Player Impact on Left Side
; Input: None
; Output: ax = 0 || 1
proc ImpactDetectionLeft

    ; Impact Detected if:
	; 1. [PlayerX] = 0
    ; 2. [PlayerXProgress] - [ImpactCheck + si] = 16
    ; OR
    ; 3. [ImpactCheck + si + 2] - [PlayerY] = range(-15, 15)
	; OR
	; 4. if [PlayerY] > 168:
	; [PlayerXProgress] = 1104
	; OR [PlayerXProgress] = 1376
	; OR [PlayerXProgress] = 2448
	; -1-
	cmp [PlayerX], 0
	je @@PImpactDetected

	; Go over Array of Hitboxes
    mov cx, 118
    mov si, 2	
    @@PImpactCheck:
	; -2-
	mov ax, [PlayerXProgress]
	sub ax, [ImpactCheck + si]
	cmp ax, 16
	jne @@RepeatP

    ; -3-
    mov ax, [ImpactCheck + si + 2]
	sub ax, [PlayerY]
	cmp ax, -15
	jl @@RepeatP
	cmp ax, 15
	jg @@RepeatP
	jmp @@PImpactDetected

    ; No Impact Detected - Repeat
    @@RepeatP:
    add si, 4
    loop @@PImpactCheck

	; -4-
	cmp [PlayerY], 168
	jbe @@PNoImpactDetected
	cmp [PlayerXProgress], 1104
	je @@PImpactDetected
	cmp [PlayerXProgress], 1376
	je @@PImpactDetected
	cmp [PlayerXProgress], 2448
	je @@PImpactDetected

    ; No Impact Detected
	@@PNoImpactDetected:
    xor ax, ax
    jmp @@Exit

    @@PImpactDetected:
    mov ax, 1

	@@Exit:
	ret
endp ImpactDetectionLeft

; Check Player Impact on Up Side
; Also Detects Impact with Surprise Block
; Input: None
; Output: ax = 0 || 1
proc ImpactDetectionUp

    ; -=- Player -=-
    ; Impact Detected if:
    ; 1. [PlayerY] = 0
    ; OR
    ; 2. [ImpactCheck + si] - [PlayerXProgress] = range(-15, 11)
    ; AND
    ; 3. [ImpactCheck + si + 2] - [PlayerY] = -16

    ; -1-
    cmp [PlayerY], 0
    je @@ImpactDetected

    ; Go over Array of Hitboxes
    mov cx, 43
    mov si, 2
    @@ImpactCheck:
    ; -2-
    mov ax, [ImpactCheck + si]
    sub ax, [PlayerXProgress]
    cmp ax, -15
    jl @@Repeat
    cmp ax, 11
    jg @@Repeat

    ; -3-
    @@Statement3:
    mov ax, [ImpactCheck + si + 2]
    sub ax, [PlayerY]
    cmp ax, -16
    je @@ImpactDetected

    ; No Impact Detected - Repeat
    @@Repeat:
    add si, 4
    loop @@ImpactCheck

    ; No Impact Detected
    xor ax, ax
    jmp @@Exit

    @@ImpactDetected:
    mov ax, 1
	; Look for Surprise Block Impact
	cmp si, 50
	ja @@Exit
	; Surprise Block Detected
	; Check for Coin
	mov bx, [ImpactCheck + si]
    sub bx, [PlayerXProgress]
    cmp bx, -12
    jl @@Exit
    cmp bx, 5
    jg @@Exit
	; Player is a bit centered, give coin
	mov [ShowCoin], 1
	mov bx, [PlayerX]
	mov [CoinXPos], bx
	mov bx, [ImpactCheck + si + 2]
	sub bx, 16
	mov [CoinYPos], bx

    @@Exit:
    ret
endp ImpactDetectionUp

; Check Player Impact on Down Side
; Input: None
; Output: ax = 0 || 1
proc ImpactDetectionDown

	; Imapct Detected if:
	; 1. [ImpactCheck + si] - [PlayerXProgress] = range(-15, 11)
	; AND
	; 2. [PlayerY] - [ImpactCheck + si + 2] = 16
	; OR
	; 3. if [PlayerY] = 168:
	; Void is: 1104-1125, 1376-1413, 2448-2469
	; Pull Down at Void
	; Go over Array of Hitboxes
	mov cx, 82
	mov si, 2
	; -1-
	@@PImpactCheck:
	mov ax, [ImpactCheck + si]
	sub ax, [PlayerXProgress]
	cmp ax, -15
	jl @@RepeatP
	cmp ax, 11
	jg @@RepeatP

	; -2-
	mov ax, [ImpactCheck + si + 2]
	sub ax, [PlayerY]
	cmp ax, 16
	je @@PImpactDetected
	; No Impact Detected - Repeat
	@@RepeatP:
	add si, 4
	loop @@PImpactCheck

	; -3-
	cmp [PlayerY], 168
	jne @@PNoImpactDetected
	cmp [PlayerXProgress], 1104
	jb @@PImpactDetected
	cmp [PlayerXProgress], 1125
	jb @@PNoImpactDetected
	cmp [PlayerXProgress], 1376
	jb @@PImpactDetected
	cmp [PlayerXProgress], 1413
	jb @@PNoImpactDetected
	cmp [PlayerXProgress], 2448
	jb @@PImpactDetected
	cmp [PlayerXProgress], 2469
	ja @@PImpactDetected

	; No Impact Detected
	@@PNoImpactDetected:
	xor ax, ax
	jmp @@Exit

	; Impact Detected
	@@PImpactDetected:
	mov ax, 1

	@@Exit:
	ret
endp ImpactDetectionDown
;================================================
;==============HITBOX DETECTION END==============
;================================================

;================================================
;====================KEYBOARD====================
;================================================
; Get Keyboard Input from User
; Register Usage: ax, bx
; Output: Arrow Key Press Status in DS
proc GetUserInput

	; Reset Input
	mov [RightArrowPress], 0
	mov [LeftArrowPress], 0
	mov [UpArrowPress], 0

	; Read Keyboard Input
	call CheckAndReadKey

	; Check Right Arrow
	cmp ah, 4Dh
	je @@RightArrowPressed
	
	; Check Left Arrow
	cmp ah, 4Bh
	je @@LeftArrowPressed

	; Check Up Arrow
	; Avoid Flying
	mov bh, ah
	call ImpactDetectionDown
	cmp ax, 0
	jz @@Exit
	cmp bh, 48h
	je @@UpArrowPressed

	; No Key was Pressed
	jmp @@Exit

	; Arrow Key Press Actions
	@@RightArrowPressed:
	mov [RightArrowPress], 1
	jmp @@Exit

	@@LeftArrowPressed:
	mov [LeftArrowPress], 1
	jmp @@Exit

	@@UpArrowPressed:
	mov [UpArrowPress], 1
	
	@@Exit:
	ret
endp GetUserInput

; Read Key Status
; Register Usage: ax
; Output: ah = scan code, al = ASCII character or 0
proc CheckAndReadKey

	mov ah, 1
	int 16h
	pushf
	jz @@return 
	mov ah, 0
	int 16h

	@@return:	
		popf
		ret
endp CheckAndReadKey
;================================================
;==================KEYBOARD END==================
;================================================

;================================================
;====================GRAPHICS====================
;================================================
; Enable Graphic Mode
proc SetGraphic

	mov ax,13h
	int 10h
	
	ret
endp SetGraphic

; Apply Graphical Changes to the Screen
; Register Usage: ax, bx, cx, dx
; Input: None
; Output: Screen Changes
proc UpdateScreen
	
	; Show Stats
	call ShowStats

	; Check if the player reached the middle of screen
	; The world only has to move relatively to the character
	; if the player reaches the middle of the screen
	; else, the player will correct their edges alone
	; without having to draw everything and waste resources
	mov bx, [PlayerXProgress]
	cmp [PlayerX], 160
	je @@RelativeMovement
	
	; Background is Static
	sub bx, [PlayerX]
	jmp @@PrintBackground

	; Everything moves relative to Mario
	@@RelativeMovement:
	sub bx, 160

	@@PrintBackground:
	mov dx, offset World1
	mov [ScreenX], 0
	mov [ScreenY], 31
	mov [ScreenColSize], 320
	mov [ScreenRowSize], 169
	mov [BMPWidth], 3584
	mov [BMPISOff], bx
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP

	; Print Mario on Screen
	; Check for Movement Animations
	@@ShowMario:
	cmp [PlayerDirection], 1
	jz @@MarioLeft2
	call PMovesRightAnimation
	jmp @@ShowCoin
	@@MarioLeft2:
	call PMovesLeftAnimation
	
	; Check if to Show a Coin
	@@ShowCoin:
	cmp [ShowCoin], 0
	je @@Exit
	call SurpriseCoin

	@@Exit:
	ret
endp UpdateScreen

; Grant the Player a Coin and Show on Screen
; 99 Coins = +1 Lives
; Input: None
; Output: Coin on Screen and Scores in DS
proc SurpriseCoin
	
	; Give Coin and 10 Points
	cmp [ShowCoin], 1
	ja @@PrintCoin
	inc [PlayerCoins]
	add [PlayerScore], 10

	@@PrintCoin:
	mov dx, offset Coin
	mov ax, [CoinXPos]
	mov [ScreenX], ax
	mov ax, [CoinYPos]
	sub ax, [ShowCoin]
	mov [CoinYPos], ax
	mov [ScreenY], ax
	mov [ScreenColSize], 10
	mov [ScreenRowSize], 14
	mov [BMPWidth], 10
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 1
	call OpenShowBMP
	
	; 99 Coins = +1 Lives
	cmp [PlayerCoins], 99
	jb @@ShowCoin
	mov [PlayerCoins], 0
	inc [PlayerLives]

	@@ShowCoin:
	cmp [ShowCoin], 8
	jb @@Exit
	mov [ShowCoin], -1
	
	@@Exit:
	inc [ShowCoin]
	ret
endp SurpriseCoin

; Display Game Stats on top
; Input: None
; Output: Stats on Screen
proc ShowStats

	; Stats Template
	ShowSkyStats:
		mov dx, offset SkyStats
		mov [ScreenX], 0
		mov [ScreenY], 0
		mov [ScreenColSize], 320
		mov [ScreenRowSize], 31
		mov [BMPWidth], 320
		mov [BMPISOff], 0
		mov [BMPSOff], 0
		mov [HowMuchToSub], 0
		mov [ChromaKeyBool], 1
		call OpenShowBMP
		jmp ShowStatsNumbers
		
		
	; Digits are in DS
	; TotalD for how many to show
	; Digit1-5 for digits to show
	ShowStatsNumbers:
		; Score
		mov ax, [PlayerScore]
		call SplitAXDecimal ; numbers are in Digits1-5
		mov [TotalD], 5
		mov [DigitXStart], 34
		call show_numbers
		
		; Coins
		mov al, [PlayerCoins]
		xor ah, ah
		call SplitAXDecimal ; numbers are in Digits1-5
		mov [TotalD], 2
		mov [DigitXStart], 129
		call show_numbers
		
		; Time
		mov ax, [Time]
		call SplitAXDecimal ; numbers are in Digits1-5
		mov [TotalD], 3
		mov [DigitXStart], 259
		call show_numbers
		
	@@Exit:
		ret
endp ShowStats

; Show Numbers on Screen
; Input 1: Array - Digits
; Input 2: Array Digits Length - TotalD
; Input 3: First Digit[X, Y] on Screen - DigitXStart
; Output: Numbers on Screen
proc show_numbers
	
	mov cl, [TotalD]
	xor ch, ch
	
	ShowDigit:
		push cx
		; Constant Data
		mov dx, offset SkyNumbers
		mov [ScreenY], 20
		; ScreenX is changing
		mov [ScreenColSize], 7
		mov [ScreenRowSize], 10
		mov [BMPWidth], 79
		; BMPISOff is changing (number 0-9)
		mov [BMPSOff], 0
		mov [HowMuchToSub], 0
		mov [ChromaKeyBool], 0
		
		; Inconstant Data
		mov bl, [TotalD]
		xor bh, bh
		mov [ScreenX], bx
		sub [ScreenX], cx
		mov bx, [ScreenX]
		shl bx, 3
		add bx, [DigitXStart]
		mov [ScreenX], bx ; digit placement on screen = (TotalD - cx) * 8
		
		mov si, cx
		xor bh, bh
		mov bl, [Digits + si - 1]
		shl bx, 3 ; the offset in file is the number * 8
		mov [BMPISOff], bx
		
		; Show Digit
		call OpenShowBMP
		pop cx
		loop ShowDigit
	
	ret
endp show_numbers

; Screen Display on Launch
; Waits for Keyboard Input 'Q' or 'Enter'
; Output: DS:[OpeningExitCode] = 0 || 1
proc opening_screen
	
	mov dx, offset OpeningScr
	mov [ScreenX], 0
	mov [ScreenY], 0
	mov [ScreenColSize], 320
	mov [ScreenRowSize], 200
	mov [BMPWidth], 320
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	@@ReadKey:
		call CheckAndReadKey
		
		cmp al, 'q'
		jz @@PressedQ
		
		cmp al, 13
		jz @@PressedEnter
		
		jmp @@ReadKey
	
	@@PressedQ:
		mov [OpeningExitCode], 1
		jmp @@End
	
	@@PressedEnter:
		mov [OpeningExitCode], 0
	
	@@End:
		ret
endp opening_screen

; Screen Display before Game
proc show_loading_screen
	
	mov dx, offset LoadingScreen
	mov [ScreenX], 0
	mov [ScreenY], 0
	mov [ScreenColSize], 320
	mov [ScreenRowSize], 200
	mov [BMPWidth], 320
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	mov dx, offset Lives
	mov [ScreenX], 182
	mov [ScreenY], 128
	mov [ScreenColSize], 7
	mov [ScreenRowSize], 10
	mov [BMPWidth], 31
	mov bl, [PlayerLives]
	xor bh, bh
	shl bx, 3
	mov [BMPISOff], bx
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	push 30
	call Sleep
	
	ret
endp show_loading_screen

; Display Game Over Victory Screen
proc game_over_win
	
	mov dx, offset GameOverWin
	mov [ScreenX], 0
	mov [ScreenY], 0
	mov [ScreenColSize], 320
	mov [ScreenRowSize], 200
	mov [BMPWidth], 320
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	push 75
	call Sleep
	
	ret
endp game_over_win

; Display Game Over Lose Screen
proc game_over_lose
	
	mov dx, offset GameOverLose
	mov [ScreenX], 0
	mov [ScreenY], 0
	mov [ScreenColSize], 320
	mov [ScreenRowSize], 200
	mov [BMPWidth], 320
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	push 75
	call Sleep
	
	ret
endp game_over_lose

; Display Game Quit Screen
proc ExitScreen
	
	mov dx, offset Goodbye
	mov [ScreenX], 0
	mov [ScreenY], 0
	mov [ScreenColSize], 320
	mov [ScreenRowSize], 200
	mov [BMPWidth], 320
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	ret
endp ExitScreen

; Draws Rectangle on Screen
; Input: X, Y, Width, Height, Color
; Output: Rectangle on Screen
proc draw_rect

    push bp
    mov bp, sp

    x equ [bp+12]
    y equ [bp+10]
    w equ [bp+8]
    h equ [bp+6]
    color equ [bp+4]

    push ax
    push cx
    push di

    push x
    push y
    call coords_to_pix

    mov di, ax
    mov ax, color
    mov cx, h

	@@Y:
    push di
    push cx
    mov cx, w

	@@X:
    stosb
    loop @@X
    pop cx
    pop di
    add di, 320
    loop @@Y

    pop di
    pop cx
    pop ax

    pop bp
    ret 10
endp draw_rect

; Animate Mario Walking into the Castle
proc MarioCastleAni
	
	add [PlayerX], 8
	
	; Draw Mario's side switch
	mov dx, offset SmallMarioLeft
	mov ax, [PlayerX]
	mov [ScreenX], ax
	mov [ScreenY], 152
	mov [ScreenColSize], 12
	mov [ScreenRowSize], 16
	mov [BMPWidth], 223
	mov [BMPISOff], 114
	mov [BMPSOff], 0
	mov [HowMuchToSub], -1
	mov [ChromaKeyBool], 1
	call OpenShowBMP
	
	; Draw Mario jumping from pole
	inc [PlayerX]
	mov [PlayerY], 152
	mov cx, 12
	@@MarioJump1:
		push cx
		
		; Fix Background
		call DrawCastle

		; Draw Player
		mov dx, offset SmallMarioLeft
		mov ax, [PlayerX]
		mov [ScreenX], ax
		mov ax, [PlayerY]
		mov [ScreenY], ax
		mov [ScreenColSize], 16
		mov [ScreenRowSize], 16
		mov [BMPWidth], 223
		mov [BMPISOff], 129
		mov [BMPSOff], 0
		mov [HowMuchToSub], -1
		mov [ChromaKeyBool], 1
		call OpenShowBMP
		
		; Repeat
		@@Repeat1:
		call Sleep25ms
		inc [PlayerX]
		pop cx
		loop @@MarioJump1
	
	; Downwards
	mov cx, 16
	@@MarioJump2:
		push cx
		
		; Fix Background
		call DrawCastle

		; Draw Player
		mov dx, offset SmallMarioLeft
		mov ax, [PlayerX]
		mov [ScreenX], ax
		mov ax, [PlayerY]
		mov [ScreenY], ax
		mov [ScreenColSize], 16
		mov [ScreenRowSize], 16
		mov [BMPWidth], 223
		mov [BMPISOff], 129
		mov [BMPSOff], 0
		mov [HowMuchToSub], -1
		mov [ChromaKeyBool], 1
		call OpenShowBMP
		
		; Repeat
		call Sleep25ms
		inc [PlayerX]
		inc [PlayerY]
		pop cx
		loop @@MarioJump2
	
	; Draw Mario walking to castle
	mov [PlayerX], 197
	mov [PlayerY], 168
	
	mov cx, 67
	@@WalkingToCastle:
		push cx
		
		; Draw Castle
		call DrawCastle
		
		; Draw Player
		call PMovesRightAnimation
		
		; Repeat
		call Sleep25ms
		add [PRightForm], 10
		inc [PlayerX]
		pop cx
		loop @@WalkingToCastle
	
	; Close Castle
	call Sleep25ms
	call DrawCastle
	
	ret
endp MarioCastleAni

; Draw the Castle to Fix the Background
proc DrawCastle

	mov dx, offset Castle
    mov [ScreenX], 156
    mov [ScreenY], 104
    mov [ScreenColSize], 152
    mov [ScreenRowSize], 80
    mov [BMPWidth], 152
    mov [BMPISOff], 0
	mov [BMPSOff], 0
    mov [HowMuchToSub], 0
    mov [ChromaKeyBool], 0
    call OpenShowBMP

	; Fix Flag being Overwritten
	call FlagAniDraw

	ret
endp DrawCastle

; Animate Flag Going Down
proc FlagAniDraw
	
	; Fix Background Bug
	push 156
	push 39
	push 15
	push 2
	push Aqua
	call draw_rect

	; Draw Flag
	mov dx, offset VictoryFlag
	mov [ScreenX], 156
	mov ax, [FlagY]
	mov [ScreenY], ax
	mov [ScreenColSize], 16
	mov [ScreenRowSize], 17
	mov [BMPWidth], 16
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	ret
endp FlagAniDraw

; Fix Flag Pole
proc FlagPoleDraw
	
	mov dx, offset PoleTop
	mov [ScreenX], 164
	mov [ScreenY], 31
	mov [ScreenColSize], 12
	mov [ScreenRowSize], 8
	mov [BMPWidth], 12
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP

	cmp [PlayerY], 39
	jb @@Exit
	mov dx, offset FlagPole
	mov [ScreenX], 164
	mov ax, [PlayerY]
	sub ax, 4
	mov [ScreenY], ax
	mov [ScreenColSize], 13
	mov [ScreenRowSize], 22
	mov [BMPWidth], 12
	mov [BMPISOff], 0
	mov [BMPSOff], 0
	mov [HowMuchToSub], 0
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	@@Exit:
	ret
endp FlagPoleDraw

; Mario Pulling Down Flag Animation
proc MarioFlagAni
	
	; Fix Pole
	call FlagPoleDraw
	
	; Draw correct form for animation
	cmp [VictoryForm], 2
	jge @@Form2
	
	@@Form1:
		mov dx, offset SmallMarioRight
		mov ax, [PlayerX]
		mov [ScreenX], ax
		mov ax, [PlayerY]
		mov [ScreenY], ax
		mov [ScreenColSize], 12
		mov [ScreenRowSize], 16
		mov [BMPWidth], 223
		mov [BMPISOff], 97
		mov [BMPSOff], 0
		mov [HowMuchToSub], -1
		mov [ChromaKeyBool], 1
		call OpenShowBMP
		inc [VictoryForm]
		jmp @@End
	
	@@Form2:
		mov dx, offset SmallMarioRight
		mov ax, [PlayerX]
		mov [ScreenX], ax
		mov ax, [PlayerY]
		mov [ScreenY], ax
		mov [ScreenColSize], 12
		mov [ScreenRowSize], 16
		mov [BMPWidth], 223
		mov [BMPISOff], 112
		mov [BMPSOff], 0
		mov [HowMuchToSub], -1
		mov [ChromaKeyBool], 1
		call OpenShowBMP
		inc [VictoryForm]
		cmp [VictoryForm], 3
		jbe @@End
		mov [VictoryForm], 0
	
	@@End:
	ret
endp MarioFlagAni

; Mario Death Animation
proc DeathAniDraw
	
	; Fix background
	mov dx, offset World1
	mov ax, [PlayerX]
	mov [ScreenX], ax
	mov [ScreenY], 31
	mov [ScreenColSize], 14
	mov [ScreenRowSize], 169
	mov [BMPWidth], 3584
	mov ax, [PlayerXProgress]
	mov [BMPISOff], ax
	mov [BMPSOff], 0
	mov [HowMuchToSub], 2
	mov [ChromaKeyBool], 0
	call OpenShowBMP
	
	; Draw player
	mov dx, offset SmallMarioRight
	mov ax, [PlayerX]
	mov [ScreenX], ax
	mov ax, [PlayerY]
	mov [ScreenY], ax
	mov [ScreenColSize], 14
	mov [ScreenRowSize], 16
	mov [BMPWidth], 223
	mov [BMPISOff], 209
	mov [BMPSOff], 0
	mov [HowMuchToSub], 1
	mov [ChromaKeyBool], 1
	call OpenShowBMP
	
	ret
endp DeathAniDraw

; Mario Walking Right Animation
proc PMovesRightAnimation
	
	; Animation
	cmp [PRightForm], 20
	jb @@DrawForm0
	cmp [PRightForm], 40
	ja @@DrawForm2
	jmp @@DrawForm1

	@@DrawForm0:
		mov [BMPISOff], 0
		inc [PRightForm]
		jmp @@Finally

	@@DrawForm1:
		mov [BMPISOff], 15
		inc [PRightForm]
		jmp @@Finally

	@@DrawForm2:
		mov [BMPISOff], 30
		inc [PRightForm]
		cmp [PRightForm], 60
		jz @@Finally
		mov [PRightForm], 0

	@@Finally:
		mov dx, offset SmallMarioRight
		mov ax, [PlayerX]
		mov [ScreenX], ax
		mov ax, [PlayerY]
		mov [ScreenY], ax
		mov [ScreenColSize], 12
		mov [ScreenRowSize], 16
		mov [BMPWidth], 223
		mov [BMPSOff], 0
		mov [HowMuchToSub], -1
		mov [ChromaKeyBool], 1
		call OpenShowBMP
		
		ret
endp PMovesRightAnimation

; Mario Walking Right Animation
proc PMovesLeftAnimation
	
	; Animation
	cmp [PLeftForm], 20
	jb @@DrawForm0
	cmp [PLeftForm], 40
	ja @@DrawForm2
	jmp @@DrawForm1

	@@DrawForm0:
		mov [BMPISOff], 211
		inc [PLeftForm]
		jmp @@Finally

	@@DrawForm1:
		mov [BMPISOff], 196
		inc [PLeftForm]
		jmp @@Finally

	@@DrawForm2:
		mov [BMPISOff], 183
		inc [PLeftForm]
		cmp [PLeftForm], 60
		jz @@Finally
		mov [PLeftForm], 0

	@@Finally:
		mov dx, offset SmallMarioLeft
		mov ax, [PlayerX]
		mov [ScreenX], ax
		mov ax, [PlayerY]
		mov [ScreenY], ax
		mov [ScreenColSize], 12
		mov [ScreenRowSize], 16
		mov [BMPWidth], 223
		mov [BMPSOff], 0
		mov [HowMuchToSub], -1
		mov [ChromaKeyBool], 1
		call OpenShowBMP
		
		ret
endp PMovesLeftAnimation
;================================================
;==================GRAPHICS END==================
;================================================

;================================================
;=====================BITMAP=====================
;================================================
; Open a BMP file and Show it on Screen
; Handles the entire Process
proc OpenShowBMP near
	
	call OpenBMPFile
	call ReadBMPHeader
	call ReadBMPPalette
	call CopyBMPPalette
	call PositionBMP
	call ShowBMP
	call CloseBMPFile
	
	ret
endp OpenShowBMP

; Read a BMP File
proc OpenBMPFile near
	
	mov ah, 3Dh
	xor al, al
	int 21h
	mov [FileHandle], ax
	
	ret
endp OpenBMPFile

; Read a BMP File's Header
proc ReadBMPHeader near
	
	push cx
	push dx
	
	mov ah, 3Fh
	mov bx, [FileHandle]
	mov cx, 54
	mov dx, offset Header
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBMPHeader

; Read a BMP File's Palette
proc ReadBMPPalette near
	
	push cx
	push dx
	
	mov ah, 3Fh
	mov cx, 400h
	mov dx, offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBMPPalette

; Copy a BMP File's Palette
proc CopyBMPPalette near
	
	push cx
	push dx
	
	mov si, offset Palette
	mov cx, 256
	mov dx, 3C8h
	mov al, 0  ; black first
	out dx, al ; 3C8h
	inc dx     ; 3C9h
	
	CopyNextColor:
		mov al, [si+2] ; Red
		shr al, 2 	   ; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).
		out dx, al
		mov al, [si+1] ; Green.
		shr al, 2
		out dx, al
		mov al, [si]   ; Blue.
		shr al, 2
		out dx, al
		add si, 4 	   ; Point to next color.  (4 bytes for each color BGR + null)
		
		loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBMPPalette

; Show BMP File on Screen
proc ShowBMP
	
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx, [ScreenRowSize]
	
	mov ax, [ScreenColSize] ; row size must be dividable by 4 so if it less we must calculate the extra padding bytes 
	xor dx, dx
	mov si, 4
	div si
	cmp dx, 0
	mov bp, 0
	sub bp, dx
	jz @@row_ok
	mov bp, 4
	sub bp, dx
	
	@@row_ok:
		mov dx, [ScreenX]
	
	@@NextLine:
		push cx
		push dx
		
		mov di, cx ; Current Row at the small BMP (each time -1)
		add di, [ScreenY] ; add the Y on entire screen
		
		; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
		dec di
		mov cx, di
		shl cx, 6
		shl di, 8
		add di, cx
		add di, dx
	
		; small Read one line
		mov ah, 3fh
		mov cx, [ScreenColSize]
		add cx, bp  ; extra  bytes to each row must be divided by 4
		mov dx, offset ScrLine
		int 21h
		
		; Copy one line into video memory
		cld ; Clear direction flag, for movsb
		mov cx, [ScreenColSize]
		mov si, offset ScrLine
		
		@@DrawLine:
			cmp [ChromaKeyBool], 1
			jnz @@NotChromaKey
			
			cmp [byte ptr si], Pink
			jnz @@NotChromaKey
			
			inc si
			inc di
			jmp @@DontDraw
			
		@@NotChromaKey:
			movsb ; Copy line to the screen
			
		@@DontDraw:
			loop @@DrawLine
		
		mov ah, 42h
		mov al, 1
		mov bx, [FileHandle]
		xor cx, cx
		mov dx, [BMPWidth] ; For world loading, total_world_width-320+2
		sub dx, [ScreenColSize]
		sub dx, [HowMuchToSub]
		int 21h
		
		pop dx
		pop cx
		
		loop @@NextLine
	
	pop cx
		
	ret
endp ShowBMP

; Read from Position in BMP File
proc PositionBMP near
	
	mov ah, 42h
	mov al, 1
	mov bx, [FileHandle]
	mov dx, [BMPISOff]
	mov cx, [BMPSOff]
	int 21h
	
	ret
endp PositionBMP

; Close BMP File after Reading
proc CloseBMPFile near
	
	mov ah, 3Eh
	mov bx, [FileHandle]
	int 21h
	
	ret
endp CloseBMPFile
;================================================
;===================BITMAP END===================
;================================================

;================================================
;======================TIME======================
;================================================
; Sleep for a period of time
; Only Works for DosBox 50000/Max Cycles
; Input: how many 100ms, example: 5 = 500ms, 10 = 1s, 15 = 1.5s
proc Sleep
	
	push bp
	mov bp, sp
	
	SleepTime equ [word bp + 4]
	
	push cx
	
	mov cx, SleepTime
	
	Sleep100:
		call Sleep100ms
		loop Sleep100
	
	pop cx
	pop bp
	
	ret 2
endp Sleep

; Sleep 100ms - DosBox 50000/Max Cycles
proc Sleep100ms

	push cx
	
	mov cx, 4
	@@Sleep:
		call Sleep25ms
		loop @@Sleep
	
	pop cx
	
	ret
endp Sleep100ms

; Sleep 25ms - DosBox 50000/Max Cycles
proc Sleep25ms

	push cx
	
	mov cx, 1000
	
	@@Self1:
		push cx
		mov cx, 1250
		
	@@Self2:	
		loop @@Self2
		
		pop cx
		loop @@Self1
	
	pop cx
	
	ret
endp Sleep25ms

; Game Animations Momentum
; Momentum Type 1
proc MomentumSleep1

	push cx
	
	mov cx, 1000
	
	@@Self1:
		push cx
		mov cx, 30
		
	@@Self2:	
		loop @@Self2
		
		pop cx
		loop @@Self1
	
	pop cx
	
	ret
endp MomentumSleep1

; Game Animations Momentum
; Momentum Type 2
proc MomentumSleep2

	push cx
	
	mov cx, 1000
	
	@@Self1:
		push cx
		mov cx, 20
		
	@@Self2:	
		loop @@Self2
		
		pop cx
		loop @@Self1
	
	pop cx
	
	ret
endp MomentumSleep2

; Update Game Time
proc UpdateTime
	
	; If the current time in seconds is different from the last time, remove 1 seconds
	; This works only because it runs on high cycles and the code is not too long
	; Inefficient but unnecessary to complicate, as the countdown is unessential for the game
	; Therefore incredibly efficient for the game itself
	mov ah, 2Ch
	int 21h
	
	cmp dh, [LastTimeSeconds]
	jz SameTime
	
	TimeChanged:
		dec [Time]
		mov [LastTimeSeconds], dh
	
	SameTime:
		ret
endp UpdateTime
;================================================
;====================TIME END====================
;================================================

END start