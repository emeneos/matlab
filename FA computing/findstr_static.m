function index = findstr_static(pattern, string)
  % Finds the first occurrence of a pattern in a string.

  % Args:
  %   pattern: The pattern to search for.
  %   string: The string to search in.

  % Returns:
  %   The index of the first occurrence of the pattern in the string, or -1 if the
  %   pattern is not found.

  %#codegen
  index = -1;

  for i = 1:length(string)
    if string(i) == pattern(1)
      if length(pattern) == 1 || strncmp(string(i:i + length(pattern) - 1), pattern, length(pattern))
        index = i;
        break;
      end
    end
  end

end