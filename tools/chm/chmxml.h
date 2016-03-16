#ifndef __CHMXML_H__
#define __CHMXML_H__ 1

/*
 * replaces all occurrences of html entities in src
 * by there utf-8 equivalents.
 * return a NUL-terminated, newly allocated string
 */
char *xml_dequote(const char *src, size_t len);

/*
 * same as above, but modifies src in-place.
 * src is guaranteed to be NUL-terminated afterwards,
 * and must therefore hold at least len+1 bytes
 */
char *xml_dequote_inplace(char *src, size_t len);

/*
 * replaces all occurrences of utf-8 sequences in src
 * which have a defined html entity, and puts
 * the string in double-quotation marks.
 * returns a NUL-terminated, newly allocated string
 */
char *xml_enquote(const char *src, size_t len);

/*
 * same as above, for NUL-terminated input strings
 */
char *xml_quote(const char *src);

/*
 * iniializes tables.
 * Returns TRUE on success, FALSE otherwise.
 * FALSE does not indicate a fatal error,
 * the function will still work, using a slower lookup method.
 */
int xml_init(void);

/*
 * frees any allocated memory.
 */
void xml_exit(void);

#endif /* __CHMXML_H__ */
