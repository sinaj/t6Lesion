% Using data file evaluateTestData1.mat we should have the following:
% fNeg = 3
% fPos = 4
% tPos = 3
% tNeg = 13 + 12 + 13 = 38
% dsc = (2tPos)/(fPos + fNeg + 2tPos) = (2*3)/(4 + 3 + 2*3) = 6/13 = 0.4615
% sensitivity = tPos / (tPos + fNeg) = 3 / (3 + 3) = 0.5
% specificity = tNeg / (fPos + tNeg) = 38 / (4 + 38) = 38/42 = 0.9048
% accuracy = (tPos + tNeg) / (tPos + fPos + fNeg + tNeg) = (3 + 38) / (48) = 41/48 = 0.8542

load('evaluateTestData1.mat');

dsc = evaluate(groundTruth, detections, 'dsc')
sensitivity = evaluate(groundTruth, detections, 'sensitivity')
specificity = evaluate(groundTruth, detections, 'specificity')
accuracy = evaluate(groundTruth, detections, 'accuracy')