%% Clear and start
clear;
h = 200;
w = 200;

counterlimit = 100000;
FOV = 4;
overlapimg = {'N = 1', 'N = 2', 'N = 3', 'N = 4_2', 'N = 5_2', 'N = 6', 'N = 7'};
overlapimgfold = {'n1', 'n2', 'n3', 'n4', 'n5', 'n6', 'n7'};
pathimgsingle = fullfile(pwd, 'overlay', ['tFOV', num2str(FOV)], ['N = 1', '.jpg']);
imgsingle = imread(pathimgsingle);
%% Create required directories
dirconfirm = input(' Are you sure you want to create new set of directories ? ', 's');
if(dirconfirm == 'y')
    for k = 1:7
        pathpositivedir  = fullfile(pwd,'dataset_cropped',['tFOV' num2str(FOV)], 'positives', overlapimgfold{k});
        pathnegativedir  = fullfile(pwd,'dataset_cropped',['tFOV' num2str(FOV)], 'negatives', overlapimgfold{k});
        if ~isfolder(pathpositivedir)
            mkdir(pathpositivedir)
        end
        if ~isfolder(pathnegativedir)
            mkdir(pathnegativedir)
        end
    end
end


%% Create imgoverlap cell
for k = 1:7
    pathimgoverlap = fullfile(pwd, 'overlay', ['tFOV', num2str(FOV)], [overlapimg{k}, '.jpg']);
    imgoverlap{k} = imread(pathimgoverlap);
end

%% Visualize img manually to set the image bounds
figure
imshow(imgsingle)

title('Visualize the single image to set the manual bounds');
%% Image annotate
figure(979)
stepsizex = 10;
stepsizey = 10;
annotatersave = cell(size(imgsingle, 1), size(imgsingle, 2));

for j = 160:stepsizey:280
    for i = 230:stepsizex:520
        
    croppedfovsingle = imcrop(imgsingle, [i-1, j-1, w, h]);
    subplot(2, 1, 1)
    hold on 
        imshow(imgsingle);
        rectangle('Position',[i-1, j-1, w, h])
    hold off
    subplot(2, 1, 2)
        imshow(croppedfovsingle);
    
    tp = input("Do you see WBC (y/n) ", 's');
    
    %annotatersave{j, i} = tp;
    
    for k =1:7
        croppedfovoverlap{k} = imcrop(imgoverlap{k}, [i-1, j-1, w, h]);
    end
        switch(tp)
            case 'y'
              for k =1:7
                imwrite(croppedfovoverlap{k}, fullfile(pwd,'dataset_cropped',['tFOV' num2str(FOV)], 'positives', overlapimgfold{k},[num2str(i) num2str(j), num2str(FOV), overlapimg{k}, '.jpg']));
              end 
                
            case 'q'
                break
            
            case 'f'
                i = i+100;
                continue
            case 'c'
                
                continue
            otherwise 
                
              for k =1:7
                imwrite(croppedfovoverlap{k}, fullfile(pwd,'dataset_cropped',['tFOV' num2str(FOV)], 'negatives',overlapimgfold{k}, [num2str(i) num2str(j), num2str(FOV), overlapimg{k}, '.jpg']));
              end
    
        end
        clc 
    end
    
end
