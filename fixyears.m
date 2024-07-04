% Define the path
data_path = 'C:\Users\adawy\Desktop\panay\New folder\Scenarios\Default\TxtInOut\combinetrial';

% List of file extensions to process
file_extensions = {'*.wnd', '*.tmp', '*.slr', '*.pcp', '*.hmd'};

% Loop through each file extension
for ext_idx = 1:length(file_extensions)
    % Get the list of files with the current extension
    file_list = dir(fullfile(data_path, file_extensions{ext_idx}));
    
    % Loop through each file
    for file_idx = 1:length(file_list)
        % Get the full path of the current file
        file_path = fullfile(data_path, file_list(file_idx).name);
        
        % Read the existing data as text
        fid = fopen(file_path, 'r');
        if fid == -1
            fprintf('Error opening file: %s\n', file_path);
            continue;
        end
        file_content = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
        fclose(fid);
        
        % Find and replace "  13" with "  14" in the header line
        header_line_idx = 3; % Assuming the header line is always at line 3
        header_line = file_content{1}{header_line_idx};
        if contains(header_line, '  14')
            modified_header_line = strrep(header_line, '  14', '  15');
            file_content{1}{header_line_idx} = modified_header_line;
            
            % Debugging information
            fprintf('Updated NBYR in file: %s\n', file_path);
            
            % Write the updated content back to the file
            fid = fopen(file_path, 'w');
            if fid == -1
                fprintf('Error opening file for writing: %s\n', file_path);
                continue;
            end
            for line_idx = 1:length(file_content{1})
                fprintf(fid, '%s\n', file_content{1}{line_idx});
            end
            fclose(fid);
        else
            % Debugging information if no change is needed
            fprintf('NBYR already updated or not found in file: %s\n', file_path);
        end
    end
end

disp('NBYR value update process complete.');
