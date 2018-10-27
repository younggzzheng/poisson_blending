function  output = imblend( source, mask, target, transparent )
% figure(1)
% subplot(2,2,1)
% imshow(source);
% title('Source');
%
% subplot(2,2,2)
% imshow(mask);
% title('Mask');
%
% subplot(2,2,3)
% imshow(target);
% title('Target');
%
%
output = target;
% subplot(2,2,4);
% imshow(output);


[height, width, color] = size(source);
A = sparse([],[],[]);
%  To speed up solving A, we can get only the pixels that need to be solved
%  in mask.
mask = mask(:,:,1);
[maskY, maskX] = find(mask);
varNum = zeros(height,width);

% First pixel in mask that is populated gets 1, second 2, etc.
counter = 1;
for i = 1:size(maskY,1)
    varNum(maskY(i), maskX(i)) = counter;
    counter = counter + 1;
end

b = zeros(size(maskY,1),color);
for i = 1:size(maskY,1)
    y = maskY(i);
    x = maskX(i);
    
    %   Laplacian:
    %     0  -1  0
    %     -1  4 -1
    %     0  -1  0
    A(i, varNum(y,x)) = 4;
    
    
    %% bottom
    if (y==1 || x ==1 || y == height || x == width)
        b(i,1) = b(i,1) + target(y,x,1);
        b(i,2) = b(i,2) + target(y,x,2);
        b(i,3) = b(i,3) + target(y,x,3);
    else
        if (mask(y-1,x) == 1) % take gradient
            A(i, varNum(y-1,x)) = -1;
            b(i,1) = b(i,1) - (source(y-1,x,1) - source(y,x,1));
            b(i,2) = b(i,2) - (source(y-1,x,2) - source(y,x,2));
            b(i,3) = b(i,3) - (source(y-1,x,3) - source(y,x,3));
        else % keep target
            b(i,1) = b(i,1) + target(y-1,x,1);
            b(i,2) = b(i,2) + target(y-1,x,2);
            b(i,3) = b(i,3) + target(y-1,x,3);
        end
        %% top
        if (mask(y+1,x) == 1) % take gradient
            A(i, varNum(y+1,x)) = -1;
            b(i,1) = b(i,1) - (source(y+1,x,1) - source(y,x,1));
            b(i,2) = b(i,2) - (source(y+1,x,2) - source(y,x,2));
            b(i,3) = b(i,3) - (source(y+1,x,3) - source(y,x,3));
        else % keep target
            b(i,1) = b(i,1) + target(y+1,x,1);
            b(i,2) = b(i,2) + target(y+1,x,2);
            b(i,3) = b(i,3) + target(y+1,x,3);
        end
        %% left
        if (mask(y,x-1) == 1) % take gradient
            A(i, varNum(y,x-1)) = -1;
            b(i,1) = b(i,1) - (source(y,x-1,1) - source(y,x,1));
            b(i,2) = b(i,2) - (source(y,x-1,2) - source(y,x,2));
            b(i,3) = b(i,3) - (source(y,x-1,3) - source(y,x,3));
        else % keep target
            b(i,1) = b(i,1) + target(y,x-1,1);
            b(i,2) = b(i,2) + target(y,x-1,2);
            b(i,3) = b(i,3) + target(y,x-1,3);
        end
        %% right
        if (mask(y,x+1) == 1) % take gradient
            A(i, varNum(y,x+1)) = -1;
            b(i,1) = b(i,1) - (source(y,x+1,1) - source(y,x,1));
            b(i,2) = b(i,2) - (source(y,x+1,2) - source(y,x,2));
            b(i,3) = b(i,3) - (source(y,x+1,3) - source(y,x,3));
        else % keep target
            b(i,1) = b(i,1) + target(y,x+1,1);
            b(i,2) = b(i,2) + target(y,x+1,2);
            b(i,3) = b(i,3) + target(y,x+1,3);
        end
    end
    
end
Rx = A\b(:,1);
Rmask = Rx > 0;
Rx = Rmask .* Rx;

Gx = A\b(:,2);
Gmask = Gx > 0;
Gx = Gmask .* Gx;

Bx = A\b(:,3);
Bmask = Bx > 0;
Bx = Bmask .* Bx;


for i=1:size(maskY,1)
    y = maskY(i);
    x = maskX(i);
    output(y,x,1) = Rx(i);
    output(y,x,2) = Gx(i);
    output(y,x,3) = Bx(i);
    
end
figure(69)
imshow(output)



%%