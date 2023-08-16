module pcre

pub fn (r &RegEx) split(s string, opt int) ![]string {
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	mut parts := []string{}
	mut pos := 0
	mut last := 0
	stop := s.len
	for {
		code := C.pcre_exec(r.re, r.extra, s.str, stop, pos, opt, offsets.data, offsetcount)
		if code == C.PCRE_ERROR_NOMATCH {
			break
		} else if code <= 0 {
			return fail_exec(code)
		} else {
			pos = offsets[1]
			end := offsets[0]
			parts << s[last..end]
			last = pos
			if pos == stop {
				break
			}
		}
	}
	if last < stop {
		parts << s[last..stop]
	} else {
		parts << ''
	}
	return parts
}

pub fn (r &RegEx) split_first(s string, opt int) ![]string {
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	mut parts := []string{}
	stop := s.len
	code := C.pcre_exec(r.re, r.extra, s.str, stop, 0, opt, offsets.data, offsetcount)
	if code == C.PCRE_ERROR_NOMATCH {
		parts << s
	} else if code <= 0 {
		return fail_exec(code)
	} else {
		end := offsets[0]
		parts << s[0..end]
		pos := offsets[1]
		parts << s[pos..stop]
	}
	return parts
}

pub fn (r &RegEx) chop(s string, opt int) ![]string {
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	mut parts := []string{}
	mut pos := 0
	mut last := 0
	stop := s.len
	for {
		code := C.pcre_exec(r.re, r.extra, s.str, stop, pos, opt, offsets.data, offsetcount)
		if code == C.PCRE_ERROR_NOMATCH {
			break
		} else if code <= 0 {
			return fail_exec(code)
		} else {
			pos = offsets[1]
			end := offsets[0]
			parts << s[last..end]
			parts << s[end..pos]
			last = pos
			if pos == stop {
				break
			}
		}
	}
	if last < stop {
		parts << s[last..stop]
	} else {
		parts << ''
	}
	return parts
}

pub fn (r &RegEx) chop_first(s string, opt int) ![]string {
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	mut parts := []string{}
	stop := s.len
	code := C.pcre_exec(r.re, r.extra, s.str, stop, 0, opt, offsets.data, offsetcount)
	if code == C.PCRE_ERROR_NOMATCH {
		parts << s
	} else if code <= 0 {
		return fail_exec(code)
	} else {
		end := offsets[0]
		parts << s[0..end]
		pos := offsets[1]
		parts << s[end..pos]
		parts << s[pos..stop]
	}
	return parts
}
