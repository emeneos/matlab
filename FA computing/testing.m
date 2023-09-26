input_filepath = 'dwi.nii.gz';
output_filepath = 'fa_calculated.nii.gz';
mask_filepath = 'mask.nii.gz';  % Optional: Provide a mask file path, or leave it empty
bval = 'dwi.bvals';
bvec = 'dwi.bvecs';

calculateAndSaveFA(input_filepath, output_filepath, mask_filepath, bval, bvec);
