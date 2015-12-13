close all
clear all
clc

%Load all the face and non-face images
addpath(sprintf('%s/customhog/',pwd))
load('imageFaces.mat')
load('imageNonFaces.mat')
load('idx.mat')
customHOG_setup;

%Split the data into training and testing set
trainImages = [imageFaces(idxTrainFaces,:); imageNonFaces(idxTrainNonFaces,:)];
testImages = [imageFaces(idxTestFaces,:); imageNonFaces(idxTestNonFaces,:)];
trueTrainLabels = [ones(size(idxTrainFaces,1),1); zeros(size(idxTrainNonFaces,1),1)];
trueTestLabels = [ones(size(idxTestFaces,1),1); zeros(size(idxTestNonFaces,1),1)];

%Extract hog features for training set
tic
for i=1:size(trainImages);
    [hogFeatures,imhog] = customHog(reshape(trainImages(i,:),[128 128 3]));
    trainFeatures(i,:) = hogFeatures;
end
extractFeaturesTimeTrain = toc;
disp(sprintf('Time for Extracting Hog features of Training Set: %f',extractFeaturesTimeTrain));

% Run till this section.
%% Train a SVM model
tic
kernelTrain = kernel_poly(trainFeatures, trainFeatures,1);
kernelTime = toc;
disp(sprintf('Time for training Kernelization: %f',kernelTime));
% Use built-in libsvm cross validation to choose the C regularization
% parameter.

crange = 10.^[-10:2:3];
for i = 1:numel(crange)
    acc(i) = svmtrain(trueTrainLabels, [(1:size(kernelTrain,1))' kernelTrain], sprintf('-t 4 -v 10 -c %g', crange(i)));
end
[~, bestc] = max(acc);
fprintf('Cross-val chose best C = %g\n', crange(bestc));


% Train and evaluate SVM classifier using libsvm
model = svmtrain(trueTrainLabels, [(1:size(kernelTrain,1))' kernelTrain], sprintf('-t 4 -c %g', crange(bestc)));


tic
for i=1:size(trainImages);
    [hogFeatures,imhog] = customHog(reshape(trainImages(i,:),[128 128 3]));
    trainFeatures(i,:) = hogFeatures;
end
extractFeaturesTimeTest = toc;
disp(sprintf('Time for Extracting Hog features of Testing Set: %f',extractFeaturesTimeTest));

tic
kernelTest = kernel_poly(trainFeatures, testFeatures,1);
kernelTime = toc;
disp(sprintf('Time for testing Kernelization: %f',kernelTime));

tic
[testLabels,accTest,valsTest] = svmpredict(trueTestLabels, [(1:size(kerneltest,1))' kerneltest], model);
predictTime = toc;
disp(sprintf('Time for predicting 1500 images: %f',predictTime));

[trainLabels,accTrain,valsTrain] = svmpredict(trueTrainLabels, [(1:size(kernelTrain,1))' kernelTrain], model);

test_accuracy = mean(testlabels==trueTestLabels);
train_accuracy = mean(trainLabels==trueTrainLabels);