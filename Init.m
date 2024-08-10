function Table = Init(lab_img,NR,imgs)

lab_imgres = reshape(lab_img,[],3);
imgsres = reshape(imgs,[],1);
%imgres = reshape(img,[],3); 

%[lab_imgres,ia,~] = unique(lab_imgres(:,:),'rows','stable');

lab_imgress = zeros(size(lab_imgres));
%imgress = zeros(size(imgres));

[imgss,idx] = sort(imgsres);

for i=1:size(lab_imgres,1)
    
    lab_imgress(i,:) = lab_imgres((idx(i)),:);
    %imgress(i,:)     = imgres((idx(i)),:);
end

v = 1;
vv = 1;
Table = cell(NR,1);

for i=1:NR
    
    tt = zeros((size(imgss,1)),3);
    
    while(vv==imgss(v))
        if(v<size(lab_imgres,1))
            tt(v,:) = [lab_imgress(v,1),lab_imgress(v,2),lab_imgress(v,3)];%,imgress(v,1),imgress(v,2),imgress(v,3),imgss(v,1)] ;
            v=v+1;
        else
            break
        end
    end
    tt( ~any(tt(:,1),2), : ) = [];
    Table(i) = {tt(:,:)};
    vv = vv+1;
end
end