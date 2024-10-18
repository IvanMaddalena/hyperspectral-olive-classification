% Upload hyperspectral image
hcube = hypercube('taglio_Mola_EL1.img', 
'_temp_matlab_R2023a_win64\taglio_Mola_EL1.hdr');
% Select RGB image
rgbImg = colorize(hcube, 'Method', 'rgb', 'ContrastStretching', true);
% Display image
figure
imagesc(rgbImg);
axis image off
title('RGB Image of Data Cube')
% Display image
imshow(rgbImg);
% Zoom with the mouse to select pixels more precisely
zoom on;
% Temporarily block the start of ginput
pause();
% Exit zoom mode
zoom off;
% Select pixels from image using ginput
num_points = 50;
[x, y] = ginput(num_points);
% Rounds the coordinates of the selected pixels to the nearest integer positions
x = round(x);
y = round(y);
% Calculate the reflectance of selected pixels in all bands
num_bands = size(hcube.DataCube, 3);
reflectance_values = zeros(num_points, num_bands);
for i = 1:num_points
 x_pixel = x(i);
 y_pixel = y(i);
 
 % Extracts the spectral values ​​of the selected pixel
 spectral_values = squeeze(hcube.DataCube(y_pixel, x_pixel, :));
 
 % Save spectral values ​​in reflectance matrix
 reflectance_values(i, :) = spectral_values;
end
% View image with olive trees highlighted
figure;
imshow(rgbImg);
hold on;
scatter(x, y, 'r', 'filled');
title('Olive trees identified');
% Calculate the wavelength range
wavelengths = linspace(386.00, 930.50, num_bands);
% Create a new graph for the Spectral Plot
figure;
hold on;
grid on;
% Displays the spectral values ​​of the selected pixels
for i = 1:num_points
 plot(wavelengths, reflectance_values(i, :), 'LineWidth', 1.5);
end
% Set the x-axis (wavelength) limits
xlim([min(wavelengths), max(wavelengths)]);
% Set y-axis (reflectance) limits
ylim([0, 1]);
% Label the axes
xlabel('Wavelength (nm)');
ylabel('Reflectance');
% Adds a title to the chart
title('Spectral Plot of selected pixels');
