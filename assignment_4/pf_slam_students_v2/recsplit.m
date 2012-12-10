% Input:   XY - [2,N]: X,Y coordinates
% Output:  NLines - Number of lines extracted
%          r - [NLines]: line parameter
%          alpha - [NLines]: line parameter

function [NLines, r, alpha, segend, seglen] = recsplit(XY)
  
  configfile;
  
  % Perform clustering
  [NClusters, ClusterIdx] = cluster(XY);
  
  NLines = 0;
  r = [];
  alpha = [];
  PointIdx = [];
  
  % Extract line segments from the clusters
  for i=1:NClusters
    
    [NLines_i, r_i, alpha_i, PointIdx_i] = ...
	Split(XY, ClusterIdx(i,1), ClusterIdx(i,2));
    
    NLines = NLines + NLines_i;
    r = [r; r_i];
    alpha = [alpha ; alpha_i];
    PointIdx = [PointIdx ; PointIdx_i];
    
  end
  
  % No merging is performed.
  
  % Compute endpoints/lengths of the segments
  segend = [];
  seglen = [];
  for i=1:NLines
    % First endpoint
    d = r(i) - XY(1, PointIdx(i,1)) * cos(alpha(i)) - ...
	XY(2, PointIdx(i,1)) * sin(alpha(i));
    segend(i,1) = XY(1, PointIdx(i,1)) + d * cos(alpha(i));
    segend(i,2) = XY(2, PointIdx(i,1)) + d * sin(alpha(i));
  
    % Second endpoint
    d = r(i) - XY(1, PointIdx(i,2)) * cos(alpha(i)) - ...
	XY(2, PointIdx(i,2)) * sin(alpha(i));
    segend(i,3) = XY(1, PointIdx(i,2)) + d * cos(alpha(i));
    segend(i,4) = XY(2, PointIdx(i,2)) + d * sin(alpha(i));
    
    % Length
    seglen(i) = sqrt((segend(i,1) - segend(i,3))^2 + ...
		     (segend(i,2) - segend(i,4))^2);
  end
  
  % Removing short segments
  GoodSegIdx = find(seglen >= MINSEGLENGTH);
  NLines = length(GoodSegIdx);
  r = r(GoodSegIdx);
  alpha = alpha(GoodSegIdx);
  segend = segend(GoodSegIdx, :);
  seglen = seglen(GoodSegIdx);
  
  return  % function RecSplit
  
%---------------------------------------------------------------------
% Main splitting function
function [NSegs, r, alpha, idx] = Split(XY, startIdx, endIdx)
  
  configfile;

  % Number of input points
  N = endIdx - startIdx + 1;
  
  % If there are not sufficient number of points
  if (N < MINSEGPOINTS)
    NSegs = 0;
    r = [];
    alpha = [];
    idx = [];
    return
  end
  
  % Fit a line using the N points
  [r, alpha] = FitLine(XY(:, startIdx:endIdx));
  
  % Compute the distances from the points to the fitted line
  d = CompDistPointsToLine(XY(:, startIdx:endIdx), r, alpha);

  % Find the splitting position (if there is)
  SplitPos = FindSplitPos(N, d);
  
  % If found a splitting point
  if (SplitPos ~= -1)
    [NSegs1, r1, alpha1, idx1] = Split(XY, startIdx, SplitPos+startIdx-1);
    [NSegs2, r2, alpha2, idx2] = Split(XY, SplitPos+startIdx-1, endIdx);
    NSegs = NSegs1 + NSegs2;
    r = [r1; r2];
    alpha = [alpha1; alpha2];
    idx = [idx1; idx2];
    
  % Or no need to split
  else
    idx = [startIdx, endIdx];
    NSegs = 1;
  end
  
  return  % function Split


%---------------------------------------------------------------------
% This function computes the distances from the input points to
% an input line.
% Note that here we can have negative values for distances (to indicate
% which side relative to the line the point belongs).
% Input:   XY - [2,N] : input points
%          r, alpha: line parameters
% Output:  d - [N]: the distances from the input points to the line.

function d = CompDistPointsToLine(XY, r, alpha)
  
  cosA = cos(alpha);
  sinA = sin(alpha);
  
  N = size(XY,2);
  d = zeros(N,1);
  
  xcosA = XY(1,:) * cosA;
  ysinA = XY(2,:) * sinA;
  d = xcosA + ysinA - r;
  
  return  % function ComDistPointsToLine
  


  
%---------------------------------------------------------------------

function SplitPos = FindSplitPos(N, d)

  configfile;
  
  % Initialize
  SplitPos = -1;
  maxSum = 0;
  
  if (d(1) < 0), side = 1.0; else side = -1.0; end;
  
  splittingside = 0;
  
  % Find the local maximum set (2 points)
  for i=1:N-1,
    if (d(i)*side > INLIERTHRESHOLD && d(i+1)*side > INLIERTHRESHOLD)
      
      splittingside = 1;
      AbsDi = abs(d(i));
      AbsDi1 = abs(d(i+1));
      if (AbsDi + AbsDi1) > maxSum
	maxSum = AbsDi + AbsDi1;
	if (AbsDi>AbsDi1), SplitPos = i; else SplitPos = i+1; end
      end
    
    else
      if (splittingside == 1 && ...
	  d(i)*side < INLIERTHRESHOLD && d(i+1)*side < INLIERTHRESHOLD)
	break;
      end
    end
  end


  % If the split position is toward either end of the segment, find
  % otherway to split.
  if (SplitPos ~= -1 && (SplitPos < 3 || SplitPos > N-2))
    [maxD, SplitPos] = max(abs(d));
    if (SplitPos == 1), SplitPos = 2; end;
    if (SplitPos == N), SplitPos = N-1; end;
  end
  
  return  % function SplitPos
  
%---------------------------------------------------------------------

