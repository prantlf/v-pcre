module pcre

[noinit]
pub struct Match {
	re      &RegEx
	offsets []int
}

pub fn (m &Match) group_bounds(idx int) ?(int, int) {
	offset := idx * 2
	start := m.offsets[offset]
	if start < 0 {
		return none
	}
	end := m.offsets[offset + 1]
	return start, end
}

pub fn (m &Match) group_text(subject string, idx int) ?string {
	return if start, end := m.group_bounds(idx) {
		subject[start..end]
	} else {
		return none
	}
}
