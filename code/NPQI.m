% Upload hyperspectral image
hcube = hypercube('taglio_Mola_EL1.img', "taglio_Mola_EL1.hdr");
% Extract data from DataCube
data = hcube.DataCube;
% Read the dimensions of the hyperspectral image
[rows, cols, bands] = size(data);
% Initialize a matrix for the NPQI (Normalized phaeophytinization index)
npqi = zeros(rows, cols);
% Calculate the NPQI index for each pixel
for row = 1:rows
 for col = 1:cols
 % Extract the band values ​​needed to calculate NPQI
 R415 = data(row, col, 4); % It uses the band with wavelength 415 nm, in this case the 4
 R435 = data(row, col, 8); % It uses the 435 nm wavelength band, in this case the 8
 
 % Calculate the NPQI index
 npqi(row, col) = (R415 - R435) / (R415 + R435);
 end
end
% Find the minimum value of npqi
min_value = min(npqi, [], 'all', 'omitnan');
% Find the maximum value of npqi
max_value = max(npqi, [], 'all', 'omitnan');
% Find the mean of the npqi values
mean_value = nanmean(npqi, 'all');
% Represents the NPQI index as an image
figure;
imshow(npqi, []);
title('Vegetation Index NPQI');
colorbar;
% The NPQI index is a numerical index that represents a measure of 
% pheophytin normalization and is usually represented using a gray scale.
% However, a colored representation of the NPQI index
% can be useful for a more intuitive visualization.
% Represents the NPQI index as a colored image
figure;
imagesc(npqi);
colormap jet;
colorbar;
title('Vegetation Index NPQI (Colored)');
val1 = -0.2;
val2 = 0.2;
% Normalization of the NPQI index in the desired range
gci_normalized = mat2gray(npqi, [val1, val2]);
% Represents the normalized NPQI index as a 'jet' colormap image
figure;
colormap jet;
imagesc(npqi);
title('Vegetation Index NPQI (Normalized)');
colorbar;
% Set the color axis bounds to associate values ​​from val1 to val2 to the colorbar
set(gca, 'CLim', [val1, val2]);
% Calculate the histogram of npqi values
figure;
histogram(npqi(:), 'BinMethod', 'auto', 'NumBins', 200, 'FaceColor','auto'); % ":" to convert the matrix to a column vector
colormap jet; % Set colormap to 'jet'
colorbar('southoutside'); % Add a colorbar to show the association between colors and frequencies
title('NPQI Histogram');
xlabel('NPQI Value');
ylabel('Frequency');
xlim([val1 val2]);
% Sets the color axis limits of the colorbar
clim([val1, val2]);
