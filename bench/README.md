# Benchmarks

When only a match of a regex is needed, Oniguruma, PCRE and RE2 are significantly faster than the built-in regex. When the unnamed groups are needed, the times become more similar, with PCRE having an edge. When named groups are needed, PCRE has a clear edge:

    ❯ ./bench/bench-all-regexes.vsh
     SPENT    13.674 ms in regex test
     SPENT    15.110 ms in regex unamed
     SPENT   120.848 ms in regex named
     SPENT    54.464 ms in regex miss
     SPENT     5.652 ms in prantlf.onig test
     SPENT    10.198 ms in prantlf.onig unnamed
     SPENT   119.563 ms in prantlf.onig named
     SPENT    33.507 ms in prantlf.onig miss
     SPENT     6.122 ms in prantlf.pcre test
     SPENT     6.583 ms in prantlf.pcre unnamed
     SPENT    32.855 ms in prantlf.pcre named
     SPENT     7.050 ms in prantlf.pcre miss
     SPENT    11.555 ms in prantlf.pcre2 test
     SPENT    12.225 ms in prantlf.pcre2 unnamed
         N/A	prantlf.pcre2 named
         N/A	prantlf.pcre2 miss
     SPENT     2.859 ms in prantlf.re2 test
     SPENT    19.213 ms in prantlf.re2 unnamed
     SPENT   128.975 ms in prantlf.re2 named
     SPENT    76.966 ms in prantlf.re2 miss
