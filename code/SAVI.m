% Upload hyperspectral image
hcube = hypercube('taglio_Mola_EL1.img', taglio_Mola_EL1.hdr");
% Extract data from the DataCube
data = hcube.DataCube;
% Read the dimensions of the hyperspectral image
[rows, cols, bands] = size(data);
% Initialize an array for the SAVI index
savi = zeros(rows, cols);
% Calculate the SAVI index for each pixel
for row = 1:rows
 for col = 1:cols
 % Extract the band values ​​needed to calculate SAVI
 nir_band = data(row, col, 42); % It uses the NIR (near infrared) band, in this case the 42
 red_band = data(row, col, 26); % Use the red band, in this case the 26th
 
 % Calculate the SAVI index
 L = 0.5;
 savi(row, col) = (nir_band - red_band) / (nir_band + red_band + L) * (1 + L);
 % Generally speaking, in areas without green vegetation cover, 
 % L=1; in areas with moderate green vegetation cover, L=0.5; 
 % in areas with high green vegetation cover, L=0 (which is equivalent to the NDVI method).
 end
end
savi_no_zeros = savi(savi ~= 0); % Filter values ​​other than 0
% Find the minimum value of savi
min_value = min(savi_no_zeros, [], 'all', 'omitnan');
% Find the maximum value of savi
max_value = max(savi, [], 'all', 'omitnan');
% Find the average of the savi values
mean_value = nanmean(savi_no_zeros, 'all');
% Represents the SAVI index as an image 
figure;
imshow(savi);
title('SAVI Vegetation Index');
colorbar;
% Represents the SAVI index as a 'jet' colormap image
figure;
colormap jet;
imagesc(savi);
title('SAVI Vegetation Index');
colorbar;
% Normalization of the SAVI index in the interval [0, 1]
savi_normalized = mat2gray(savi, [0, 1]);
% Represents the normalized SAVI index as a 'jet' colormap image
figure;
colormap jet;
imagesc(savi_normalized);
title('SAVI Vegetation Index');
colorbar;
val1 = 0;
val2 = 1;
% Calculate the histogram of SAVI values ​​excluding the value 0
savi_no_zeros = savi(savi ~= 0); % Filter values ​​other than 0
figure;
h = histogram(savi_no_zeros(:), 'BinMethod', 'auto', 'NumBins', 64, 'FaceColor', 
'auto'); % ":" to convert the matrix to a column vector
colormap jet; % Set colormap to 'jet'
colorbar('southoutside'); % Add a colorbar to show the association between colors and frequencies
title('SAVI Histogram');
xlabel('SAVI Value');
ylabel('Frequency');
% Manually set the histogram x-axis limits 
xlim([val1, val2]);
% Sets the color axis limits of the colorbar
clim([val1, val2]);
