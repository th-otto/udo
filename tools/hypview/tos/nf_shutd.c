#include "hypdefs.h"
#include <mint/arch/nf_ops.h>


long nf_shutdown(int mode)
{
	struct nf_ops *nf_ops;
	long res = 0;

	if ((nf_ops = nf_init()) != NULL)
	{
		long shutdown_id = NF_GET_ID(nf_ops, NF_ID_SHUTDOWN);
		
		if (shutdown_id)
        	res = nf_ops->call(shutdown_id | mode);
	}
	return res;
}
