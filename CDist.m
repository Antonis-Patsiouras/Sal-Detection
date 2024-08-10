function Dr = CDist(nr,Table)
%% Initializing

w = waitbar(0,'Color Distances Computing ...');
pause(.05)

Dr = zeros(nr,nr);
%% Initializing 1st Table

for i=1:nr
    
    waitbar((1/nr)*i,w,sprintf('\nComputing Distance Between %d/%d \n',i,nr));
    pause(.05)
    
    region1 = cell2mat(Table(i));
    p = zeros(size(region1,1),3);
    
    for r=1:size(region1,1)
        
        p(r,1) = region1(r,1);%L
        p(r,2) = region1(r,2);%A
        p(r,3) = region1(r,3);%B
    end
    
    [~,~,ic] = unique(p, 'rows', 'stable');
    h = accumarray(ic, 1);
    Res = h(ic);
    
    f1 = zeros(size(p,1),1);
    for ii=1:size(p,1)
        
        f1(ii) = Res(ii);
    end
    
    [p,~,~] = unique(p(:,:),'rows','stable');
    %% Initializing 2nd Table
   
    for j=1:nr
        
        if (j~=i) && (i<j)
            
            region2 = cell2mat(Table(j));
            pp = zeros(size(region2,1),3);
  
            for rr=1:size(region2,1)
                
                pp(rr,1) = region2(rr,1);
                pp(rr,2) = region2(rr,2);
                pp(rr,3) = region2(rr,3);
            end
            
            [~,~,ic] = unique(pp, 'rows', 'stable');
            h = accumarray(ic, 1);
            Res = h(ic);
            
            f2 = zeros(size(pp,1),1);
            for ii=1:size(pp,1)
                
                f2(ii) = Res(ii);
            end
            
            [pp,~,~] = unique(pp(:,:),'rows','stable');
            %% Calc Color Dist
            
            DD = zeros(size(p,1),1);
            
            for r=1:size(p,1)
                for rr=1:size(pp,1)
                    
                    if (r~=rr) && (r<rr)
                        
                        DD(r) = DD(r) + (cmcde(p(r,1:3),pp(rr,1:3))*f1(r)*f2(rr));
                    else
                        
                        DD(r) = DD(r) + DD(rr);
                    end
                end
            end
            
            Dr(i,j) = sum(DD(:));    
        else
            
            Dr(i,j) = Dr(j,i);
        end
    end
end
%% Normalize

MAX = max(Dr(:));
Dr = Dr./MAX;
close(w);
end