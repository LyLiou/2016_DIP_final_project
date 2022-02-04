function [ output ] = myfilt1( input, sz )
    %bwinput = input(:, :, 1)+input(:, :, 2)+input(:, :, 3);
    [m, n] = size(input(:, :, 1));
    %bwinput = padarray(bwinput, [sz, sz], 'symmetric');
    input = padarray(input, [sz, sz], 'symmetric');
    output = zeros(size(input));
    for i = sz+1:sz+m
        for j = sz+1:sz+n
            flag = 0;
            for k = i-sz:i+sz
                for l = j-sz:j+sz
                    if input(i, j, 1)<0.7 || input(i, j, 2)<0.7 || input(i, j, 3)<0.7
                        flag = 1;
                    end
                    if flag == 1
                        break
                    end
                end
                if flag == 1
                    break
                end
            end
            if flag == 1
                output(i, j, 1:3) = input(i, j, 1:3);
            else
                output(i, j, 1:3) = [1, 1, 1];
            end
        end
    end
    output = output(sz+1:sz+m, sz+1:sz+n, :);
end

