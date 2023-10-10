function filename = generate_temp_filename()
    % Generates a unique file name in the current working directory.

    % Generate a random file name.
    filename = strcat('temp_', num2str(rand(1) * 100000));

    % Get the full path to the file.
    filename = fullfile(pwd, filename);
end