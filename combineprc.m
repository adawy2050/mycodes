% Define the paths
existing_data_path = 'C:\Users\adawy\Desktop\panay\New folder\Scenarios\Default\TxtInOut\combinetrial\4';
new_data_path = 'C:\Users\adawy\Desktop\extracted_2024_4_data';

% List of .pcp files to process
file_names = {
    'Panay_ERA5_20100101_0001.pcp',
    'Panay_ERA5_20100101_0002.pcp',
    'Panay_ERA5_20100101_0003.pcp',
    'Panay_ERA5_20100101_0004.pcp',
    'Panay_ERA5_20100101_0005.pcp',
    'Panay_ERA5_20100101_0006.pcp',
    'Panay_ERA5_20100101_0007.pcp',
    'Panay_ERA5_20100101_0008.pcp',
    'Panay_ERA5_20100101_0009.pcp',
    'Panay_ERA5_20100101_0010.pcp',
    'Panay_ERA5_20100101_0011.pcp',
    'Panay_ERA5_20100101_0012.pcp',
    'Panay_ERA5_20100101_0013.pcp',
    'Panay_ERA5_20100101_0014.pcp',
    'Panay_ERA5_20100101_0015.pcp',
    'Panay_ERA5_20100101_0016.pcp',
    'Panay_ERA5_20100101_0017.pcp',
    'Panay_ERA5_20100101_0018.pcp',
    'Panay_ERA5_20100101_0019.pcp',
    'Panay_ERA5_20100101_0020.pcp',
    'Panay_ERA5_20100101_0021.pcp',
    'Panay_ERA5_20100101_0022.pcp',
    'Panay_ERA5_20100101_0023.pcp',
    'Panay_ERA5_20100101_0024.pcp',
    'Panay_ERA5_20100101_0025.pcp',
    'Panay_ERA5_20100101_0026.pcp',
    'Panay_ERA5_20100101_0027.pcp',
    'Panay_ERA5_20100101_0028.pcp',
    'Panay_ERA5_20100101_0029.pcp',
    'Panay_ERA5_20100101_0030.pcp'
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
