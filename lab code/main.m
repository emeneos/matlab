% Define test inputs
M = 64;   % Number of rows
N = 64;   % Number of columns
P = 32;   % Number of frames
G = 20;   % Number of directions

% Create a synthetic signal (replace this with your actual signal data)
signal = rand(M, N, P, G);

% Generate synthetic gradient directions
% For simplicity, we'll create a random set of unit vectors
gi = randn(G, 3);
gi = gi ./ vecnorm(gi, 2, 2);  % Normalize vectors to unit length

% Optional parameters (you can customize these as needed)
options = struct();
options.L = 6;         % Maximum order of SH (default: 6)
options.lambda = 0.006; % Tikhonov regularization parameter (default: 0.006)
options.chunksz = 1000; % Chunk size for processing (default: 1000)
options.mask = true(M, N, P);  % Voxel mask (default: entire image)


suma = varar(1,2,'L', options.L, 'lambda', options.lambda);

% Call the signal2sh function
%SH = signal2sh(signal, gi, 'L', options.L, 'lambda', options.lambda, 'chunksz', options.chunksz, 'mask', options.mask);

% Display the size of the resulting SH coefficients
disp(size(SH));
