load('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/frames.mat')
load('svmModel.mat')

for i=1:size(mov,2)
    detectImage = mov(i).cdata;
    scaledImages = multiscaleImage(detectImage);
    for j=1:5
    testFrames = slidingWindow(scaledImages{j});
    imageIdx = detectFaces(testFrames)
    