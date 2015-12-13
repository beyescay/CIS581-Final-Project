SET_PARAMS;
global cell_pixel_ids;
global storage;
global clearStorage;
global blockLayout;
global myfun;
global ix;
global iy;
global mag_page;
global ang_page;
global cC;
global cR;


%% sampleImage is an example image from the train set to ascertain dimension calculations
sampleImg = reshape(imageFaces(1,:),[128 128 3]);
% create the mag, idxing template - 
[numR, numC,~] = size(sampleImg);
sampleImg = single(imresize(sampleImg, [RESIZE_R RESIZE_C]));
if ((size(sampleImg,3)  ~= 1))
    sampleImg = rgb2gray(sampleImg);
end
    
im_id_template  = reshape((1:RESIZE_C*RESIZE_R)',[RESIZE_R, RESIZE_C]);

% get the NUM_CELLS*CELL_SIZE by CELL_SIZE matrix
C = mat2cell(im_id_template,[repmat(CELL_SIZE,RESIZE_R/CELL_SIZE,1)],...
                                   [repmat(CELL_SIZE, RESIZE_C/CELL_SIZE,1)]);
cellIds = cell2mat(reshape(C,[RESIZE_R/CELL_SIZE*RESIZE_C/CELL_SIZE,1]));
cell_pixel_ids = cellIds((1:CELL_SIZE:CELL_SIZE*NUM_CELLS)',1);
idx_template = repmat(cell_pixel_ids,1,CELL_SIZE*CELL_SIZE);
patch = cell2mat(C(1));
increment = patch - 1;
linear_adder = reshape(increment,CELL_SIZE*CELL_SIZE,1)';
linear_adder_spread = repmat(linear_adder,NUM_CELLS,1);
cell_pixel_ids = linear_adder_spread + idx_template;

% make template for the NUM_CELLS*(CELL_SIZE^2)
template_cell_idx = reshape((1:NUM_CELLS*CELL_SIZE*CELL_SIZE),NUM_CELLS,...
                                            CELL_SIZE*CELL_SIZE);
[cR, cC] = ind2sub([NUM_CELLS,CELL_SIZE*CELL_SIZE], ...
                                (1:NUM_CELLS*CELL_SIZE*CELL_SIZE));
    
cC =cC';
cR = cR';

clearStorage = zeros(NUM_CELLS,CELL_SIZE*CELL_SIZE,CELL_SIZE*CELL_SIZE);
storage =  zeros(NUM_CELLS,CELL_SIZE*CELL_SIZE,CELL_SIZE*CELL_SIZE);

% define the block layout - in terms of cell_idx
cellGrid = reshape((1:NUM_CELLS),[CELLM_R, CELLM_C]);
blockGrid = cellGrid(1:end-1,1:end-1);
blockIncrement = [0 1 CELLM_R CELLM_R+1];
blockIds = reshape(blockGrid,[(BLOCKM_R)*(BLOCKM_C),1]);
blockIds_spread = repmat(blockIds,1,4);
blockIncrement_spread = repmat(blockIncrement,(BLOCKM_R)*(BLOCKM_C),1);
blockLayout = blockIncrement_spread + blockIds_spread;

myfun = @testCellFun;

ix = zeros([RESIZE_R RESIZE_C], 'like', sampleImg);
iy = zeros([RESIZE_R RESIZE_C], 'like', sampleImg);
mag_page = zeros([RESIZE_R RESIZE_C 3], 'like',sampleImg);
ang_page = zeros([RESIZE_R RESIZE_C 3],'like', sampleImg);


