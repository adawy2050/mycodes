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

% Pre-allocate the array to store wind component data
u10_data_hourly = zeros(length(time), length(target_lat));
v10_data_hourly = zeros(length(time), length(target_lat));

% Loop through each point and extract hourly u and v wind component data
for i = 1:length(target_lat)
    lat_ind = lat_idx(i);
    lon_ind = lon_idx(i);
    u10_data_hourly(:, i) = ncread(ncfile, 'u10', [lon_ind, lat_ind, 1], [1, 1, length(time)]);
    v10_data_hourly(:, i) = ncread(ncfile, 'v10', [lon_ind, lat_ind, 1], [1, 1, length(time)]);
end

% Calculate wind speed from u and v components
wind_speed_hourly = sqrt(u10_data_hourly.^2 + v10_data_hourly.^2);

% Convert time to MATLAB datetime format (assuming the time units are "hours since 1900-01-01 00:00:00")
time_ref = datetime(1900, 1, 1);
time_datetime = time_ref + hours(time);

% Aggregate hourly data to daily means
days = unique(dateshift(time_datetime, 'start', 'day'));
wind_speed_daily = zeros(length(days), length(target_lat));

for i = 1:length(days)
    day_mask = (dateshift(time_datetime, 'start', 'day') == days(i));
    wind_speed_daily(i, :) = mean(wind_speed_hourly(day_mask, :), 1, 'omitnan');
end

% Save the data to a text file in the desired format
output_file = 'wind_speed_data_daily.txt';
fileID = fopen(output_file, 'w');
fprintf(fileID, 'Year\tMonth\tDay\tLatitude\tLongitude\tWindSpeed(m/s)\n');
for i = 1:length(days)
    for j = 1:length(target_lat)
        fprintf(fileID, '%d\t%d\t%d\t%.2f\t%.2f\t%f\n', year(days(i)), month(days(i)), day(days(i)), target_lat(j), target_lon(j), wind_speed_daily(i, j));
    end
end
fclose(fileID);

disp('Data extraction and conversion complete. Results saved to wind_speed_data_daily.txt');
