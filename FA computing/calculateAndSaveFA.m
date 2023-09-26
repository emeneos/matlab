function calculateAndSaveFA(input_filepath, output_filepath, mask_filepath, bval, bvec)
    % Calculate FA volume
    FA = return_fa_volume(input_filepath, bval, bvec, mask_filepath);


    % Use niftiinfo to read the NIfTI headers
    niftiInfo = niftyCopy(input_filepath);

    % Load the diffusion MRI data from the specified file
    dmri = niftiread(input_filepath);
    
    % Add an extra dimension to FA to match the dimensions of dmri
    FA = reshape(FA, size(dmri, 1), size(dmri, 2), size(dmri, 3), 1);
    % Replicate the FA tensor along the fourth dimension to match the time dimension of dmri
    FA = repmat(FA, [1, 1, 1, size(dmri, 4)]);
    FA = int16(FA);


    niftiInfo.img = FA;
    new_nii = make_nii(FA);
    save_nii(new_nii,output_filepath);
    
    % Display a message indicating successful file creation
    fprintf('FA NIfTI file saved to %s\n', output_filepath);
end