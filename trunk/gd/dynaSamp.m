function b = dynaSamp(numProj,angle,x,Msize,bb)

angleLength = length(angle);

if nargin == 4,
    bb = zeros(angleLength*Msize,1);
end



L = numProj;
width = Msize;
N = width;
thc = linspace(0, pi-pi/L, L);
thc = thc(angle);


Row = zeros(1,length(x));
  
for ll = 1:angleLength

	if ((thc(ll) <= pi/4) | (thc(ll) > 3*pi/4))
		yr = round(tan(thc(ll))*(-N/2+1:N/2-1))+N/2+1;
%       for nn = 1:N-1
%       	M(yr(nn),nn+1) = 1;
%         for index = 1 : width
%             if ((yr(nn)-1 + index - width/2 ) < width&&(yr(nn)-1 + index - width/2 )>=0)
%             MeatureMatrix((ll-1)*width + index,(yr(nn)-1 + index - width/2 )*N   + nn + 1)=1;
%             end
%         end
          for index = 1:width
              %form a row
              for nn = 1:N-1
                  if ((yr(nn)-1 + index - width/2 ) < width&&(yr(nn)-1 + index - width/2 )>=0)
                      Row ((yr(nn)-1 + index - width/2 )*N   + nn + 1) = 1;
                  end   
              end
              %sample
              bb((ll-1)*width + index)= Row * x;
              Row(:) = 0;
          end
      
  else 
		xc = round(cot(thc(ll))*(-N/2+1:N/2-1))+N/2+1;
% 		for nn = 1:N-1
% 			M(nn+1,xc(nn)) = 1;
%             for index = 1 : width
%                 if((xc(nn)+ index - width/2)<width&&(xc(nn)+ index - width/2)>=0)
%                     MeatureMatrix((ll-1)*width+index,(nn+1-1)*N + xc(nn)+ index - width/2)=1;
%                 end
%             end
% 		end
          for index = 1:width
              %form a row
              for nn = 1:N-1
                 if((xc(nn)+ index - width/2)<width&&(xc(nn)+ index - width/2)>=0)
                      Row ((nn+1-1)*N + xc(nn)+ index - width/2) = 1;
                  end   
              end
              %sample
              bb((ll-1)*width + index)= Row * x;
              Row(:) = 0;
          end

  end

end
b = bb;
