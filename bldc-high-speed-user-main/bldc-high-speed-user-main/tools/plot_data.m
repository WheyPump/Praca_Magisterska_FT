function plot_data(file_name, max_samples)
    % PLOT_DATA Plots the first N samples from the specified data file.
    % 
    % This function reads a matrix from a specified file and plots the first
    % N samples of three current signals and IMU data.
    %
    % Parameters:
    %   file_name (string): The name of the file containing the data to be plotted.
    %   max_samples (integer): The maximum number of samples to plot from the data.
    %
    % Usage: plot_data('data.txt', 10000)
    % Example: plot_data('..\dataset\examples\bldc_high_speed_fault0_speed4000_2025-08-20-11-01-32.txt', 10000);

    % Read the matrix from the specified file
    signal = readmatrix(file_name, 'NumHeaderLines', 1);

    % Determine the number of samples to plot
    if max_samples < 1
        N = size(signal, 1); % Use full length if max_samples is -1 or less
    else
        N = min(max_samples, size(signal, 1));
    end

    % Create a figure for the plot
    figure;

    % Plot the current data
    subplot(3, 1, 1); % Create a subplot for current data
    plot(signal(1:N, 1), 'r', 'DisplayName', 'i_a'); hold on;
    plot(signal(1:N, 2), 'g', 'DisplayName', 'i_b');
    plot(signal(1:N, 3), 'b', 'DisplayName', 'i_c');

    % Customize the current plot
    legend('show'); % Automatically shows the legend based on DisplayName
    xlabel('Samples (-)');
    ylabel('Phase currents');
    title(sprintf('BLDC motor phase currents (the first %d samples)', N));
    grid on;
    axis tight;

    % Plot the IMU data (is 20 times slower)
    subplot(3, 1, 2); % Create a subplot for IMU data
    imu_samples = 1:20:N; % Select IMU samples that are 20 times slower
    plot(imu_samples, signal(imu_samples, 4), 'm', 'DisplayName', 'acc_x'); hold on; % imu_x is in column 4
    plot(imu_samples, signal(imu_samples, 5), 'c', 'DisplayName', 'acc_y'); % imu_y is in column 5
    plot(imu_samples, signal(imu_samples, 6), 'k', 'DisplayName', 'acc_z'); % imu_z is in column 6

    % Customize the IMU plot
    legend('show'); % Automatically shows the legend based on DisplayName
    xlabel('Samples (-)');
    ylabel('Accelerometer data');
    title(sprintf('IMU data (sampling frequency lower by a factor of 20, first %d samples)', length(imu_samples)));
    grid on;
    axis tight;

    % Plot the gyroscope data
    subplot(3, 1, 3); 
    plot(imu_samples, signal(imu_samples, 7), 'm', 'DisplayName', 'gyro_x'); hold on; % imu_x gyroscope is in column 7
    plot(imu_samples, signal(imu_samples, 8), 'c', 'DisplayName', 'gyro_y'); % imu_y gyroscope is in column 8
    plot(imu_samples, signal(imu_samples, 9), 'k', 'DisplayName', 'gyro_z'); % imu_z gyroscope is in column 9

    % Customize the gyroscope plot
    legend('show'); % Automatically shows the legend based on DisplayName
    xlabel('Samples (-)');
    ylabel('Gyroscope data');
    grid on;
    axis tight;
end
