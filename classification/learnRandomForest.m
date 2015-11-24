function [ model ] = learnRandomForest( X, Y )

tree_num = 30;

model = TreeBagger(tree_num, X, Y, 'OOBPred', 'On');
