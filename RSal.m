function [imrc,imgs,imrcS] = RSal(path,filename)
%% Preprocessing Image 

f = waitbar(0,'Preprocessing Your Image Please Wait...');
pause(.05)

main = cd (path);
[img,map] = imread([path,filename]);
cd (main);

p = 0.9;
imgdouble = im2double(img);
avg = mean2(imgdouble);
s = std2(imgdouble);

img = imadjust(img,[avg-p*s 1],[avg+p*s 1]);
[img,~,~] = imreducehaze(img,p,'method','approxdcp');

img = localcontrast(img,0.2,-0.4);
img = localcontrast(img,0.3,-0.8);

img = imsharpen(img,'Radius',0.3,'Amount',0.1);
img = uint8(img);
%% //Segmenting Image

waitbar(.1,f,'Segmenting Image');
pause(.05)

cd('Felzenszwalb-Segmentation-master');
%[imgs,NR] = segmentFelzenszwalb(img, 0.8, 500, 300, false, 0 , false);
[imgs,NR] = segmentFelzenszwalb(img, 1, 500, 100, false, 0 , false);
imgs=imgs+1;
cd ..;
%% //Redusing Colors

waitbar(.2,f,'Reducing Colors');
pause(.05)

img = KMeansColorReduction (img,map,NR);
img=uint8(img); 
lab_img = rgb2lab(img);
%% //Initializing Regions

waitbar(.3,f,'Initializing Regions');
pause(.05)

reg = regionprops3(imgs,'Volume','Centroid','VoxelList');

weight = table2array(reg(:,1));
centr = table2array(reg(:,2));
pix = table2array(reg(:,3));

weight( ~any(weight(:,1),2), : ) = [];
centr( ~any(centr(:,1),2), : ) = [];

idx=cellfun(@isempty,pix);
pix(idx) = [];
%% //Initializing Computing Tables

waitbar(.4,f,'Initializing Computing Tables');
pause(.05)

Table = Init(lab_img,NR,imgs);
%% //Spatial Distances Computing

waitbar(.5,f,'Spatial Distances Computing');
pause(.05)

Ds = Dist (centr,NR);
%% //Color Distances Computing

waitbar(.6,f,sprintf('%d Color Distances Computing',NR));
pause(.05)

idx=cellfun(@isempty,Table);
Table(idx) = [];
%NoR = size(Table,1);
%n = size(img);

Dr = CDist (NR,Table);
%% //Saliency Values Computing

waitbar(.7,f,'Saliency Values Computing');
pause(.05)

SS = Saliency(Ds,NR,weight,Dr);
%% //Values Assignment  

waitbar(.8,f,'Values Assignment');
pause(.05)

imrc = Assignment(img,SS,pix);
imrcS = imrc;
%% //Thresholding Saliency Map 

waitbar(.9,f,'Thresholding Saliency Map');
pause(.05)

for i=1:4
    
    MAX = mean(imrc(:));
    
    fseed = imrc(:,:) >  MAX;
    bseed = imrc(:,:) <= MAX;
    
    fmask = zeros(size(imrc));
    bmask = fmask;
    fmask(:,:) = fseed;
    bmask(:,:) = bseed;
    
    roi = false(size(imrc));
    roi(5:end-5,5:end-5,:) = true;
    %roi(size(fmask,1),size(fmask,2)) = true;
    
    L = superpixels(imrc,500);
    
    imrc = grabcut(imrc,L,roi,fmask,bmask);
    imrc = im2uint8(imrc);
    
    t = adaptthresh(imrc,1);
    imrc = imbinarize(imrc,t);
    imrc = im2uint8(imrc);
    
    SE = strel('square', 5);
    imrc = imdilate(imrc,SE);
    imrc = imerode(imrc,SE);
end
%% Finishing Process

waitbar(.95,f,'Finishing Process');
pause(.05)

imrc = im2uint8(imrc);

waitbar(1,f,'Finished');
pause(.05)

close(f)
end