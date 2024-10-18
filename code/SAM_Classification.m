% Upload hyperspectral image
hcube = hypercube('taglio_Mola_EL1.img', 
'_temp_matlab_R2023a_win64\taglio_Mola_EL1.hdr');
% Extract hyperspectral data from image
data = hcube.DataCube;
% Select specific bands for olive tree classification
selectedBands = [44 45 46];
selectedData = data(:, :, selectedBands);
% Select RGB image
rgbImg = colorize(hcube, 'Method', 'rgb', 'ContrastStretching', true);
% View RGB image
figure
imshow(rgbImg);
title('RGB Image of Data Cube')
% Zoom with the mouse to select pixels more precisely
zoom on;
pause();
zoom off;
% Select additional pixels as reference hyperspectral signatures
numRefPixels = 10;
refPixels = ginput(numRefPixels);
zoom out;
% Extract hyperspectral signatures of reference pixels
refSpectra = zeros(numRefPixels, numel(selectedBands));
for i = 1:numRefPixels
 x = round(refPixels(i, 1));
 y = round(refPixels(i, 2));
 refSpectra(i, :) = squeeze(data(y, x, selectedBands));
end
% Calculate similarity scores for the entire image using only the selected bands
scores = zeros(size(data, 1), size(data, 2), numRefPixels);
for i = 1:numRefPixels
 scores(:, :, i) = sam(selectedData, refSpectra(i, :));
end
% Calculate the maximum score among the different reference spectra
maxScores = max(scores, [], 3);
% Display classified image
figure
imagesc(maxScores);
axis image off
title('Classified Image')
