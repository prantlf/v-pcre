module pcre

import prantlf.strutil { check_bounds_strict }

[inline]
pub fn (r &RegEx) exec(subject string, options int) !Match {
	return unsafe { r.exec_within_nochk(subject, 0, subject.len, options)! }
}

pub fn (r &RegEx) exec_within(subject string, start int, end int, options int) !Match {
	stop := check_bounds_strict(subject, start, end)!
	return unsafe { r.exec_within_nochk(subject, start, stop, options)! }
}

[unsafe]
pub fn (r &RegEx) exec_within_nochk(subject string, start int, end int, options int) !Match {
	offsetcount := (r.captures + 1) * 3
	offsets := []int{len: offsetcount}
	code := C.pcre_exec(r.re, r.extra, subject.str, end, start, options, offsets.data,
		offsetcount)
	return if code == C.PCRE_ERROR_NOMATCH {
		NoMatch{}
	} else if code <= 0 {
		fail_exec(code)
	} else {
		Match{offsets}
	}
}

fn fail_exec(code int) ExecError {
	return if code < 0 {
		ExecError{
			msg: 'executing the regular expression failed'
			code: code
		}
	} else {
		ExecError{
			msg: 'insufficient space for captures'
		}
	}
}
