function wndw = reshape_intoWindows(C)

    s = length(C(1,:));
    temp1 = reshape(C(1,:),[sqrt(s), sqrt(s)]);
    temp2 = reshape(C(2,:),[sqrt(s), sqrt(s)]);
    temp3 = reshape(C(3,:),[sqrt(s), sqrt(s)]);
    temp4 = reshape(C(4,:),[sqrt(s), sqrt(s)]);
    
    wndw = [temp1 temp3; temp2 temp4];
    wndw = reshape(wndw, [1, s*4]);

end