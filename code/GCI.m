% Upload hyperspectral image
hcube = hypercube('taglio_Mola_EL1.img', "taglio_Mola_EL1.hdr");
% Extract data from DataCube
data = hcube.DataCube;
% Read the dimensions of the hyperspectral image
[rows, cols, bands] = size(data);
% Initialize a matrix for the GCI index
gci = zeros(rows, cols);
% Calculate the GCI index for each pixel
for row = 1:rows
 for col = 1:cols
 % Extract the band values ​​needed to calculate GCI
 green_band = data(row, col, 20); % Use the green band, in this case the 20
 nir_band = data(row, col, 42); % It uses the NIR (near infrared) band, in this case the 42
 
 % Calculate the GCI index
 gci(row, col) = (nir_band / green_band) - 1;
 end
end
% Represent the GCI index as an image
figure;
imshow(gci, []);
title('GCI Vegetation Index');
colorbar;
% Define a custom color map
customMap = jet(256); 
% Represents the GCI index as a color image
figure;
imshow(gci, 'Colormap', customMap);
title('GCI Vegetation Index (Colored)');
colorbar;
% Find the minimum value of gci
min_value = min(gci, [], 'all', 'omitnan');
% Find the maximum value of gci
max_value = max(gci, [], 'all', 'omitnan');
% Find the mean of the gci values
mean_value = nanmean(gci, 'all');
val1 = 1.0;
val2 = 9.0;
% Normalization of the GCI index in the interval [1, 3]
gci_normalized = mat2gray(gci, [val1, val2]);
% Represents the normalized GCI index as a 'jet' colormap image
figure;
colormap jet;
imagesc(gci);
title('Vegetation Index GCI (Normalized)');
colorbar;
% Set the color axis bounds to associate values ​​from val1 to val2 to the colorbar
set(gca, 'CLim', [val1, val2]);
val3 = 0;
val4 = 10;
% Calculate the histogram of GCI values
figure;
h = histogram(gci(:), 'BinMethod', 'auto', 'NumBins', 300, 'FaceColor', 'auto'); % ":" 
to convert the matrix to a column vector
colormap jet; % Set colormap to 'jet'
colorbar('southoutside'); % Add a colorbar to show the association between colors and frequencies
title('GCI Histogram');
xlabel('GCI Value');
ylabel('Frequency');
% Manually set the limits of the histogram x-axis excluding the value 0
xlim([val3, val4]);
% Sets the color axis limits of the colorbar
clim([val3, val4]);
