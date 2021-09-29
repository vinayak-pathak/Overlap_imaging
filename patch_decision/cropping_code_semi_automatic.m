%% Clear and start
clear;
h = 200;
w = 200;

counterlimit = 100000;
FOV = 8;
overlapimg = {'N = 1', 'N = 2', 'N = 3', 'N = 4', 'N = 5', 'N = 6', 'N = 7'};
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
%% Visualize image manually to set it out...
imgcropper(imgsingle)

%% Create imgoverlap cell
for k = 1:7
    pathimgoverlap = fullfile(pwd, 'overlay', ['tFOV', num2str(FOV)], [overlapimg{k}, '.jpg']);
    imgoverlap{k} = imread(pathimgoverlap);
end

%% Image annotate
%figure(9911)
stepsizex = 10; % Step Size for sliding window movement x direction
stepsizey = 10; % Step Size for sliding window movement y direction
annotatersave = cell(numel(1:stepsizex:size(imgsingle, 1)), numel(1:stepsizey:size(imgsingle, 2))); % Va
%%
for j = 1:stepsizey:size(imgsingle, 1)-h
    
    for i = 1:stepsizex:size(imgsingle, 2)-w
        
    croppedfovsingle = imcrop(imgsingle, [i-1, j-1, w, h]);
%     subplot(2, 1, 1)
%     hold on 
%         imshow(imgsingle);
%         rectangle('Position',[i-1, j-1, w, h])
%         title('Sliding Window over pathology slide')
%    hold off
%     subplot(2, 1, 2)
%         imshow(croppedfovsingle);
    
    
    
    for k =1:7
        croppedfovoverlap{k} = imcrop(imgoverlap{k}, [i-1, j-1, w, h]);
    end
    
    d = conditionChecker(imgsingle, i-1, j-1, h, w, roilist); % d stores the decision at each 
    tp = outputcondition(d); %tp checks if there is a true positive or not;
    annotatersave{j, i} = tp;
    
        switch(tp)
            case 'y'
                for k =1:7
                    imwrite(imresize(croppedfovoverlap{k}, [201, 201]), fullfile(pwd,'dataset_cropped',['tFOV' num2str(FOV)], 'positives',overlapimgfold{k}, [num2str(i),'_', num2str(j),'_', num2str(FOV),'_', overlapimg{k},'_', '.jpg']));
                end 
                %title(strcat('Decision = ', tp))
                
 
            case 'n'
                for k =1:7
                    imwrite(imresize(croppedfovoverlap{k}, [201, 201]), fullfile(pwd,'dataset_cropped',['tFOV' num2str(FOV)], 'negatives',overlapimgfold{k}, [num2str(i),'_', num2str(j),'_', num2str(FOV),'_', overlapimg{k},'_', '.jpg']));
                end
                %title(strcat('Decision = ', tp))
            otherwise
 
        end
            
                %printf("%.02f / %.02f", progress, totaliter)
                
         prog = [i, j];
         disp(prog)
    end
    %progress = (i+1)*(j+1)-1;
            
    %totaliter = ((size(imgsingle, 1)-h)*size(imgsingle, 2)-w)/(stepsizex*stepsizey);
    
    clc
end
save(fullfile(pwd,'dataset_cropped',['tFOV' num2str(FOV)], 'decision.mat'), 'annotatersave', 'roilist')
%% Functions d checker
function [tp] = outputcondition(d)
if(any(strcmp(d, 'y'))==1)
    tp = 'y';
    
elseif(any(strcmp(d, 'c'))==1)
    tp = 'c';
    
elseif(all(strcmp(d, 'n'))==1)
    tp = 'n';
end

end
