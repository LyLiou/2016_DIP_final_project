sel = input('Choose a function.\n');
sel = round(sel);

if sel<1 || sel>5
    fprintf('See you.\n')
    return
end

img_name = uigetfile({'*.tif'}, 'Select picture');
input_img = im2single(imread(img_name));
if size(input_img, 3)==1
    input_img = cat(3, input_img, input_img, input_img);
end

if sel == 1
    text_size = input('Enter the width of a alphabet.\n');
    fprintf('Please wait...\n')
    mask_size = round(text_size);
    HSI_img = myRGB2HSI(input_img);
    HSI_bg = HSI_img;
    HSI_bg(:, :, 3) = medfilt2(HSI_bg(:, :, 3), [mask_size mask_size]);
    RGB_bg = myHSI2RGB(HSI_bg);
    figure
    imshow(RGB_bg(:, :, 1:3));
    imwrite(im2uint8(RGB_bg(:, :, 1:3)), '1background.tif');

    HSI_img(:, :, 3) = (1-HSI_bg(:, :, 3) + HSI_img(:, :, 3));
    output_img = myHSI2RGB(HSI_img);
    figure
    imshow(output_img(:, :, 1:3));
    imwrite(im2uint8(output_img(:, :, 1:3)), '2remove_background.tif');
elseif sel == 2
    fprintf('Please wait...\n')
    var = input('Enter variable used to power-low transformation.\n');
    HSI_img = myRGB2HSI(input_img);
    HSI_img(:, :, 3) = HSI_img(:, :, 3).^var;
    output_img = myHSI2RGB(HSI_img);
    figure
    imshow(output_img(:, :, 1:3));
    imwrite(im2uint8(output_img(:, :, 1:3)), '3power_low.tif');
elseif sel == 3
    text_size = input('Enter the width of a alphabet.\n');
    fprintf('Please wait...\n')
    input_img = myfilt1(input_img, round(text_size/2));
    figure
    imshow(input_img);
    imwrite(im2uint8(input_img(:, :, 1:3)), '4remove_noise.tif');
    
    mask = 1 - im2single(bwareafilt(logical(1-rgb2gray(input_img)), [0, round((text_size*0.25)^2)]));
    input_img = 1-(1-input_img).* cat(3, mask, mask, mask);
    figure
    imshow(input_img);
    imwrite(im2uint8(input_img(:, :, 1:3)), '5remove_noise.tif');

    gray_img = 1-rgb2gray(input_img);
    C = centerOfMass(gray_img);
    cn = C(2);
    lcn = centerOfMass(gray_img(:, 1:cn));
    rcn = centerOfMass(gray_img(:, cn:end));
    input_img = imrotate(1-input_img, rad2deg(atan((rcn(1)-lcn(1))/(rcn(2)+size(input_img, 2)/2-lcn(2)))), 'bicubic', 'loose');
    input_img = 1-input_img;
    figure
    imshow(input_img(:, :, 1:3));
    imwrite(im2uint8(input_img(:, :, 1:3)), '6deskew.tif');
elseif sel == 4
    text_size = input('Enter the width of a alphabet.\n');
    fprintf('Please wait...\n')
    len = round(text_size*2);
    input_img = line_detect(rgb2gray(input_img), len);
    figure
    imshow(input_img);
    imwrite(im2uint8(input_img), '7line.tif');

    input_img = logical(1-input_img);
    fl = fopen('line.in', 'w');
    fprintf(fl, '%d %d %d\n', size(input_img), text_size);
    fprintf(fl, '%d ', input_img);
    figure
    imshow(input_img);
    imwrite(im2uint8(input_img), '8line.tif');
elseif sel == 5
    file_in = uigetfile({'*.tif'}, 'Select 7line.tif');
    text_size = input('Enter the width of a alphabet.\n');
    fprintf('Please wait...\n')
    line = im2single(imread(file_in));
    kernal = strel('disk', round(text_size/8));
    line = imopen(line, kernal);
    input_img = 1-(1-input_img).*cat(3, line, line, line);
    A = dlmread('line.out');
    B = 1-A;
    input_img = input_img.*cat(3, B, B, B);
    input_img = input_img+cat(3, A.*0.9, A.*0.24, A.*0.24);
    figure
    imshow(input_img);
    imwrite(im2uint8(input_img(:, :, 1:3)), '9replace_line.tif');
end