function showPIC(x,width,height)
maxx = max(x);
minx = min(x);
disx = maxx-minx;
lengthx = length(x);
for i =1 :lengthx
    x(i) = (x(i)-minx)/(disx); 
end
imshow(reshape(x,width,height));


