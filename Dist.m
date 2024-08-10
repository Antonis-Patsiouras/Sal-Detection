function Ds = Dist(centr,n)

Ds = zeros(n,n);
for i=1:n
    for j=1:n
        if (j~=i) && (i<j)
            Ds(i,j) = pdist2(centr(i),centr(j));
        else
            Ds(i,j) = Ds(j,i);
        end
    end
end

MAX = max(Ds(:));
Ds = Ds./MAX;
end