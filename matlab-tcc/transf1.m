function transf1 ()
    m = zeros(31,12);
    m = readmatrix ('dados2021.txt');
    a = 1;
    b = 1;
    
    for a = 1:size(m,1)
        for b = 1:size(m,2)
            if m(a,b) > 0
                m(a,b) = 1;
            end
        end
    end
    
    dlmwrite('dados2021_v2.txt',m);
end

