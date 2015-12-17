tic
vidObj = VideoReader('/Users/beyescay/Documents/Upenn/3rd Sem/CIS 581/Project 4/anchorman.mp4');

vidWidth = vidObj.Width;
vidHeight = vidObj.Height;

%Create a movie structure array,mov.

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

%Read one frame at a time until the end of the video is reached.

k = 1;
while hasFrame(vidObj)
    mov(k).cdata = readFrame(vidObj);
    k = k+1;
end
toc