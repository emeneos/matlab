function remove_temp_dir(temp_dir)
  % Removes a temporary directory.

  % Check if the temporary directory exists.
  if isfile(temp_dir)
    % The temporary directory exists.
    cmd = sprintf('rmdir %s', temp_dir);
    system(cmd);
  end
end