/* #ifdef HAVE_CONFIG_H */
#include "config.h"
/* #endif */

#include "pcre_internal.h"

PCRE_EXP_DEFN int PCRE_CALL_CONVENTION
pcre_ctype(const char ch)
{
  return PRIV(default_tables)[ctypes_offset + ch];
}

PCRE_EXP_DEFN int PCRE_CALL_CONVENTION
pcre_gentype(pcre_uint32 ch)
{
  const ucd_record *prop = GET_UCD(ch);
  return PRIV(ucp_gentype)[prop->chartype];
}

PCRE_EXP_DEFN int PCRE_CALL_CONVENTION
pcre_chartype(pcre_uint32 ch)
{
  const ucd_record *prop = GET_UCD(ch);
  return prop->chartype;
}
