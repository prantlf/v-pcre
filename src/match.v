module pcre

@[noinit]
pub struct Match {
	offsets []int
}

@[direct_array_access]
pub fn (m &Match) group_bounds(idx int) ?(int, int) {
	if idx < 0 || idx >= m.offsets.len / 3 {
		return none
	}
	offset := idx * 2
	start := m.offsets[offset]
	if start < 0 {
		return none
	}
	end := m.offsets[offset + 1]
	return start, end
}

@[direct_array_access]
pub fn (m &Match) group_text(subject string, idx int) ?string {
	return if start, end := m.group_bounds(idx) {
		subject[start..end]
	} else {
		none
	}
}
