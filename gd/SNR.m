function snrValue = SNR(x_orig,x_recon)
    
	% snr = 20 log10( signal.^2/noise.^2)
	x_orig = x_orig(:);
    x_recon = x_recon(:);
	
	Px_orig = sum(x_orig.^2);
	Px_noise = sum(abs(x_recon-x_orig).^2);
	
	snrValue = 20 * log10(Px_orig/Px_noise);