
function staticTest(DirName,noiseLevel,IHT_Threshold)
n = 64;
N = n*n;

%set projection num
 L = 10;
 
%measure matrix
[matrix] = getSampMatrix(n,L);
Aeq = double(matrix);
%measure
center =n/2;
dis = -4;
ObjSize = 4;
x = SampPIC(center+dis,center+ObjSize+dis,center,center+ObjSize,n);
beq = Aeq * x(:);
%-----------------add noise----
if(noiseLevel~=0)
 noiseLevel = max(beq) * 0.1;
 noise =   randn(size(beq));
 beq = beq +    noiseLevel * (noise/norm(noise));
end;

%fbp reconstruction
theta = (180/L ):(180/L):180;
R = radon(x,theta);
xbp = iradon(R,theta,n);

totalIter = 100;
artIter = 1;
GDIter = 200;
tol = 0.01;
lamda = 0;
x0 = xbp(:);



xlast = x0;
tic;
for i=1:totalIter
    
    disp('totalIter');
    disp(i);
    
    x0 = reconART(beq,Aeq, tol, x0(:),artIter*length(beq));     
    x0 = GradDes(xbp(:),lamda,x0(:),n,GDIter,tol,beq,Aeq);
    
%     %--------------hard threshold-------------------
      if(IHT_Threshold~=0)
        [temp_ht index_ht]= sort(x0,'descend');
        
        IHT_Threshold = size(find(xbp(:)>0));
       % IHT_Threshold = size(find(x(:)>0));
        for ht = IHT_Threshold:length(x0)
            x0(index_ht(ht))= 0;
        end;
      end;
    
    %------------------------------------------------
   
     iterError(i) = norm(x0 - xlast);
     X0 = reshape(x0,n,n);
     val = sum(sum(sqrt([diff(X0,1,2) zeros(n,1)].^2 + [diff(X0,1,1); zeros(1,n)].^2 )));
     ObjFun(i) = val + norm(Aeq*x0 - beq);
     
     
     xlast = x0;
    
    if(iterError(i)<1)
        break;
    end
    
end



timeDura = toc;
disp('time');
disp(timeDura);

xcs =x0;

resultPIC = figure;

subplot(2,2,1);
showPIC(x(:),n,n);
title('orignal image');

subplot(2,2,2);
showPIC(xbp(:),n,n);
title('fbp reconstructed image');

subplot(2,2,3);
showPIC(x0,n,n);
title('cs reconstructed image');

 subplot(2,2,4);
 plot( iterError(1:length(iterError)) );
 
snrValue = SNR(x(:),xcs(:));
 
 saveData(DirName,xcs,xbp,x,iterError,resultPIC,timeDura,snrValue);

