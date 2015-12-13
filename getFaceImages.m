% clc
% clear all

imageFolderNames = dir('Dataset/lfw_funneled');
imageFolderNames(1:2)=[];

for i =1874:length(imageFolderNames);
    disp(sprintf('Folder Number:%i',i));
    if imageFolderNames(i).isdir==1
        imageNames = dir(sprintf('Dataset/lfw_funneled/%s',imageFolderNames(i).name));
        imageNames(1:2)=[];
        for j=1:length(imageNames)
            disp(sprintf('Image Number:%i',j));
            imageCurrent = imread(sprintf('Dataset/lfw_funneled/%s/%s',imageFolderNames(i).name,imageNames(j).name));
            imageCurrent = reshape(imageCurrent,[1 250*250*3]);
            if i~=1
                imageFaces = [imageFaces; imageCurrent];
            else
                imageFaces = [imageCurrent];
            end
        end
    else
    end
    if size(imageFaces,1)>5000
        break;
    end
end