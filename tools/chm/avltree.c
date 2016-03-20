#include "chmtools.h"
#include "avltree.h"

struct _AVLTree {
	GCompareFunc compare;
	GDestroyNotify destroy;
	int count;
	AVLTreeNode *root;
};

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

AVLTreeNode *AVLTreeNode_Create(void *data)
{
	AVLTreeNode *node;
	
	node = g_new(AVLTreeNode, 1);
	if (node == NULL)
		return NULL;
	node->parent = NULL;
	node->left = NULL;
	node->right = NULL;
	node->balance = 0;
	node->data = data;
	return node;
}

/*** ---------------------------------------------------------------------- ***/

static void AVLTreeNode_Destroy(AVLTree *tree, AVLTreeNode *node)
{
	tree->destroy(node->data);
	g_free(node);
}

/*** ---------------------------------------------------------------------- ***/

int AVLTree_Depth(AVLTreeNode *node)
{
	int LeftDepth, RightDepth;

	if (node->left != NULL)
		LeftDepth = AVLTree_Depth(node->left) + 1;
	else
		LeftDepth = 0;
	if (node->right != NULL)
		RightDepth = AVLTree_Depth(node->right) + 1;
	else
		RightDepth = 0;
	if (LeftDepth > RightDepth)
		return LeftDepth;
	return RightDepth;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void AVLTree_BalanceAfterInsert(AVLTree *tree, AVLTreeNode *node)
{
	AVLTreeNode *OldParent;
	AVLTreeNode *OldParentParent;
	AVLTreeNode *OldRight;
	AVLTreeNode *OldRightLeft;
	AVLTreeNode *OldRightRight;
	AVLTreeNode *OldLeft;
	AVLTreeNode *OldLeftLeft;
	AVLTreeNode *OldLeftRight;

	OldParent = node->parent;
	if (OldParent == NULL)
		return;
	if (OldParent->left == node)
	{
		/* Node is left son */
		--OldParent->balance;
		if (OldParent->balance == 0)
			return;
		if (OldParent->balance == -1)
		{
			AVLTree_BalanceAfterInsert(tree, OldParent);
			return;
		}
		/* OldParent->balance == -2 */
		if (node->balance == -1)
		{
			/* rotate */
			OldRight = node->right;
			OldParentParent = OldParent->parent;
			if (OldParentParent != NULL)
			{
				/* OldParent has GrandParent. GrandParent gets new child */
				if (OldParentParent->left == OldParent)
					OldParentParent->left = node;
				else
					OldParentParent->right = node;
			} else
			{
				/* OldParent was root node. New root node */
				tree->root = node;
			}
			node->parent = OldParentParent;
			node->right = OldParent;
			OldParent->parent = node;
			OldParent->left = OldRight;
			if (OldRight != NULL)
				OldRight->parent = OldParent;
			node->balance = 0;
			OldParent->balance = 0;
		} else
		{
			/* Node->balance == +1 */
			/* double rotate */
			OldParentParent = OldParent->parent;
			OldRight = node->right;
			OldRightLeft = OldRight->left;
			OldRightRight = OldRight->right;
			if (OldParentParent != NULL)
			{
				/* OldParent has GrandParent. GrandParent gets new child */
				if (OldParentParent->left == OldParent)
					OldParentParent->left = OldRight;
				else
					OldParentParent->right = OldRight;
			} else
			{
				/* OldParent was root node. new root node */
				tree->root = OldRight;
			}
			OldRight->parent = OldParentParent;
			OldRight->left = node;
			OldRight->right = OldParent;
			node->parent = OldRight;
			node->right = OldRightLeft;
			OldParent->parent = OldRight;
			OldParent->left = OldRightRight;
			if (OldRightLeft != NULL)
				OldRightLeft->parent = node;
			if (OldRightRight != NULL)
				OldRightRight->parent = OldParent;
			if (OldRight->balance <= 0)
				node->balance = 0;
			else
				node->balance = -1;
			if (OldRight->balance == -1)
				OldParent->balance = 1;
			else
				OldParent->balance = 0;
			OldRight->balance = 0;
		}
	} else
	{
		/* Node is right son */
		++OldParent->balance;
		if (OldParent->balance == 0)
			return;
		if (OldParent->balance == 1)
		{
			AVLTree_BalanceAfterInsert(tree, OldParent);
			return;
		}
		/* OldParent->balance == +2 */
		if(node->balance == 1)
		{
			/* rotate */
			OldLeft = node->left;
			OldParentParent = OldParent->parent;
			if (OldParentParent != NULL)
			{
				/* Parent has GrandParent . GrandParent gets new child */
				if(OldParentParent->left == OldParent)
					OldParentParent->left = node;
				else
					OldParentParent->right = node;
			} else
			{
				/* OldParent was root node . new root node */
				tree->root = node;
			}
			node->parent = OldParentParent;
			node->left = OldParent;
			OldParent->parent = node;
			OldParent->right = OldLeft;
			if (OldLeft != NULL)
				OldLeft->parent = OldParent;
			node->balance = 0;
			OldParent->balance = 0;
		} else
		{
			/* Node->balance == -1 */
			/* double rotate */
			OldLeft = node->left;
			OldParentParent = OldParent->parent;
			OldLeftLeft = OldLeft->left;
			OldLeftRight = OldLeft->right;
			if (OldParentParent != NULL)
			{
				/* OldParent has GrandParent . GrandParent gets new child */
				if (OldParentParent->left == OldParent)
					OldParentParent->left = OldLeft;
				else
					OldParentParent->right = OldLeft;
			} else
			{
				/* OldParent was root node . new root node */
				tree->root = OldLeft;
			}
			OldLeft->parent = OldParentParent;
			OldLeft->left = OldParent;
			OldLeft->right = node;
			node->parent = OldLeft;
			node->left = OldLeftRight;
			OldParent->parent = OldLeft;
			OldParent->right = OldLeftLeft;
			if (OldLeftLeft != NULL) 
				OldLeftLeft->parent = OldParent;
			if (OldLeftRight != NULL)
				OldLeftRight->parent = node;
			if (OldLeft->balance >= 0)
				node->balance = 0;
			else
				node->balance = 1;
			if (OldLeft->balance == 1)
				OldParent->balance = -1;
			else
				OldParent->balance = 0;
			OldLeft->balance = 0;
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

static AVLTreeNode *AVLTree_FindInsertPos(AVLTree *tree, void *data)
{
	int comp;
	AVLTreeNode *node;
	
	node = tree->root;
	while (node != NULL)
	{
		comp = tree->compare(data, node->data);
		if (comp < 0)
		{
			if (node->left != NULL)
				node = node->left;
			else
				return node;
		} else
		{
			if (node->right != NULL)
				node = node->right;
			else
				return node;
		}
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_Add(AVLTree *tree, void *data)
{
	AVLTreeNode *node;
	
	if (tree == NULL)
		return NULL;
	node = AVLTreeNode_Create(data);
	AVLTree_AddNode(tree, node);
	return node;
}

/*** ---------------------------------------------------------------------- ***/

/*
 * add a node. If there are already nodes with the same value it will be
 * inserted rightmost
 */
void AVLTree_AddNode(AVLTree *tree, AVLTreeNode *node)
{
	AVLTreeNode *InsertPos;
	int InsertComp;
	
	if (tree == NULL || node == NULL)
		return;
	node->left = NULL;
	node->right = NULL;
	++tree->count;
	if (tree->root != NULL)
	{
		InsertPos = AVLTree_FindInsertPos(tree, node->data);
		InsertComp = tree->compare(node->data, InsertPos->data);
		node->parent = InsertPos;
		if (InsertComp < 0)
		{
			/* insert to the left */
			InsertPos->left = node;
		} else
		{
			/* insert to the right */
			InsertPos->right = node;
		}
		AVLTree_BalanceAfterInsert(tree, node);
	} else
	{
		tree->root = node;
		node->parent = NULL;
	}
}

/*** ---------------------------------------------------------------------- ***/

static void AVLTree_BalanceAfterDelete(AVLTree *tree, AVLTreeNode *node)
{
	AVLTreeNode *OldParent;
	AVLTreeNode *OldRight;
	AVLTreeNode *OldRightLeft;
	AVLTreeNode *OldLeft;
	AVLTreeNode *OldLeftRight;
	AVLTreeNode *OldRightLeftLeft;
	AVLTreeNode *OldRightLeftRight;
	AVLTreeNode *OldLeftRightLeft;
	AVLTreeNode *OldLeftRightRight;
	
	if (node == NULL)
		return;
	if (node->balance == 1 || node->balance == -1)
		return;
	OldParent = node->parent;
	if (node->balance == 0)
	{
		/* Treeheight has decreased by one */
		if (OldParent != NULL)
		{
			if (OldParent->left == node)
				++OldParent->balance;
			else
				--OldParent->balance;
			AVLTree_BalanceAfterDelete(tree, OldParent);
		}
		return;
	}
	if (node->balance == 2)
	{
		/* Node is overweighted to the right */
		OldRight = node->right;
		if (OldRight->balance >= 0)
		{
			/* OldRight->balance == {0 or -1} */
			/* rotate left */
			OldRightLeft = OldRight->left;
			if (OldParent != NULL)
			{
				if (OldParent->left == node)
					OldParent->left = OldRight;
				else
					OldParent->right = OldRight;
			} else
			{
				tree->root = OldRight;
			}
			node->parent = OldRight;
			node->right = OldRightLeft;
			OldRight->parent = OldParent;
			OldRight->left = node;
			if (OldRightLeft != NULL)
				OldRightLeft->parent = node;
			node->balance = (1 - OldRight->balance);
			--OldRight->balance;
			AVLTree_BalanceAfterDelete(tree, OldRight);
		} else
		{
			/* OldRight->balance == -1 */
			/* double rotate right left */
			OldRightLeft = OldRight->left;
			OldRightLeftLeft = OldRightLeft->left;
			OldRightLeftRight = OldRightLeft->right;
			if (OldParent != NULL)
			{
				if (OldParent->left == node)
					OldParent->left = OldRightLeft;
				else
					OldParent->right = OldRightLeft;
			} else
			{
				tree->root = OldRightLeft;
			}
			node->parent = OldRightLeft;
			node->right = OldRightLeftLeft;
			OldRight->parent = OldRightLeft;
			OldRight->left = OldRightLeftRight;
			OldRightLeft->parent = OldParent;
			OldRightLeft->left = node;
			OldRightLeft->right = OldRight;
			if (OldRightLeftLeft != NULL)
				OldRightLeftLeft->parent = node;
			if (OldRightLeftRight != NULL)
				OldRightLeftRight->parent = OldRight;
			if (OldRightLeft->balance <= 0)
				node->balance = 0;
			else
				node->balance = -1;
			if (OldRightLeft->balance >= 0)
				OldRight->balance = 0;
			else
				OldRight->balance = 1;
			OldRightLeft->balance = 0;
			AVLTree_BalanceAfterDelete(tree, OldRightLeft);
		}
	} else
	{
		/* Node->balance == -2 */
		/* Node is overweighted to the left */
		OldLeft = node->left;
		if (OldLeft->balance <= 0)
		{
			/* rotate right */
			OldLeftRight = OldLeft->right;
			if (OldParent != NULL)
			{
				if (OldParent->left == node)
					OldParent->left = OldLeft;
				else
					OldParent->right = OldLeft;
			} else
			{
				tree->root = OldLeft;
			}
			node->parent = OldLeft;
			node->left = OldLeftRight;
			OldLeft->parent = OldParent;
			OldLeft->right = node;
			if (OldLeftRight != NULL)
				OldLeftRight->parent = node;
			node->balance = (-1 - OldLeft->balance);
			++OldLeft->balance;
			AVLTree_BalanceAfterDelete(tree, OldLeft);
		} else
		{
			/* OldLeft->balance == 1 */
			/* double rotate left right */
			OldLeftRight = OldLeft->right;
			OldLeftRightLeft = OldLeftRight->left;
			OldLeftRightRight = OldLeftRight->right;
			if (OldParent != NULL)
			{
				if (OldParent->left == node)
					OldParent->left = OldLeftRight;
				else
					OldParent->right = OldLeftRight;
			} else
			{
				tree->root = OldLeftRight;
			}
			node->parent = OldLeftRight;
			node->left = OldLeftRightRight;
			OldLeft->parent = OldLeftRight;
			OldLeft->right = OldLeftRightLeft;
			OldLeftRight->parent = OldParent;
			OldLeftRight->left = OldLeft;
			OldLeftRight->right = node;
			if (OldLeftRightLeft != NULL)
				OldLeftRightLeft->parent = OldLeft;
			if (OldLeftRightRight != NULL)
				OldLeftRightRight->parent = node;
			if (OldLeftRight->balance >= 0)
				node->balance = 0;
			else
				node->balance = 1;
			if (OldLeftRight->balance <= 0)
				OldLeft->balance = 0;
			else
				OldLeft->balance = -1;
			OldLeftRight->balance = 0;
			AVLTree_BalanceAfterDelete(tree, OldLeftRight);
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

void AVLTree_Delete(AVLTree *tree, AVLTreeNode *node)
{
	AVLTreeNode *OldParent;
	AVLTreeNode *OldLeft;
	AVLTreeNode *OldRight;
	AVLTreeNode *Successor;
	AVLTreeNode *OldSuccParent;
	AVLTreeNode *OldSuccLeft;
	AVLTreeNode *OldSuccRight;
	int OldBalance;

	if (tree == NULL || node == NULL)
		return;
	OldParent = node->parent;
	OldBalance = node->balance;
	node->parent = NULL;
	node->balance = 0;
	if (node->left == NULL && node->right == NULL)
	{
		/* Node is Leaf (no children) */
		if (OldParent != NULL)
		{
			/* Node has parent */
			if (OldParent->left == node)
			{
				/* Node is left Son of OldParent */
				OldParent->left = NULL;
				++OldParent->balance;
			} else
			{
				/* Node is right Son of OldParent */
				OldParent->right = NULL;
				--OldParent->balance;
			}
			AVLTree_BalanceAfterDelete(tree, OldParent);
		} else
		{
			/* Node is the only node of tree */
			tree->root = NULL;
		}
		--tree->count;
		AVLTreeNode_Destroy(tree, node);
		return;
	}
	if (node->right == NULL)
	{
		/* Left is only son */
		/* and because DelNode is AVL, Right has no childrens */
		/* replace DelNode with Left */
		OldLeft = node->left;
		node->left = NULL;
		OldLeft->parent = OldParent;
		if (OldParent != NULL)
		{
			if (OldParent->left == node)
			{
				OldParent->left = OldLeft;
				++OldParent->balance;
			} else
			{
				OldParent->right = OldLeft;
				--OldParent->balance;
			}
			AVLTree_BalanceAfterDelete(tree, OldParent);
		} else
		{
			tree->root = OldLeft;
		}
		--tree->count;
		AVLTreeNode_Destroy(tree, node);
		return;
	}
	if (node->left == NULL)
	{
		/* Right is only son */
		/* and because DelNode is AVL, Left has no childrens */
		/* replace DelNode with Right */
		OldRight = node->right;
		node->right = NULL;
		OldRight->parent = OldParent;
		if (OldParent != NULL)
		{
			if (OldParent->left == node)
			{
				OldParent->left = OldRight;
				++OldParent->balance;
			} else
			{
				OldParent->right = OldRight;
				--OldParent->balance;
			}
			AVLTree_BalanceAfterDelete(tree, OldParent);
		} else
		{
			tree->root = OldRight;
		}
		--tree->count;
		AVLTreeNode_Destroy(tree, node);
		return;
	}
	/* DelNode has both: Left and Right */
	/* Replace node with symmetric Successor */
	Successor = AVLTree_FindSuccessor(node);
	assert(Successor);
	OldLeft = node->left;
	OldRight = node->right;
	OldSuccParent = Successor->parent;
	OldSuccLeft = Successor->left;
	OldSuccRight = Successor->right;
	node->balance = Successor->balance;
	Successor->balance = OldBalance;
	if (OldSuccParent != node)
	{
		/* at least one node between node and Successor */
		node->parent = Successor->parent;
		if (OldSuccParent->left == Successor)
			OldSuccParent->left = node;
		else
			OldSuccParent->right = node;
		Successor->right = OldRight;
		OldRight->parent = Successor;
	} else
	{
		/* Successor is right son of node */
		node->parent = Successor;
		Successor->right = node;
	}
	Successor->left = OldLeft;
	if (OldLeft != NULL)
		OldLeft->parent = Successor;
	Successor->parent = OldParent;
	node->left = OldSuccLeft;
	if (node->left != NULL)
		node->left->parent = node;
	node->right = OldSuccRight;
	if (node->right != NULL)
		node->right->parent = node;
	if (OldParent != NULL)
	{
		if (OldParent->left == node)
			OldParent->left = Successor;
		else
			OldParent->right = Successor;
	} else
	{
		tree->root = Successor;
	}
	/* delete Node as usual */
	AVLTree_Delete(tree, node);
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindLowest(AVLTree *tree)
{
	AVLTreeNode *node = tree->root;
	
	if (node != NULL)
	{
		while (node->left != NULL)
			node = node->left;
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindHighest(AVLTree *tree)
{
	AVLTreeNode *node = tree->root;
	
	if (node != NULL)
	{
		while (node->right != NULL)
			node = node->right;
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindSuccessor(AVLTreeNode *node)
{
	if (node != NULL)
	{
		if (node->right != NULL)
		{
			node = node->right;
			while (node->left != NULL)
				node = node->left;
		} else
		{
			while (node->parent != NULL && node->parent->right == node)
				node = node->parent;
			node = node->parent;
		}
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindPrecessor(AVLTreeNode *node)
{
	if (node != NULL)
	{
		if (node->left != NULL)
		{
			node = node->left;
			while (node->right != NULL)
				node = node->right;
		} else
		{
			while (node->parent != NULL && node->parent->left == node)
				node = node->parent;
			node = node->parent;
		}
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

void AVLTree_Remove(AVLTree *tree, void *data)
{
	AVLTreeNode *node;
	
	node = AVLTree_Find(tree, data);
	AVLTree_Delete(tree, node);
}

/*** ---------------------------------------------------------------------- ***/

void AVLTree_RemovePointer(AVLTree *tree, void *data)
{
	AVLTreeNode *node;
	
	node = AVLTree_FindPointer(tree, data);
	AVLTree_Delete(tree, node);
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_Find(AVLTree *tree, void *data)
{
	int comp;
	AVLTreeNode *node;

	if (tree == NULL)
		return NULL;
	node = tree->root;
	while (node != NULL)
	{
		comp = tree->compare(data, node->data);
		if (comp == 0)
			return node;
		if (comp < 0)
			node = node->left;
		else
			node = node->right;
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindPointer(AVLTree *tree, void *data)
{
	AVLTreeNode *node;

	node = AVLTree_FindLeftMost(tree, data);
	while (node != NULL)
	{
		if (node->data == data)
			break;
		node = AVLTree_FindSuccessor(node);
		if (node == NULL)
			break;
		if (tree->compare(data, node->data) != 0)
			return NULL;
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindLeftMost(AVLTree *tree, void *data)
{
	AVLTreeNode *node;
	AVLTreeNode *left;

	node = AVLTree_Find(tree, data);
	while (node != NULL)
	{
		left = AVLTree_FindPrecessor(node);
		if (left == NULL || tree->compare(data, left->data) != 0)
			break;
		node = left;
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindRightMost(AVLTree *tree, void *data)
{
	AVLTreeNode *node;
	AVLTreeNode *right;

	node = AVLTree_Find(tree, data);
	while (node != NULL)
	{
		right = AVLTree_FindSuccessor(node);
		if (right == NULL || tree->compare(data, right->data) != 0)
			break;
		node = right;
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindLeftMostSameKey(AVLTree *tree, AVLTreeNode *node)
{
	AVLTreeNode *left;
	void *data;

	if (node != NULL)
	{
		data = node->data;
		for (;;)
		{
			left = AVLTree_FindPrecessor(node);
			if (left == NULL || tree->compare(data, left->data) != 0)
				break;
			node = left;
		}
	}
	return node;	
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindRightMostSameKey(AVLTree *tree, AVLTreeNode *node)
{
	AVLTreeNode *right;
	void *data;

	if (node != NULL)
	{
		data = node->data;
		for (;;)
		{
			right = AVLTree_FindSuccessor(node);
			if (right == NULL || tree->compare(data, right->data) != 0)
				break;
			node = right;
		}
	}
	return node;	
}

/*** ---------------------------------------------------------------------- ***/

AVLTreeNode *AVLTree_FindNearest(AVLTree *tree, void *data)
{
	AVLTreeNode *node;
	int comp;

	node = tree->root;
	while (node != NULL)
	{
		comp = tree->compare(data, node->data);
		if (comp == 0)
			break;
		if (comp < 0)
		{
			if (node->left != NULL)
				node = node->left;
			else
				break;
		} else
		{
			if (node->right != NULL)
				node = node->right;
			else
				break;
		}
	}
	return node;
}

/*** ---------------------------------------------------------------------- ***/

void AVLTree_MoveDataLeftMost(AVLTree *tree, AVLTreeNode **pnode)
{
	AVLTreeNode *node;
	AVLTreeNode *LeftMost;
	AVLTreeNode *PreNode;
	void *data;
	
	if (tree == NULL || pnode == NULL || (node = *pnode) == NULL)
		return;
	LeftMost = node;
	for (;;)
	{
		PreNode = AVLTree_FindPrecessor(LeftMost);
		if (PreNode == NULL || tree->compare(node->data, PreNode->data) != 0)
			break;
		LeftMost = PreNode;
	}
	if (LeftMost == node)
		return;
	data = LeftMost->data;
	LeftMost->data = node->data;
	node->data = data;
	*pnode = LeftMost;
}

/*** ---------------------------------------------------------------------- ***/

void AVLTree_MoveDataRightMost(AVLTree *tree, AVLTreeNode **pnode)
{
	AVLTreeNode *node;
	AVLTreeNode *RightMost;
	AVLTreeNode *PostNode;
	void *data;
	
	if (tree == NULL || pnode == NULL || (node = *pnode) == NULL)
		return;
	RightMost = node;
	for (;;)
	{
		PostNode = AVLTree_FindSuccessor(RightMost);
		if (PostNode == NULL || tree->compare(node->data, PostNode->data) != 0)
			break;
		RightMost = PostNode;
	}
	if (RightMost == node)
		return;
	data = RightMost->data;
	RightMost->data = node->data;
	node->data = data;
	*pnode = RightMost;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int CheckNode(AVLTree *tree, AVLTreeNode *node, int *RealCount)
{
	int LeftDepth, RightDepth;
	int check;
	
	if (node == NULL)
		return 0;

	++(*RealCount);
	
	/* test left son */
	if (node->left != NULL)
	{
		if (node->left->parent != node)
		{
			CHM_DEBUG_LOG(0, "ConsistencyCheckNode-2 left-parent %p != %p\n", node->left->parent, node);
			return -2;
		}
		if (tree->compare(node->left->data, node->data) > 0)
		{
			CHM_DEBUG_LOG(0, "ConsistencyCheckNode-3 left %p > %p\n", node->left->data, node->data);
			return -3;
		}
		check = CheckNode(tree, node->left, RealCount);
		if (check != 0)
			return check;
	}
	
	/* test right son */
	if (node->right != NULL)
	{
		if (node->right->parent != node)
		{
			CHM_DEBUG_LOG(0, "ConsistencyCheckNode-4 right parent %p != %p\n", node->right->parent, node);
			return -4;
		}
		if (tree->compare(node->data, node->right->data) > 0)
		{
			CHM_DEBUG_LOG(0, "ConsistencyCheckNode-5 %p > right %p\n", node->data, node->right->data);
			return -5;
		}
		check = CheckNode(tree, node->right, RealCount);
		if (check != 0)
			return check;
	}
	
	/* test balance */
	if (node->left != NULL)
		LeftDepth = AVLTree_Depth(node->left) + 1;
	else
		LeftDepth = 0;
	if (node->right != NULL)
		RightDepth = AVLTree_Depth(node->right) + 1;
	else
		RightDepth = 0;
	if (node->balance != (RightDepth - LeftDepth))
	{
		CHM_DEBUG_LOG(0, "ConsistencyCheckNode-6 balance %d != %d\n", node->balance, (RightDepth - LeftDepth));
		return -6;
	}
	/* ok */
	return 0;
}

int AVLTree_ConsistencyCheck(AVLTree *tree)
{
	int RealCount;
	int check;
	
	RealCount = 0;
	check = CheckNode(tree, tree->root, &RealCount);
	if (check == 0)
	{
		if (tree->count != RealCount)
		{
			CHM_DEBUG_LOG(0, "ConsistencyCheckNode-1 count %d != %d\n", tree->count, RealCount);
			check = -1;
		}
	}
	return check;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int ComparePointer(const void *data1, const void *data2)
{
	if (data1 < data2)
		return -1;
	if (data1 > data2)
		return 1;
	return 0;
}

static void do_nothing(void *data)
{
	UNUSED(data);
}

AVLTree *AVLTree_Create(GCompareFunc compare, GDestroyNotify destroy)
{
	AVLTree *tree;
	
	if (compare == 0)
		compare = ComparePointer;
	if (destroy == 0)
		destroy = do_nothing;
	tree = g_new(AVLTree, 1);
	if (tree == NULL)
		return NULL;
	tree->root = NULL;
	tree->count = 0;
	tree->compare = compare;
	tree->destroy = destroy;
	return tree;
}

/*** ---------------------------------------------------------------------- ***/

static void DeleteNode(AVLTree *tree, AVLTreeNode *node)
{
	if (node != NULL)
	{
		if (node->left != NULL)
			DeleteNode(tree, node->left);
		if (node->right != NULL)
			DeleteNode(tree, node->right);
		AVLTreeNode_Destroy(tree, node);
	}
}

void AVLTree_Destroy(AVLTree *tree)
{
	if (tree == NULL)
		return;
	DeleteNode(tree, tree->root);
	g_free(tree);
}
