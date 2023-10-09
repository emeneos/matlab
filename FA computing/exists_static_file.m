function exists = exists_static_file(filename)
  % Checks if a file exists.

  % Args:
  %   filename: The name of the file to check.

  % Returns:
  %   A boolean value indicating whether the file exists.

  exists = false;
  statinfo = dir(filename);
  if ~isempty(statinfo) && statinfo.bytes > 0
    exists = true;
  end
end