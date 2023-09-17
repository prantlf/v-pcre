module pcre

fn test_empty() {
	re := pcre_compile('', 0) or {
		assert err.msg() == 'studying the regular expression failed'
		return
	}
	assert false
}

fn test_invalid() {
	re := pcre_compile('(', 0) or {
		assert err.msg() == 'missing ) at 1'
		return
	}
	assert false
}

fn test_simple() {
	re := pcre_compile('a', 0)!
	defer {
		re.free()
	}
	assert re.captures == 0
	assert re.names == 0
}

fn test_group() {
	re := pcre_compile('(a)', 0)!
	defer {
		re.free()
	}
	assert re.captures == 1
	assert re.names == 0
}

fn test_named_group() {
	re := pcre_compile('(?<test>a)', 0)!
	defer {
		re.free()
	}
	assert re.captures == 1
	assert re.names == 1
	assert re.group_index_by_name('dummy') == -1
	assert re.group_index_by_name('test') == 1
	assert re.group_name_by_index(1) == 'test'
}
