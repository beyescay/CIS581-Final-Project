function wndw = reshape_intoWindows(C)

    global discretization;   
    
    s = length(C(1,:));
    tempLin = reshape(C,[1, discretization*discretization*s]);
    tempSort = sort(tempLin);        
    wndw = tempSort;

end