function [matrix] = SampPIC(lx,rx,uy,ly,Msize)

matrix = zeros(Msize);
scale = Msize /64;

%outer circle
[x, y] = Circle(Msize/2,Msize/2,24*scale,Msize); 
 for i = 1:length(x)
    matrix(x(i),y(i)) = 128;
 end
 %inner circle
 [x, y] = Circle(Msize/2,Msize/2,18*scale,Msize);
 for i = 1:length(x)
    matrix(x(i),y(i)) = 0;
 end
 %bones
 R = 2;
 bones = 255;
 [x,y] = Circle(Msize/2 + 20*scale , Msize/2, R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
 [x,y] = Circle(Msize/2 - 20*scale , Msize/2, R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
  [x,y] = Circle(Msize/2 , Msize/2+ 20*scale ,  R * scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
  [x,y] = Circle(Msize/2 , Msize/2 - 20*scale ,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
  
  location = 17;
  [x,y] = Circle(Msize/2 + location*scale*1.732/2, Msize/2 + location*scale*1.732/2,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
    [x,y] = Circle(Msize/2 + location*scale*1.732/2, Msize/2 - location*scale*1.732/2,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
    [x,y] = Circle(Msize/2 - location*scale*1.732/2, Msize/2 - location*scale*1.732/2,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
    [x,y] = Circle(Msize/2 - location*scale*1.732/2, Msize/2 + location*scale*1.732/2,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
 
% %circle matrix
 bones = 200;
  R = 2;
  [x,y] = Circle(Msize/2 - 5*scale , Msize/2 - 5 * scale,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
  [x,y] = Circle(Msize/2 + 5 * scale  , Msize/2- 5 * scale,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
  
   [x,y] = Circle(Msize/2   , Msize/2 - 5 * scale,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
  %small circle 
  R = 1 ;
   [x,y] = Circle(Msize/2 -3*scale  , Msize/2 - 5 * scale - 4,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
    [x,y] = Circle(Msize/2 + 3 * scale  , Msize/2 - 5 * scale - 4,  R *scale,Msize);
  for i = 1:length(x)
    matrix(x(i),y(i)) = bones;
  end
  

%tumor
matrix(uy:ly,lx:rx) = 255;

function [x y] = Circle(centerX,centerY,R,Msize)
 gridx = meshgrid(1:Msize);
 gridy = meshgrid(1:Msize)';
 [x y] = find((gridx-floor(centerX)).^2 + (gridy-floor(centerY)).^2 < R.^2 ) ;





