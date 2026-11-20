_GiveOddEgg:
	; Figure out which egg to give.

	; Compare a random word to probabilities out of $ffff.
	call Random
	ld hl, OddEggProbabilities
	ld c, 0
	ld b, c
.loop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

	; Break on $ffff.
	ld a, d
	cp HIGH($ffff)
	jr nz, .not_done
	ld a, e
	cp LOW($ffff)
	jr z, .done
.not_done

	; Break when the random word <= the next probability in de.
	ldh a, [hRandomSub]
	cp d
	jr c, .done
	jr z, .ok
	jr .next
.ok
	ldh a, [hRandomAdd]
	cp e
	jr c, .done
	jr z, .done
.next
	inc bc
	jr .loop
.done

	ld hl, OddEggs
	ld a, NICKNAMED_MON_STRUCT_LENGTH
	call AddNTimes
	push hl ; chosen egg (struct, then nickname)

	ld a, EGG_TICKET
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantityChange], a
	ld a, -1
	ld [wCurItemQuantity], a
	ld hl, wNumItems
	call TossItem

; Gold port: copy the egg straight into the party (Crystal used mobile code here).
	ld hl, wPartyCount
	ld a, [hl]
	ld e, a ; index of the new mon
	inc [hl]
	ld c, a
	ld b, 0
	inc hl
	add hl, bc
	ld a, EGG
	ld [hli], a
	ld [hl], -1

	ld a, e
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	push de
	call AddNTimes
	ld d, h
	ld e, l
	pop bc ; c = index
	pop hl
	push bc
	push hl
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	pop hl
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc ; nickname
	pop bc
	push bc
	push hl
	ld a, c
	ld hl, wPartyMonNicknames
	ld bc, MON_NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	pop bc
	ld a, c
	ld hl, wPartyMonOTs
	ld bc, NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, .Odd
	ld bc, NAME_LENGTH
	jp CopyBytes

.Odd:
	dname "ODD", NAME_LENGTH

INCLUDE "data/events/odd_eggs.asm"
