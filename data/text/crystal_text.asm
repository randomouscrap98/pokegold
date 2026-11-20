; Crystal-only text (Buena, Poké Seer, radio)

_BuenaAskWhichPrizeText::
	text "Which prize would"
	line "you like?"
	done

_BuenaComeAgainText::
	text "Oh. Please come"
	line "back again!"
	done

_BuenaHereYouGoText::
	text "Here you go!"

	para ""
	done

_BuenaIsThatRightText::
	text_ram wStringBuffer1
	text "?"
	line "Is that right?"
	done

_BuenaNoRoomText::
	text "You have no room"
	line "for it."

	para ""
	done

_BuenaNotEnoughPointsText::
	text "You don't have"
	line "enough points."

	para ""
	done

_BuenaOffTheAirText::
	text_start
	line ""
	done

_BuenaRadioMidnightText1::
	text_start
	line "BUENA: Oh my…"
	done

_BuenaRadioMidnightText10::
	text "…"
	done

_BuenaRadioMidnightText2::
	text_start
	line "It's midnight! I"
	done

_BuenaRadioMidnightText3::
	text_start
	line "have to shut down!"
	done

_BuenaRadioMidnightText4::
	text_start
	line "Thanks for tuning"
	done

_BuenaRadioMidnightText5::
	text_start
	line "in to the end! But"
	done

_BuenaRadioMidnightText6::
	text_start
	line "don't stay up too"
	done

_BuenaRadioMidnightText7::
	text_start
	line "late! Presented to"
	done

_BuenaRadioMidnightText8::
	text_start
	line "you by DJ BUENA!"
	done

_BuenaRadioMidnightText9::
	text "I'm outta here!"
	done

_BuenaRadioText1::
	text_start
	line "BUENA: BUENA here!"
	done

_BuenaRadioText2::
	text_start
	line "Today's password!"
	done

_BuenaRadioText3::
	text_start
	line "Let me think… It's"
	done

_BuenaRadioText4::
	text_start
	line "@"
	text_ram wStringBuffer1
	text "!"
	done

_BuenaRadioText5::
	text_start
	line "Don't forget it!"
	done

_BuenaRadioText6::
	text_start
	line "I'm in GOLDENROD's"
	done

_BuenaRadioText7::
	text_start
	line "RADIO TOWER!"
	done

_OPT_GroovyText::
	text_start
	line "groovy!"
	done

_SeerCantTellAThingText::
	text "Whaaaat? I can't"
	line "tell a thing!"

	para "How could I not"
	line "know of this?"
	done

_SeerDoNothingText::
	text "Fufufu! I saw that"
	line "you'd do nothing!"
	done

_SeerEggText::
	text "Hey!"

	para "That's an EGG!"

	para "You can't say that"
	line "you've met it yet…"
	done

_SeerImpressedText::
	text "Incidentally…"

	para "I'm impressed by"
	line "your dedication."

	para "It's been a long"
	line "time since I've"

	para "seen a #MON as"
	line "mighty as this"
	cont "@"
	text_ram wSeerNickname
	text "."

	para "I'm sure that"
	line "seeing @"
	text_ram wSeerNickname
	text_start

	para "in battle would"
	line "excite anyone."
	done

_SeerMightyText::
	text "Incidentally…"

	para "It certainly has"
	line "grown mighty!"

	para "This @"
	text_ram wSeerNickname
	text_start
	line "must have come"

	para "through numerous"
	line "#MON battles."

	para "It looks brimming"
	line "with confidence."
	done

_SeerMoreCareText::
	text "Incidentally…"

	para "It would be wise"
	line "to raise your"

	para "#MON with a"
	line "little more care."
	done

_SeerMoreConfidentText::
	text "Incidentally…"

	para "It seems to have"
	line "grown a little."

	para "@"
	text_ram wSeerNickname
	text " seems"
	line "to be becoming"
	cont "more confident."
	done

_SeerMuchStrengthText::
	text "Incidentally…"

	para "@"
	text_ram wSeerNickname
	text " has"
	line "grown. It's gained"
	cont "much strength."
	done

_SeerNameLocationText::
	text "Hm… I see you met"
	line "@"
	text_ram wSeerNickname
	text " here:"
	cont "@"
	text_ram wSeerCaughtLocation
	text "!"
	prompt

_SeerNoLocationText::
	text "What!? Incredible!"

	para "I don't understand"
	line "how, but it is"

	para "incredible!"
	line "You are special."

	para "I can't tell where"
	line "you met it, but it"
	cont "was at level @"
	text_ram wSeerCaughtLevelString
	text "."

	para "Am I good or what?"
	prompt

_SeerSeeAllText::
	text "I see all."
	line "I know all…"

	para "Certainly, I know"
	line "of your #MON!"
	done

_SeerTimeLevelText::
	text "The time was"
	line "@"
	text_ram wSeerTimeOfDay
	text "!"

	para "Its level was @"
	text_ram wSeerCaughtLevelString
	text "!"

	para "Am I good or what?"
	prompt

_SeerTradeText::
	text "Hm… @"
	text_ram wSeerNickname
	text_start
	line "came from @"
	text_ram wSeerOT
	text_start
	cont "in a trade?"

	para "@"
	text_ram wSeerCaughtLocation
	text_start
	line "was where @"
	text_ram wSeerOT
	text_start
	cont "met @"
	text_ram wSeerNickname
	text "!"
	prompt
