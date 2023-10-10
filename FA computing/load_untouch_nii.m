%  Load NIFTI or ANALYZE dataset, but not applying any appropriate affine
%  geometric transform or voxel intensity scaling.
%
%  Although according to NIFTI website, all those header information are
%  supposed to be applied to the loaded NIFTI image, there are some
%  situations that people do want to leave the original NIFTI header and
%  data untouched. They will probably just use MATLAB to do certain image
%  processing regardless of image orientation, and to save data back with
%  the same NIfTI header.
%
%  Since this program is only served for those situations, please use it
%  together with "save_untouch_nii.m", and do not use "save_nii.m" or
%  "view_nii.m" for the data that is loaded by "load_untouch_nii.m". For
%  normal situation, you should use "load_nii.m" instead.
%  
%  Usage: nii = load_untouch_nii(filename, [img_idx], [dim5_idx], [dim6_idx], ...
%			[dim7_idx], [old_RGB], [slice_idx])
%  
%  filename  - 	NIFTI or ANALYZE file name.
%  
%  img_idx (optional)  -  a numerical array of image volume indices.
%	Only the specified volumes will be loaded. All available image
%	volumes will be loaded, if it is default or empty.
%
%	The number of images scans can be obtained from get_nii_frame.m,
%	or simply: hdr.dime.dim(5).
%
%  dim5_idx (optional)  -  a numerical array of 5th dimension indices.
%	Only the specified range will be loaded. All available range
%	will be loaded, if it is default or empty.
%
%  dim6_idx (optional)  -  a numerical array of 6th dimension indices.
%	Only the specified range will be loaded. All available range
%	will be loaded, if it is default or empty.
%
%  dim7_idx (optional)  -  a numerical array of 7th dimension indices.
%	Only the specified range will be loaded. All available range
%	will be loaded, if it is default or empty.
%
%  old_RGB (optional)  -  a scale number to tell difference of new RGB24
%	from old RGB24. New RGB24 uses RGB triple sequentially for each
%	voxel, like [R1 G1 B1 R2 G2 B2 ...]. Analyze 6.0 from AnalyzeDirect
%	uses old RGB24, in a way like [R1 R2 ... G1 G2 ... B1 B2 ...] for
%	each slices. If the image that you view is garbled, try to set 
%	old_RGB variable to 1 and try again, because it could be in
%	old RGB24. It will be set to 0, if it is default or empty.
%
%  slice_idx (optional)  -  a numerical array of image slice indices.
%	Only the specified slices will be loaded. All available image
%	slices will be loaded, if it is default or empty.
%
%  Returned values:
%  
%  nii structure:
%
%	hdr -		struct with NIFTI header fields.
%
%	filetype -	Analyze format .hdr/.img (0); 
%			NIFTI .hdr/.img (1);
%			NIFTI .nii (2)
%
%	fileprefix - 	NIFTI filename without extension.
%
%	machine - 	machine string variable.
%
%	img - 		3D (or 4D) matrix of NIFTI data.
%
%  - Jimmy Shen (jimmy@rotman-baycrest.on.ca)
%
function nii = load_untouch_nii(filename, img_idx, dim5_idx, dim6_idx, dim7_idx, ...
			old_RGB, slice_idx)
    %#codegen

  % Count the number of arguments that are passed to the function.
  num_args = nargin;

  % Check if the filename argument is missing.
  if num_args < 1
    error('Usage: nii = load_untouch_nii(filename, [img_idx], [dim5_idx], [dim6_idx], [dim7_idx], [old_RGB], [slice_idx])');
  end

  % Check if the img_idx argument is missing.
  if num_args < 2
    img_idx = [];
  end

  % Check if the dim5_idx argument is missing.
  if num_args < 3
    dim5_idx = [];
  end

  % Check if the dim6_idx argument is missing.
  if num_args < 4
    dim6_idx = [];
  end

  % Check if the dim7_idx argument is missing.
  if num_args < 5
    dim7_idx = [];
  end

  % Check if the old_RGB argument is missing.
  if num_args < 6
    old_RGB = 0;
  end

  % Check if the slice_idx argument is missing.
  if num_args < 7
    slice_idx = [];
  end


   v = version;

   %  Check file extension. If .gz, unpack it into temp folder
   %
   if length(filename) > 2 & strcmp(filename(end-2:end), '.gz')

      if ~strcmp(filename(end-6:end), '.img.gz') & ...
	 ~strcmp(filename(end-6:end), '.hdr.gz') & ...
	 ~strcmp(filename(end-6:end), '.nii.gz')

         error('Please check filename.');
      end
      tmpDir = generate_temp_filename();
      create_temp_dir(tmpDir);
      if str2double(v(1:3)) < 7.1 
         error('Please use MATLAB 7.1 (with java) and above, or run gunzip outside MATLAB.');
      elseif strcmp(filename(end-6:end), '.img.gz')
         filename1 = filename;
         filename2 = filename;
         filename2(end-6:end) = '';
         filename2 = [filename2, '.hdr.gz'];

         gzFileName = filename;

         filename1 = gunzip(filename1, tmpDir);
         filename2 = gunzip(filename2, tmpDir);
         filename = char(filename1);	% convert from cell to string
      elseif strcmp(filename(end-6:end), '.hdr.gz')
         filename1 = filename;
         filename2 = filename;
         filename2(end-6:end) = '';
         filename2 = [filename2, '.img.gz'];

         gzFileName = filename;

         filename1 = gunzip(filename1, tmpDir);
         filename2 = gunzip(filename2, tmpDir);
         filename = char(filename1);	% convert from cell to string
      elseif strcmp(filename(end-6:end), '.nii.gz')
          
         gzFileName = filename;
         filename = gunzip(filename, tmpDir);
         filename = char(filename);	% convert from cell to string
      end
   end

   %  Read the dataset header
   %
   [nii.hdr,nii.filetype,nii.fileprefix,nii.machine] = load_nii_hdr(filename);

   if nii.filetype == 0
      nii.hdr = load_untouch0_nii_hdr(nii.fileprefix,nii.machine);
      nii.ext = [];
   else
      nii.hdr = load_untouch_nii_hdr(nii.fileprefix,nii.machine,nii.filetype);

      %  Read the header extension
      %
      nii.ext = load_nii_ext(filename);
   end

   %  Read the dataset body
   %
   [nii.img,nii.hdr] = load_untouch_nii_img(nii.hdr,nii.filetype,nii.fileprefix, ...
		nii.machine,img_idx,dim5_idx,dim6_idx,dim7_idx,old_RGB,slice_idx);

   %  Perform some of sform/qform transform
   %
%   nii = xform_nii(nii, tolerance, preferredForm);

   nii.untouch = 1;


   %  Clean up after gunzip
   %
    if isfile(gzFileName)

      %  fix fileprefix so it doesn't point to temp location
      %
      nii.fileprefix = gzFileName(1:end-7);
      remove_temp_dir(tmpDir);
   end


   return					% load_untouch_nii

