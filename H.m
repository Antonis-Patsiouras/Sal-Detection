function [imhc,Sal] = H (path,filename)
%% 
f = waitbar(0,'Preprocessing Your Image Please Wait...');
pause(.05)

main = cd (path);
[img, map] = imread([path,filename]);
cd (main);

s=size(img,1)*size(img,2);
%% 
waitbar(.1,f,'Reducing Colors');
pause(.05)

imgq = KMeansColorReduction (img,map,12);

lab_img = rgb2lab(imgq);

L = lab_img(:,:,1);
A = lab_img(:,:,2);
B = lab_img(:,:,3);
%% 
waitbar(.2,f,'Initializing');
pause(.05)

fpix = Clr_Freq(img); 
v=1;
pix=zeros(s,4);

for i = 1:size(lab_img,1)
    for j = 1:size(lab_img,2)
        pix(v,1)=L(i,j);
        pix(v,2)=A(i,j);
        pix(v,3)=B(i,j);
        pix(v,4)=fpix(i,j);
        v=v+1;
    end
end
%% 

pix( ~any(pix(:,1),2), : ) = [];
pix = unique(pix(:,:),'rows','stable');
%% 

n = size(pix,1);
Sc = zeros(n);

imhc = zeros(size(lab_img,1),size(lab_img,2));
%% 
Dist = zeros(n,n);

waitbar(.4,f,'Color Distances Computing');
pause(.05)

for i = 1:n
    for c=1:n
        Dist(i,c) = cmcde(pix(i,1:3),pix(c,1:3));
        Sc(i) = Sc(i) + Dist(i,c)*pix(c,4);        
    end
    
    [row,col] = find((lab_img(:,:,1) == pix(i,1))&(lab_img(:,:,2) == pix(i,2))&(lab_img(:,:,3) == pix(i,3)));
    
    for j = 1:size(row,1)
        imhc(row(j),col(j)) = Sc(i);
    end
    
end

MAX = max(imhc(:));
imhc = imhc./MAX;
%% 
T = zeros(n);
m = n/4;
m = int8(m);
m = double(m);

[D,I] = sort(Dist);
%%

SS = zeros(n);
S = zeros(n);
Sal = zeros(n,n);

waitbar(.6,f,'Calculating Saliency Values');
pause(.05)

for i = 1:n
    
    for c=1:m
        T(i) = T(i) + D(c,i);
    end
    
    for c=1:m
        idx = I(c,i);
        SS(i) = SS(i) + ( (T(i) - D(c,i)) * Sc(idx));
    end
    
    S(i) = (1 / ((m-1) * T(i)) ) * SS(i);
    
    [row,col] = find((lab_img(:,:,1) == pix(i,1))&(lab_img(:,:,2) == pix(i,2))&(lab_img(:,:,3) == pix(i,3)));
    
    for l = 1:size(row,1)
        imhc(row(l),col(l)) = S(i);
        Sal(row(l),col(l)) = S(i);
    end
end

MAX = max(imhc(:));
imhc = imhc./MAX;
%% 
waitbar(.8,f,'Thresholding Saliency Map');
pause(.05)

for i=1:4
    avg=mean2(imhc);
    
    fseed = imhc(:,:) > avg;
    bseed = imhc(:,:) <= avg;
    
    fmask = zeros(size(imhc));
    bmask = fmask;
    fmask(:,:) = fseed;
    bmask(:,:) = bseed;
    
    roi = false(size(imhc));
    roi(5:end-5,5:end-5,:) = true;
    %roi(size(fmask,1),size(fmask,2)) = true;
    
    L = superpixels(imhc,500);
    
    imhc = grabcut(imhc,L,roi,fmask,bmask);
    imhc = im2uint8(imhc);
    
    t = adaptthresh(imhc,1);
    imhc = imbinarize(imhc,t);
    imhc = im2uint8(imhc);
    
    SE = strel('square', 5);
    imhc = imdilate(imhc,SE);
    imhc = imerode(imhc,SE);
end

waitbar(.9,f,'Finishing Process');
pause(.05)

imhc = im2uint8(imhc);

waitbar(1,f,'Finished');
pause(.05)

close(f)
end