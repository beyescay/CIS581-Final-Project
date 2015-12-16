tic

testImages = final_winow_idx;

for i=1:size(testImages,1);
    disp(sprintf('Testing Image:%i',i));
    [hogFeatures,imhog] = customHOG(testImages(i,:));
    testFeatures1(i,:) = hogFeatures;
end
extractFeaturesTimeTest = toc;
disp(sprintf('Time for Extracting Hog features of Testing Set: %f',extractFeaturesTimeTest));

%%
tic
kernelTest = kernel_poly(trainFeatures, testFeatures1,1);
kernelTime = toc;
disp(sprintf('Time for testing Kernelization: %f',kernelTime));

trueTestLabels = ones(size(testFeatures1,1),1);
tic
[testLabels1,accTest,valsTest] = svmpredict(trueTestLabels, [(1:size(kernelTest,1))' kernelTest], model);
predictTime = toc;
disp(sprintf('Time for predicting 2000 images: %f',predictTime));
