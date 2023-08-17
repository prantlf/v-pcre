# Changes

## [0.1.0](https://github.com/prantlf/v-pcre/compare/v0.0.2...v0.1.0) (2023-08-17)

### Features

* Return NoMatch if replace methods did not replace anything ([edb534d](https://github.com/prantlf/v-pcre/commit/edb534d57202f108a4b95dc35d7510c28c35f2d8))
* Return NoReplace if replaced parts remained the same ([825c495](https://github.com/prantlf/v-pcre/commit/825c4956153bfd000e5a7edf7a1cc61b694daff2))

### BREAKING CHANGES

If you expected that `replace` and `replace_first`
always returned a string, either the same one or a new one
with some parts replaced, you will need to modify your code. You
will need to check if the returned error is NoMatch or NoReplace
and use the original string in that case:
```go
if new_string := re.replace(old_string, with, 0) {
  // use new_string
} else {
  if err is NoMatch || err is NoReplace {
    // use old_string
  } else {
    return err
  }
}
```

If you expected that `replace` and `replace_first`
always returned a string, either the same one or a new one with some
parts replaced, you will need to modify your code. You will need to
check if the returned error is NoMatch and use the original string in
that case:
```go
if new_string := re.replace(old_string, with, 0) {
  // use new_string
} else {
  if err is NoMatch {
    // use old_string
  } else {
    return err
  }
}
```

## [0.0.2](https://github.com/prantlf/v-pcre/compare/v0.0.1...v0.0.2) (2023-08-16)

### Bug Fixes

* Guard group_bounds against negavive input ([ea2e27e](https://github.com/prantlf/v-pcre/commit/ea2e27efa634cfd329cebc805acb63b0cf3d13a5))

## 0.0.1 (2023-08-16)

Initial release.
