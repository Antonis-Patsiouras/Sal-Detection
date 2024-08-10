function [normImage] = Clr_Freq(originalImage)

rows = size(originalImage,1);
columns = size(originalImage,2);

% Construct the 3D gamut.
%lutSize = 256;  % Use 256 to get maximum resolution possible out of a 24 bit RGB image.
lutSize = 12;  % Use a smaller LUT size to get colors grouped into fewer, larger groups in the gamut.
reductionFactor = double(256) / double(lutSize);
gamut3D = zeros(lutSize, lutSize, lutSize);
for row = 1 : rows
	for col = 1: columns
		redValue = floor(double(originalImage(row, col, 1)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		greenValue = floor(double(originalImage(row, col, 2)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		blueValue = floor(double(originalImage(row, col, 3)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		gamut3D(redValue, greenValue, blueValue) = gamut3D(redValue, greenValue, blueValue) + 1;
	end
end

% Now construct the color frequency image.
% Make an image where we get the color of the original image, and have the output value of the color
% frequency image be the number of times that exact color occurred in the original image.
colorFrequencyImage = zeros(rows, columns);
for row = 1 : rows
	for col = 1: columns
		redValue = floor(double(originalImage(row, col, 1)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		greenValue = floor(double(originalImage(row, col, 2)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		blueValue = floor(double(originalImage(row, col, 3)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		freq = gamut3D(redValue, greenValue, blueValue);
		colorFrequencyImage(row, col) =  freq;
    end
end
%numberOfColors = double(rows) * double(columns);
%numberOfColors = sum(sum(sum(gamut3D)));
%sumr = sum(sum(colorFrequencyImage));
normImage = colorFrequencyImage * 255 / max(max(colorFrequencyImage));
end