%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT 1. W        : Weight matrix
%       2. v        : [image size,1] initial guess
%       3. p        : projections
%       4. numIter  : The number of interations
%
% OUTPUT 1. retV : [image size, numIter]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function retV = ml_em(W,v,p,numIter)

% Initialization
retV = zeros(length(v),1);
%retV(:,1) = v(:);

sumCol = sum(W)'; % a row vector of the sums of each column
Wt = W';          % Transpose of the weight matrix

index0 = find(sumCol == 0);
sumCol(index0) =0.1; 

% Iteration
for k = 2:numIter
    proj = W*v;                  % Projection into pixel
    index0 = find(proj==0);
    proj(index0) = 0.1;
    backProj = Wt * (p./proj);   % Back Projection into voxel
    %backProj = p./proj;
    v = v .* (backProj ./ sumCol);
    retV = v;
end

