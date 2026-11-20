HoOhChamber:
	ld hl, wPartySpecies
	ld a, [hl]
	cp HO_OH ; is Ho-oh the first Pokémon in the party?
	jr nz, .done ; if not, we're done
	call GetMapAttributesPointer ; pointless?
	ld de, EVENT_WALL_OPENED_IN_HO_OH_CHAMBER
	ld b, SET_FLAG
	call EventFlagAction
.done
	ret

OmanyteChamber:
	call GetMapAttributesPointer ; pointless?
	ld de, EVENT_WALL_OPENED_IN_OMANYTE_CHAMBER
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	jr nz, .nope

	ld a, WATER_STONE
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	jr c, .open

	ld a, [wPartyCount]
	ld b, a
	inc b
.loop
	dec b
	jr z, .nope
	ld a, b
	dec a
	ld [wCurPartyMon], a
	push bc
	ld a, MON_ITEM
	call GetPartyParamLocation
	pop bc
	ld a, [hl]
	cp WATER_STONE
	jr nz, .loop

.open
	call GetMapAttributesPointer ; pointless?
	ld de, EVENT_WALL_OPENED_IN_OMANYTE_CHAMBER
	ld b, SET_FLAG
	call EventFlagAction

.nope
	ret

SpecialAerodactylChamber:
	push de
	push bc

	call GetMapAttributesPointer
	ld a, h
	cp HIGH(RuinsOfAlphAerodactylChamber_MapAttributes)
	jr nz, .nope
	ld a, l
	cp LOW(RuinsOfAlphAerodactylChamber_MapAttributes)
	jr nz, .nope

	ld de, EVENT_WALL_OPENED_IN_AERODACTYL_CHAMBER
	ld b, SET_FLAG
	call EventFlagAction

	scf
	jr .done

.nope
	and a

.done
	pop bc
	pop de
	ret

SpecialKabutoChamber:
	push hl
	push de

	call GetMapAttributesPointer
	ld a, h
	cp HIGH(RuinsOfAlphKabutoChamber_MapAttributes)
	jr nz, .done
	ld a, l
	cp LOW(RuinsOfAlphKabutoChamber_MapAttributes)
	jr nz, .done

	ld de, EVENT_WALL_OPENED_IN_KABUTO_CHAMBER
	ld b, SET_FLAG
	call EventFlagAction

.done
	pop de
	pop hl
	ret

DisplayUnownWords:
	ld a, [wScriptVar]
	ld hl, MenuHeaders_UnownWalls
	and a
	jr z, .load

	ld d, 0
	ld e, UNOWN_WALL_MENU_HEADER_SIZE
.loop
	add hl, de
	dec a
	jr nz, .loop

.load
	call LoadMenuHeader
	xor a
	ldh [hBGMapMode], a
	call MenuBox
	call UpdateSprites
	call ApplyTilemap
	call MenuBoxCoord2Tile
	inc hl
	ld d, 0
	ld e, SCREEN_WIDTH
	add hl, de
	add hl, de
	ld a, [wScriptVar]
	ld c, a
	ld de, UnownWalls
	and a
	jr z, .copy
.loop2
	ld a, [de]
	inc de
	cp -1
	jr nz, .loop2
	dec c
	jr nz, .loop2
.copy
	call _DisplayUnownWords_LoadLetters ; DMG: Crystal used the word room tileset's glyphs
	call _DisplayUnownWords_CopyWord
	call WaitBGMap2
	call JoyWaitAorB
	call PlayClickSFX
	call CloseWindow
	ret

; DMG version: the words are stored in the normal charmap, and each letter is drawn
; as one 8x8 Unown glyph (the Pokédex Unown font) loaded into vTiles2 $60+.
DEF UNOWN_WALL_FIRST_TILE EQU $60

INCLUDE "data/events/unown_walls.asm"

_DisplayUnownWords_LoadLetters:
; de = word. Load each letter's glyph into UNOWN_WALL_FIRST_TILE + its position.
	push hl
	push de
	ld hl, vTiles2 tile UNOWN_WALL_FIRST_TILE
.loop
	ld a, [de]
	cp '@'
	jr z, .done
	push de
	push hl
	cp '-'
	ld a, NUM_UNOWN ; the dash follows Z
	jr z, .got_index
	ld a, [de]
	sub 'A'
.got_index
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, UnownFont
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push hl
	lb bc, BANK(UnownFont), 1
	call Get2bpp
	pop hl
	ld bc, 1 tiles
	add hl, bc
	pop de
	inc de
	jr .loop
.done
	pop de
	pop hl
	ret

_DisplayUnownWords_CopyWord:
; Place one glyph per 2x2 letter square (top-left tile), as in Crystal's layout.
	push hl
	push de
	ld b, UNOWN_WALL_FIRST_TILE
.word_loop
	ld a, [de]
	cp '@'
	jr z, .word_done
	ld [hl], b
	inc b
	inc hl
	inc hl
	inc de
	jr .word_loop
.word_done
	pop de
	pop hl
	ret
