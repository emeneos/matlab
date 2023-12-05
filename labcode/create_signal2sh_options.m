function options = create_signal2sh_options(M, N, P)
  % Maximum order of SH (default: 6)
  options.L = 6;
  % Tikhonov regularization parameter (default: 0.006)
  options.lambda = 0.006;
  % Chunk size for processing (default: 1000)
  options.chunksz = 1000;
  % Voxel mask (default: entire image)
  options.mask = true(M, N, P);
end