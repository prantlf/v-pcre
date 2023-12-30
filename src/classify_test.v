module pcre

fn test_chartype_space() {
	assert pcre_chartype(` `) & char_space != 0
	assert pcre_chartype(`\r`) & char_space != 0
	assert pcre_chartype(`\n`) & char_space != 0
	assert pcre_chartype(`.`) & char_space == 0
	assert pcre_chartype(`a`) & char_space == 0
}

fn test_chartype_letter() {
	assert pcre_chartype(`a`) & char_letter != 0
	assert pcre_chartype(` `) & char_letter == 0
	assert pcre_chartype(`.`) & char_letter == 0
	assert pcre_chartype(`1`) & char_letter == 0
}

fn test_chartype_digit() {
	assert pcre_chartype(`1`) & char_digit != 0
	assert pcre_chartype(` `) & char_digit == 0
	assert pcre_chartype(`.`) & char_digit == 0
	assert pcre_chartype(`a`) & char_digit == 0
}

fn test_chartype_xdigit() {
	assert pcre_chartype(`1`) & char_xdigit != 0
	assert pcre_chartype(`f`) & char_xdigit != 0
	assert pcre_chartype(` `) & char_xdigit == 0
	assert pcre_chartype(`.`) & char_xdigit == 0
	assert pcre_chartype(`g`) & char_xdigit == 0
}

fn test_chartype_word() {
	assert pcre_chartype(`1`) & char_word != 0
	assert pcre_chartype(`a`) & char_word != 0
	assert pcre_chartype(`_`) & char_word != 0
	assert pcre_chartype(` `) & char_word == 0
	assert pcre_chartype(`.`) & char_word == 0
}

fn test_chartype_meta() {
	assert pcre_chartype(`\0`) & char_meta != 0
	assert pcre_chartype(`.`) & char_meta != 0
	assert pcre_chartype(` `) & char_meta == 0
	assert pcre_chartype(`1`) & char_meta == 0
	assert pcre_chartype(`a`) & char_meta == 0
}

fn test_gentype_other() {
	assert pcre_unicode_gentype(`\r`) == .other
	assert pcre_unicode_gentype(`\n`) == .other
}

fn test_gentype_letter() {
	assert pcre_unicode_gentype(`a`) == .letter
	assert pcre_unicode_gentype(`Z`) == .letter
}

fn test_gentype_number() {
	assert pcre_unicode_gentype(`0`) == .number
	assert pcre_unicode_gentype(`9`) == .number
}

fn test_gentype_punctuation() {
	assert pcre_unicode_gentype(`.`) == .punctuation
	assert pcre_unicode_gentype(`?`) == .punctuation
	assert pcre_unicode_gentype(`!`) == .punctuation
}

fn test_gentype_symbol() {
	assert pcre_unicode_gentype(`+`) == .symbol
	assert pcre_unicode_gentype(`~`) == .symbol
}

fn test_gentype_space() {
	assert pcre_unicode_gentype(` `) == .separator
}
