function [d] =  conditionChecker(imgsingle, x, y, h, w, roilist)



    for k = 1:size(roilist, 1)
    
       
        
        [xcSlid, ycSlid] = centerCatcher(x, y, h, w); %xcSlid, ycSlid     
        [xcircle, ycircle, radius] = roiExtracter(roilist{k, 1}, roilist{k, 2});
        d{k} = roiInsideSlidingwindowchecker(xcSlid, ycSlid, xcircle, ycircle, radius, h, w);
        
    end
        

        
    function[xc, yc] = centerCatcher(x, y, h, w)
        
        xc = x+w*0.5;
        yc = y+h*0.5;
        

    end


    function[xcircle, ycircle, radius] = roiExtracter(xy, r)
        
       xcircle = xy(1);
       ycircle = xy(2);
       radius = r;
       
       
    end


    function [d] =  roiInsideSlidingwindowchecker(xcSlid, ycSlid, xcircle, ycircle, radius, h, w) %Check if the roi lies inside the Sliding Window or not
        
        xdist = abs(xcircle-xcSlid);
        ydist = abs(ycircle-ycSlid);
        
        
            
        if((xdist<(0.5*w-radius))&&(ydist<(0.5*h-radius)))
             d = 'y';
        elseif((xdist>(0.5*w+radius))|(ydist>(0.5*h+radius)))
            d = 'n';
        else
             d = 'c';
        end
            
        
        
        
    end

         
end