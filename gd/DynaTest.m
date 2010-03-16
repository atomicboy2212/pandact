

%
clear;

%size of the object
 n = 64;
 N = n*n;
 DetBin = 64;
 DetBinDis =  1;
 %projection Num
 L = 180;
 
 
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
 
 %para 4 dyna phantom
 
 
 
 scale = n/64;
 cycleNum = 7;
 cycleLen = floor(L/cycleNum);
halfCycleLen = floor(cycleLen/2);
MaxDis = 5*scale;
speed = MaxDis/halfCycleLen;
ObjSize = 4*scale;
if halfCycleLen == 0
    disp('need more projection')
    return;
end
 
 %forword Prj
 det = zeros(DetBin,1);
 for iter = 1:L
     %-------------dynaPhantom--------------------
      j = mod(iter-1,cycleLen);
      pos = j - halfCycleLen;
      dis = pos * speed;
      dis = floor(dis);
      a(j+1) = dis;
       center = n/2;

       samplePIC = SampPIC(center+dis,center+ObjSize+dis,center,center+ObjSize,n);
      %---------------------------------------------     
      
      
     %prj
     DetVal = HBForwardPrj(xSrc,ySrc,xDet,yDet, theta(iter),n,samplePIC);
     det(:,iter) = DetVal(:);
     
 end
 
 %get Prior image
 xpDyna = iradon(det,theta,'spline','Shepp-Logan',n);
 xpDyna = xpDyna';
 %showPIC(xpDyna(:),n,n);
 
 %reconstruction para
 maxIter = 100;
 artIter = 5;
 GDIter = 20;
 lamda= 0;
 tol = 0.1;
 phase = 1;
 
 %theta used in reconstruction
 phaseLen = length(phase);
 for i=0:cycleNum-1
     thetaSeq( ...
          i* phaseLen+ 1 : i*phaseLen + max(phase)...
           ) = theta( i*cycleLen+1 : i*cycleLen + max(phase));
 end
 LeftPrj = mod(L,cycleLen);
 if (LeftPrj<=phaseLen && LeftPrj>0)
   thetaSeq(...
            (cycleNum-1)*phaseLen +1 : (cycleNum-1)*phaseLen + LeftPrj...
            ) = theta( cycleNum*cycleLen + 1 : cycleNum*cycleLen +  LeftPrj);
 elseif(LeftPrj>0)
     thetaSeq(...
            (cycleNum-1)*phaseLen +1 : (cycleNum-1)*phaseLen + max(phase)...
            ) = theta( cycleNum*cycleLen + 1 : cycleNum*cycleLen +  max(phase));
 end
 
 %prjSeq
 SeqLen = length(thetaSeq);
 for i = 1 : SeqLen
  prjSeq(i) = find(theta == thetaSeq(i));
 end
 
 %reconstruction
 Perror = zeros(1,maxIter);
 image0 = xpDyna(:);
 imagelast = image0;
 image0 = reshape(image0,n,n);
 for i = 1:maxIter
   disp('iter = ')
   disp(i);
   for iter = 1 : artIter
     image0 = FART(xSrc,ySrc,xDet,yDet,thetaSeq,n,image0,det,prjSeq);
   end
   %GradDes(xprior,lamda,x0,Msize,maxIter,tol,Beq,Aeq,xart)
     image0 = GradDes(xpDyna(:),lamda,image0(:),n,GDIter,tol,image0(:));
   %---------------hard threshold-----\
%          [temp_ht index_ht]= sort(image0,'descend');
%          ht_threshold = 1618;
%          for ht=ht_threshold:length(image0)
%              image0(index_ht(ht))=0;
%          end
   %-------------------------------
     image0 = reshape(image0,n,n);
     Perror(i) = norm(imagelast(:) - image0(:));
     imagelast = image0;
 end
 
figure;
subplot(3,1,1);

showPIC(xpDyna(:),n,n);
title('prior image');

subplot(3,1,2);

showPIC(image0(:),n,n);
title('reconstructed');

 subplot(3,1,3);
 plot( Perror(20:length(Perror)) )
 
 
 
 
 
