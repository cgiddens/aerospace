% FIND POWER SPECTRUM OF A MICROPHONE SIGNAL
%----------------------------------------------
% Aerospace Engineering, UT Austin 2016
% Author: Calvin Giddens
%----------------------------------------------
% Inputs:
%       x:      Input signal (Volts)
%       x2:     Second input signal (Volts)
%       fs:     Sampling frequency (Hz)
%
% Output:
%       psdx:   Power spectrum of signal (dB/Hz)
%----------------------------------------------
% NOTE: FFT method borrowed heavily from Mathworks
% NOTE: Averages two identical signals to minimize noise

function [] = pspec(x,x2,fs)

	N = length(x);

	% calib is the mV/Pa rating of the microphone
	calib = 2;

	% Convert from Volts to Pascals
	xPa = (1000 * x) / calib;
	x = xPa;

	xPa2 = (1000 * x2) / calib;
	x2 = xPa2;

	% Take Discrete Fourier Transform of signal
	xdft = fft(x);
	xdft2 = fft(x2);

	% To conserve total power, multiply all frequencies,
	% positive and negative, by a factor of 2
	xdft = xdft(1:N/2+1);
	xdft2 = xdft2(1:N/2+1);

	% Convert to power spectrum
	psdx = (1/(fs*N)) * abs(xdft).^2;
	psdx2 = (1/(fs*N)) * abs(xdft2).^2;

	psdx(2:end-1) = 2 * psdx(2:end-1);
	psdx2(2:end-1) = 2 * psdx2(2:end-1);

	% Average power spectra of both signals
	psdxav = (psdx + psdx2) / 2;

	freq = 0:fs/length(x):fs/2;

	% Plot the resulting power spectrum

	% Smoothened plot, useful for removing resonances/anomalies from environment
	% NOTE: Not actually reducing noise - just makes it physically easier on the eyes
	% plot(freq(1:fs/1000:length(freq)),smooth(10 * log10(psdx(1:fs/1000:length(freq)))))

	% Full plot, no smoothing (only aliasing)
	plot(freq,smooth(10 * log10(psdxav)))

	% Configure plot
	grid on
	hold on
	set(gca,'XScale','log');
	set(gca,'Xlim',[30 17000]);
	set(gca,'Xtick',[30 50 100 300 500 1000 2000 3000 5000 7000 10000 15000 20000]);
	xlabel('Frequency (x 10kHz)')
	ylabel('Power/Frequency (dB/Hz)')
	title('Frequency Response')

end
