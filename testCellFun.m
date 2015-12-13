function g = testCellFun(C)
   
    g  = [C(1,:) C(2,:) C(3,:) C(4,:)];
    g = g./(norm(g) + 0.0001);
   
end
