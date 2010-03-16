function x = minil2(beq,Aeq, tol, x0,maxIter)

%sart
[m n] = size(Aeq);

xk = x0;
j = 1;

while (j <= n)
    
    Asumcol = sum(Aeq(:,j));
    if(Asumcol<0.1)
      Asumcol = 0.1;
    end
    
    i=1;
    sumA = 0;
    while(i<m)
    
        sumA = sumA + Aeq(i,j)* ((beq(i) - Aeq(i,:) * x0)/sum(Aeq(i,:))); 
        i = i+1;
    end

    xk(j) = x0(j) + sumA / Asumcol;
    
    j = j + 1;
 
    
end
    

x = xk;

function c = min(a, b)
if(b<a)
    c = a;
else
    c = b;
end
