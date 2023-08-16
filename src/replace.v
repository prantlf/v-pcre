module pcre

import strings { Builder, new_builder }

pub const opt_replace_groups = 0x40000000 /* C6 */

pub fn (r &RegEx) replace(s string, with string, opt int) !string {
	repl_grps := opt & pcre.opt_replace_groups != 0
	exec_opt := opt & ~pcre.opt_replace_groups
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	mut builder := unsafe { &Builder(nil) }
	mut pos := 0
	mut last := 0
	stop := s.len
	for {
		code := C.pcre_exec(r.re, r.extra, s.str, stop, pos, exec_opt, offsets.data, offsetcount)
		if code == C.PCRE_ERROR_NOMATCH {
			if pos == 0 {
				return NoMatch{}
			}
			break
		} else if code <= 0 {
			return fail_exec(code)
		} else {
			if isnil(builder) {
				mut b := new_builder(s.len + with.len)
				builder = &b
			}
			unsafe { builder.write_ptr(s.str + last, offsets[0] - last) }
			if repl_grps {
				replace_with(mut builder, s, with, offsets)
			} else {
				builder.write_string(with)
			}
			pos = offsets[1]
			last = pos
			if pos == stop {
				break
			}
		}
	}
	if last < stop {
		unsafe { builder.write_ptr(s.str + last, stop - last) }
	}
	return builder.str()
}

pub fn (r &RegEx) replace_first(s string, with string, opt int) !string {
	repl_grps := opt & pcre.opt_replace_groups != 0
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	stop := s.len
	code := C.pcre_exec(r.re, r.extra, s.str, stop, 0, opt, offsets.data, offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		NoMatch{}
	} else if code <= 0 {
		fail_exec(code)
	} else {
		mut builder := new_builder(s.len + with.len)
		unsafe { builder.write_ptr(s.str, offsets[0]) }
		if repl_grps {
			replace_with(mut builder, s, with, offsets)
		} else {
			builder.write_string(with)
		}
		pos := offsets[1]
		len := stop - pos
		if len > 0 {
			unsafe { builder.write_ptr(s.str + pos, len) }
		}
		builder.str()
	}
}

[direct_array_access]
fn replace_with(mut builder Builder, s string, with string, offsets []int) {
	mut from := with.index_u8(`$`)
	if from < 0 {
		builder.write_string(with)
		return
	}

	mut prev := if from > 0 {
		if with[from - 1] != `\\` {
			unsafe { builder.write_ptr(with.str, from) }
			`\0`
		} else {
			if from - 1 > 0 {
				unsafe { builder.write_ptr(with.str, from - 1) }
			}
			`\\`
		}
	} else {
		`\0`
	}

	offsetcount := offsets.len / 3
	for from < with.len {
		cur := with[from]
		if prev == `\\` {
			builder.write_u8(cur)
			from++
			prev = `\0`
		} else if cur == `$` && prev != `\\` {
			if from + 1 < with.len {
				digit := with[from + 1]
				if digit >= `0` && digit <= `9` {
					idx := digit - `0`
					if idx < offsetcount {
						unsafe {
							start := offsets[idx * 2]
							stop := offsets[idx * 2 + 1]
							builder.write_ptr(s.str + start, stop - start)
						}
					}
				} else {
					builder.write_u8(`$`)
					builder.write_u8(digit)
				}
				from += 2
				prev = `\0`
			} else {
				break
			}
		} else if cur == `\\` {
			from++
			prev = cur
		} else {
			builder.write_u8(cur)
			from++
			prev = cur
		}
	}

	if from < with.len {
		unsafe { builder.write_ptr(with.str + from, with.len - from) }
	}
}
