% return a meature matrix 
% 
% N  the size of the matrix would be N*N
% 
% L the num of projection


function [Matrix] =  getSampMatrix(N,L)
thc = linspace(pi/L, pi, L);
%----------radom matrix test----------------
%   radseed = randn(1,L);
%   radseed = mapminmax(radseed,0,1);
%   thc = (radseed*pi);
%------------------------------
M = zeros(N);
width = N;
MeatureMatrix = zeros(width*L, N*N);
% full mask
for ll = 1:L

	if ((thc(ll) <= pi/4) | (thc(ll) > 3*pi/4))
		yr = round(tan(thc(ll))*(-N/2+1:N/2-1))+N/2+1;
    	for nn = 1:N-1
      	M(yr(nn),nn+1) = 1;
        for index = 1 : width
            if ((yr(nn)-1 + index - width/2 ) < width&&(yr(nn)-1 + index - width/2 )>=0)
            MeatureMatrix((ll-1)*width + index,(yr(nn)-1 + index - width/2 )*N   + nn + 1)=1;
            end
        end
      end
  else 
		xc = round(cot(thc(ll))*(-N/2+1:N/2-1))+N/2+1;
		for nn = 1:N-1
			M(nn+1,xc(nn)) = 1;
            for index = 1 : width
                if((xc(nn)+ index - width/2)<width&&(xc(nn)+ index - width/2)>=0)
                    MeatureMatrix((ll-1)*width+index,(nn+1-1)*N + xc(nn)+ index - width/2)=1;
                end
            end
		end
	end

end
Matrix = MeatureMatrix; 