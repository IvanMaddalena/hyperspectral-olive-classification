% Upload hyperspectral image
hcube = hypercube('taglio_Mola_EL1.img', "taglio_Mola_EL1.hdr");
% Extract data from DataCube
data = hcube.DataCube;
% Read the dimensions of the hyperspectral image
[rows, cols, bands] = size(data);
% Initializes a matrix for the Solar-Induced Fluorescence (SIF) index
sif = zeros(rows, cols);
% Calculate the SIF index for each pixel
for row = 1:rows
 for col = 1:cols
 % Extract the band values ​​needed to calculate SIF
 B760 = data(row, col, 44); % Use the 760 nm wavelength band, in this case the 44
 B687 = data(row, col, 29); % Use the band with wavelength 687 nm, in this case the 29
 
 % Calculate the SIF index
 sif(row, col) = (B760 - B687) / (B760 + B687);
 end
end
% Find the minimum value of sif
min_value = min(sif, [], 'all', 'omitnan');
% Find the maximum value of sif
max_value = max(sif, [], 'all', 'omitnan');
% Find the mean of the sif values
mean_value = nanmean(sif, 'all');
% Represents the SIF index as an image
figure;
imshow(sif, []);
title('Vegetation Index SIF');
colorbar;
% Represents the SIF vegetation index as a colored image
figure;
imagesc(sif);
colormap jet;
colorbar;
title('Vegetation Index SIF');
% Normalization of the SIF index in the interval [0, 1]
sif_normalized = mat2gray(sif, [0, 1]);
% Represents the normalized SIF index as a 'jet' colormap image
figure;
colormap jet;
imagesc(sif_normalized);
title('Vegetation Index SIF (Normalized)');
colorbar;
val1 = 0;
val2 = 1;
% Calculate the histogram of SIF values ​​excluding the value 0
figure;
h = histogram(sif(:), 'BinMethod', 'auto', 'NumBins', 64, 'FaceColor', 'auto'); % ":" 
to convert the matrix to a column vector
colormap jet; % Set colormap to 'jet'
colorbar('southoutside'); % Add a colorbar to show the association between colors and frequencies
title('SIF Histogram');
xlabel('SIF Value');
ylabel('Frequency');
% Manually set the limits of the histogram x-axis excluding the value 0
xlim([val1, val2]);
% Sets the color axis limits of the colorbar
clim([val1, val2]);
