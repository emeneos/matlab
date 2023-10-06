function calculateAndSaveFA(input_filepath, output_filepath, mask_filepath, bval, bvec)
    %#codegen
    % Calculate FA volume
    FA = return_fa_volume(input_filepath, bval, bvec, mask_filepath);

    hdr = copy_nii_structure(input_filepath,FA);
  
    save_untouch_nii(hdr,output_filepath);
    
    % Display a message indicating successful file creation
    fprintf('FA NIfTI file saved to %s\n', output_filepath);
end