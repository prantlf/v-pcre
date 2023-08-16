# PCRE - Perl Compatible Regular Expressions - for V

The [PCRE] library is a [fast](bench/README.md) set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5.

This package uses the older, but still widely deployed PCRE library, originally released in 1997, at version 8.45.

## Synopsis

```go
import prantlf.pcre { pcre_compile }

pattern := r'answer (?<answer>\d+)'
text := 'Is the answer 42?'

re := pcre_compile(pattern, 0)!
defer { re.free() }

assert re.contains(text, 0)!
idx := re.index_of(text, 0)!
assert idx == 14
start, end := re.index_range(text, 0)!
assert start == 14
assert end == 16

m := re.exec(text, 0)!
assert re.captures == 1
assert re.names == 1
start, end := m.group_bounds(1)?
assert start == 14
assert end == 16
assert m.group_text(text, 1)? == '42'
assert re.group_index_by_name('answer') == 1

text2 := re.replace(text, 'question known', 0)!
assert text2 == 'Is the question known?'
assert !re.contains(text2, 0)
```

## Installation

You can install this package either from [VPM] or from GitHub:

```txt
v install prantlf.pcre
v install --git https://github.com/prantlf/v-pcre
```

## API

The following types, constants, functions and methods are exported:

### Types

    struct RegEx {}

    struct Match {
      groups      []Group
      names       map[string][]int
    }

    struct Group {
      start int
      end   int
    }

    struct MetaCharTable {
      esc              int
      anychar          int
      anytime          int
      zero_or_one_time int
      one_or_more_time int
      anychar_anytime  int
    }

    struct Syntax {
      op              int
      op2             int
      behavior        int
      options         int
      meta_char_table MetaCharTable
    }

    struct NoMatch {}

    struct CompileError {
      msg  string
      code int
    }

    struct ExecuteError {
      msg  string
      code int
    }

### Constants

		// C1   Affects compile only
		// C2   Does not affect compile; affects exec
		// C3   Affects compile, exec
		// C4   Affects compile, exec, study
		// C5   Affects exec; takes precedence over settings passed from pcre_compile
		// C6   Affects replace

		opt_caseless /* C1 */
		opt_multiline /* C1 */
		opt_dotall /* C1 */
		opt_extended /* C1 */
		opt_anchored /* C4 C5 */
		opt_dollar_endonly /* C2 */
		opt_extra /* C1 */
		opt_notbol /* C5 */
		opt_noteol /* C5 */
		opt_ungreedy /* C1 */
		opt_notempty /* C5 */
		opt_utf8 /* C4 */
		opt_no_auto_capture /* C1 */
		opt_no_utf8_check /* C1 C5 */
		opt_auto_callout /* C1 */
		opt_partial_soft /* C5 */
		opt_never_utf /* C1 */
		opt_no_auto_possess /* C1 */
		opt_firstline /* C3 */
		opt_dupnames /* C1 */
		opt_newline_cr /* C3 C5 */
		opt_newline_lf /* C3 C5 */
		opt_newline_crlf /* C3 C5 */
		opt_newline_any /* C3 C5 */
		opt_newline_anycrlf /* C3 C5 */
		opt_bsr_anycrlf /* C3 C5 */
		opt_bsr_unicode /* C3 C5 */
		opt_javascript_compat /* C4 */
		opt_no_start_optimize /* C2 C5 */
		opt_partial_hard /* C5 */
		opt_notempty_atstart /* C5 */
		opt_ucp /* C3 */
		opt_replace_groups /* C6 */

### Functions

    pcre_compile(source string, options int) !&RegEx

### Methods

    (r &RegEx) free()

    (r &RegEx) group_index_by_name(name string) int
    (r &RegEx) group_name_by_index(idx int) string

    (r &RegEx) exec(subject string, options int) !Match
    (r &RegEx) exec_within(subject string, start int, end int, options int) !Match
    (r &RegEx) exec_within_nochk(subject string, start int, end int, options int) !Match

    (r &RegEx) matches(s string, opt int) !bool
    (r &RegEx) matches_within(s string, at int, end int, opt int) !bool
    (r &RegEx) matches_within_nochk(s string, at int, stop int, opt int) !bool

    (r &RegEx) contains(s string, opt int) !bool
    (r &RegEx) contains_within(s string, at int, end int, opt int) !bool
    (r &RegEx) contains_within_nochk(s string, at int, stop int, opt int) !bool

    (r &RegEx) starts_with(s string, opt int) !bool
    (r &RegEx) starts_with_within(s string, at int, end int, opt int) !bool
    (r &RegEx) starts_with_within_nochk(s string, at int, stop int, opt int) !bool

    (r &RegEx) index_of(s string, option int) !int
    (r &RegEx) index_of_within(s string, start int, end int, opt int) !int
    (r &RegEx) index_of_within_nochk(s string, start int, stop int, opt int) !int

    (r &RegEx) index_range(s string, opt int) !(int, int)
    (r &RegEx) index_range_within(s string, start int, end int, opt int) !(int, int)
    (r &RegEx) index_range_within_nochk(s string, start int, stop int, opt int) !(int, int)

    (r &RegEx) ends_with(s string, opt int) !bool
    (r &RegEx) ends_with_within(s string, from int, to int, opt int) !bool
    (r &RegEx) ends_with_within_nochk(s string, from int, to int, opt int) !bool

    (r &RegEx) count_of(s string, opt int) !int
    (r &RegEx) count_of_within(s string, start int, end int, opt int) !int
    (r &RegEx) count_of_within_nochk(s string, start int, stop int, opt int) !int

    (r &RegEx) split(s string, opt int) ![]string
    (r &RegEx) split_first(s string, opt int) ![]string

    (r &RegEx) chop(s string, opt int) ![]string
    (r &RegEx) chop_first(s string, opt int) ![]string

    (r &RegEx) replace(s string, with string, opt int) !string
    (r &RegEx) replace_first(s string, with string, opt int) !string

    (m &Match) group_bounds(idx int) ?(int, int)
    (m &Match) group_text(subject string, idx int) ?string

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.pcre
[PCRE]: https://www.pcre.org/
