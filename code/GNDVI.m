% Upload Hyperspectral Image
hcube = hypercube('taglio_Mola_EL1.img', "taglio_Mola_EL1.hdr");
% Extract data from DataCube
data = hcube.DataCube;
% Read the dimensions of the hyperspectral image
[rows, cols, bands] = size(data);
% Initialize a matrix for the GNDVI index
gndvi = zeros(rows, cols);
% Calculate the GNDVI index for each pixel
for row = 1:rows
 for col = 1:cols
 % Extract the band values ​​needed to calculate GNDVI
 green_band = data(row, col, 20); % Use the green band, in this case the 20
 nir_band = data(row, col, 42); % It uses the NIR (near infrared) band, in this case the 42
 
 % Calculate the GNDVI index
 gndvi(row, col) = (nir_band - green_band) / (nir_band + green_band);
 end
end
% Find the minimum value of gndvi
min_value = min(gndvi, [], 'all', 'omitnan');
% Find the maximum value of gndvi
max_value = max(gndvi, [], 'all', 'omitnan');
% Find the average of the gndvi values
mean_value = nanmean(gndvi, 'all');
% Represents the GNDVI index as an image
figure;
imshow(gndvi, []);
title('Vegetation Index GNDVI');
colorbar;
% Represents the GNDVI index as a colored image
figure;
imagesc(gndvi);
colormap jet;
colorbar;
title('Vegetation Index GNDVI (Colored)');
% Normalization of the GNDVI index in the interval [0, 1]
gndvi_normalized = mat2gray(gndvi, [0, 1]);
% Represents the normalized GNDVI index as a 'jet' colormap image
figure;
colormap jet;
imagesc(gndvi_normalized);
title('Vegetation Index GNDVI');
colorbar;
val1 = 0;
val2 = 1;
% Calculate the histogram of GNDVI values
figure;
h = histogram(gndvi(:), 'BinMethod', 'auto', 'NumBins', 64, 'FaceColor', 'auto'); % ":" 
to convert the matrix to a column vector
colormap jet; % Set colormap to 'jet'
colorbar('southoutside'); % Add a colorbar to show the association between colors and frequencies
title('GNDVI Histogram');
xlabel('GNDVI Value');
ylabel('Frequency');
% Manually set the limits of the histogram x-axis excluding the value 0
xlim([val1, val2]);
% Sets the color axis limits of the colorbar
clim([val1, val2]);
