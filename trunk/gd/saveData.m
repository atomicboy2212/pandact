
function saveData(DirName,xp,xbp,orig_image,NewtonStep,resultPIC,timeDuration,snrValue)

%DirName = 'haha';
FoldPath = 'results/';


FoldName = strcat(FoldPath,DirName);
%disp(FoldName);
[state message] = mkdir(FoldName);
%disp(message);
mesSize = size(message);
if(mesSize ~= 0)
    disp(message);
    return;
end
%cs_reconstructed
cs_reconstructed = strcat(FoldName,'/cs_reconstructed_image_');
cs_reconstructed = strcat(cs_reconstructed,DirName);
cs_reconstructed = strcat(cs_reconstructed,'.mat');
disp(cs_reconstructed);
save(cs_reconstructed, 'xp');
%fbp_reconstructed
fbp_reconstructed = strcat(FoldName,'/fbp_reconstructed_image_');
fbp_reconstructed= strcat(fbp_reconstructed,DirName);
fbp_reconstructed = strcat(fbp_reconstructed,'.mat');
disp(fbp_reconstructed);
save(fbp_reconstructed, 'xbp');
%orig_image
orig_image = strcat(FoldName,'/orig_image_');
orig_image= strcat(orig_image,DirName);
orig_image = strcat(orig_image,'.mat');
disp(orig_image);
save(orig_image, 'orig_image');

%NewtonStep
totalNewtonStep_path = strcat(FoldName,'/totalNewtonStep_');
totalNewtonStep_path= strcat(totalNewtonStep_path,DirName);
totalNewtonStep_path = strcat(totalNewtonStep_path,'.mat');
disp(totalNewtonStep_path);
save(totalNewtonStep_path, 'NewtonStep');

%time
time_path = strcat(FoldName,'/time');
time_path= strcat(time_path,DirName);
time_path = strcat(time_path,'.mat');
disp(time_path);
save(time_path, 'timeDuration');

%snr
snrValue_path = strcat(FoldName,'/snrValue_');
snrValue_path= strcat(snrValue_path,DirName);
snrValue_path = strcat(snrValue_path,'.mat');
disp(snrValue_path);
save(snrValue_path, 'snrValue');

%result PIC 
result_image = strcat(FoldName,'/result_image_');
result_image= strcat(result_image,DirName);
result_image = strcat(result_image,'.fig');
disp(result_image);
saveas(resultPIC, result_image);





%origImage = str(origImage,FoldPath)
%save('1.txt', 'x');

