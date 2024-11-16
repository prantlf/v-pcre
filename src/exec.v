module pcre

import prantlf.strutil { check_bounds_strict }

pub const error_null = -2
pub const error_badoption = -3
pub const error_badmagic = -4
pub const error_unknown_opcode = -5
pub const error_nomemory = -6
pub const error_nosubstring = -7
pub const error_matchlimit = -8
pub const error_badutf8 = -10
pub const error_badutf8_offset = -11
pub const error_partial = -12
pub const error_badpartial = -13
pub const error_internal = -14
pub const error_badcount = -15
pub const error_recursionlimit = -21
pub const error_badnewline = -23
pub const error_badoffset = -24
pub const error_shortutf8 = -25
pub const error_recurseloop = -26
pub const error_badmode = -28
pub const error_badendianness = -29
pub const error_badlength = -32

@[inline]
pub fn (r &RegEx) exec(subject string, options int) !Match {
	return unsafe { r.exec_within_nochk(subject, 0, subject.len, options)! }
}

pub fn (r &RegEx) exec_within(subject string, start int, end int, options int) !Match {
	stop := check_bounds_strict(subject, start, end)!
	return unsafe { r.exec_within_nochk(subject, start, stop, options)! }
}

@[unsafe]
pub fn (r &RegEx) exec_within_nochk(subject string, start int, end int, options int) !Match {
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	code := C.pcre_exec(r.re, r.extra, subject.str, end, start, options, offsets.data,
		offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		NoMatch{}
	} else if code == C.PCRE_ERROR_PARTIAL {
		Partial{}
	} else if code <= 0 {
		fail_exec(code)
	} else {
		Match{offsets}
	}
}

fn fail_exec(code int) ExecError {
	return if code < 0 {
		ExecError{
			msg:  'executing the regular expression failed'
			code: code
		}
	} else {
		ExecError{
			msg: 'insufficient space for captures'
		}
	}
}
