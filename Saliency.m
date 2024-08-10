function SS = Saliency(Ds,n,weight,Dr)

S = zeros(n,n);
for i=1:n
    for j=1:n
        if (j~=i) && (i<j)
            
            S(i,j) = exp(-Ds(i,j)/0.4)*weight(j)*Dr(i,j);
        else
            
            S(i,j) = S(j,i);
        end
    end
end

SS = sum(S,2);
end