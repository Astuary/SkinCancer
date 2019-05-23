function PlaceThresholdBars(plotNumber, lowThresh, highThresh)
try
	% Show the thresholds as vertical red bars on the histograms.
	subplot(2, 4, plotNumber);
	hold on;
	yAxisRangeValues = ylim;
	line([lowThresh, lowThresh], yAxisRangeValues, 'Color', 'r', 'LineWidth', 2);
	line([highThresh, highThresh], yAxisRangeValues, 'Color', 'r', 'LineWidth', 2);
	% Place a text label on the bar chart showing the threshold.
	fontSizeThresh = 14;
	annotationTextL = sprintf('%d', lowThresh);
	annotationTextH = sprintf('%d', highThresh);
	% For text(), the x and y need to be of the data class "double" so let's cast both to double.
	text(double(lowThresh + 5), double(0.85 * yAxisRangeValues(2)), annotationTextL, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	text(double(highThresh + 5), double(0.85 * yAxisRangeValues(2)), annotationTextH, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	
	% Show the range as arrows.
	% Can't get it to work, with either gca or gcf.
	% 	annotation(gca, 'arrow', [lowThresh/maxXValue(2) highThresh/maxXValue(2)],[0.7 0.7]);
catch ME
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	errordlg(errorMessage);
end
return; % from PlaceThresholdBars()