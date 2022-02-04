function [ output ] = threshold( input )
    output = zeros(size(input));
    k = 0.7;
    for i = 1:size(input, 1)
        for j = 1:size(input, 2)
            if input(i, j)<k
                output(i, j) = input(i, j);
            else
                output(i, j) = 1;
            end
        end
    end
end

