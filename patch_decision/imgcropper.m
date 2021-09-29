%% functions
function imgcropper(imgsingle)
f = figure(97);
imshow(imgsingle)
title('Visualize the single image to set the manual bounds');
% ax = axes(f);
% ax.Units = 'pixels';
% ax.Position = [0 0  1100 2000];
c = uicontrol(f, 'Style','edit');
c.String
c.Callback =@noWbc;
c.Position = [500 15  20, 20];
    function noWbc(c, src,event)
        assignin('base', 'wbcno', c.String)
    end
d = uicontrol(f, 'Style','pushbutton');
d.String = "Create Masks";
d.Callback = @createMaskfromImage;
d.Position = [600 15  80, 20];
    function    createMaskfromImage(src, event)
        wbcno = evalin('base', 'wbcno');
        figure;
        %imshow(imgsingle)
        %title('This is the image title')
        %for i = 1:str2num(wbcno)
            
            masklist = ones(size(imgsingle, 1), size(imgsingle, 2), str2num(wbcno));
        %end
        roilist = cell(str2num(wbcno), 2);
        
        for i =1:str2num(wbcno)
            
            figure(979)
            
            imshow(imgsingle);
            roi = drawcircle('InteractionsAllowed', 'all');
            ans = input('Are you satisfied with the mask[y/n]', 's');
            
            if(ans=='y')
                roilist{i, 1} = roi.Center;
                roilist{i, 2} = roi.Radius;
                masklist(:, :, i) = createMask(roi);
                imshow(masklist(:, :, i))
            
            else
                i = i-1;
            end
            
            
        end
       assignin('base', 'masklist', masklist);
       assignin('base', 'roilist', roilist);
    end
    
end