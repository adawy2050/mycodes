% Define the paths
existing_data_path = 'C:\Users\adawy\Desktop\panay\New folder\Scenarios\Default\TxtInOut\combinetrial\4';
new_data_path = 'C:\Users\adawy\Desktop\extracted_2024_4_data';
% List of .tmp files to process

% List of .wnd files to process
wnd_file_names = {
    'Panay_ERA5_20100101_0001.wnd',
    'Panay_ERA5_20100101_0002.wnd',
    'Panay_ERA5_20100101_0003.wnd',
    'Panay_ERA5_20100101_0004.wnd',
    'Panay_ERA5_20100101_0005.wnd',
    'Panay_ERA5_20100101_0006.wnd',
    'Panay_ERA5_20100101_0007.wnd',
    'Panay_ERA5_20100101_0008.wnd',
    'Panay_ERA5_20100101_0009.wnd',
    'Panay_ERA5_20100101_0010.wnd',
    'Panay_ERA5_20100101_0011.wnd',
    'Panay_ERA5_20100101_0012.wnd',
    'Panay_ERA5_20100101_0013.wnd',
    'Panay_ERA5_20100101_0014.wnd',
    'Panay_ERA5_20100101_0015.wnd',
    'Panay_ERA5_20100101_0016.wnd',
    'Panay_ERA5_20100101_0017.wnd',
    'Panay_ERA5_20100101_0018.wnd',
    'Panay_ERA5_20100101_0019.wnd',
    'Panay_ERA5_20100101_0020.wnd',
    'Panay_ERA5_20100101_0021.wnd',
    'Panay_ERA5_20100101_0022.wnd',
    'Panay_ERA5_20100101_0023.wnd',
    'Panay_ERA5_20100101_0024.wnd',
    'Panay_ERA5_20100101_0025.wnd',
    'Panay_ERA5_20100101_0026.wnd',
    'Panay_ERA5_20100101_0027.wnd',
    'Panay_ERA5_20100101_0028.wnd',
    'Panay_ERA5_20100101_0029.wnd',
    'Panay_ERA5_20100101_0030.wnd'
};

% Loop through each .wnd file and merge data
for i = 1:length(wnd_file_names)
    % Read the existing data as text
    existing_file = fullfile(existing_data_path, wnd_file_names{i});
    fid = fopen(existing_file, 'r');
    existing_data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    fclose(fid);
    
    % Read the new data as text, skipping the header row
    new_file = fullfile(new_data_path, wnd_file_names{i});
    fid = fopen(new_file, 'r');
    new_data = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Delimiter', '\t');
    fclose(fid);
    
    % Format the new data for appending
    new_data_formatted = arrayfun(@(x, y, z) sprintf('%d\t%d\t%f', x, y, z), ...
                                  new_data{1}, new_data{2}, new_data{3}, ...
                                  'UniformOutput', false);
    
    % Append the new data to the existing data
    combined_data = [existing_data{1}; new_data_formatted];
    
    % Write the combined data back to the file
    fid = fopen(existing_file, 'w');
    fprintf(fid, '%s\n', combined_data{:});
    fclose(fid);
end

disp('Wind speed data merging complete.');
