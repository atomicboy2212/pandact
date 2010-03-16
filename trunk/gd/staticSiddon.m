%
function staticSiddon(DirName,noiseLevel,IHT_Threshold)

%size of the object
 n = 64;
 N = n*n;
 DetBin = 64;
 DetBinDis =  1;
 %projection Num
 L = 15;
 
  %{
         
      0            111111               o
      0            111111               O
      0            111111               o
      
  Detector         Object             Source 
 
 %}
 
  %source position

 [xSrc] = ones(1,DetBin)*(2*n);
 [ySrc] = [-n/2:DetBinDis:-DetBinDis,DetBinDis:DetBinDis:n/2];
 %[ySrc] = [-n/2:DetBinDis:n/2];
 
  %detector
 [xDet] = ones(1,DetBin)*(-2*n);
 [yDet] = [-n/2:DetBinDis:-DetBinDis,DetBinDis:DetBinDis:n/2];
 %[yDet] = [-n/2:DetBinDis:n/2];
 
  %getProjection angle
 theta = (180/L):(180/L):180;
 
 dis = -4;
 center = n/2;
 ObjSize = 4;
 x = SampPIC(center+dis,center+ObjSize+dis,center,center+ObjSize,n);
 DetSize = length(xSrc);
 
  for iter = 1:L 
     %prj
     [DetVal rays] = HBForwardPrj(xSrc,ySrc,xDet,yDet, theta(iter),n,x);
     det( (iter-1)*DetSize + 1 : (iter -1)*DetSize + DetSize,1 ) = DetVal(:);
     Aeq((iter-1)*DetSize + 1 : (iter -1)*DetSize + DetSize,:) = rays;     
  end
beq = Aeq * x(:);



%fbp reconstruction
theta = (180/L ):(180/L):180;
R = radon(x,theta);
xbp = iradon(R,theta,n);

totalIter = 50;
artIter = 1;
GDIter = 200;
tol = 0.01;
lamda = 0;
x0 = xbp(:);
%
%x0 = ones(length(x0),1)*(-100);

xlast = x0;
tic;
for i=1:totalIter
    
    disp('totalIter');
    disp(i);
    x0 = reconART(beq,Aeq, tol, x0(:),artIter*length(beq)); 
    %---------------------------
%     for artIndex = 1:artIter
%         
%         dx =  Aeq'* (Aeq*x0 - beq);
%         alpha = 0.01;
%          beta = 0.5;  
%          backiter = 0;
%          t = 1;  
%         lastt = t;
%          while (backiter<32)
%       
% 
%             fl = norm(Aeq*x0-beq);
%             fr = norm(Aeq*(x0 + t*dx)-beq);
%             lastt = t;
%             if(fl<fr)
%           
%                break;
%             end
%             t = beta*t;
%             backiter = backiter+1;
%          end
%     x0 = x0  - t*dx;
%     end;
    %--------------------------------------
    x0 = GradDes(xbp(:),lamda,x0(:),n,GDIter,tol);
    
      
    
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

