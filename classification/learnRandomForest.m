function [ model ] = learnRandomForest( X, Y )

tree_num = 5;

model = TreeBagger(tree_num, X, Y, 'OOBPred', 'On');
