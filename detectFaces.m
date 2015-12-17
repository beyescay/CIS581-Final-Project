function [testLabelsFrames,accTest,valsTest]  = detectFaces(testFrames,trainFeatures,model)
global RESIZE_R
global RESIZE_C

tic
for i=1:size(testFrames,1)
    disp(sprintf('Testing Frame:%i',i));
% %     testImg = imshow(uint8(reshape(testImages(i,:),[128 128 3])));
%     pause
   [hogFeatures,imhog2] = customHOG(reshape(testFrames(i,:),[RESIZE_R RESIZE_C 3]));
%     [hogFeatures,imhog] = extractHOGFeatures(reshape(testFrames(i,:),[128 128 3]),'CellSize',[4 4]);
%     [hogFeatures,imhog] = customHOG(testImages);
    testFeaturesFrames(i,:) = hogFeatures;
end
extractFeaturesTimeTest = toc;
disp(sprintf('Time for Extracting Hog features of Testing Set: %f',extractFeaturesTimeTest));
%%
tic
kernelTest = double(kernel_poly(trainFeatures, testFeaturesFrames,1));
kernelTime = toc;
disp(sprintf('Time for testing Kernelization: %f',kernelTime));
%%
tic
trueTestLabelsFrames = ones(size(testFrames,1),1);
testLabelsFrames = zeros(size(testFrames,1),1);
[testLabelsFrames,accTest,valsTest] = svmpredict(trueTestLabelsFrames, [(1:size(kernelTest,1))' kernelTest], model);
predictTime = toc;
disp(sprintf('Time for predicting 2000 images: %f',predictTime));

imageIdx = find(testLabelsFrames==1)';


