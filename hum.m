cd 'C:\cygwin64\home\adawy\COAWST\ROMS_prep\extractedstation\'

% Load the NetCDF file
ncfile = 'C:\cygwin64\home\adawy\COAWST\ROMS_prep\Projects\swat2roms\era5_atm_20240401_20240430.nc';

% Read the latitude, longitude, and time data
lat = ncread(ncfile, 'latitude');
lon = ncread(ncfile, 'longitude');
time = ncread(ncfile, 'time');

% Define the target latitude and longitude points
target_lat = [11, 11, 11, 11, 11, 11.25, 11.25, 11.25, 11.25, 11.25, 11.25, 11.5, 11.5, 11.5, 11.5, 11.5, 11.5, 11.75, 11.75, 11.75, 11.75, 11.75, 11.75, 12, 12, 12, 12, 12, 12];
target_lon = [122, 122.25, 122.5, 122.75, 123, 121.75, 122, 122.25, 122.5, 122.75, 123, 121.75, 122, 122.25, 122.5, 122.75, 123, 121.75, 122, 122.25, 122.5, 122.75, 123, 121.75, 122, 122.25, 122.5, 122.75, 123];

% Find the nearest indices for the target latitudes and longitudes
lat_idx = arrayfun(@(x) find(abs(lat - x) == min(abs(lat - x)), 1), target_lat);
lon_idx = arrayfun(@(x) find(abs(lon - x) == min(abs(lon - x)), 1), target_lon);

% Pre-allocate the array to store temperature and dew point temperature data
temp_data_hourly = zeros(length(time), length(target_lat));
dewpoint_data_hourly = zeros(length(time), length(target_lat));

% Loop through each point and extract hourly temperature and dew point temperature data
for i = 1:length(target_lat)
    lat_ind = lat_idx(i);
    lon_ind = lon_idx(i);
    temp_data_hourly(:, i) = ncread(ncfile, 't2m', [lon_ind, lat_ind, 1], [1, 1, length(time)]);
    dewpoint_data_hourly(:, i) = ncread(ncfile, 'd2m', [lon_ind, lat_ind, 1], [1, 1, length(time)]);
end

% Convert temperature and dew point temperature from Kelvin to Celsius
temp_data_hourly_c = temp_data_hourly - 273.15;
dewpoint_data_hourly_c = dewpoint_data_hourly - 273.15;

% Calculate the saturation vapor pressure using the Magnus formula
e_temp = @(T) 6.112 .* exp((17.67 .* T) ./ (T + 243.5));

% Calculate the hourly relative humidity
relative_humidity_hourly = 100 .* (e_temp(dewpoint_data_hourly_c) ./ e_temp(temp_data_hourly_c));

% Convert time to MATLAB datetime format (assuming the time units are "hours since 1900-01-01 00:00:00")
time_ref = datetime(1900, 1, 1);
time_datetime = time_ref + hours(time);

% Aggregate hourly data to daily means
days = unique(dateshift(time_datetime, 'start', 'day'));
humidity_data_daily = zeros(length(days), length(target_lat));

for i = 1:length(days)
    day_mask = (dateshift(time_datetime, 'start', 'day') == days(i));
    humidity_data_daily(i, :) = mean(relative_humidity_hourly(day_mask, :), 1, 'omitnan');
end

% Save the data to a text file in the desired format
output_file = 'humidity_data_daily.txt';
fileID = fopen(output_file, 'w');
fprintf(fileID, 'Year\tMonth\tDay\tLatitude\tLongitude\tRelativeHumidity(%%)\n');
for i = 1:length(days)
    for j = 1:length(target_lat)
        fprintf(fileID, '%d\t%d\t%d\t%.2f\t%.2f\t%f\n', year(days(i)), month(days(i)), day(days(i)), target_lat(j), target_lon(j), humidity_data_daily(i, j));
    end
end
fclose(fileID);

disp('Data extraction and conversion complete. Results saved to humidity_data_daily.txt');
