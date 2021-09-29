%% Imresize checker, if some of the output image do not match the required dimension and are off by a pixel
clear
FOV = (1:35);
overlap = {'n1', 'n2', 'n3','n4', 'n5', 'n6', 'n7'}; 

for FOVNUM = 1:35
for overlapnum = 1:7
filelist = dir(fullfile('D:\final_data_set\dataset_cropped', ['tFOV', num2str(FOVNUM)], 'negatives', overlap{overlapnum}, '*.jpg'));
tic
disp([FOVNUM, overlapnum])
for i = 1:numel(filelist)
    img = imread(fullfile(filelist(i).folder, filelist(i).name));
    if((size(img, 1)<201)||(size(img, 2)<201))
        imwrite(imresize(img, [201, 201]), fullfile(filelist(i).folder, filelist(i).name))
    end
end
toc

end
end