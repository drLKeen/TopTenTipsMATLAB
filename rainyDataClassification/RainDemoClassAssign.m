function rainData = RainDemoClassAssign(rainData)
% categories: clear, rainy, stormy, humid, and fair

totalWind = sqrt(rainData.uwnd.^2 + rainData.vwnd.^2);


weathercat = strings(length(rainData.rain), 1); % Preallocate a string array

% Define conditions for weathercat
weathercat(rainData.rain == 0 & rainData.rhum < 50) = "clear";
weathercat(rainData.rain == 0 & rainData.rhum >= 50) = "humid";
weathercat(rainData.rain > 0 & totalWind < 4) = "rainy";
weathercat(rainData.rain > 0 & totalWind >= 4) = "stormy";

% complicate the classifications a little by having some conditions
% override others. The "fair" class isn't well defined (on purpose) to add
% inconsitstencies to the dataset. Otherwise, classification is too simple
% and accurate.

weathercat(~(rainData.rain == 0 & rainData.rhum < 50) & ...
           ~(rainData.rain > 0 & totalWind < 4) & ...
           ~(rainData.rain > 10 & totalWind >= 4) & ...
           ~(rainData.rain == 0 & rainData.rhum > 50)) = "fair";

weathercat(rainData.rain == 0 & totalWind >= 8) = "windy";

% Add the new variable to the table
rainData.weathercat = weathercat;

end