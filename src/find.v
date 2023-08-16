module pcre

import prantlf.strutil { check_bounds_incl }

[inline]
pub fn (r &RegEx) matches(s string, opt int) !bool {
	return unsafe { r.matches_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) matches_within(s string, at int, end int, opt int) !bool {
	stop := check_bounds_incl(s, at, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.matches_within_nochk(s, at, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) matches_within_nochk(s string, at int, stop int, opt int) !bool {
	if at == stop {
		return false
	}
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	code := C.pcre_exec(r.re, r.extra, s.str, stop, at, opt, offsets.data, offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		false
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets[0] == at && offsets[1] == stop
	}
}

[inline]
pub fn (r &RegEx) contains(s string, opt int) !bool {
	return unsafe { r.contains_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) contains_within(s string, start int, end int, opt int) !bool {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.contains_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) contains_within_nochk(s string, start int, stop int, opt int) !bool {
	if start == stop {
		return false
	}
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	code := C.pcre_exec(r.re, r.extra, s.str, stop, start, opt, offsets.data, offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		false
	} else if code <= 0 {
		fail_exec(code)
	} else {
		true
	}
}

[inline]
pub fn (r &RegEx) starts_with(s string, opt int) !bool {
	return unsafe { r.starts_with_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) starts_with_within(s string, at int, end int, opt int) !bool {
	stop := check_bounds_incl(s, at, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.starts_with_within_nochk(s, at, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) starts_with_within_nochk(s string, at int, stop int, opt int) !bool {
	if at == stop {
		return false
	}
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	code := C.pcre_exec(r.re, r.extra, s.str, stop, at, opt, offsets.data, offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		false
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets[0] == at
	}
}

[inline]
pub fn (r &RegEx) index_of(s string, option int) !int {
	return unsafe { r.index_of_within_nochk(s, 0, s.len, option)! }
}

pub fn (r &RegEx) index_of_within(s string, start int, end int, opt int) !int {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return -1
	}
	return unsafe { r.index_of_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) index_of_within_nochk(s string, start int, stop int, opt int) !int {
	if start == stop {
		return -1
	}
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	code := C.pcre_exec(r.re, r.extra, s.str, stop, start, opt, offsets.data, offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		-1
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets[0]
	}
}

[inline]
pub fn (r &RegEx) index_range(s string, opt int) !(int, int) {
	unsafe {
		return r.index_range_within_nochk(s, 0, s.len, opt)!
	}
}

pub fn (r &RegEx) index_range_within(s string, start int, end int, opt int) !(int, int) {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return -1, -1
	}
	unsafe {
		return r.index_range_within_nochk(s, start, stop, opt)!
	}
}

[unsafe]
pub fn (r &RegEx) index_range_within_nochk(s string, start int, stop int, opt int) !(int, int) {
	if start == stop {
		return -1, -1
	}
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	code := C.pcre_exec(r.re, r.extra, s.str, stop, start, opt, offsets.data, offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		-1, -1
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets[0], offsets[1]
	}
}

[inline]
pub fn (r &RegEx) ends_with(s string, opt int) !bool {
	return unsafe { r.ends_with_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) ends_with_within(s string, start int, end int, opt int) !bool {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.ends_with_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) ends_with_within_nochk(s string, start int, end int, opt int) !bool {
	if start == end {
		return false
	}
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	code := C.pcre_exec(r.re, r.extra, s.str, end, start, opt, offsets.data, offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		false
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets[1] == end
	}
}

[inline]
pub fn (r &RegEx) count_of(s string, option int) !int {
	return unsafe { r.count_of_within_nochk(s, 0, s.len, option)! }
}

pub fn (r &RegEx) count_of_within(s string, start int, end int, opt int) !int {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return 0
	}
	return unsafe { r.count_of_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) count_of_within_nochk(s string, start int, end int, opt int) !int {
	if start == end {
		return 0
	}
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	mut cnt := 0
	mut pos := start
	for {
		code := C.pcre_exec(r.re, r.extra, s.str, end, pos, opt, offsets.data, offsetcount)
		if code == C.PCRE_ERROR_NOMATCH {
			break
		} else if code <= 0 {
			return fail_exec(code)
		} else {
			cnt++
			pos = offsets[1]
			if pos == end {
				break
			}
		}
	}
	return cnt
}
