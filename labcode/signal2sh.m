
function SH = signal2sh( signal, gi, opt ) %#codegen
% Declare the MEX function as extrinsic.
%coder.extrinsic('mexGenerateSHMatrix');
%#codegen
% function SH = signal2sh( signal, gi, 'opt1', value1, 'opt2', value2, ... )
%
%   Takes a generic symmetric signal defined over the unit sphere and 
%   represents it in the basis of spherical harmonics by using (Tikhonov 
%   regularized) least squares:
%
%      signal: a MxNxPxG double array containing the signal sampled at G
%         directions at each voxel within the MxNxP image frame.
%      gi: a Gx3 matrix with the directions sampled table, each row 
%         corresponding to a unit vector (signal(gi) is assumed to be equal
%         to signal(-gi));
%
%      SH: a MxNxPx((L+1)(L+2)/2) array with the coefficients computed at 
%         each voxel.
%
%   Optional arguments may be passed as name/value pairs in the regular
%   matlab style:
%
%      L: an even integer with the maximum order of the SH to be used
%         (default: 6).
%      lambda: the Tikhonov regularization parameter for the linear least
%         squares problem (default 0.006).
%      chunksz: the LLS problem reduces to the product of the dwi signal
%         by an inverse matrix that may be pre-computed for the whole data
%         set. To improve the performance, cunksz voxels are gathered
%         together in a single matrix that is pre-multiplied by the LLS
%         inverse at each step, hence taking advantage of matlab's
%         capabilities (default: 1000).
%      mask: a MxNxP array of logicals. Only those voxels where mask is
%         true are processed, the others are filled with zeros.

% Check the mandatory input argments:
%#codegen
if(nargin<2)
    error('At lest the signal and the directions table must be supplied');
end
[M,N,P,G] = size(signal);
NV = M*N*P; % Total number of voxels to be processed

% Compute the LS matix for SH fitting:
% GxK, where K=(L+1)(L+2)/2
% size of B is 64 x (R = (L/2 + 1) * (L + 1)), L comes from the
% create_signal2sh_options. Also remember that the 64 is G from the
% signal.then we can do B = double(zeros(G,R)) ;
L = opt.L;
R = (L/2 + 1) * (L + 1);
B = zeros(G,R);
M = size(gi,1);
if coder.target('MATLAB')
    %execute interpreted matlab code
    B = GenerateSHMatrix( opt.L, gi );    % GxK, where K=(L+1)(L+2)/2
else
    %generate  C code using existing C code(*(sd
    %coder.varsize('G', [inf, inf], [1 1]);
    coder.cinclude('test.cpp'); %I can not find the h file 
    %coder.updateBuildInfo('addSourcePaths','D:\uvalladolid\DMRIMatlab\mexcode\sh');
    %fprintf('Running custom C code...');

    

    
    % Call mexGenerateSHMatrix
    coder.ceval('test',coder.ref(B),[],uint8(L), coder.ref(gi),uint8(M));
    %coder.ceval('mexGenerateSHMatrix',coder.ref(B),[],uint8(L), coder.ref(gi),uint8(G_));

    %coder.ceval('mexGenerateSHMatrix',1,B,3,coder.ref(opt.L),coder.ref(gi),coder.ref(B));
end
LR  = GenerateSHEigMatrix( opt.L );     % KxK
WLS = (B'*B+(opt.lambda).*LR^2)\(B');   % (KxK)^(-1) * (KxG) -> KxG
WLS = WLS'; % GxK, for convenience, see loop below

% Now, fit the data chunk-by-chunk via least squares where the mask is true
signal  = reshape(signal,[NV,G]); % NVxG
mask    = opt.mask(:);            % NVx1
% Mask...
signal = signal(mask,:); % PVxG
PV     = size(signal,1);
SHmask = zeros(PV,size(WLS,2)); % NVxK
for ck=1:ceil(PV/opt.chunksz)
    idi = (ck-1)*opt.chunksz+1;
    idf = min(ck*opt.chunksz,PV);
    SHmask(idi:idf,:) = signal(idi:idf,:)*WLS; % (chunksz x G) * (G x K) -> (chunksz x K)
end
% Cast the result to the proper size:
SH   = zeros(NV,size(WLS,2)); % NVx(L+1)(L+2)/2
SH(mask,:) = SHmask;
SH = reshape(SH,[M,N,P,size(WLS,2)]);

