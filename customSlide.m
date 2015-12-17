function netImageContentAllWindows = customSlide(image)

global discretization;
global desc_size;
desc_size = 128;s

[numR, numC, ~] = size(image);
miniWindowSize = 32;
discretization = desc_size/miniWindowSize;
cellReshape = @reshape_intoWindows;
tic
% alter image to fit the required sliding window 
closestR = round(numR/miniWindowSize);
closestC = round(numC/miniWindowSize);

image = imresize(image, [closestR*miniWindowSize closestC*miniWindowSize]);

numR = closestR*miniWindowSize;
numC = closestC*miniWindowSize;

hWindowNum = numR*numC/(miniWindowSize^2);



motherTemplate_2d = reshape( (1:numR*numC),[numR numC] );


hWindow_blk = mat2cell(motherTemplate_2d, miniWindowSize.*ones((numR/miniWindowSize),1),...
                                          miniWindowSize.*ones((numC/miniWindowSize),1));
hWindow_blk = cell2mat(reshape(hWindow_blk,hWindowNum,1));
hWindow_idx = hWindow_blk(1:miniWindowSize:size(hWindow_blk,1),1);

% hWindow patch 
hWindow_patch = hWindow_blk(1:miniWindowSize,:) - 1;
hWindow_adder = reshape(hWindow_patch,[miniWindowSize*miniWindowSize, 1])';
hWindow_adder_spread = repmat(hWindow_adder, hWindowNum,1);
hWindow_idx = repmat(hWindow_idx,1,miniWindowSize*miniWindowSize);
hWindowContent_idx = hWindow_adder_spread + hWindow_idx;

% now for the full window - concatenatiom of STRIDE-hWindow
hWindow_numR = numR/miniWindowSize;
hWindow_numC = numC/miniWindowSize;
windowNumR = hWindow_numR-(discretization-1);
windowNumC = hWindow_numC-(discretization-1);

windowLayout = reshape((1:hWindow_numR*hWindow_numC),[hWindow_numR hWindow_numC]);
windowLayout = windowLayout(1:end-(discretization -1 ), 1:end-(discretization -1));


window_cat = windowLayout(1:discretization,1:discretization) -1 ;

window_hWindow_adder = reshape(window_cat,[1, discretization*discretization]);
window_hWindow_content_idx = reshape(windowLayout,[windowNumR*windowNumC,1]);
window_hWindow_content_idx = repmat(window_hWindow_content_idx,1,discretization*discretization);
window_hWindow_adder_spread = repmat(window_hWindow_adder,windowNumR*windowNumC,1);
window_hWindow_content = window_hWindow_content_idx + window_hWindow_adder_spread;


window_pxl = hWindowContent_idx(reshape(window_hWindow_content', windowNumC*...
                                        windowNumR*discretization*discretization ,1),:);
windowCelled = mat2cell(window_pxl,discretization*discretization....
          *ones(windowNumR*windowNumC,1),miniWindowSize*miniWindowSize);

windowUnrolled  = cellfun(cellReshape, windowCelled,'UniformOutput',0);
windowUnrolled = cell2mat(windowUnrolled);

% extending into 3rd dimension
add_dim1 = zeros(1,size(windowUnrolled,2));
add_dim2 = zeros(1,size(windowUnrolled,2)) + numR*numC;
add_dim3 = zeros(1,size(windowUnrolled,2)) + 2*numR*numC;
net_dim_adder = [add_dim1 add_dim2 add_dim3];

windowUnrolled_dim3 = repmat(windowUnrolled,1,3);
net_dim_adder_extend = repmat(net_dim_adder,windowNumC*windowNumR,1);
final_winow_idx = windowUnrolled_dim3 + net_dim_adder_extend;
toc

netImageContentAllWindows = image(final_winow_idx);


end