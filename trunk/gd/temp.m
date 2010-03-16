% 
% x0 = 1000;
% xp = x0;
% alpha = 0.01;
% beta = 0.5;  
% biter = 1;
% t = 1;
% 
% for i =1 : 20
%     xlast = xp;
%     dx = -xp;
%     grad = xp;
%     
%     while biter <32
%         
%         
%         fl = .5 * (xp + t*dx) *(xp + t*dx);
%         fr = .5 *(xp)*xp  +   alpha * t * (grad'*dx);
%         if(fl<=fr)
%           break;
%         end
%         t = beta*t;
%         biter= biter+1;
%     end
%      xp = xp + t*dx; 
%      disp(xp);
% end

L = 10;
theta = (180/L):(180/L):180;
t0 = [1,0]';
for i =1 : length(theta)
    t = [cosd(theta(i)) -sind(theta(i));sind(theta(i)) cosd(theta(i))];
    tt = t*t0;
    x(i)= tt(1);
    y(i)= tt(2);
end

