function [hog_features,imhog] = customHOG(img)

global CELL_SIZE;
global RESIZE_R;
global RESIZE_C;
global NUM_CELLS;
global NUM_BINS;
global BLOCKM_R;
global BLOCKM_C;
global cell_pixel_ids;
global storage;
global clearStorage;
global blockLayout;
global myfun;
global ix;
global iy;
global cC;
global cR;
global mag_page;
global ang_page;
% tic

    currImg = single(img);
    currImg = imresize(currImg, [RESIZE_R RESIZE_C]);
    
    ix = zeros([RESIZE_R RESIZE_C], 'like', currImg);
    iy = zeros([RESIZE_R RESIZE_C], 'like', currImg);
    mag_page = zeros([RESIZE_R RESIZE_C 3], 'like',currImg);
    ang_page = zeros([RESIZE_R RESIZE_C 3],'like', currImg);
    
    % calculate the gradient(keep max over each channel at that pixel)
    
    
    
    for i = 1 : size(currImg,3)
        ix(:,2:end-1,i) = conv2(currImg(:,:,i), [1 0 -1], 'valid');
        iy(2:end-1,:,i) = conv2(currImg(:,:,i), [1;0;-1], 'valid');  
        
        
        ix(:,1,i)   = currImg(:,2,i)   - currImg(:,1,i);
        ix(:,end,i) = currImg(:,end,i) - currImg(:,end-1,i);
    
        iy(1,:,i)   = currImg(2,:,i)   - currImg(1,:,i);
        iy(end,:,i) = currImg(end,:,i) - currImg(end-1,:,i);
        
  
         mag_page(:,:,i) = hypot(ix(:,:,i),iy(:,:,i));
         ang_page(:,:,i) = atan2d(-iy(:,:,i),ix(:,:,i));
    end  
    
     
    
    [max_mag_page,max_mag_idx] = max(mag_page,[],3);
    [rIdx, cIdx] = ndgrid(1:RESIZE_R, 1:RESIZE_C);
    ind  = sub2ind([RESIZE_R RESIZE_C 3], rIdx(:), cIdx(:), max_mag_idx(:));
    angles = reshape(ang_page(ind), [RESIZE_R RESIZE_C]);    

                            
    % change the range of the angles
    angles(angles > 179 ) = angles(angles > 179) - 179;
    angles(angles <  0) = angles(angles < 0) + 179;
    angles(angles < 10) = 10;
    angles(angles > 170) = 169;
    angles = angles + 10;
    
    % the magnitude of the gradient - arranged by cell
    magGradient = max_mag_page;       
    
    reshapedAngles = angles(reshape(cell_pixel_ids,RESIZE_R*RESIZE_C,1)');
    reshapedAngles = reshape(reshapedAngles,[NUM_CELLS,CELL_SIZE*CELL_SIZE]);    
    
    magGradient = magGradient(reshape(cell_pixel_ids,RESIZE_R*RESIZE_C,1)');
    magGradient = reshape(magGradient, [NUM_CELLS,CELL_SIZE*CELL_SIZE]);    
    
    % to this mag matrix, obtain the quotient and remainder
    binCentres_rows = floor(reshapedAngles./20);
    R = 1 - rem(reshapedAngles,20)./20;
    votedMag_lower = magGradient.*R;
    
    
    % storage ids
    storage_ids = NUM_CELLS*CELL_SIZE*CELL_SIZE.*(cC-1) + cR + ...
                  NUM_CELLS.*(reshape(binCentres_rows,...
                            [NUM_CELLS*CELL_SIZE*CELL_SIZE, 1]) - 1);
                        
    
    storage(storage_ids) = reshape(votedMag_lower,...
                            [NUM_CELLS*CELL_SIZE*CELL_SIZE, 1]);
    % clear storage
    
    
    
    accBins = sum(storage,3);
    accBins = accBins(:,1:NUM_BINS);
    storage = clearStorage;
    
    % do the same for the upper part of the bilinear interpolation
    binCentres_rows = ceil(reshapedAngles./20);
    R = rem(reshapedAngles,20)./20;
    votedMag_upper = magGradient.*R;
    
    % storage ids - upper part of the bilinear interpolation
    storage_ids = NUM_CELLS*CELL_SIZE*CELL_SIZE.*(cC-1) + cR + ...
                  NUM_CELLS.*(reshape(binCentres_rows,...
                            [NUM_CELLS*CELL_SIZE*CELL_SIZE, 1]) - 1);
                        
   
    storage(storage_ids) = reshape(votedMag_upper,...
                            [NUM_CELLS*CELL_SIZE*CELL_SIZE, 1]);
                        
   
    
    tempAccBins = sum(storage,3);
    tempAccBins = tempAccBins(:,1:NUM_BINS);
    accBins = tempAccBins + accBins;
    storage = clearStorage;    
    
    
    blockBins = accBins(blockLayout',:);
    
    blockCelled = mat2cell(blockBins,[4.*ones(BLOCKM_R*BLOCKM_C,1)],NUM_BINS);
    tempBins = cellfun(myfun,blockCelled,'UniformOutput',0);
    tempBins = cell2mat(tempBins);
    hog_features  = reshape(tempBins,[1,BLOCKM_R*BLOCKM_C*4*NUM_BINS]);
%     toc
    
    tt = reshape(tempBins,[BLOCKM_R BLOCKM_C 4*NUM_BINS]);
    tt = single(tt);
    imhog = vl_hog('render', tt, 'variant', 'dalaltriggs');
    
end