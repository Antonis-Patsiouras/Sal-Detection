function imrc = Assignment(img,SS,pix)

imrc = zeros(size(img,1),size(img,2));
for i=1:size(SS,1)
    
    region = cell2mat(pix(i));
    
    for j=1:size(region,1)
        
        x1 = region(j,2);
        y1 = region(j,1);
        imrc(x1,y1) = SS(i);
    end
end

MAX = max(imrc(:));
imrc = imrc./MAX;
end