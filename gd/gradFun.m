      
%1st gradient of the objective function     
 function gradf = gradFun(x,Dv,Dh,n)
     
	 maxiter = length(x);
     gradf = zeros(maxiter,1);
     
% 	 
% 	 for i =1 :maxiter
% 	 
%        %disp('grad iter');
%        %disp(i);
%        Dhx = Dh(i,:)* x;
%        Dvx = Dv(i,:)* x;
%        s = sqrt(Dhx*Dhx + Dvx*Dvx);
%        DDhx = Dh(i,:)'*Dhx;
%        DDvx = Dv(i,:)'*Dvx;
%        if(s<0.1)
%            s = 0.1;
%        end
%        gradf =  gradf + (1/s) * (DDhx+DDvx);
%     end
     
	 
	  for row = 0:n-2
	    for col = 1:n-1	 
	   
	   rowh = row +1;
	   colv = col +1;
%        
% 	 
	   Dhx = -x(row*n + col) + x(rowh*n + col);
	   Dvx = -x(row*n + col) + x(row*n + colv);
	   s = sqrt(Dhx*Dhx + Dvx*Dvx);
	   if(s<0.1)
	      s = 0.1;
	   end
% 	 
% 	 
       %gradf = gradf + 1/s * Dh'*Dh*x
       index = row*n + col;
       indexh = rowh*n + col;
       gradf(index) = gradf(index) + (1/s)*( x(row*n + col) - x(rowh*n + col));
       gradf(indexh) = gradf(indexh) + (1/s)*( -x(row*n + col) + x(rowh*n + col));
       
  
	   %gradf = gradf * 1/s * Dv'*Dv*x
       indexv = row*n + colv;
       gradf(index) = gradf(index) + (1/s)*( x(row*n + col) - x(indexv));
       gradf(indexv) = gradf(indexv) + (1/s)*( -x(row*n + col) + x(indexv));
	    end%col
      end%row
        
