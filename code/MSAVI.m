% Upload hyperspectral image
hcube = hypercube('taglio_Mola_EL1.img', taglio_Mola_EL1.hdr");
% Extract data from DataCube
data = hcube.DataCube;
% Read the dimensions of the hyperspectral image
[rows, cols, bands] = size(data);
% Initialize an array for the MSAVI index
msavi = zeros(rows, cols);
% Calculate MSAVI index for each pixel
for row = 1:rows
 for col = 1:cols
 % Extract the band values ​​needed to calculate MSAVI
 nir_band = data(row, col, 42); % It uses the NIR (near infrared) band, in this case the 30
 red_band = data(row, col, 26); % Use the red band, in this case the 20
 
 % Calculate MSAVI index
 msavi(row, col) = (2 * nir_band + 1 - sqrt((2 * nir_band + 1)^2 - 8 * (nir_band 
- red_band))) / 2;
 
 % Make sure the MSAVI index is between 0 and 1
 msavi(row, col) = max(0, min(msavi(row, col), 1));
 end
end
msavi_no_zeros = msavi(msavi ~= 0); % Filter values ​​other than 0
% Find the minimum value of MSAVI
min_value = min(msavi_no_zeros, [], 'all', 'omitnan');
% Find the maximum value of MSAVI
max_value = max(msavi, [], 'all', 'omitnan');
% Find the mean of MSAVI values
mean_value = nanmean(msavi_no_zeros, 'all');
% Represents the MSAVI index as an image
figure;
imshow(msavi);
title('MSAVI Vegetation Index');
colorbar;
% Represents the MSAVI index as a 'jet' colormap image
figure;
colormap jet;
imagesc(msavi);
title('MSAVI Vegetation Index');
colorbar;
val1 = 0;
val2 = 1;
% Calculate the histogram of MSAVI values ​​excluding the value 0
msavi_no_zeros = msavi(msavi ~= 0); % Filter values ​​other than 0
figure;
h = histogram(msavi_no_zeros(:), 'BinMethod', 'auto', 'NumBins', 64, 'FaceColor', 
'auto'); % ":" to convert the matrix to a column vector
colormap jet; % Set the colormap to 'jet'
colorbar('southoutside'); % Add a colorbar to show the association between colors and frequencies
title('MSAVI Histogram');
xlabel('MSAVI Value');
ylabel('Frequency');
% Manually set the limits of the histogram x-axis excluding the value 0
xlim([val1, val2]);
% Sets the color axis limits of the colorbar
clim([val1, val2]);
