% Define the paths
existing_data_path = 'C:\Users\adawy\Desktop\panay\New folder\Scenarios\Default\TxtInOut\combinetrial';
new_data_path = 'C:\Users\adawy\Desktop\extracted_2024_data';
% List of .tmp files to process
tmp_file_names = {
    'Panay_ERA5_20100101_0001.tmp',
    'Panay_ERA5_20100101_0002.tmp',
    'Panay_ERA5_20100101_0003.tmp',
    'Panay_ERA5_20100101_0004.tmp',
    'Panay_ERA5_20100101_0005.tmp',
    'Panay_ERA5_20100101_0006.tmp',
    'Panay_ERA5_20100101_0007.tmp',
    'Panay_ERA5_20100101_0008.tmp',
    'Panay_ERA5_20100101_0009.tmp',
    'Panay_ERA5_20100101_0010.tmp',
    'Panay_ERA5_20100101_0011.tmp',
    'Panay_ERA5_20100101_0012.tmp',
    'Panay_ERA5_20100101_0013.tmp',
    'Panay_ERA5_20100101_0014.tmp',
    'Panay_ERA5_20100101_0015.tmp',
    'Panay_ERA5_20100101_0016.tmp',
    'Panay_ERA5_20100101_0017.tmp',
    'Panay_ERA5_20100101_0018.tmp',
    'Panay_ERA5_20100101_0019.tmp',
    'Panay_ERA5_20100101_0020.tmp',
    'Panay_ERA5_20100101_0021.tmp',
    'Panay_ERA5_20100101_0022.tmp',
    'Panay_ERA5_20100101_0023.tmp',
    'Panay_ERA5_20100101_0024.tmp',
    'Panay_ERA5_20100101_0025.tmp',
    'Panay_ERA5_20100101_0026.tmp',
    'Panay_ERA5_20100101_0027.tmp',
    'Panay_ERA5_20100101_0028.tmp',
    'Panay_ERA5_20100101_0029.tmp',
    'Panay_ERA5_20100101_0030.tmp'
};

% Loop through each .tmp file and merge data
for i = 1:length(tmp_file_names)
    % Read the existing data as text
    existing_file = fullfile(existing_data_path, tmp_file_names{i});
    fid = fopen(existing_file, 'r');
    existing_data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    fclose(fid);
    
    % Read the new data as text, skipping the header row
    new_file = fullfile(new_data_path, tmp_file_names{i});
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

disp('Temperature data merging complete.');
