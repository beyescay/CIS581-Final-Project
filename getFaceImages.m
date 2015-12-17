clc
clear all
imageFolderNames = dir('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/Dataset/faceData/2003');
imageFolderNames(1:3)=[];
count =0;
for i =1:length(imageFolderNames);
    disp(sprintf('Folder Number:%i',i));
    if imageFolderNames(i).isdir==1
        imageSubFolderNames = dir(sprintf('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/Dataset/faceData/2003/%s',imageFolderNames(i).name));
        imageSubFolderNames(1:3)=[];
        for j=1:length(imageSubFolderNames)
            imageNames = dir(sprintf('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/Dataset/faceData/2003/%s/%s',imageFolderNames(i).name,imageSubFolderNames(j).name));
            imageNames(1:2)=[];
            for k=1:size(imageNames,1)
                count =count+1;
                disp(sprintf('Image Number:%i',k));
                imageCurrent = imread(sprintf('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/Dataset/faceData/2003/%s/%s/%s',imageFolderNames(i).name,imageSubFolderNames(j).name,imageNames(k).name));
                if size(imageCurrent,1)==86 && size(imageCurrent,2)==86
                    imageCurrent = reshape(imageCurrent,[1 86*86*3]);
                    if count~=1
                        imageFacesFIW = [imageFacesFIW; imageCurrent];
                    else
                        imageFacesFIW = [imageCurrent];
                    end
                else
                end
            end
        end
        
        
    else
    end
    if size(imageFacesFIW,1)>5000
        break;
    end
end