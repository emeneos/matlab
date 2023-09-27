function niftiCopy = copy_nii_structure(input_filepath,FA)

    hdr = load_untouch_nii(input_filepath);
    hdr.img = FA;
    hdr.hdr.dime.dim = [ndims(FA),size(FA),repmat(1,[1,8-1-ndims(FA)])];
    hdr.hdr.dime.pixdim(5)=0;

    % Get the datatype of the FA array
    FA_datatype = class(FA);

    % Use the switch statement to assign the right number to the datatype
    switch FA_datatype
        case 'uint8'
            hdr.hdr.dime.datatype = 2;
        case 'int8'
            hdr.hdr.dime.datatype = 256;
        case 'uint16'
            hdr.hdr.dime.datatype = 512;
        case 'int16'
            hdr.hdr.dime.datatype = 4;
        case 'uint32'
            hdr.hdr.dime.datatype = 768;
        case 'int32'
            hdr.hdr.dime.datatype = 8;
        case 'single'
            hdr.hdr.dime.datatype = 16;
        case 'double'
            hdr.hdr.dime.datatype = 64;
        otherwise
            error('This datatype is not supported');
    end
    
    % Return the niftiCopy header
    niftiCopy = hdr;

end