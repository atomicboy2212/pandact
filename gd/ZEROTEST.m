n = 64;
N = n*n;

%set projection num
 L = 180;
 
 %measure matrix
[matrix] = getSampMatrix(n,L);
A = double(matrix);
theta = (180/L ):(180/L):180;

dis = 0;
center = n/2;
ObjSize = 4;
samplePIC = SampPIC(center+dis,center+ObjSize+dis,center,center+ObjSize,n);
btemp = A * samplePIC(:);
x0 = zeros(n,n);
xart = reconART(btemp,A, 0.1, x0(:),50*length(btemp)); 
