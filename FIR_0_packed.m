fs1 = 50;
fs2 = 100;
f1 = 8; 
f2 = 12; 
A_dB = 80;

Beta = A_dB/10; %if A_dB < 40 dB have to reduce Beta
M = floor((fs1/(f2-f1))*A_dB/15); %For windowed design, A_dB/22

if rem(M,2)==0 %we want N to be an odd integer 
    M=M+1;  
end

MM=(M-1)/2; %Compute end points of array interval, NN
phi=2*pi*(-MM:MM)*(f1+f2)/(2*fs1); %compute phase argument of sinc filter
 
h=sin(phi)./phi; %unscaled sinc filter h
h(MM+1)=1; %correct failed 0/0 computation
h0=h.*kaiser(2*MM+1,Beta)'; %Apply window to obtain Stopband Ripple
h2=h0*(f2+f1)/fs1; %Scale filter gain f0/fs

h3 = zeros(1,2*length(h2));
h3(1:2:end) = h2;

f13 = fs2/8;
f23 = fs2/4;

phi3 = 2*pi*(-length(h3):length(h3))*(f13+f23)/(2*fs2);
h1 = sin(phi3)./phi3;
h1(length(h3)+1) = 1;
h03 = h1 .* kaiser(2*length(h3)+1, Beta)';
g1 = h03*(f23+f13)/fs2;

figure(207)
subplot(3,1,1)
grid on
plot(h3,'b','linewidth',2)
axis([-1 50 -0.1 0.5])
title('Impulse Response, Kaiser')
xlabel('Time Index')
ylabel('Amplitude')

fh=fftshift(20*log10(abs(fft(h3,1024))));
fh2=fftshift(20*log10(abs(fft(g1,1024))));

subplot(3,1,2)
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh,'b','linewidth',2)
hold on
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh2,'r','linewidth',2)
hold off
grid on
axis([-20 +20 -120 10])
title('Frequency Response of h3 and g1')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')

subplot(3,2,5)
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh,'b','linewidth',2)
grid on
hold on 
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh2,'r','linewidth',2)
hold off
axis([-10 +10 -0.0010 0.0010])
title('In-Band Ripple Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')

subplot(3,2,6)
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh,'b','linewidth',2)
grid on
axis([10 +30 -120 10])
title('Transition BW Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')
