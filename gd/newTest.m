

n = 64;
N = n*n;

%set projection num
 L = 180;
 
%measure matrix
[matrix] = getSampMatrix(n,L);
A = double(matrix);



theta = (180/L ):(180/L):180;


%dyna sample
scale = n/64;
cycleNum = 5;
cycleLen = floor(L/cycleNum);
halfCycleLen = floor(cycleLen/2);
MaxDis = 4*scale;
speed = MaxDis/halfCycleLen;
ObjSize = 4*scale;
if halfCycleLen == 0
    disp('need more projection')
    return;
end
R = zeros(n,L);
for i = 1:L
    j = mod(i,cycleLen);
    pos = j - halfCycleLen;
    dis = pos * speed;
    dis = floor(dis);
    a(j+1) = dis;
   
    center = n/2;
    dis =0;
    samplePIC = SampPIC(center+dis,center+ObjSize+dis,center,center+ObjSize,n);

    Rtemp = radon(samplePIC,theta(i),n);
    R(:,i) = Rtemp;
    Ttheta(j+1,ceil(i/cycleLen)) = i;
    
     btemp = A * samplePIC(:);

   %-----------------add noise----
%    noise =   randn(size(btemp));
%    btemp = btemp +    25 * noise/norm(noise);
	%-------------------------------
        proj(j+1,(ceil(i/cycleLen)-1)*n+1:(ceil(i/cycleLen))*n) = (i-1)*n+1:i*n;
        bcycle(j+1,(ceil(i/cycleLen)-1)*n+1:(ceil(i/cycleLen))*n) = btemp((i-1)*n+1:i*n);
     b((i-1)*n+1:i*n,:)= btemp((i-1)*n+1:i*n,:);       
end

xpDyna = iradon(R,theta,'spline','Shepp-Logan',n);



Phase = [1:4];

%
detVal =   bcycle(Phase,:)';
detVal = detVal(:);
PrjSeq = proj(Phase,:)';
PrjSeq = PrjSeq(:);
thetaSeq = Ttheta(Phase,:)';
thetaSeq = thetaSeq(:);
%detVal  == A(PrjSeq,:) * xrec ;   

totalIter = 20;
artIter = 5;
GDIter = 20;
tol = 0.1;
x0 = xpDyna(:);
error = 0;
%for xtrue
dis = -4;
xtrue = SampPIC(n/2+dis,n/2+ObjSize+dis,n/2,n/2+ObjSize,n);
xtrue = xtrue(:);

iterError = 0;
lamda = 0;
%x0 = zeros(length(x0),1);
for i=1:totalIter
    
    disp('totalIter');
    disp(i);
    
     xlast = x0;
     %x0 = reconART(detVal,A(PrjSeq,:), tol, x0,artIter*length(detVal)); 
       x0 = reconART(detVal,A(PrjSeq,:), tol, x0,length(detVal)); 
    
    
%     for iter=1:artIter
%         disp('artIter');
%         disp(iter);
%         
%         x0 = dynaArt(L,thetaSeq,x0,n,xtrue);
%        
%  
%     end

    %error(i*2 +1 ) = norm(xart-x0);
  
   % x0 = GradDes(lamda,x0,n,GDIter,tol);  
   
    
    %disp('xgd');
    %disp(norm(x0-xtrue));
    
    %error(i*2 +2 ) = norm(x0-xart);
    %x0 = GradDes(detVal,A(PrjSeq,:),lamda,x0,n,GDIter,tol);  
    %x0 = xart;
    %--------------hard threshold-------------------
%         [temp_ht index_ht]= sort(x0,'descend');
%         ht_threshold = 1618;
%         for ht=ht_threshold:length(x0)
%             x0(index_ht(ht))=0;
%         end
    
    %------------------------------------------------

    % iterError(i) = norm(x0 - xlast);
%     
%     if(iterError(i)<1)
%         break;
%     end
    
end



xresult = x0;

disp('finished');

figure;
subplot(1,2,1);

showPIC(xpDyna(:),n,n);
title('prior image');

subplot(1,2,2);

showPIC(x0,n,n);
title('reconstructed');


