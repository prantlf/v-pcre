# Changes

## [0.3.2](https://github.com/prantlf/v-pcre/compare/v0.3.1...v0.3.2) (2025-07-31)

### Bug Fixes

* Fix compiler warnings ([34c0924](https://github.com/prantlf/v-pcre/commit/34c0924d998c576dd03c3484c64f7344670a4d97))

## [0.3.1](https://github.com/prantlf/v-pcre/compare/v0.3.0...v0.3.1) (2024-11-16)

### Bug Fixes

* Fix sources for the new V compiler ([bedf536](https://github.com/prantlf/v-pcre/commit/bedf5369c2a1d8db141288218eddce983da356fc))

## [0.3.0](https://github.com/prantlf/v-pcre/compare/v0.2.4...v0.3.0) (2024-01-01)

### Features

* Export character-classifying functions ([a957350](https://github.com/prantlf/v-pcre/commit/a9573504959d02932cebcd2011f171665e358382))

## [0.2.4](https://github.com/prantlf/v-pcre/compare/v0.2.3...v0.2.4) (2023-12-11)

### Bug Fixes

* Use flags to force static linking instead of config define ([20ace95](https://github.com/prantlf/v-pcre/commit/20ace95e5c800a16a8034ad58483ae212b3302ad))

## [0.2.3](https://github.com/prantlf/v-pcre/compare/v0.2.2...v0.2.3) (2023-12-11)

### Bug Fixes

* Adapt for V langage changes ([51f8985](https://github.com/prantlf/v-pcre/commit/51f8985e921f2d7cb8914010452a6a35d62addc5))

## [0.2.2](https://github.com/prantlf/v-pcre/compare/v0.2.1...v0.2.2) (2023-09-17)

### Bug Fixes

* Support build on windows ([61c634b](https://github.com/prantlf/v-pcre/commit/61c634bfa7b72a51c6272da6f460e8f848d292dc))

## [0.2.1](https://github.com/prantlf/v-pcre/compare/v0.2.0...v0.2.1) (2023-09-10)

### Bug Fixes

* Make the RegEx struct public ([ea7cbc0](https://github.com/prantlf/v-pcre/commit/ea7cbc0ba41d6a18e2d9487183db66170d5ebdda))

## [0.2.0](https://github.com/prantlf/v-pcre/compare/v0.1.1...v0.2.0) (2023-09-09)

### Features

* Support partial matches ([ac4cec0](https://github.com/prantlf/v-pcre/commit/ac4cec0cd8827b0a7549f8644dfc2923437d0149))

## [0.1.1](https://github.com/prantlf/v-pcre/compare/v0.1.0...v0.1.1) (2023-08-17)

### Bug Fixes

* Do not pass opt_replace_groups to pcre_exec ([588c73c](https://github.com/prantlf/v-pcre/commit/588c73ca6dfb310d037bdeb7d897e2097bd40ecd))
* Handle any combination or \r and \n as eoln ([4cdadbf](https://github.com/prantlf/v-pcre/commit/4cdadbfe8c029c9147411c4b2e5595a0f298d3df))
* Remove unused RegExp pointer from Match ([56d9a42](https://github.com/prantlf/v-pcre/commit/56d9a422c59ef12ec9da9de1f3098c93a1edbd07))

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
