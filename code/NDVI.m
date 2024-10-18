% Calculate the NDVI index
hcube = hypercube('taglio_Mola_EL1.img', taglio_Mola_EL1.hdr");
output = ndvi(hcube);
ndvi_no_zeros = output(output ~= 0); % Filtra i valori diversi da 0
% Find the minimum value of ndvi
min_value = min(output, [], 'all', 'omitnan');
% Find the maximum value of ndvi
max_value = max(output, [], 'all', 'omitnan');
% Find the mean of the ndvi values
mean_value = nanmean(ndvi_no_zeros, 'all');
% Display NDVI image
figure;
imshow(output, 'Colormap', jet);
title('NDVI Image');
colorbar;
% Calculate the histogram of NDVI values ​​excluding the value 0
ndvi_no_zeros = output(output ~= 0); % Filter values ​​other than 0
figure;
h = histogram(ndvi_no_zeros(:), 'BinMethod', 'auto', 'NumBins', 64, 'FaceColor', 
'auto'); % ":" to convert the matrix to a column vector
colormap jet; % Set colormap to 'jet'
colorbar('southoutside'); % Add a colorbar to show the association between colors and frequencies
title('NDVI Histogram');
xlabel('NDVI Value');
ylabel('Frequency');
% Set the color axis limits of the colorbar
clim([-1, 1]);
