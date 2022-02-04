function [ output ] = myRGB2HSI( input )
    %http://angeljohnsy.blogspot.com/2013/05/converting-rgb-image-to-hsi.html
    R = input(:, :, 1);
    G = input(:, :, 2);
    B = input(:, :, 3);
    H = acosd((1/2*((R-G)+(R-B)))./((((R-G).^2+((R-B).*(G-B))).^0.5)+0.000001));
    H(B>G) = 360-H(B>G);
    H = H/360;
    S = 1 - (3./(sum(input,3)+0.0000001)).*min(input,[],3);
    I = sum(input, 3)./3;
    output = cat(3, H, S, I);
end

