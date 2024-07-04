% Define the paths
new_data_path = 'C:\cygwin64\home\adawy\COAWST\ROMS_prep\extractedstation';
output_data_path = 'C:\Users\adawy\Desktop\extracted_2024_4_data';

% Ensure the output directory exists
if ~exist(output_data_path, 'dir')
    mkdir(output_data_path);
end

% Define the file name patterns
file_suffixes = {'pcp', 'tmp', 'slr', 'hmd', 'wnd'};

% Define the new data file names
new_data_files = {'precipitation_data_daily.txt', 'temperature_data_daily.txt', 'solar_radiation_data_daily.txt', 'humidity_data_daily.txt', 'wind_speed_data_daily.txt'};
new_data_variable_names = {'Precipitation(mm)', 'Temperature(degC)', 'SolarRadiation(MJ/m^2)', 'RelativeHumidity(%)', 'WindSpeed(m/s)'};

% Load the new data
new_data = struct();
for i = 1:length(new_data_files)
    opts = detectImportOptions(fullfile(new_data_path, new_data_files{i}), 'Delimiter', '\t', 'VariableNamingRule', 'preserve');
    new_data.(file_suffixes{i}) = readtable(fullfile(new_data_path, new_data_files{i}), opts);
end

% Define the target latitude and longitude points and corresponding file names
target_lat = [11, 11, 11, 11, 11, 11, 11.25, 11.25, 11.25, 11.25, 11.25, 11.25, 11.5, 11.5, 11.5, 11.5, 11.5, 11.5, 11.75, 11.75, 11.75, 11.75, 11.75, 11.75, 12, 12, 12, 12, 12, 12];
target_lon = [121.75, 122, 122.25, 122.5, 122.75, 123, 121.75, 122, 122.25, 122.5, 122.75, 123, 121.75, 122, 122.25, 122.5, 122.75, 123, 121.75, 122, 122.25, 122.5, 122.75, 123, 121.75, 122, 122.25, 122.5, 122.75, 123];
file_names = {
    'Panay_ERA5_20100101_0025', 'Panay_ERA5_20100101_0026', 'Panay_ERA5_20100101_0027', 'Panay_ERA5_20100101_0028', 'Panay_ERA5_20100101_0029', 'Panay_ERA5_20100101_0030', ...
    'Panay_ERA5_20100101_0019', 'Panay_ERA5_20100101_0020', 'Panay_ERA5_20100101_0021', 'Panay_ERA5_20100101_0022', 'Panay_ERA5_20100101_0023', 'Panay_ERA5_20100101_0024', ...
    'Panay_ERA5_20100101_0013', 'Panay_ERA5_20100101_0014', 'Panay_ERA5_20100101_0015', 'Panay_ERA5_20100101_0016', 'Panay_ERA5_20100101_0017', 'Panay_ERA5_20100101_0018', ...
    'Panay_ERA5_20100101_0007', 'Panay_ERA5_20100101_0008', 'Panay_ERA5_20100101_0009', 'Panay_ERA5_20100101_0010', 'Panay_ERA5_20100101_0011', 'Panay_ERA5_20100101_0012', ...
    'Panay_ERA5_20100101_0001', 'Panay_ERA5_20100101_0002', 'Panay_ERA5_20100101_0003', 'Panay_ERA5_20100101_0004', 'Panay_ERA5_20100101_0005', 'Panay_ERA5_20100101_0006'
};

% Loop through each target location and each parameter
for i = 1:length(target_lat)
    for j = 1:length(file_suffixes)
        % Extract the new data for the current location
        lat = target_lat(i);
        lon = target_lon(i);
        new_data_for_location = new_data.(file_suffixes{j})(new_data.(file_suffixes{j}).Latitude == lat & new_data.(file_suffixes{j}).Longitude == lon, :);

        % Format the new data
        new_data_variable_name = new_data_variable_names{j};
        new_data_formatted = table(new_data_for_location.Year, new_data_for_location.Month, new_data_for_location.Day, new_data_for_location.(new_data_variable_name), ...
                                   'VariableNames', {'Year', 'Month', 'Day', new_data_variable_name});

        % Construct the output file name
        output_file_name = sprintf('%s.%s', file_names{i}, file_suffixes{j});
        output_file_path = fullfile(output_data_path, output_file_name);

        % Write the extracted data to a new file with 'FileType' specified
        writetable(new_data_formatted, output_file_path, 'Delimiter', '\t', 'WriteVariableNames', true, 'FileType', 'text');
    end
end

disp('Data extraction complete.');
