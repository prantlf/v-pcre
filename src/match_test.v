module pcre

fn test_bounds_no_capture() {
	m := Match{
		offsets: [1, 3, 0]
	}
	if _, _ := m.group_bounds(-1) {
		assert false
	}
	start, end := m.group_bounds(0)?
	assert start == 1
	assert end == 3
	if _, _ := m.group_bounds(1) {
		assert false
	}
}

fn test_bounds_one_capture() {
	m := Match{
		offsets: [1, 3, 1, 2, 0, 0]
	}
	start, end := m.group_bounds(1)?
	assert start == 1
	assert end == 2
	if _, _ := m.group_bounds(2) {
		assert false
	}
}

fn test_bounds_bad_capture() {
	m := Match{
		offsets: [1, 3, -1, -1, 0, 0]
	}
	if _, _ := m.group_bounds(1) {
		assert false
	}
}

fn test_text() {
	m := Match{
		offsets: [1, 3, 1, 2, -1, -1, 0, 0]
	}
	if _, _ := m.group_text('abc', -1) {
		assert false
	}
	assert m.group_text('abc', 0)? == 'bc'
	assert m.group_text('abc', 1)? == 'b'
	if _ := m.group_text('abc', 2) {
		assert false
	}
	if _ := m.group_text('abc', 3) {
		assert false
	}
}
