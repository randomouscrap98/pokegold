; Crystal's map name sign, reworked for DMG.
; Crystal draws the name with the overworld font in vTiles1, which gold's DMG
; layout uses for NPC sprites. Instead, the frame takes vTiles2 $60-$6D and the
; name's unique letters are copied into $6E-$7F (font extra/frame tiles that
; OpenText reloads anyway). The sign is copied to the window tilemap with
; STAT-safe writes (Crystal used HDMA).

DEF MAP_NAME_SIGN_START   EQU $60
DEF MAP_NAME_SIGN_LETTERS EQU MAP_NAME_SIGN_START + 14
DEF MAP_NAME_SIGN_MAX_LETTERS EQU $80 - MAP_NAME_SIGN_LETTERS

InitMapNameSign::
	xor a
	ldh [hBGMapMode], a
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetWorldMapLocation
	ld [wCurLandmark], a
	call .CheckNationalParkGate
	jr z, .gate

	call GetMapEnvironment
	cp GATE
	jr nz, .not_gate

.gate
	ld a, -1
	ld [wCurLandmark], a

.not_gate
	ld hl, wMapNameSignFlags
	bit SHOWN_MAP_NAME_SIGN, [hl]
	res SHOWN_MAP_NAME_SIGN, [hl]
	jr nz, .dont_do_map_sign

	call .CheckMovingWithinLandmark
	jr z, .dont_do_map_sign
	ld a, [wCurLandmark]
	ld [wPrevLandmark], a

	call .CheckSpecialMap
	jr z, .dont_do_map_sign

; Display for 60 frames
	ld a, 60
	ld [wLandmarkSignTimer], a
	call LoadMapNameSignGFX
	ret

.dont_do_map_sign
	ld a, [wCurLandmark]
	ld [wPrevLandmark], a
	xor a
	ld [wLandmarkSignTimer], a
	ld a, $90
	ldh [rWY], a
	ldh [hWY], a
	ret

.CheckMovingWithinLandmark:
	ld a, [wCurLandmark]
	ld c, a
	ld a, [wPrevLandmark]
	cp c
	ret z
	cp LANDMARK_SPECIAL
	ret

.CheckSpecialMap:
; These landmarks do not get pop-up signs.
	cp -1
	ret z
	cp LANDMARK_SPECIAL ; redundant check
	ret z
	cp LANDMARK_RADIO_TOWER
	ret z
	cp LANDMARK_LAV_RADIO_TOWER
	ret z
	cp LANDMARK_UNDERGROUND_PATH
	ret z
	cp LANDMARK_INDIGO_PLATEAU
	ret z
	cp LANDMARK_POWER_PLANT
	ret z
	ld a, 1
	and a
	ret

.CheckNationalParkGate:
	ld a, [wMapGroup]
	cp GROUP_ROUTE_35_NATIONAL_PARK_GATE
	ret nz
	ld a, [wMapNumber]
	cp MAP_ROUTE_35_NATIONAL_PARK_GATE
	ret z
	cp MAP_ROUTE_36_NATIONAL_PARK_GATE
	ret

PlaceMapNameSign::
	ld hl, wLandmarkSignTimer
	ld a, [hl]
	and a
	jr z, .disappear
	dec [hl]
	cp 60
	ret z
	cp 59
	jr nz, .already_initialized
	call DrawMapNameSign
.already_initialized
	ld a, $70
	ldh [rWY], a
	ldh [hWY], a
	ret

.disappear
	ldh a, [hWY]
	cp $70
	ret nz ; don't touch the window if something else uses it
	ld a, $90
	ldh [rWY], a
	ldh [hWY], a
	ret

LoadMapNameSignGFX:
	ld de, MapEntryFrameGFX
	ld hl, vTiles2 tile MAP_NAME_SIGN_START
	lb bc, BANK(MapEntryFrameGFX), 14
	call Get2bpp
; Copy each unique letter of the landmark name into the letter tiles.
	ld a, [wCurLandmark]
	ld e, a
	farcall GetLandmarkName
	ld hl, wMapNameSignLetters
	ld bc, MAP_NAME_SIGN_MAX_LETTERS
	xor a
	call ByteFill
	ld hl, wStringBuffer1
.loop
	ld a, [hli]
	cp '@'
	ret z
	cp $80
	jr c, .loop ; space and control characters use the frame's blank tile
	push hl
	call .FindOrAddLetter
	pop hl
	jr .loop

.FindOrAddLetter:
; Return if letter a is already loaded; otherwise load it into the next slot.
	ld c, a
	ld hl, wMapNameSignLetters
	ld b, 0
.find
	ld a, [hli]
	and a
	jr z, .add
	cp c
	ret z
	inc b
	ld a, b
	cp MAP_NAME_SIGN_MAX_LETTERS
	ret nc ; out of slots
	jr .find
.add
	dec hl
	ld [hl], c
; de = Font + (c - $80) tiles
	ld a, c
	sub $80
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, Font
	add hl, de
	ld d, h
	ld e, l
; hl = vTiles2 tile (MAP_NAME_SIGN_LETTERS + b)
	ld a, b
	add MAP_NAME_SIGN_LETTERS
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, vTiles2
	add hl, bc
	lb bc, BANK(Font), 1
	call Get1bpp
	ret

DrawMapNameSign:
; Build the 4 sign rows in wTilemap and copy them to the window tilemap.
	call PlaceMapNameFrame
	call PlaceMapNameCenterAlign
	hlcoord 0, 0
	ld de, vTilemap1
	ld b, 4
.row
	ld c, SCREEN_WIDTH
.col
.wait
	ldh a, [rSTAT]
	and STAT_BUSY
	jr nz, .wait
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .col
	ld a, e
	add TILEMAP_WIDTH - SCREEN_WIDTH
	ld e, a
	ld a, d
	adc 0
	ld d, a
	dec b
	jr nz, .row
	ret

PlaceMapNameCenterAlign:
	ld a, [wCurLandmark]
	ld e, a
	farcall GetLandmarkName
	call .GetNameLength
	ld a, SCREEN_WIDTH
	sub c
	srl a
	ld b, 0
	ld c, a
	hlcoord 0, 2
	add hl, bc
	ld de, wStringBuffer1
.place
	ld a, [de]
	inc de
	cp '@'
	ret z
	cp $80 ; spaces and <BSP> (a line break on the town map) become blanks
	jr c, .blank
	push hl
	ld c, a
	ld hl, wMapNameSignLetters
	ld b, MAP_NAME_SIGN_LETTERS
.find
	ld a, [hli]
	and a
	jr z, .notfound
	cp c
	jr z, .found
	inc b
	jr .find
.notfound
	ld b, MAP_NAME_SIGN_START + 13
.found
	pop hl
	ld [hl], b
	inc hl
	jr .place
.blank
	ld [hl], MAP_NAME_SIGN_START + 13
	inc hl
	jr .place

.GetNameLength:
	ld c, 0
	push hl
	ld hl, wStringBuffer1
.loop
	ld a, [hli]
	cp '@'
	jr z, .stop
	inc c
	jr .loop
.stop
	pop hl
	ret

PlaceMapNameFrame:
	hlcoord 0, 0
	; top left
	ld a, MAP_NAME_SIGN_START + 1
	ld [hli], a
	; top row
	ld a, MAP_NAME_SIGN_START + 2
	call .FillTopBottom
	; top right
	ld a, MAP_NAME_SIGN_START + 4
	ld [hli], a
	; left, first line
	ld a, MAP_NAME_SIGN_START + 5
	ld [hli], a
	; first line
	call .FillMiddle
	; right, first line
	ld a, MAP_NAME_SIGN_START + 11
	ld [hli], a
	; left, second line
	ld a, MAP_NAME_SIGN_START + 6
	ld [hli], a
	; second line
	call .FillMiddle
	; right, second line
	ld a, MAP_NAME_SIGN_START + 12
	ld [hli], a
	; bottom left
	ld a, MAP_NAME_SIGN_START + 7
	ld [hli], a
	; bottom
	ld a, MAP_NAME_SIGN_START + 8
	call .FillTopBottom
	; bottom right
	ld a, MAP_NAME_SIGN_START + 10
	ld [hl], a
	ret

.FillMiddle:
	ld c, SCREEN_WIDTH - 2
	ld a, MAP_NAME_SIGN_START + 13
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

.FillTopBottom:
	ld c, (SCREEN_WIDTH - 2) / 4 + 1
	jr .enterloop

.continueloop
	ld [hli], a
	ld [hli], a

.enterloop
	inc a
	ld [hli], a
	ld [hli], a
	dec a
	dec c
	jr nz, .continueloop
	ret

MapEntryFrameGFX:
INCBIN "gfx/frames/map_entry_sign.2bpp"
