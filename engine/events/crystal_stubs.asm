; Stubs for Crystal specials/functions whose real versions are mobile-only.

StubbedTrainerRankings_Healings:
StubbedTrainerRankings_PhoneCalls:
	ret

CheckMobileAdapterStatusSpecial:
; No mobile adapter on DMG: always report "not connected".
	xor a
	ld [wScriptVar], a
	ret

GiveOddEgg:
	farcall _GiveOddEgg
	ret

; Crystal home functions, kept out of ROM0 (only called from this section).
BuenaPrintText:
	push hl
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY
	lb bc, TEXTBOX_INNERH - 1, TEXTBOX_INNERW
	call ClearBox
	pop hl
	jp PrintTextboxText

IsAPokemon:
; Return carry if species a is not a Pokemon.
	and a
	jr z, .NotAPokemon
	cp EGG
	jr z, .Pokemon
	cp NUM_POKEMON + 1
	jr c, .Pokemon
.NotAPokemon:
	scf
	ret
.Pokemon:
	and a
	ret
