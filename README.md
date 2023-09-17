# PCRE - Perl Compatible Regular Expressions - for V

The [PCRE] library is a [fast] set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5.

This package uses the older, but still widely deployed PCRE library, originally released in 1997, at version 8.45. If you are interested in the current version, PCRE2, released in 2015 and now at version 10.42, see [prantlf.pcre2].

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

## Usage

For the syntax of the regular expression patterns, see the [quick reference] or the [exhaustive documentation] from the web site with the [original documentation] for PCRE for C. Especially notable are pages about the [pattern limits] and the [compatibility with PERL5].

### Compile

A regular expression pattern has to be compiled at first. Both synonymous methods share the same functionality:

```go
import prantlf.pcre { pcre_compile }
pcre_compile(source string, options u32) !&RegEx
```

```go
import prantlf.pcre
pcre.compile(source string, options u32) !&RegEx
```

The following options can be applied. Combine multiple options together with the `|` (binary OR) operator:

    opt_anchored           Force pattern anchoring
    opt_auto_callout       Compile automatic callouts
    opt_bsr_anycrlf        \R matches only CR, LF, or CRLF
    opt_bsr_unicode        \R matches all Unicode line endings
    opt_caseless           Do caseless matching
    opt_dollar_endonly     $ not to match newline at end
    opt_dotall             . matches anything including NL
    opt_dupnames           Allow duplicate names for subpatterns
    opt_extended           Ignore white space and # comments
    opt_extra              PCRE extra features
                           (not much use currently)
    opt_firstline          Force matching to be before newline
    opt_javascript_compat  JavaScript compatibility
    opt_multiline          ^ and $ match newlines within data
    opt_never_utf          Lock out UTF, e.g. via (*UTF)
    opt_newline_any        Recognize any Unicode newline sequence
    opt_newline_anycrlf    Recognize CR, LF, and CRLF as newline
                           sequences
    opt_newline_cr         Set CR as the newline sequence
    opt_newline_crlf       Set CRLF as the newline sequence
    opt_newline_lf         Set LF as the newline sequence
    opt_no_auto_capture    Disable numbered capturing paren-
                           theses (named ones available)
    opt_no_auto_possess    Disable auto-possessification
    opt_no_start_optimize  Disable match-time start optimizations
    opt_no_utf8_check      Do not check the pattern for UTF-8
                           validity (only relevant if opt_utf8 is set)
    opt_ucp                Use Unicode properties for \d, \w, etc.
    opt_ungreedy           Invert greediness of quantifiers
    opt_utf8               Run pcre_compile() in UTF-8 mode

If the compilation fails, an error will be returned:

```go
struct CompileError {
  msg    string  // the error message
  code   int     // the error code
  offset int     // if >= 0, points to the pattern where the compilation failed
}
```

Don't forget to free the regular expression object when you do not need it any more:

```go
(r &RegEx) free()
defer { re.free() }
```

Some characteristics of the regular expression, which are usually needed when executing it later, can be enquired right after compiling it:

```go
struct RegEx {
  captures int  // total count of the capturing groups
  names    int  // total count of the named capturing groups
}
```

```go
(r &RegEx) group_index_by_name(name string) int
(r &RegEx) group_name_by_index(idx int) string
```

See also the [original documentation for pcre_compile2].

### Execute

After compiling, the regular expression can be executed with various subjects:

```go
(r &RegEx) exec(subject string, options int) !Match
(r &RegEx) exec_within(subject string, start int, end int, options int) !Match
(r &RegEx) exec_within_nochk(subject string, start int, end int, options int) !Match
```

The following options can be applied. Combine multiple options together with the `|` (binary OR) operator:

    opt_anchored          Match only at the first position
    opt_bsr_anycrlf       \R matches only CR, LF, or CRLF
    opt_bsr_unicode       \R matches all Unicode line endings
    opt_newline_any       Recognize any Unicode newline sequence
    opt_newline_anycrlf   Recognize CR, LF, & CRLF as newline sequences
    opt_newline_cr        Recognize CR as the only newline sequence
    opt_newline_crlf      Recognize CRLF as the only newline sequence
    opt_newline_lf        Recognize LF as the only newline sequence
    opt_notbol            Subject string is not the beginning of a line
    opt_noteol            Subject string is not the end of a line
    opt_notempty          An empty string is not a valid match
    opt_notempty_atstart  An empty string at the start of the subject
                          is not a valid match
    opt_no_start_optimize Do not do "start-match" optimizations
    opt_no_utf8_check     Do not check the subject for UTF-8 validity
                          (only relevant if opt_utf8 was set at compile time)
    opt_partial           ) Return error_partial for a partial
    opt_partial_soft      ) match if no full matches are found
    opt_partial_hard      Return error_partial for a partial match
                          if that is found before a full match

If the execution succeeds, an object with information about the match will be returned:

```go
struct Match {}
```

Capturing groups can be obtained by the following methods, which return `none`, if the group number is invalid. The group number `0` (zero) means the whole match:

```go
(m &Match) group_bounds(idx int) ?(int, int)
(m &Match) group_text(subject string, idx int) ?string
```

If the execution cannot match the pattern, a special error will be returned:

```go
struct NoMatch {}
```

If the execution matches the pattern only partially - see options `opt_partial_hard` and `opt_partial_soft`, a special error will be returned:

```go
struct Partial {}
```

If the execution fails from other reasons, a general error will be returned:

```go
struct ExecuteError {
  msg  string
  code int
}
```

The following error codes may encounter and are exported as public constants:

```go
error_null           = -2
error_badoption      = -3
error_badmagic       = -4
error_unknown_opcode = -5
error_nomemory       = -6
error_nosubstring    = -7
error_matchlimit     = -8
error_badutf8        = -10
error_badutf8_offset = -11
error_badpartial     = -13
error_internal       = -14
error_badcount       = -15
error_recursionlimit = -21
error_badnewline     = -23
error_badoffset      = -24
error_shortutf8      = -25
error_recurseloop    = -26
error_badmode        = -28
error_badendianness  = -29
error_badlength      = -32
```

See also the [original documentation for pcre_exec] and the description of the [partial matching].

## Others

The API consists of two parts - basic compilation and execution of a regular expression, corresponding with the [PCRE] C API described above and convenience functions for typical string checking, searching, splitting and replacing described below.

### Searching

```go
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
```

### Replace

Replace either all occurrences or only the first one matching the pattern of the regular expression:

```go
(r &RegEx) replace(s string, with string, opt int) !string
(r &RegEx) replace_first(s string, with string, opt int) !string
```

If the regular expression doesn't match the pattern, a special error will be returned:

```go
struct NoMatch {}
```

If the regular expression matches, but the replacement string is the same as the found string, so the replacing wouldn't change anything, a special error will be returned:

```go
struct NoReplace {}
```

### Split

Split the input string by the regular expression and return the remaining parts in a string array:

```go
(r &RegEx) split(s string, opt int) ![]string
(r &RegEx) split_first(s string, opt int) ![]string
```

Split the input string by the regular expression and return all parts, both remaining and splitting, in a string array:

```go
(r &RegEx) chop(s string, opt int) ![]string
(r &RegEx) chop_first(s string, opt int) ![]string
```

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.pcre
[PCRE]: https://www.pcre.org/
[original documentation]: https://www.pcre.org/original/doc/html/
[original documentation for pcre_compile2]: https://www.pcre.org/original/doc/html/pcre_compile2.html
[original documentation for pcre_exec]: https://www.pcre.org/original/doc/html/pcre_exec.html
[partial matching]: https://www.pcre.org/original/doc/html/pcrepartial.html
[quick reference]: https://www.pcre.org/original/doc/html/pcresyntax.html
[exhaustive documentation]: https://www.pcre.org/original/doc/html/pcrepattern.html
[pattern limits]: https://www.pcre.org/original/doc/html/pcrelimits.html
[compatibility with PERL5]: https://www.pcre.org/original/doc/html/pcrecompat.html
[prantlf.pcre2]: https://github.com/prantlf/v-pcre2
[fast]: https://github.com/prantlf/v-pcre2/blob/master/bench/README.md
