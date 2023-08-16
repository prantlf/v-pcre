module pcre

[noinit]
pub struct ExecError {
	Error
pub:
	msg  string
	code int
}

fn (e ExecError) msg() string {
	return e.msg
}

[noinit]
pub struct NoMatch {
	Error
}

fn (e NoMatch) msg() string {
	return 'no match'
}
