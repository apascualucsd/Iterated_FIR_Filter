fs1 = 50;
fs2 = 100;
fs3 = 200;
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

h4 = conv(h3, g1, 'same');

%h5
h5 = zeros(1,2*length(h4));
h5(1:2:end) = h4;

f14 = fs3/8;
f24 = fs3/4;

phi4 = 2*pi*(-length(h5):length(h5))*(f14+f24)/(2*fs3);
h7 = sin(phi4)./phi4;
h7(length(h5)+1) = 1;
h04 = h7 .* kaiser(2*length(h5)+1, Beta)';
g2 = h04*(f24+f14)/fs3;

figure(205)
subplot(3,1,1)
plot(h5,'b','linewidth',2)
grid on
axis([-1 50 -0.1 0.5])
title('Impulse Response, lowpass interpolating filter ')
xlabel('Time Index')
ylabel('Amplitude')

fh3=fftshift(20*log10(abs(fft(g2,1024))));

fh2=fftshift(20*log10(abs(fft(h5,1024))));

subplot(3,1,2)
plot([-0.5:1/1024:0.5-1/1024]*fs3,fh2,'b','linewidth',2)
hold on
plot([-0.5:1/1024:0.5-1/1024]*fs3,fh3,'--r','linewidth',2)
hold off
grid on
axis([-20 +20 -120 10])
title('Frequency Response of g2 and h5')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')

subplot(3,2,5)
plot([-0.5:1/1024:0.5-1/1024]*fs3,fh2,'b','linewidth',2)
grid on
hold on 
plot([-0.5:1/1024:0.5-1/1024]*fs3,fh3,'r','linewidth',2)
hold off
axis([-10 +10 -0.005 0.005])
title('In-Band Ripple Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')

subplot(3,2,6)
plot([-0.5:1/1024:0.5-1/1024]*fs3,fh2,'b','linewidth',2)
grid on
axis([10 +30 -120 10])
title('Transition BW Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')
