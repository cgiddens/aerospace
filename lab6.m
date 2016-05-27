function [] = lab6(data)

% LABORATORY 6
% code to process the measured acceleration signal
% plots time history 
% integrates to find displacement
% calculates power spectrum

% sirohi 102214

%clear all
%close all

fs = 1000;              % sampling frequency, Hz
T = 1;                  % duration of signal, s

dt = 1/fs;              % calculate time interval, s
tvec = [0:dt:T-dt]';    % generate time vector

%data = load('A1_data.txt','-ascii'); 

tipAccel = data(:,1)-mean(data(:,1));
tipVel = zeros(length(tvec),1);
tipDisp = zeros(length(tvec),1);

% % integrate to find velocity and displacement
% % for ii = 2:length(tvec),
% %     tipVel(ii) = tipVel(ii-1) + dt/2*(tipAccel(ii-1)+tipAccel(ii));
% %     tipDisp(ii) = tipDisp(ii-1) + dt/2*(tipVel(ii-1)+tipVel(ii));
% % end
tipVel = cumtrapz(tipAccel)*dt;
tipDisp = cumtrapz(tipVel)*dt;

figure(1)
subplot(311);
plot(tvec,tipAccel,'k-');
ylabel('Tip Acceleration, m^2/s');
grid on
subplot(312);
plot(tvec,tipVel,'k-');
ylabel('Tip Velocity, m/s');
grid on
subplot(313);
plot(tvec,tipDisp,'k-');
ylabel('Tip Displacement, m');
xlabel('Time, s');
grid on

dftAccel = fft(tipAccel);                               % calculate FFT
dftAccel = dftAccel(1:length(tvec)/2+1);                % throw away negative frequencies
%magAccel = 1/length(tvec)*abs(dftAccel);               % only magnitude at each frequency
psdAccel = (1/(fs*length(tvec))) * abs(dftAccel).^2;    % calculate power and scale it
psdAccel(2:end-1) = 2*psdAccel(2:end-1);                % multiply by two to account for negative frequencies
fvec = 0:fs/length(tvec):fs/2;                          % generate properly scaled frequency vector

figure(2)
subplot(211)
plot(tvec,tipAccel,'k-');
ylabel('Tip Acceleration, m^2/s');
xlabel('Time, s');
grid on
subplot(212);
plot(fvec,10*log10(psdAccel))
%plot(fvec,magAccel, 'b-');
grid on
xlabel('Frequency, Hz')
ylabel('Power/Frequency (dB/Hz)')

end