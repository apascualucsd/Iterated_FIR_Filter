fs1 = 50;
fs2 = 200;
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

hh3 = zeros(1,4*length(h2));
hh3(1:4:end) = h2;

r2 = 0.01;
dev2 = [(10^(r2/20)-1)/(10^(r2/20)+1) 10^(-A_dB/20)]; 
[n_g2, fo_g2, ao_g2, w_g2] = firpmord([fs2/8 fs2/4], [1 0], dev2, 2*fs2);
gg1 = firpm(n_g2, fo_g2, ao_g2, w_g2);

figure(211)
subplot(3,1,1)
grid on
plot(hh3,'b','linewidth',2)
axis([-1 50 -0.1 0.5])
title('Impulse Response, Kaiser')
xlabel('Time Index')
ylabel('Amplitude')

fh=fftshift(20*log10(abs(fft(hh3,1024))));
fh2=fftshift(20*log10(abs(fft(gg1,1024))));

subplot(3,1,2)
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh,'b','linewidth',2)
hold on
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh2,'r','linewidth',2)
hold off
grid on
axis([-20 +20 -120 10])
title('Frequency Response of hh3 and gg1')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')

subplot(3,2,5)
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh,'b','linewidth',2)
grid on
hold on 
plot([-0.5:1/1024:0.5-1/1024]*fs2,fh2,'r','linewidth',2)
hold off
axis([-10 +10 -0.005 0.005])
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

