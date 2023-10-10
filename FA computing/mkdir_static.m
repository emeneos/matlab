function void = mkdir_static(temp_dir)

    cmd = sprintf('mkdir %s', temp_dir);
    system(cmd);
end