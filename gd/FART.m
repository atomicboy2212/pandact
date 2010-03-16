function image1 = FART(xSrc,ySrc,xDet,yDet,angleSeq,n,image0,DetVal,prjSeq)
AngleLen = length(angleSeq);
image1 = image0;
for iter = 1:AngleLen
    image1 = FFART(...
                  xSrc,ySrc,xDet,yDet,angleSeq(iter),n,image1,DetVal( : , prjSeq(iter) )...
                  );

end


