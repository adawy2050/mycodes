% Define the paths
existing_data_path = 'C:\Users\adawy\Desktop\panay\New folder\Scenarios\Default\TxtInOut\combinetrial\4';
new_data_path = 'C:\Users\adawy\Desktop\extracted_2024_4_data';

% List of .slr files to process
file_names = {
    'Panay_ERA5_20100101_0001.slr',
    'Panay_ERA5_20100101_0002.slr',
    'Panay_ERA5_20100101_0003.slr',
    'Panay_ERA5_20100101_0004.slr',
    'Panay_ERA5_20100101_0005.slr',
    'Panay_ERA5_20100101_0006.slr',
    'Panay_ERA5_20100101_0007.slr',
    'Panay_ERA5_20100101_0008.slr',
    'Panay_ERA5_20100101_0009.slr',
    'Panay_ERA5_20100101_0010.slr',
    'Panay_ERA5_20100101_0011.slr',
    'Panay_ERA5_20100101_0012.slr',
    'Panay_ERA5_20100101_0013.slr',
    'Panay_ERA5_20100101_0014.slr',
    'Panay_ERA5_20100101_0015.slr',
    'Panay_ERA5_20100101_0016.slr',
    'Panay_ERA5_20100101_0017.slr',
    'Panay_ERA5_20100101_0018.slr',
    'Panay_ERA5_20100101_0019.slr',
    'Panay_ERA5_20100101_0020.slr',
    'Panay_ERA5_20100101_0021.slr',
    'Panay_ERA5_20100101_0022.slr',
    'Panay_ERA5_20100101_0023.slr',
    'Panay_ERA5_20100101_0024.slr',
    'Panay_ERA5_20100101_0025.slr',
    'Panay_ERA5_20100101_0026.slr',
    'Panay_ERA5_20100101_0027.slr',
    'Panay_ERA5_20100101_0028.slr',
    'Panay_ERA5_20100101_0029.slr',
    'Panay_ERA5_20100101_0030.slr'
};

% Loop through each file and merge data
for i = 1:length(file_names)
    % Read the existing data as text
    existing_file = fullfile(existing_data_path, file_names{i});
    fid = fopen(existing_file, 'r');
    existing_data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    fclose(fid);
    
    % Read the new data as text, skipping the header row
    new_file = fullfile(new_data_path, file_names{i});
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

disp('Data merging complete.');
