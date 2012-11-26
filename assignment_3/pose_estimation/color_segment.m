%% Hue segments the image in n colors

function [cl_angles, cl_center , cl_type] = color_segment (color_s, img, sat, lum, max_pxarea, min_pxarea, img_center, radius, radius_inner , stdthreshold)

img_cols = size(img, 2);
img_rows = size(img, 1);

%% dim of max colors
color_segm_col = size(color_s, 1);

%% tranform image color space 
img_hsv = rgb2hsv(img);

%% take channels
img_h = img_hsv(:,:,1);
img_s = img_hsv(:,:,2);
img_l = img_hsv(:,:,3);

% img_h(175, 53)
%  img_h(72,268)
% img_h(234,234)

valid_ha = ( ( img_h(:,:) >= color_s(1,1)) & ( img_h(:,:) < color_s(1,2)) );
valid_hb = ( ( img_h(:,:) >= color_s(2,1)) & ( img_h(:,:) < color_s(2,2)) );
valid_sa = ( ( img_s(:,:) >= sat(1) ) & ( img_s(:,:) < sat(2) ) );
valid_sb = ( ( img_s(:,:) >= sat(1) ) & ( img_s(:,:) < sat(2) ) );
valid_la = ( ( img_l(:,:) >= lum(1) ) & ( img_l(:,:) < lum(2) ) );
valid_lb = ( ( img_l(:,:) >= lum(1) ) & ( img_l(:,:) < lum(2) ) );

valid_a = valid_ha .* valid_sa .* valid_la;
valid_b = valid_hb .* valid_sb .* valid_lb;


%% label
[L_a, num_a] = bwlabel(valid_a, 8);
[L_b, num_b] = bwlabel(valid_b, 8);
% [L_a, num_a] = bwlabel(valid_a, 4);
% [L_b, num_b] = bwlabel(valid_b, 4);


figure(13)
subplot(2,1,1);
axis equal;
RGB = label2rgb(L_a);
imshow(RGB);
subplot(2,1,2);
axis equal;
RGB = label2rgb(L_b);
imshow(RGB);
figure(12)
hold on

%% center accumulator
cl_center = [];
cl_angles = [];
cl_type = [];

%% filter too small cluster
%% channel A
for i = 1:num_a,
    idx = find(L_a == i);
   
    if ( (size( (idx),1) < min_pxarea) || (size( (idx),1) > max_pxarea) )
        L_a(idx) = 0;
    else
        c_col = (floor(idx / img_rows) + 1);
        c_row = (mod(idx, img_rows) + 1);

        cc2 = sum(c_col) / size( (idx),1);
        cc1 = sum(c_row) / size( (idx),1);       

	cstd = std(c_col);
	rstd = std(c_row);

	cc = img_center(1);	
	rc = img_center(2);	
%         if( (cc1 - radius)^2 + (cc2 - radius)^2 < radius^2)
%             if( (cc1 - radius)^2 + (cc2 - radius)^2 > radius_inner^2)
%                 cl_center = [cl_center; [cc1, cc2]];
%             end    
%         end
	if( (cc1 - rc)^2 + (cc2 - cc)^2 < radius^2)
		if( (cc1 - rc)^2 + (cc2 - cc)^2 > radius_inner^2)
			if ( (cstd <= stdthreshold) && (rstd <= stdthreshold) )
				[size( (idx),1)	 cstd rstd 1]
				cl_center = [cl_center; [cc1, cc2]];
				cl_type = [cl_type ; 1];  % 1st color = green
			end;
		end
	end
    end    
end

%% channel B
for i = 1:num_b,
    idx = find(L_b == i);
    
    if ( (size( (idx),1) < min_pxarea) || (size( (idx),1) > max_pxarea) )
        L_b(idx) = 0;
    else    
        c_col = (floor(idx / img_rows) + 1);
        c_row = (mod(idx, img_rows) + 1);

	cstd = std(c_col);
	rstd = std(c_row);
	
        cc2 = sum(c_col) / size( (idx),1);
        cc1 = sum(c_row) / size( (idx),1);       
        
	cc = img_center(1);	
	rc = img_center(2);	
%         if( (cc1 - radius)^2 + (cc2 - radius)^2 < radius^2)
%             if( (cc1 - radius)^2 + (cc2 - radius)^2 > radius_inner^2)
%                 cl_center = [cl_center; [cc1, cc2]];
%             end    
%         end             
	if( (cc1 - rc)^2 + (cc2 - cc)^2 < radius^2)
		if( (cc1 - rc)^2 + (cc2 - cc)^2 > radius_inner^2)
			if ( (cstd <= stdthreshold) && (rstd <= stdthreshold) )
				[ size( (idx),1) cstd rstd 2 ]
				cl_center = [cl_center; [cc1, cc2]];
				cl_type = [cl_type ; 2];  % 2nd color = blue
			end;
		end
	end
    end
end


%%
% ***** DEBUG **********8
% figure(343)
% subplot(2,1,1);
% RGB = label2rgb(L_a);
% imshow(RGB);
% subplot(2,1,2);
% RGB = label2rgb(L_b);
% imshow(RGB);
% figure(2)
% hold on
% hold on
% plot(cl_center(:, 2),  cl_center(:, 1), 'bx', 'MarkerSize', 5);
% % plot(img_center(:, 2),  img_center(:, 1), 'rx', 'MarkerSize', 5);
% pause
%% atan is (deltarow, deltacol)
if(isempty(cl_center) ~= 1)
    
%     cl_angles = atan2(cl_center(:, 1) - img_center(:, 1), cl_center(:, 2) - img_center(:, 2));
    cl_angles = atan2(cl_center(:, 1) - img_center(:, 2), cl_center(:, 2) - img_center(:, 1));

    for i=1:size(cl_center,1)
      if cl_angles(i) > pi, cl_angles(i) = cl_angles(i) - pi*2; end
      if cl_angles(i) <= -pi, cl_angles(i) = cl_angles(i) + pi*2; end
    end

end