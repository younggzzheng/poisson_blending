% Starter script for CSCI 1290 project on Poisson blending. 
% Written by James Hays and Pat Doran.
% imblend.m is the function where you will implement your blending method.
% By default, imblend.m performs a direct composite.

close all
clear variables

data_dir = './../data';
out_dir = './results';

%there are four inputs for each compositing operation -- 
% 1. 'source' image. Parts of this image will be inserted into 'target'
% 2. 'mask' image. This binary image, the same size as 'source', specifies
%     which pixels will be copied to 'target'
% 3. 'target' image. This is the destination for the 'source' pixels under
%     the 'mask'
% 4. 'offset' vector. This specifies how much to translate the 'source'
%     pixels when copying them to 'target'. These vectors are hard coded
%     below for the default test cases. They are of the form [y, x] where
%     positive values mean shifts down and to the right, respectively.

offset = cell(6,1);
offset{1} = [ 210  10 ];
offset{2} = [  10  28 ];
offset{3} = [ 140 80 ];
offset{4} = [  -40  90 ];
offset{5} = [  60 100 ];
offset{6} = [ -28  88 ];
offset{7} = [ -300  -100 ];


% for i = 1:length(offset)
for i = 7:7

    source = imread(sprintf('%s/source_%02d.jpg',data_dir,i));
    mask   = imread(sprintf('%s/mask_%02d.jpg',data_dir,i));
    target = imread(sprintf('%s/target_%02d.jpg',data_dir,i));
    
    source = im2double(source);
    mask = round(im2double(mask));
    target = im2double(target);

    % Interactive mask
     mask = getmask(source);
    
    [source, mask, target] = fiximages(source, mask, target, offset{i});
    
    output = imblend(source, mask, target);
%     output = source .* mask + target .* ~mask;

    figure(i)
    imshow(output)
    
    imwrite(output,sprintf('%s/result_%02d.jpg',out_dir,i),'jpg','Quality',95);
end

