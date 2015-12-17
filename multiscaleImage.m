function scaledImages = multiscaleImage(image)


scale = [2 2^0.5 1 1/(2^0.5) 1/2];
numR = size(image,1);
numC = size(image,2);

newNumR = round(numR/scale);
newNumC = round(numC/scale);

scaledImages{1} = imresize(image,[newNumR(1),newNumC(1)]);
scaledImages{2} = imresize(image,[newNumR(2),newNumC(2)]);
scaledImages{3} = imresize(image,[newNumR(3),newNumC(3)]);
scaledImages{4} = imresize(image,[newNumR(4),newNumC(4)]);
scaledImages{5} = imresize(image,[newNumR(5),newNumC(5)]);
