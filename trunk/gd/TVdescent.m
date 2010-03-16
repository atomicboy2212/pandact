function [x,error_sq] = TVdescent(Aeq,Beq,x0,Msize,maxIter,tol)

n = Msize;
N = n*n;
x = x0;

% create (sparse) differencing matrices for TV
Dv = spdiags([reshape([-ones(n-1,n); zeros(1,n)],N,1) ...
  reshape([zeros(1,n); ones(n-1,n)],N,1)], [0 1], N, N);
Dh = spdiags([reshape([-ones(n,n-1) zeros(n,1)],N,1) ...
  reshape([zeros(n,1) ones(n,n-1)],N,1)], [0 n], N, N);
  
  
  
  for i=1:maxIter
  
    xlast = x0;
    gradf2 = gradf2(x0,Dv,Dh);
    gradf1 = gradf(x0,Dv,Dh);
	
	%[rowgrad2,colgrad2] = size(gradf2);
	[rowA, colA] = size(Aeq);
	
	dx = zeros(N+rowA,1);
	
	BRight = [-gradf1;zeros(rowA,1)];
	
    ALeft = zeros(colA + rowA, colA + rowA) ;
    ALeft(1:colA,1:colA) = gradf2;	
	ALeft(1:colA,colA +1 :colA + rowA) =  Aeq';
	ALeft(colA+1 : colA + rowA, 1:colA) = Aeq;
	
	dx = cgsolve(ALeft, BRight, tol, 600);
	dx = dx(1:N);
	
	%-------------line search--------------
	t = 1;beta = 0.5;backiter = 1;
	  while (backiter<32)

        fl = ObjFun(x + lastt*dx,Dv,Dh,n);
        fr = ObjFun(x + t*dx,Dv,Dh,n);
        lastt = t;
      if(fl<fr)
          break;
      end%end while
      t = beta*t;
      backiter = backiter+1;
	  
  end%end for
	  x0 = x0 + t*dx;
	error_sq(i) = norm(xlast - x0);
  end
  x = x0;





function gradf2 = gradf2Fun(x,Dv,Dh)
maxiter = length(x);
gradf2 = zeros(maxiter,maxiter);

for i = 1:maxiter
         Dhx = Dh(i,:)* x;
         Dvx = Dv(i,:)* x;
         Dht = Dh(i,:)*Dh(i,:)';
         Dvt = Dv(i,:)*Dv(i,:)';
         s = (Dhx * Dhx + Dvx*Dvx)^(-1.5);
		 s2 = (Dhx * Dhx + Dvx*Dvx)^(-0.5);
         gradf2 = gradf2 + (-1)*s*(Dht*x+Dvt*x)*(Dht*x+Dvt*x)' + s*(Dht+Dvt);
		 
end

