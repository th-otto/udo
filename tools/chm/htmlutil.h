#ifndef __HTMLUTIL_H__
#define __HTMLUTIL_H__ 1

/*
 * most commonly used
 */
char *GetVal(const char *tag, size_t taglen, const char *attribname_ci);
char *GetTagName(const char *tag, size_t len);

/*
 * less commonly used, but useful
 */
char *GetUpTagName(const char *tag, size_t len);
char *GetNameValPair(const char *tag, size_t taglen, const char *attribname_ci);
char *GetValFromNameVal(const char *namevalpair);

#endif /* __HTMLUTIL_H__ */
