function temp_dir = create_temp_dir(temp_dir_name)
  % Creates a temporary directory and returns the full path to the directory.

  % Check if the temp_dir_name variable is empty or null.
  if isempty(temp_dir_name)
    % Generate a temporary directory name.
    temp_dir_name = generate_temp_filename();
  end

  % Check if the temporary directory already exists.
  if isfile(temp_dir_name)
    % The temporary directory already exists.
    temp_dir = temp_dir_name;
  else
    % Create a new directory.
    cmd = sprintf('mkdir %s', temp_dir_name);
    system(cmd);

    % Get the full path to the directory.
    temp_dir = fullfile(pwd, temp_dir_name);
  end

end
