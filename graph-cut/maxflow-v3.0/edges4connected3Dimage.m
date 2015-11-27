function E = edges4connected3Dimage(height,width,depth)

% EDGE4CONNECTED Creates edges where each node
%   is connected to its four adjacent neighbors on a 
%   height x width grid.
%   E - a vector in which each row i represents an edge
%   E(i,1) --> E(i,2). The edges are listed is in the following 
%   neighbor order: down,up,right,left, where nodes 
%   indices are taken column-major.
%
%   (c) 2008 Michael Rubinstein, WDI R&D and IDC
%   $Revision$
%   $Date$
%

s = [width, height, depth];
w = width;
h = height;
d = depth;
subs = zeros(3*w*h*d - w*h - h*d - d*w, 6);
c = 1;

for d = 1:depth
    for h = 1:height
        for w = 1:width-1
            subs(c, :) = [w h d (w+1) h d];
            c = c+1;
%             E = cat(1, E, ( [sub2ind(s, w, h, d) sub2ind(s, w+1, h, d)] ));
        end
    end
end


    
for d = 1:depth
    for h = 1:height-1
        for w = 1:width
            subs(c, :) = [w h d w (h+1) d];
            c = c+1;
%             E = cat(1, E, ( [sub2ind(s, w, h, d) sub2ind(s, w, h+1, d)] ));
        end
    end
end


    
for d = 1:depth-1
    for h = 1:height
        for w = 1:width
            subs(c, :) =[w h d w h (d+1)];
            c = c+1;
%             E = cat(1, E, ( [sub2ind(s, w, h, d) sub2ind(s, w, h, d+1)] ));
        end
    end
end

starts = sub2ind(s, subs(:, 1), subs(:, 2), subs(:, 3));
ends = sub2ind(s, subs(:, 4), subs(:, 5), subs(:, 6));

E = [[starts, ends]; [ends, starts]];

end