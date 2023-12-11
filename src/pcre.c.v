module pcre

#flag -D PCRE_STATIC
#flag -I @VROOT/libpcre
#flag @VROOT/libpcre/pcre_byte_order.c
#flag @VROOT/libpcre/pcre_chartables.c
#flag @VROOT/libpcre/pcre_compile.c
#flag @VROOT/libpcre/pcre_config.c
#flag @VROOT/libpcre/pcre_exec.c
#flag @VROOT/libpcre/pcre_fullinfo.c
#flag @VROOT/libpcre/pcre_get.c
#flag @VROOT/libpcre/pcre_globals.c
#flag @VROOT/libpcre/pcre_maketables.c
#flag @VROOT/libpcre/pcre_newline.c
#flag @VROOT/libpcre/pcre_ord2utf8.c
#flag @VROOT/libpcre/pcre_refcount.c
#flag @VROOT/libpcre/pcre_string_utils.c
#flag @VROOT/libpcre/pcre_study.c
#flag @VROOT/libpcre/pcre_tables.c
#flag @VROOT/libpcre/pcre_ucd.c
#flag @VROOT/libpcre/pcre_valid_utf8.c
#flag @VROOT/libpcre/pcre_xclass.c
#include <limits.h>
#include "pcre.h"
// #include "config.h"
// #include "pcre_internal.h"

@[typedef]
struct C.pcre {
	magic_number      u32
	size              u32
	options           u32
	flags             u32
	limit_match       u32
	limit_recursion   u32
	first_char        u16
	req_char          u16
	max_lookbehind    u16
	top_bracket       u16
	top_backref       u16
	name_table_offset u16
	name_entry_size   u16
	name_count        u16
	ref_count         u16
	dummy1            u16
	dummy2            u16
	dummy3            i16
	tables            &u8
	nullpad           voidptr
}

@[typedef]
struct C.pcre_extra {
	flags                 u32
	study_data            voidptr
	match_limit           u32
	callout_data          voidptr
	tables                &u8
	match_limit_recursion u32
	mark                  &&u8
	executable_jit        voidptr
}

fn C.pcre_compile2(pattern &u8, options int, errorcodeptr &int, errorptr &&u8, erroroffset &int, tables &u8) &C.pcre
fn C.pcre_study(re &C.pcre, options int, errorptr &&u8) &C.pcre_extra
fn C.pcre_fullinfo(re &C.pcre, extra_data &C.pcre_extra, what int, where voidptr) int

fn C.pcre_exec(re &C.pcre, extra_data &C.pcre_extra, subject &u8, length int, start_offset int, options int, offsets &int, offsetcount int) int

fn C.pcre_free_re(re &C.pcre)
fn C.pcre_free_study(extra &C.pcre_extra)
