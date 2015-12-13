clc
clear all

imageFolderNames = dir('Dataset/Scene_Dataset_SUN');
imageFolderNames(1:3)=[];

for i =1:length(imageFolderNames);
    disp(sprintf('Folder Number and Name:%i - %s',i,imageFolderNames(i).name));
    if imageFolderNames(i).isdir==1
        imageSubFolderNames = dir(sprintf('Dataset/Scene_Dataset_SUN/%s',imageFolderNames(i).name));
        imageSubFolderNames(1:3)=[];
        for j=1:length(imageSubFolderNames)
            disp(sprintf('Sub Folder Number and Name:%i - %s',j,imageSubFolderNames(j).name));
            imageNames = dir(sprintf('Dataset/Scene_Dataset_SUN/%s/%s',imageFolderNames(i).name,imageSubFolderNames(j).name));
            imageNames(1:3)=[];
            for k=1:length(imageNames);
                if imageNames(k).isdir==0
                    disp(sprintf('Image Number:%i',k));
                    imageCurrent = imread(sprintf('Dataset/Scene_Dataset_SUN/%s/%s/%s',imageFolderNames(i).name,imageSubFolderNames(j).name,imageNames(k).name));
                    [nr,nc,nz] = size(imageCurrent);
                    if nz==3
                        allowedRowNum = nr-128+1;
                        allowedColNum = nc-128+1;
                        if allowedColNum>=1 || allowedRowNum>=1
                            selRow = randperm(allowedRowNum,1);
                            selCol = randperm(allowedColNum,1);
                            imageCurrent = imageCurrent(selRow:selRow+127,selCol:selCol+127,:);
                            
                            imageCurrent = reshape(imageCurrent,[1 128*128*3]);
                            if i==1 && j==1 && k==1
                                imageNonFaces = [ imageCurrent];
                            else
                                imageNonFaces = [imageNonFaces;imageCurrent];
                            end
                        end
                    end
                end
            end
        end
    end
    if size(imageNonFaces,1)>5000
        break;
    end
end