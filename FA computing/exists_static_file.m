function exists = exists_static_file(filename)
  % Checks if a file exists.

  % Args:
  %   filename: The name of the file to check.

  % Returns:
  %   A boolean value indicating whether the file exists.

  exists = isfile(filename);

end