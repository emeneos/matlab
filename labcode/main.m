load test_data.mat; 
signal = atti( :, :, :, abs(bi-1000)<100 ); 
gi = gi( abs(bi-1000)<100, : ); 
 
[M,N,P,G] = size(signal); 
options = create_signal2sh_options(M, N, P); 
options.mask=mask; 
 
% Call the signal2sh function 
SH = signal2sh(signal, gi, options); 
 
% Display the size of the resulting SH coefficients 
disp(size(SH)); 
