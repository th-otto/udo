#ifndef __LANGID_H__
#define __LANGID_H__ 1

#include "../../rcintl/windows.rh"

#ifndef MAKELANGID
typedef uint32_t LCID;
#endif

#define SUBLANG_SHIFT 10
#undef MAKELANGID
#define MAKELANGID(primary, sub) (((sub) << SUBLANG_SHIFT) | (primary))
#undef PRIMARYLANGID
#define PRIMARYLANGID(id) ((id) & ~(1 << SUBLANG_SHIFT))
#undef SUBLANGID
#define SUBLANGID(id) ((id) >> SUBLANG_SHIFT)
#undef MAKELCID
#define MAKELCID(l,s) ((LCID)((((LCID)((uint16_t)(s)))<<16)|((LCID)((uint16_)(l)))))
#undef LANGIDFROMLCID
#define LANGIDFROMLCID(l) ((uint16_t)((l) & 0xffff))

#endif /* __LANGID_H__ */
