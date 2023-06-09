#include "hypdefs.h"
#include "hypdebug.h"

/*
 * HypTree header data:
 * 4 bytes: sum of the length of all explicit titles (big-endian)
 * Array of word bit-vectors:
 *   1st word: Bit n == 1 -> Page n has an explicit title
 *   2nd word: Bit n == 1 -> Page 16+n has an explicit title
 *   etc.
 */

/*****************************************************************************/
/* ------------------------------------------------------------------------- */
/*****************************************************************************/

gboolean hyp_tree_isset(HYP_DOCUMENT *hyp, hyp_nodenr node)
{
	hyp_nodenr bitlen;
	const unsigned char *p;
	hyp_nodenr pos;
	
	if (hyp == NULL || hyp->hyptree_len <= SIZEOF_LONG || hyp->hyptree_data == NULL || node > hyp->last_text_page)
		return FALSE;
	p = hyp->hyptree_data + SIZEOF_LONG;
	bitlen = hyp->hyptree_len - SIZEOF_LONG;
	pos = (node >> 4) << 1;
	if (!(node & 0x08))
		pos++;
	if (pos >= bitlen)
		return FALSE;
	return (p[pos] & (0x01 << (node & 0x07))) != 0;
}

/* ------------------------------------------------------------------------- */

void hyp_tree_setbit(HYP_DOCUMENT *hyp, hyp_nodenr node)
{
	hyp_nodenr bitlen;
	unsigned char *p;
	hyp_nodenr pos;
	
	if (hyp == NULL || hyp->hyptree_len <= SIZEOF_LONG || hyp->hyptree_data == NULL || node > hyp->last_text_page)
		return;
	p = hyp->hyptree_data + SIZEOF_LONG;
	bitlen = hyp->hyptree_len - SIZEOF_LONG;
	pos = (node >> 4) << 1;
	if (!(node & 0x08))
		pos++;
	if (pos >= bitlen)
		return;
	p[pos] |= (0x01 << (node & 0x07));
}

/* ------------------------------------------------------------------------- */

gboolean hyp_tree_alloc(HYP_DOCUMENT *hyp)
{
	hyp_nodenr node;
	size_t bitlen;
	long titlelen = 0;
	HYP_NODE *nodeptr;
	
	if (hyp == NULL)
		return FALSE;
	if (hyp->hyptree_data != NULL)
	{
		HYP_DBG(("hyptree already allocated"));
		return FALSE;
	}
	hyp->first_text_page = hyp_first_text_page(hyp);
	hyp->last_text_page = hyp_last_text_page(hyp);
	bitlen = SIZEOF_LONG + (((hyp->last_text_page + 16u) >> 4) << 1);

	hyp->hyptree_data = g_new0(unsigned char, bitlen);
	if (hyp->hyptree_data == NULL)
		return FALSE;
	hyp->hyptree_len = bitlen;
	
	for (node = 0; node < hyp->num_index; node++)
	{
		if ((nodeptr = hyp_loadtext(hyp, node)) != NULL)
		{
			hyp_node_find_windowtitle(nodeptr);
			if (nodeptr->window_title)
			{
				titlelen += ustrlen(nodeptr->window_title) + 1;
				hyp_tree_setbit(hyp, node);
			}
			hyp_node_free(nodeptr);
		}
	}
	long_to_chars(titlelen, hyp->hyptree_data);
	
	/*
	 * do not write the bit table when there are no titlss
	 */
	if (titlelen == 0)
		hyp->hyptree_len = SIZEOF_LONG;
	
	return TRUE;
}
