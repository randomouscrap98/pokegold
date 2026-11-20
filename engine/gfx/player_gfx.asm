; Crystal female player support: pick Chris's or Kris's graphics.

GetPlayerFrontpic::
; Load the player's front pic (7x7) to de and set wTrainerClass for its palette.
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr nz, .kris
	ld a, CAL
	ld [wTrainerClass], a
	farcall GetTrainerPic
	ret

.kris
	ld a, KRIS
	ld [wTrainerClass], a
	push de
	call WaitBGMap
	xor a
	ldh [hBGMapMode], a
	pop de
	ld hl, KrisPic
	ld b, BANK(KrisPic)
	ld c, 7 * 7
	predef DecompressGet2bpp
	call WaitBGMap
	ld a, 1
	ldh [hBGMapMode], a
	ret

GetPlayerIcon:: ; Crystal name
GetPlayerSpriteGFX::
; Return the player's overworld sprite gfx in b:de.
	ld de, ChrisSpriteGFX
	ld b, BANK(ChrisSpriteGFX)
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	ret z
	ld de, KrisSpriteGFX
	ld b, BANK(KrisSpriteGFX)
	ret

GetPlayerBackpicPointer::
; Return the player's lz-compressed backpic in b:hl.
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr nz, .kris
	ld hl, ChrisBackpic
	ld b, BANK(ChrisBackpic)
	ret

.kris
	ld hl, KrisBackpic
	ld b, BANK(KrisBackpic)
	ret
