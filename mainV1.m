load('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/frames.mat')
load('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/Data/svmModel.mat')
load('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/Data/svmModel.mat')
load('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/Data/svmModel.mat')
%% 
for i=1:1
    disp(sprintf('Detecting Faces on Frame:%i',i));
    detectImage = mov(300).cdata;
    scaledImages = multiscaleImage(detectImage);
    for j=1:5
        disp(sprintf('Detecting Faces on Scaled Image:%i',j));
        testFrames{j} = slidingWindow(scaledImages{j});
%         if sizetestFrames
        end
     [testLabelsFrames,accTest,valsTest]  = detectFaces(testFrames,trainFeatures,model);
end

