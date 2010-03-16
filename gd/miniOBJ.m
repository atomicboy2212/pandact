
function x = GradDes(xprior,lamda,x0,Msize,maxIter,tol,Beq,Aeq)

n = Msize;
N = n*n;
x = x0;

% create (sparse) differencing matrices for TV
Dv = spdiags([reshape([-ones(n-1,n); zeros(1,n)],N,1) ...
  reshape([zeros(1,n); ones(n-1,n)],N,1)], [0 1], N, N);
Dh = spdiags([reshape([-ones(n,n-1) zeros(n,1)],N,1) ...
  reshape([zeros(n,1) ones(n,n-1)],N,1)], [0 n], N, N);

for i=1:maxIter

%--------- newton method ----------------------------
%{   
  upLeft = (Dv'*Dv + Dh'*Dh);%wrong should be 2nd grad of objFun
  [row col] = size(upLeft);
  [rowA colA] = size(Aeq);
  A = zeros(row+rowA,col+rowA);
  
  A(1:row,1:col) = upLeft;
  
  A(row+1:row+rowA,1:colA) = Aeq;
  
  A(1:colA,col+1:col+rowA) = Aeq';
  
  B = zeros(row+rowA,1);
  B(row+1:row+rowA,1) = Beq;%wrong should be - grad(objFun)
  xguess = [x0;zeros(rowA,1)];
  dx =cgsolve2(xguess,A,B,1e-8, 600);
  dx = dx(1:colA);
  %}


%-----------------gradient descent method------------
                disp('grad');
                dx = lamda*gradFun(x-xprior,Dv,Dh,n) +(1-lamda)*gradFun(x,Dv,Dh,n) + (Aeq*x-beq);
                dx = -dx;
                disp('line search');
  %------------------line search------------------------%
  alpha = 0.01;
  beta = 0.5;  
  backiter = 0;
  t = 1;  
  lastt = t;
%   fx = ObjFun(x,Dv,Dh,n);
%   gradx = gradFun(x,Dv,Dh);
  while (backiter<32)
      
      %fl = f(x + t*dx); fr = f(x) + alpha * t * grad(x)' * dx   
    
%       fl = ObjFun(x + t*dx,Dv,Dh,n);
%       fr =  fx + alpha * t * (gradx'*dx);
        fl = ObjFun(x + lastt*dx,Dv,Dh,n);
        fr = ObjFun(x + t*dx,Dv,Dh,n);
        lastt = t;
      if(fl<fr)
          
          break;
      end
      t = beta*t;
      backiter = backiter+1;
  end
  %update x
  x = x + t*dx;
  disp('objFun');
  disp(ObjFun(x,Dv,Dh,n));
  end

 

      
      

      