function image1 = FFART(xSrc,ySrc,xDet,yDet,angle,n,image0,DetVal)

cosAngle = cosd(angle);
sinAngle = sind(angle);

xSrcR = cosAngle*xSrc + sinAngle * ySrc;
ySrcR = cosAngle*ySrc - sinAngle * xSrc;

xDetR = cosAngle*xDet + sinAngle * yDet;
yDetR = cosAngle*yDet - sinAngle * xDet;

SrcLen = length(xSrc);

image1 = image0;
for iter = 1:SrcLen
    image1 = FFFART(xSrcR(iter),ySrcR(iter),xDetR(iter),yDetR(iter),n,image1,DetVal(iter));

end