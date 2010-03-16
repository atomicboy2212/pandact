
function [x,res] = reconART(pData,CTMatrix, tol, x0,maxIter)
[m n] = size(CTMatrix);

xk = x0;
i = 1;

while (i <= maxIter)
    
%                                      p_k+1-w_k+1'* x_k
%          x_k+1 =  x_k +     w_k+1 * -------------------
%                                     norm(w_k+1)*norm(w_k+1)
    
    wk1 = CTMatrix(mod(i,m)+1 , :);
    pk1 = pData(mod(i,m)+1);
     
    xk1 = xk + wk1' * (pk1 - wk1* xk)/min(0.001,wk1*wk1');

    res = norm( xk - xk1 );
%     disp('res = ');
%     disp(res);
%        if(res<tol)
%            break;
%        end
    
    i = i + 1;
 
    xk = xk1;
end
    
% if(i>m)
%     disp('cannot statisfy the tol requirement');
% end



x = xk;

function c = min(a, b)
if(b<a)
    c = a;
else
    c = b;
end
