#ifndef __AVLTREE_H__
#define __AVLTREE_H__ 1

typedef struct _AVLTreeNode AVLTreeNode;
struct _AVLTreeNode {
	AVLTreeNode *parent;
	AVLTreeNode *left;
	AVLTreeNode *right;
	void *data;
	int balance;
};

AVLTreeNode *AVLTreeNode_Create(void *data);

typedef struct _AVLTree AVLTree;

int AVLTree_Depth(AVLTreeNode *node);

AVLTreeNode *AVLTree_Find(AVLTree *tree, void *data);
AVLTreeNode *AVLTree_FindSuccessor(AVLTreeNode *node);
AVLTreeNode *AVLTree_FindPrecessor(AVLTreeNode *node);
AVLTreeNode *AVLTree_FindLowest(AVLTree *tree);
AVLTreeNode *AVLTree_FindHighest(AVLTree *tree);
AVLTreeNode *AVLTree_FindNearest(AVLTree *tree, void *data);
AVLTreeNode *AVLTree_FindPointer(AVLTree *tree, void *data);
AVLTreeNode *AVLTree_FindLeftMost(AVLTree *tree, void *data);
AVLTreeNode *AVLTree_FindRightMost(AVLTree *tree, void *data);
AVLTreeNode *AVLTree_FindLeftMostSameKey(AVLTree *tree, AVLTreeNode *node);
AVLTreeNode *AVLTree_FindRightMostSameKey(AVLTree *tree, AVLTreeNode *node);
void AVLTree_AddNode(AVLTree *tree, AVLTreeNode *node);
AVLTreeNode *AVLTree_Add(AVLTree *tree, void *data);
void AVLTree_Delete(AVLTree *tree, AVLTreeNode *node);
void AVLTree_Remove(AVLTree *tree, void *data);
void AVLTree_RemovePointer(AVLTree *tree, void *data);
void AVLTree_MoveDataLeftMost(AVLTree *tree, AVLTreeNode **pnode);
void AVLTree_MoveDataRightMost(AVLTree *tree, AVLTreeNode **pnode);
int AVLTree_ConsistencyCheck(AVLTree *tree);

AVLTree *AVLTree_Create(GCompareFunc compare, GDestroyNotify destroy);
void AVLTree_Destroy(AVLTree *tree);

#endif
