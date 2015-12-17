<<<<<<< HEAD
function imageIdx = detectFaces(testFrames) 
testFrames = image(final_window_idx);
% testImages = i;
% testImages = reshape(testImages,[1 size(testImages,1)*size(testImages,2)*3]);
%%
for i=1:size(testFrames,1)
    disp(sprintf('Testing Frame:%i',i));
% %     testImg = imshow(uint8(reshape(testImages(i,:),[128 128 3])));
%     pause
   [hogFeatures,imhog2] = customHOG(reshape(testFrames(i,:),[128 128 3]));
%     [hogFeatures,imhog] = extractHOGFeatures(reshape(testFrames(i,:),[128 128 3]),'CellSize',[4 4]);
%     [hogFeatures,imhog] = customHOG(testImages);
    testFeaturesFrames(i,:) = hogFeatures;
=======
tic

testImages = final_winow_idx;

for i=1:size(testImages,1);
    disp(sprintf('Testing Image:%i',i));
<<<<<<< HEAD
    [hogFeatures,imhog] = customHOG(testImages(i,:));
    testFeatures1(i,:) = hogFeatures;
=======
    [hogFeatures,imhog] = customHOG(reshape(testImages(i,:),[128 128 3]));
    testFeatures(i,:) = hogFeatures;
>>>>>>> d764aa822cc81e4f295a871c2f65ac5554486b6c
>>>>>>> ea866be04ef4fbd5bf88bb451e46d97b319b7e98
end
extractFeaturesTimeTest = toc;
disp(sprintf('Time for Extracting Hog features of Testing Set: %f',extractFeaturesTimeTest));

<<<<<<< HEAD
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
=======
%%
tic
<<<<<<< HEAD
kernelTest = kernel_poly(trainFeatures, testFeatures1,1);
kernelTime = toc;
disp(sprintf('Time for testing Kernelization: %f',kernelTime));

trueTestLabels = ones(size(testFeatures1,1),1);
tic
[testLabels1,accTest,valsTest] = svmpredict(trueTestLabels, [(1:size(kernelTest,1))' kernelTest], model);
predictTime = toc;
disp(sprintf('Time for predicting 2000 images: %f',predictTime));
=======
kernelTest = kernel_poly(trainFeatures, testFeatures,1);
kernelTime = toc;
disp(sprintf('Time for testing Kernelization: %f',kernelTime));

tic
[testLabels,accTest,valsTest] = svmpredict(trueTestLabels, [(1:size(kernelTest,1))' kernelTest], model);
predictTime = toc;
disp(sprintf('Time for predicting 2000 images: %f',predictTime));

[trainLabels,accTrain,valsTrain] = svmpredict(trueTrainLabels, [(1:size(kernelTrain,1))' kernelTrain], model);

test_accuracy = mean(testLabels==trueTestLabels);
train_accuracy = mean(trainLabels==trueTrainLabels);
>>>>>>> d764aa822cc81e4f295a871c2f65ac5554486b6c
>>>>>>> ea866be04ef4fbd5bf88bb451e46d97b319b7e98
