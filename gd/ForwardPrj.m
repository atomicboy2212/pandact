function det = HBForwardPrj(xSrc,ySrc,xDet,yDet,angle,n,image)

% cosAngle = cosd(angle);
% sinAngle = sind(angle);
% 
% xSrcR = cosAngle*xSrc + sinAngle * ySrc;
% ySrcR = cosAngle*xSrc - sinAngle * ySrc;
% 
% xDetR = cosAngle*xDet + sinAngle * yDet;
% yDetR = cosAngle*xDet - sinAngle * yDet;
% 
% %
% SrcLen = length(xSrc);
% for iter = 1:SrcLen
%     det(iter) = ForwardProjection(xSrcR(iter),ySrcR(iter),xDetR(iter),yDetR(iter),n,image)
% end