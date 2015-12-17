% define the imageLocation and collection


%imageLocation = 'Caltech_CropFaces';
% imageLocation = 'images'; % the images folder will have all the training images

% dataSet = imageSet(imageLocation);



global CELL_SIZE;
global BLOCK_SIZE;
global RESIZE_R;
global RESIZE_C;
global NUM_CELLS;
global NUM_BINS;
global CELLM_R;
global CELLM_C;
global BLOCKM_R;
global BLOCKM_C;


CELL_SIZE = 4; % in terms of pixels
BLOCK_SIZE = 2; % in terms of cells 
RESIZE_R = 84;
RESIZE_C = 84;
NUM_BINS = 9;
NUM_CELLS = RESIZE_R*RESIZE_C / (CELL_SIZE*CELL_SIZE);
CELLM_R = RESIZE_R/CELL_SIZE;
CELLM_C = RESIZE_C/CELL_SIZE;

BLOCKM_R = CELLM_R-1;
BLOCKM_C = CELLM_C-1; 