% Define the path
data_path = 'C:\Users\adawy\Desktop\extracted_2024_4_data';

% List of files (assuming all files in the directory need to be processed)
files = dir(fullfile(data_path, '*.pcp'));
files = [files; dir(fullfile(data_path, '*.tmp'))];
files = [files; dir(fullfile(data_path, '*.slr'))];
files = [files; dir(fullfile(data_path, '*.hmd'))];
files = [files; dir(fullfile(data_path, '*.wnd'))];

% Loop through each file and reformat data
for i = 1:length(files)
    file_path = fullfile(data_path, files(i).name);
    
    % Read the data
    opts = detectImportOptions(file_path, 'FileType', 'text', 'Delimiter', '\t', 'VariableNamingRule', 'preserve');
    data = readtable(file_path, opts);
    
    % Extract Year, Month, Day, and the parameter value
    year = data.Year;
    month = data.Month;
    day = data.Day;
    parameter_value = data{:, 4}; % Assuming the parameter is in the 4th column
    
    % Convert to "Year" and "Day" format
    date_vector = datenum(year, month, day);
    day_of_year = date_vector - datenum(2024, 1, 0); % Day of the year calculation
    reformatted_data = table(repmat(2024, size(day_of_year)), day_of_year, parameter_value, ...
                             'VariableNames', {'Year', 'Day', files(i).name(1:end-4)});
    
    % Write the reformatted data back to the file
    writetable(reformatted_data, file_path, 'Delimiter', '\t', 'WriteVariableNames', true, 'FileType', 'text');
end

disp('Data reformatting complete.');
