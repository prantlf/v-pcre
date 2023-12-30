module pcre

pub const char_space = 0x01
pub const char_letter = 0x02
pub const char_digit = 0x04
pub const char_xdigit = 0x08
pub const char_word = 0x10
pub const char_meta = 0x80

pub enum UnicodeGeneral {
	other
	letter
	mark
	number
	punctuation
	symbol
	separator
}

pub enum UnicodeParticular {
	control
	format
	unassigned
	private_use
	surrogate
	lowercase_letter
	modifier_letter
	other_letter
	titlecase_letter
	uppercase_letter
	spacing_mark
	enclosing_mark
	nonspacing_mark
	decimal_number
	letter_number
	other_number
	connector_punctuation
	dash_punctuation
	close_punctuation
	final_punctuation
	initial_punctuation
	other_punctuation
	open_punctuation
	currency_symbol
	modifier_symbol
	mathematical_symbol
	other_symbol
	line_separator
	paragraph_separator
	space_separator
}

@[inline]
pub fn pcre_chartype(ch u8) int {
	return C.pcre_ctype(ch)
}

@[inline]
pub fn pcre_isalnum(ch u8) bool {
	return C.pcre_ctype(ch) & (pcre.char_letter | pcre.char_digit) != 0
}

@[inline]
pub fn pcre_isalpha(ch u8) bool {
	return C.pcre_ctype(ch) & pcre.char_letter != 0
}

@[inline]
pub fn pcre_isdigit(ch u8) bool {
	return C.pcre_ctype(ch) & pcre.char_digit != 0
}

@[inline]
pub fn pcre_isxdigit(ch u8) bool {
	return C.pcre_ctype(ch) & pcre.char_xdigit != 0
}

@[inline]
pub fn pcre_isword(ch u8) bool {
	return ch == `_` || pcre_isalnum(ch)
}

@[inline]
pub fn pcre_isspace(ch u8) bool {
	return C.pcre_ctype(ch) & pcre.char_space != 0
}

@[inline]
pub fn pcre_unicode_gentype(r rune) UnicodeGeneral {
	return unsafe { UnicodeGeneral(C.pcre_gentype(r)) }
}

@[inline]
pub fn pcre_unicode_partype(r rune) UnicodeParticular {
	return unsafe { UnicodeParticular(C.pcre_chartype(r)) }
}

@[inline]
pub fn pcre_unicode_isalnum(r rune) bool {
	typ := unsafe { UnicodeGeneral(C.pcre_gentype(r)) }
	return typ == .letter || typ == .number
}

@[inline]
pub fn pcre_unicode_isalpha(r rune) bool {
	return C.pcre_gentype(r) == int(UnicodeGeneral.letter)
}

@[inline]
pub fn pcre_unicode_islower(r rune) bool {
	return C.pcre_chartype(r) == int(UnicodeParticular.lowercase_letter)
}

@[inline]
pub fn pcre_unicode_isupper(r rune) bool {
	return C.pcre_chartype(r) == int(UnicodeParticular.uppercase_letter)
}

@[inline]
pub fn pcre_unicode_isdigit(r rune) bool {
	return C.pcre_gentype(r) == int(UnicodeGeneral.number)
}

@[inline]
pub fn pcre_unicode_iscntrl(r rune) bool {
	return C.pcre_chartype(r) == int(UnicodeParticular.control)
}

@[inline]
pub fn pcre_unicode_isword(r rune) bool {
	return r == `_` || pcre_unicode_isalnum(r)
}

@[inline]
pub fn pcre_unicode_isspace(r rune) bool {
	return C.pcre_gentype(r) == int(UnicodeGeneral.separator)
}

@[inline]
pub fn pcre_unicode_isblank(r rune) bool {
	return C.pcre_chartype(r) == int(UnicodeParticular.space_separator)
}

@[inline]
pub fn pcre_unicode_ispunct(r rune) bool {
	return C.pcre_gentype(r) == int(UnicodeGeneral.punctuation)
}
