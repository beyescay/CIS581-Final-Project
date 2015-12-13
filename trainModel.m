close all
clear all
clc

%Load all the face and non-face images
addpath(sprintf('%s/customhog/',pwd))
load('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/idx/imageFaces.mat')
load('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/idx/imageNonFaces.mat')
load('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/idx/idx.mat')
customHOG_setup;
run('vlfeat-0.9.20/toolbox/vl_setup')
%Split the data into training and testing set
trainImages = [imageFaces(idxTrainFaces,:); imageNonFaces(idxTrainNonFaces,:)];
testImages = [imageFaces(idxTestFaces,:); imageNonFaces(idxTestNonFaces,:)];
trueTrainLabels = [ones(size(idxTrainFaces,1),1); zeros(size(idxTrainNonFaces,1),1)];
trueTestLabels = [ones(size(idxTestFaces,1),1); zeros(size(idxTestNonFaces,1),1)];

%Extract hog features for training set
totalFeatureExtractorStartTime = tic;

disp('Getting Training HOG Features')
for i=1:size(trainImages,1);
    disp(sprintf('Training Image:%i',i));
    [hogFeatures,imhog] = customHOG(reshape(trainImages(i,:),[128 128 3]));
    trainFeatures(i,:) = hogFeatures;
end
extractFeaturesTimeTrain = toc(totalFeatureExtractorStartTime);
disp(sprintf('Time for Extracting Hog features of Training Set: %f',extractFeaturesTimeTrain));

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
for i=1:size(testImages,1);
    disp(sprintf('Testing Image:%i',i));
    [hogFeatures,imhog] = customHOG(reshape(testImages(i,:),[128 128 3]));
    testFeatures(i,:) = hogFeatures;
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
disp(sprintf('Time for predicting 2000 images: %f',predictTime));

[trainLabels,accTrain,valsTrain] = svmpredict(trueTrainLabels, [(1:size(kernelTrain,1))' kernelTrain], model);

test_accuracy = mean(testlabels==trueTestLabels);
train_accuracy = mean(trainLabels==trueTrainLabels);