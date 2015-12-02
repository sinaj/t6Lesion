function show( mat, repeat_num )

if nargin < 2
    repeat_num = 1;
end

if length(size(mat)) == 2
    mat = reshape(mat, 217, 181, size(mat, 1)/(217*181));
end

for j = 1:repeat_num
    for i = 1:size(mat, 3)
        imshow(mat(:, :, i));
        pause;
    end
end

end

