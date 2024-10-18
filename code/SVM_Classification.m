% Upload hyperspectral image
hcube = hypercube('taglio_Mola_EL1.img', 'taglio_Mola_EL1.hdr');
% Select RGB image
rgbImg = colorize(hcube, 'Method', 'rgb', 'ContrastStretching', true);
% Display image
figure
imagesc(rgbImg);
axis image off
title('RGB Image of Data Cube')
% Display Image
imshow(rgbImg);
% Zoom with the mouse to select pixels more precisely
zoom on;
% Temporarily block the start of ginput
pause();
% Exit zoom mode
zoom off;
% Select 50 pixels from the image
num_points = 50;
[x, y] = ginput(num_points);
% Return to original image size
zoom out;
x = round(x);
y = round(y);
% Extract spectral signatures of selected pixels
spectral_signatures = zeros(num_points, size(hcube.DataCube, 3));
for i = 1:num_points
 % Get the coordinates of the selected pixel
 x_pixel = x(i);
 y_pixel = y(i);
 
 % Get the spectral signature of the selected pixel
 spectral_signature = squeeze(hcube.DataCube(y_pixel, x_pixel, :));
 
 % Save the spectral signature in the spectral signature matrix
 spectral_signatures(i, :) = spectral_signature;
end
% Calculate the average hyperspectral signature of the selected pixels
mean_spectral_signature = mean(spectral_signatures, 1);
% Trace the average hyperspectral signature
figure;
plot(mean_spectral_signature);
xlabel('Banda spettrale');
ylabel('Riflettanza');
title('Firma iperspettrale media dei pixel selezionati');
% Creates a label vector for the selected pixels
labels = repmat([1 0], num_points/2, 1);
labels = labels(:);
% Train SVM classifier on spectral signatures
classifier = fitcsvm(spectral_signatures, labels, 'KernelFunction', 'linear', 
'Standardize', true);
% Classify all pixels of the hyperspectral image
img_reshaped_hyperspectral = reshape(hcube.DataCube, [], size(hcube.DataCube, 3));
predicted_labels_hyperspectral = predict(classifier, img_reshaped_hyperspectral);
% Search for pixels with the same spectral signature as the selected pixels
idx_hyperspectral = ismember(predicted_labels_hyperspectral, 
predicted_labels_hyperspectral(1:num_points));
im_binary_hyperspectral = reshape(idx_hyperspectral, size(hcube.DataCube, 1), 
size(hcube.DataCube, 2));
% Resize the binary image to the original RGB image dimensions
im_binary_resized = imresize(im_binary_hyperspectral, size(rgbImg, 1:2));
% Overlays the binary image on the RGB image
rgb_overlay = imoverlay(rgbImg, im_binary_resized, [1 1 1]);
% View image with olive trees highlighted
figure;
imshow(rgb_overlay);
title('Olive trees identified');
