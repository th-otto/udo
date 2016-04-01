#ifndef __CHMINTL_H__
#define __CHMINTL_H__ 1

#undef ENABLE_NLS
#undef _
#define _(x) x
#undef P_
#define P_(s, p, c) ((c) == 1 ? s : p)

#endif
