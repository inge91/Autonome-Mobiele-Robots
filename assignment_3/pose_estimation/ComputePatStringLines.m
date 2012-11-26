% this function computes the pattern string based on the extracted segments
% and openings. The input segments are in a sequence. 
function  S = ComputePatStringLines(NLines, segend, seglen)

configfile_lines;  

S = [];

if NLines == 0
  S = repmat([0], 1, round(360/OPENRES));
else
  for i=1:NLines
    
    % append segment pattern 
    a = ComputeAngle(segend(i, 1:2), segend(i,3:4));
    a = rad2deg(abs(a));
    S = [S, repmat([1], 1, round(a/SEGRES))];
    
    % append opening pattern
    a = ComputeAngle(segend(i, 3:4), segend(mod(i,NLines)+1, 1:2));
    a = rad2deg(abs(a));
    S = [S, repmat([0], 1, round(a/OPENRES))];
    
  end
end

S

return


% This function computes the angle between 2 input points and the origin.
% Output: -pi < a <= pi
% The output condition always holds for a segment. However, for an opening > 180 degree,
% the angle is subtracted by 180 !!
function a = ComputeAngle(XY1, XY2)
  
  a = atan2(XY1(2), XY1(1)) - atan2(XY2(2), XY2(1));
  
  if a > pi, a = a - pi*2; end
  if a <= -pi, a = a + pi*2; end
  
return  

