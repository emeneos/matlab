load test_data.mat; 
signal = atti( :, :, :, abs(bi-1000)<100 ); 
gi = gi( abs(bi-1000)<100, : ); 
 
[M,N,P,G] = size(signal); 
options = create_signal2sh_options(M, N, P); 
options.mask=mask; 
 
% Call the signal2sh function 
SH  = signal2sh_mex(signal, gi, options);
SH2 = signal2sh(signal, gi, options);

mu0=sum(SH(:,:,9,2:end).^2,4);
mu2=sum(SH2(:,:,9,2:end).^2,4);
imshow([mu0,mu2],[]);
 
% Display the size of the resulting SH coefficients 
disp(size(SH)); 
