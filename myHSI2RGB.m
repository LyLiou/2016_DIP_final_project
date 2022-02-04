function [ output ] = myHSI2RGB( input )
    %http://angeljohnsy.blogspot.com/2013/06/convert-hsi-image-to-rgb-image.html
    H = input(:, :, 1);
    S = input(:, :, 2);
    I = input(:, :, 3);
    H = H*360;

    R = zeros(size(H));  
    G = zeros(size(H));  
    B = zeros(size(H));  

    B(H<120) = I(H<120).*(1-S(H<120));  
    R(H<120) = I(H<120).*(1+((S(H<120).*cosd(H(H<120)))./cosd(60-H(H<120))));  
    G(H<120) = 3.*I(H<120)-(R(H<120)+B(H<120));  

    Ht=H-120;  

    R(H>=120 & H<240) = I(H>=120 & H<240).*(1-S(H>=120 & H<240));  
    G(H>=120 & H<240) = I(H>=120 & H<240).*(1+((S(H>=120 & H<240).*cosd(Ht(H>=120&H<240)))./cosd(60-Ht(H>=120 & H<240))));  
    B(H>=120 & H<240) = 3.*I(H>=120 & H<240)-(R(H>=120 & H<240)+G(H>=120 & H<240));  

    Ht=H-240;  

    G(H>=240 & H<=360) = I(H>=240 & H<=360).*(1-S(H>=240 & H<=360));  
    B(H>=240 & H<=360) = I(H>=240 & H<=360).*(1+((S(H>=240 & H<=360).*cosd(Ht(H>=240&H<=360)))./cosd(60-Ht(H>=240&H<=360))));  
    R(H>=240 & H<=360) = 3.*I(H>=240 & H<=360)-(G(H>=240 & H<=360)+B(H>=240 & H<=360));  
    
    output = cat(3, R, G, B);
end

