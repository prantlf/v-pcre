module pcre

import prantlf.strutil { compare_str_within_nochk, str_len_nochk }

struct Name {
	name_start int
	name_end   int
	group_idx  int
}

[heap; noinit]
struct RegEx {
	re        &C.pcre
	extra     &C.pcre_extra
	name_buf  string
	name_data []Name
pub:
	captures int
	names    int
}

// C1   Affects compile only
// C2   Does not affect compile; affects exec
// C3   Affects compile, exec
// C4   Affects compile, exec, study
// C5   Affects exec; takes precedence over settings passed from pcre_compile
// C6   Affects replace

pub const opt_caseless = 0x00000001 /* C1 */
pub const opt_multiline = 0x00000002 /* C1 */
pub const opt_dotall = 0x00000004 /* C1 */
pub const opt_extended = 0x00000008 /* C1 */
pub const opt_anchored = 0x00000010 /* C4 C5 */
pub const opt_dollar_endonly = 0x00000020 /* C2 */
pub const opt_extra = 0x00000040 /* C1 */
pub const opt_notbol = 0x00000080 /* C5 */
pub const opt_noteol = 0x00000100 /* C5 */
pub const opt_ungreedy = 0x00000200 /* C1 */
pub const opt_notempty = 0x00000400 /* C5 */
pub const opt_utf8 = 0x00000800 /* C4 */
pub const opt_no_auto_capture = 0x00001000 /* C1 */
pub const opt_no_utf8_check = 0x00002000 /* C1 C5 */
pub const opt_auto_callout = 0x00004000 /* C1 */
pub const opt_partial_soft = 0x00008000 /* C5 */
pub const opt_never_utf = 0x00010000 /* C1 */
pub const opt_no_auto_possess = 0x00020000 /* C1 */
pub const opt_firstline = 0x00040000 /* C3 */
pub const opt_dupnames = 0x00080000 /* C1 */
pub const opt_newline_cr = 0x00100000 /* C3 C5 */
pub const opt_newline_lf = 0x00200000 /* C3 C5 */
pub const opt_newline_crlf = 0x00300000 /* C3 C5 */
pub const opt_newline_any = 0x00400000 /* C3 C5 */
pub const opt_newline_anycrlf = 0x00500000 /* C3 C5 */
pub const opt_bsr_anycrlf = 0x00800000 /* C3 C5 */
pub const opt_bsr_unicode = 0x01000000 /* C3 C5 */
pub const opt_javascript_compat = 0x02000000 /* C4 */
pub const opt_no_start_optimize = 0x04000000 /* C2 C5 */
pub const opt_partial_hard = 0x08000000 /* C5 */
pub const opt_notempty_atstart = 0x10000000 /* C5 */
pub const opt_ucp = 0x20000000 /* C3 */
pub const opt_replace_groups = 0x40000000 /* C6 */

[inline]
pub fn pcre_compile(source string, options int) !&RegEx {
	return compile(source, options)!
}

pub fn compile(source string, options int) !&RegEx {
	mut code := 0
	mut err := &u8(0)
	mut offset := 0
	re := C.pcre_compile2(source.str, options, &code, &err, &offset, 0)
	if isnil(re) {
		msg := unsafe { err.vstring() }
		return CompileError{
			msg: msg
			code: code
			offset: offset
		}
	}

	err = &char(0)
	extra := C.pcre_study(re, options, &err)
	if isnil(extra) {
		C.pcre_free(re)
		msg := if isnil(err) {
			'studying the regular expression failed'
		} else {
			unsafe { err.vstring() }
		}
		return CompileError{
			msg: msg
		}
	}

	captures := 0
	code = C.pcre_fullinfo(re, extra, C.PCRE_INFO_CAPTURECOUNT, &captures)
	if code != 0 {
		C.pcre_free_study(extra)
		C.pcre_free(re)
		msg := 'getting the count of captures failed'
		return CompileError{
			msg: msg
			code: code
		}
	}

	mut name_len := 0
	code = C.pcre_fullinfo(re, extra, C.PCRE_INFO_NAMECOUNT, &name_len)
	if code != 0 {
		C.pcre_free_study(extra)
		C.pcre_free(re)
		msg := 'getting the count of named captures failed'
		return CompileError{
			msg: msg
			code: code
		}
	}

	mut name_data := []Name{cap: name_len}
	mut name_buf := ''
	if name_len > 0 {
		mut name_table := &u8(0)
		code = C.pcre_fullinfo(re, extra, C.PCRE_INFO_NAMETABLE, &name_table)
		if code != 0 {
			C.pcre_free_study(extra)
			C.pcre_free(re)
			msg := 'getting the table of named captures failed'
			return CompileError{
				msg: msg
				code: code
			}
		}

		name_entry_size := 0
		code = C.pcre_fullinfo(re, extra, C.PCRE_INFO_NAMEENTRYSIZE, &name_entry_size)
		if code != 0 {
			C.pcre_free_study(extra)
			C.pcre_free(re)
			msg := 'getting size of an entry in the table of named captures failed'
			return CompileError{
				msg: msg
				code: code
			}
		}

		table_end := unsafe { name_table + (name_len * name_entry_size) }
		name_buf = unsafe { tos(name_table, table_end - name_table) }

		max_len := name_entry_size - 3
		mut table_entry := name_table
		for table_entry < table_end {
			idx := (u16(*table_entry) << 8) | unsafe { table_entry[1] }
			str := unsafe { table_entry + 2 }
			len := unsafe { str_len_nochk(str, max_len) }
			start := unsafe { str - name_table }
			name_data << Name{start, start + len, idx}
			unsafe {
				table_entry += name_entry_size
			}
		}
	}

	return &RegEx{re, extra, name_buf, name_data, captures, name_len}
}

pub fn (r &RegEx) free() {
	C.pcre_free_study(r.extra)
	C.pcre_free(r.re)
}

pub fn (r &RegEx) group_index_by_name(name string) int {
	for i, data in r.name_data {
		if unsafe { compare_str_within_nochk(name, r.name_buf, data.name_start, data.name_end) } == 0 {
			return i + 1
		}
	}
	return -1
}

pub fn (r &RegEx) group_name_by_index(idx int) string {
	data := &r.name_data[idx - 1]
	return unsafe { tos(r.name_buf.str + data.name_start, data.name_end - data.name_start) }
}
