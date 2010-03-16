function x = dynaArt(numProj,angle,x0,Msize,xtrue)



xk = x0;

angleLength = length(angle);



L = numProj;
width = Msize;
N = width;
thc = linspace(pi/4, 3*pi/4, L);
thc = thc(angle);


Row = zeros(1,length(x0));
  
for ll = 1:angleLength

	if ((thc(ll) <= pi/4) | (thc(ll) > 3*pi/4))
		yr = round(tan(thc(ll))*(-N/2+1:N/2-1))+N/2+1;

          for index = 1:width
              %form a row
              for nn = 1:N-1
                  if ((yr(nn)-1 + index - width/2 ) < width&&(yr(nn)-1 + index - width/2 )>=0)
                      Row ((yr(nn)-1 + index - width/2 )*N   + nn + 1) = 1;
                  end   
              end
              %sample
              bb= Row * xtrue;
              wk1 = Row;
              %
              pk1 = bb;
              xk1 = xk + wk1' * (pk1 - wk1* xk)/min(0.001,wk1*wk1');
              xk = xk1;
              
              Row(:) = 0;
          end
      
  else 
		xc = round(cot(thc(ll))*(-N/2+1:N/2-1))+N/2+1;

          for index = 1:width
              %form a row
              for nn = 1:N-1
                 if((xc(nn)+ index - width/2)<width&&(xc(nn)+ index - width/2)>=0)
                      Row ((nn+1-1)*N + xc(nn)+ index - width/2) = 1;
                  end   
              end
              %sample
              bb= Row * xtrue;
                            wk1 = Row;
              %
              pk1 = bb;
              xk1 = xk + wk1' * (pk1 - wk1* xk)/min(0.001,wk1*wk1');
              xk = xk1;
              Row(:) = 0;
          end

  end

end
x = xk;


function c = min(a, b)
if(b<a)
    c = a;
else
    c = b;
end