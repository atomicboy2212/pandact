function val = costFun(x,xsize)

n = xsize;
N = n*n;

% create (sparse) differencing matrices for TV
Dv = spdiags([reshape([-ones(n-1,n); zeros(1,n)],N,1) ...
  reshape([zeros(1,n); ones(n-1,n)],N,1)], [0 1], N, N);
Dh = spdiags([reshape([-ones(n,n-1) zeros(n,1)],N,1) ...
  reshape([zeros(n,1) ones(n,n-1)],N,1)], [0 n], N, N);
 

Dhx = Dh*x;  Dvx = Dv*x;
val = Dhx'*Dhx + Dvx'*Dvx;