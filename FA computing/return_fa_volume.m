function FA = return_fa_volume(filepath, bval, bvec, maskpath)
    % Load diffusion MRI data from the specified file
    dmri = niftiread(filepath);

    % Load the mask image
    mask = niftiread(maskpath);

    % Load b-values and b-vectors
    bval = load(bval);
    bvec = load(bvec);
    bvec = bvec';

    % Identify diffusion-weighted volumes based on b-values
    idg = (bval > 10) & (bval<=2000);
    idbaselines = bval<=10;
    bval = bval(:, idg);
    bvec = bvec(idg, :);
    


    % Extract diffusion-weighted images and calculate the baseline image
    dwi = double(dmri(:, :, :, idg)); % DWI data
    bsl = double(mean(dmri(:, :, :, idbaselines), 4)); % Baseline image (mean of non-DWI)

    % Compute the Apparent Tensor Inverse (atti)
    atti = dwi ./ bsl; % It represents the apparent tensor inverse

    % Initialize the fractional anisotropy (FA) matrix
    FA = zeros(size(bvec, 1), size(bvec, 2), size(bvec, 3)); % Size: 64x3 double

    % Reorder b-values
    bval = permute(bval(:), [2, 3, 4, 1]);

    % Compute the logarithm of atti divided by b-values
    li = -log(atti) ./ bval; % Size: 110x110x3x64

    % Store b-vectors in gi
    gi = bvec; % Size: 64x3 double

    % Create the matrix A for tensor calculation
    A = [gi(:, 1).*gi(:, 1), 2*gi(:, 1).*gi(:, 2), 2*gi(:, 1).*gi(:, 3), ...
         gi(:, 2).*gi(:, 2), 2*gi(:, 2).*gi(:, 3), gi(:, 3).*gi(:, 3)]; % Size: 64x6 double

    % Calculate the pseudoinverse of A (Ai)
    Ai = A\eye(size(A, 1)); % Size: 6x64 double

    % Initialize the tensor matrix
    tensor = zeros(size(li, 1), size(li, 2), size(li, 3), 6); % Size: 110x110x3x6

    % Calculate the diffusion tensor D at each voxel
    s = li(1, 1, 1, :);
    s = s(:);
    for z = 1:size(li, 3)
        for y = 1:size(li, 2)
            for x = 1:size(li, 1)
                if(mask(x, y, z))
                    s = li(x, y, z, :);
                    s = s(:);
                    D = Ai * s(:);
                    tensor(x, y, z, :) = D;
                end
            end
        end
    end

    % Initialize variables for eigenvalues and eigenvectors
    l1 = zeros(size(tensor, 1), size(tensor, 2), size(tensor, 3));
    l2 = zeros(size(tensor, 1), size(tensor, 2), size(tensor, 3));
    l3 = zeros(size(tensor, 1), size(tensor, 2), size(tensor, 3));
    u1 = zeros(size(tensor, 1), size(tensor, 2), size(tensor, 3), 3);

    % Compute eigenvalues and eigenvectors from the diffusion tensor
    for z = 1:size(tensor, 3)
        for y = 1:size(tensor, 2)
            for x = 1:size(tensor, 1)
                if(mask(x, y, z))
                    D = tensor(x, y, z, :);
                    D = [D(1), D(2), D(3); D(2), D(4), D(5); D(3), D(5), D(6)];
                    [U, L] = eig(D);
                    l1(x, y, z) = L(3, 3);
                    l2(x, y, z) = L(2, 2);
                    l3(x, y, z) = L(1, 1);
                    u1(x, y, z, :) = U(:, 3);
                end
            end
        end
    end

    l1(l1<0)=0;
    l2(l2<0)=0;
    l3(l3<0)=0;
    % Calculate the mean diffusivity (MD)
    MD = (l1 + l2 + l3) / 3;

    % Compute the fractional anisotropy (FA)
    FA = sqrt(3/2) * sqrt((l1 - MD).^2 + (l2 - MD).^2 + (l3 - MD).^2) ./ sqrt(l1.^2 + l2.^2 + l3.^2);

    % Close any existing figure (if any)
    close(figure(7));

    % Create a new figure for displaying the FA
    hf7 = figure(7);
    cortesDMRI(FA, [0,1]);
    colorbar;
    title('FA');

    
    % Help for calculate_fa
    %
    % Calculates the fractional anisotropy (FA) from a diffusion tensor image.
    %
    % Inputs:
    %   nii: The nii image
    %   bval: The b-values
    %   bvec: The b-vectors
    %
    % Outputs:
    %   fa: The FA, a scalar value
end
