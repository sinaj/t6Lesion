function [measureVal] = evaluate(groundTruth, detections, measure)
%EVALUATE This function allows for a detailed comparison of groundTruth and
% lesion detections. 
%   groundTruth is an m by n by k matrix of 0s (no lesion) and 1s (lesion)
%   detections must be the same size as the groundTruth matrix and contains
%    similiar restrictions (bit-field lesion/no lesion)
%   measure is a string describing the evaluation to use. This may be
%   temporary, as it could be better to just output multiple arguments. For
%   now, the following are the potential scores:
%   "dsc" Dice Similarity Coefficient
%   "sensitivity"
%   "specificity" 
%   "accuracy"
%   "detections" The number of lesions that we had detections inside.
%   "tp" true positives
%   "tn" true negatives
%   "fp" false positives
%   "fn" false negatives

% My approach to determining True Positives (TP), True Negatives (TN),
% False Positives (FP) and False Negatives(FN) is similar to the approach
% found here: http://www.mathworks.com/matlabcentral/fileexchange/36322-inspire-utility-to-calculate-dice-coefficient/content/DiceSimilarity2DImage.m

% In this matrix, each spot has 4 possible values:
% 3: False Negative - ground truth has a lesion, but it wasn't detected.
% 2: False Positive - we detected a lesion but there wasn't one.
% 1: True Positive - both the truth and the detection have a lesion here.
% 0: True Negative - Neither the truth or the detection have a lesion here.
measureVal = 0;

accuracyMatrix = abs(3 * groundTruth - 2 * detections);

tNeg = sum(accuracyMatrix(:) == 0);
tPos = sum(accuracyMatrix(:) == 1);
fPos = sum(accuracyMatrix(:) == 2);
fNeg = sum(accuracyMatrix(:) == 3);

switch measure
    case 'tp'
        measureVal = tPos;
        
    case 'tn'
        measureVal = tNeg;
    
    case 'fp'
        measureVal = fPos;
        
    case 'fn'
        measureVal = fNeg;
        
    case 'dsc'
        measureVal = (2 * tPos) / (fPos + fNeg + 2 * tPos);
        
    case 'sensitivity'
        measureVal = tPos / (tPos + fNeg);
        
    case 'specificity'
        measureVal = tNeg / (fPos + tNeg);
        
    case 'accuracy'
        measureVal = (tPos + tNeg) / (tPos + fPos + fNeg + tNeg);
        
    case 'detections'
        % Note that detections doesn't work when the ground truth is put
        % end to end. It has to be an actual brain matrix.
        [labelled, nLabelled] = bwlabeln(groundTruth);
        labelled = labelled .* (-1 * detections);
        
        % Count the number of different negative numbers. This is our
        % detections.
        [a, values] = hist(labelled, unique(labelled));
        nNeg = sum(values < 0);
        
        measureVal = nNeg / nLabelled;
        
    otherwise
        fprintf('Error: unknown measure paramater %s.', measure);
end


end

