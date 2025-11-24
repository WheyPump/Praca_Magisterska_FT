%% Script parameters
% Define the folder in dataset containing the data files
folder_name = 'examples';
maximum_number_of_samples = 1000;

%% Main script
folder_path = fullfile('../dataset', folder_name);

% Get a list of all .txt files in the selected folder
file_list = dir(fullfile(folder_path, '*.txt'));

% Create a folder to save plots if it doesn't exist
output_folder = fullfile('../plot', folder_name);
if exist(output_folder, 'dir')
    rmdir(output_folder, 's')
end
mkdir(output_folder);

% Loop through each file and plot the zoomed data
for k = 1:length(file_list)
    for max_samples = [maximum_number_of_samples, -1]
        % Construct the full file name
        file_name = fullfile(folder_path, file_list(k).name);
        
        % Call the plot_data function for each file
        plot_data(file_name, max_samples);
        
        % Save the current figure as a .jpg file
        [~, name, ~] = fileparts(file_name);
        if max_samples == -1
            max_samples_str = 'all';
        else
            max_samples_str = num2str(max_samples);
        end
        saveas(gcf, fullfile(output_folder, ['samples_', max_samples_str, '_', name, '.jpg']));
        
        % Close the figure to avoid displaying all plots at once
        close(gcf);
    end
end


