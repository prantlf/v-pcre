module pcre

__global (
	re     = &RegEx(unsafe { nil })
	re_grp = &RegEx(unsafe { nil })
)

fn testsuite_begin() {
	re = pcre_compile('a', 0)!
	re_grp = pcre_compile('a(\\w)', 0)!
}

fn testsuite_end() {
	re.free()
	re_grp.free()
}

fn test_replace_empty() {
	assert re.replace('', 'c', 0)! == ''
}

fn test_replace_no() {
	assert re.replace('b', 'c', 0)! == 'b'
}

fn test_replace_yes() {
	assert re.replace('a', 'c', 0)! == 'c'
}

fn test_replace_after() {
	assert re.replace('ba', 'c', 0)! == 'bc'
}

fn test_replace_before() {
	assert re.replace('ab', 'c', 0)! == 'cb'
}

fn test_replace_two() {
	assert re.replace('aa', 'c', 0)! == 'cc'
}

fn test_replace_between() {
	assert re.replace('babab', 'c', 0)! == 'bcbcb'
}

fn test_replace_first_empty() {
	assert re.replace_first('', 'c', 0)! == ''
}

fn test_replace_first_no() {
	assert re.replace_first('b', 'c', 0)! == 'b'
}

fn test_replace_first_yes() {
	assert re.replace_first('a', 'c', 0)! == 'c'
}

fn test_replace_first_after() {
	assert re.replace_first('ba', 'c', 0)! == 'bc'
}

fn test_replace_first_before() {
	assert re.replace_first('ab', 'c', 0)! == 'cb'
}

fn test_replace_first_only() {
	assert re.replace_first('aa', 'c', 0)! == 'ca'
}

fn test_replace_plain() {
	assert re_grp.replace('ab', 'c', opt_replace_groups)! == 'c'
}

fn test_replace_group() {
	assert re_grp.replace('ab', '$1', opt_replace_groups)! == 'b'
}

fn test_replace_group_within() {
	assert re_grp.replace('ab', 'c$1d', opt_replace_groups)! == 'cbd'
}

fn test_replace_whole() {
	assert re_grp.replace('ab', '$0', opt_replace_groups)! == 'ab'
}

fn test_replace_group_out() {
	assert re_grp.replace('ab', '$2', opt_replace_groups)! == ''
}

fn test_replace_escaped_group() {
	assert re_grp.replace('ab', '\\$1', opt_replace_groups)! == '$1'
}

fn test_replace_escaped_group_within() {
	assert re_grp.replace('ab', 'c\\$1d', opt_replace_groups)! == 'c$1d'
}

fn test_replace_no_group() {
	assert re_grp.replace('ab', r'$c', opt_replace_groups)! == r'$c'
}

fn test_replace_escape() {
	assert re_grp.replace('ab', '\\', opt_replace_groups)! == '\\'
}

fn test_replace_two_escapes() {
	assert re_grp.replace('ab', '\\\\', opt_replace_groups)! == '\\\\'
}

fn test_replace_disabled_groups() {
	assert re_grp.replace('ab', '$1', 0)! == '$1'
}
