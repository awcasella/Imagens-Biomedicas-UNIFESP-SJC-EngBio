clear; clc; close all;

%% Open image

name = '../Images/TransversalMRI_salt-and-pepper.pgm';

if endsWith(name, '.pgm')
    I = im2double(imread(name));
elseif endsWith(name, '.dicom')
    I = dicomread(name);
end

%% Plotting single image
figure(1)
image(im2uint8(I)); colormap(gray(256)); title('MRI'); 

% Getting a rectangular area of image for Lee's filter
rect = getrect;
xmin = round(rect(1));
ymin = round(rect(2));
xmax = xmin + round(rect(3));
ymax = ymin + round(rect(4));

vetor = I(ymin:ymax, xmin:xmax);
vetor = vetor(1:end);
vrh = var(vetor);
mrh = mean(mean(I(ymin:ymax, xmin:xmax)));
%% Processing image

% Building histogram of image
[h, x] = FazerHistograma(I); 

% Applying moving average filter
I_2 = FiltroMedia(I, [3, 3]);

% Applying Median filter
I_3 = FiltroMediana(I, 3);

% Applying Gradient filter
tipo = 'sobel';
I_4 = Gradiente(I, tipo);

% Applying laplacian filter
I_5 = Laplaciano(I, 'torre');

% Applying Lee's filter
I_6 = Lee(vrh, I, [3, 3]);

%% Plotting multiple images

figure('name','All plots')

subplot(2,3,1)
stem(x,h); title('Histogram of Image');

subplot(2,3,2)
image(im2uint8(I_2)); colormap(gray(256)); title('Moving average');

subplot(2,3,3)
image(im2uint8(I_3)); colormap(gray(256)); title('Median Filter');

subplot(2,3,4)
image(im2uint8(I_4)); colormap(gray(256)); title('Gradient with sobel');

subplot(2,3,5)
image(im2uint8(I_5)); colormap(gray(256)); title('Laplacian');

subplot(2,3,6)
image(im2uint8(I_6)); colormap(gray(256)); title('Lee Filter');