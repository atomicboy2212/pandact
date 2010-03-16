function [det rays] = HBForwardPrj(xSrc,ySrc,xDet,yDet,angle,n,image)


cosAngle = cosd(angle);
sinAngle = sind(angle);

xSrcR = cosAngle*xSrc + sinAngle * ySrc;
ySrcR = cosAngle*ySrc - sinAngle * xSrc;

xDetR = cosAngle*xDet + sinAngle * yDet;
yDetR = cosAngle*yDet - sinAngle * xDet;


SrcLen = length(xSrc);
for iter = 1:SrcLen
    [det(iter) rays(iter,:)] = ForwardProjection(xSrcR(iter),ySrcR(iter),xDetR(iter),yDetR(iter),n,image);
end