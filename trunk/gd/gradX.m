function gx = gradX(x)

 gx = ones(length(x),1);
 t= find(x==0);
 gx(t)=0;
 t=find(x<0);
 gx(t) = -1;