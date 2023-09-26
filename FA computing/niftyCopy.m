function niftiCopy = niftyCopy(niftiFilename)
    try
        % Load the NIfTI file using load_untouch_nii
        niftiData = load_untouch_nii(niftiFilename);

        % Create an empty array of zeros with dimensions matching niftiData
        emptyArray = zeros(size(niftiData.img));
        
        % Create a new NIfTI structure x with the empty array
        x = make_nii(emptyArray);
        

        % Validate and copy values from niftiData to x
        if isfield(niftiData, 'hdr') && isstruct(niftiData.hdr)
            hdr = niftiData.hdr;
            if isfield(hdr, 'hk') && isstruct(hdr.hk)
                x.hdr.hk = hdr.hk;
            else
                warning('Field ''hdr.hk'' is missing in the NIfTI file.');
            end
            if isfield(hdr, 'dime') && isstruct(hdr.dime)
                x.hdr.dime = hdr.dime;
            else
                warning('Field ''hdr.dime'' is missing in the NIfTI file.');
            end
            if isfield(hdr, 'hist') && isstruct(hdr.hist)
                x.hdr.hist = hdr.hist;
            else
                warning('Field ''hdr.hist'' is missing in the NIfTI file.');
            end
        else
            warning('Field ''hdr'' is missing in the NIfTI file.');
        end

        % Validate and copy x.filetype
        if isfield(niftiData, 'filetype')
            x.filetype = niftiData.filetype;
        else
            warning('Field ''filetype'' is missing in the NIfTI file.');
        end

        % Copy other values from niftiData to x
        x.fileprefix = niftiData.fileprefix;
        x.machine = niftiData.machine;
        x.ext = niftiData.ext;
        x.img = niftiData.img;
        x.untouch = niftiData.untouch;

        % Return the copied structure as niftiCopy
        niftiCopy = x;

    catch exception
        % If any error occurs during the process, return an empty struct and display the error message
        niftiCopy = struct();
        fprintf('Error: %s\n', exception.message);
    end
end
