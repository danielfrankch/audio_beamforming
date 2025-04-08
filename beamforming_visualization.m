%%
clear
clc
T = (1:1:60000)';
Fs = 48000; %16000 for simple case
% L = sin((8/Fs).*T);

%%
L = audioread('English.m4a');
L = L(5*Fs:10*Fs);
n = 80;
R = shift_track(L,n,'L');


%%
close all
figure 
subplot(3,4,1:2)
plot(L,'b')
hold on
plot(R,'r')
% xlim([0,0.1*length(A)])

M = (L+R)./2;
plot(M,'k','LineStyle','--')
legend('Left Mic','Right Mic','Location','southwest')
title('German Speaker standing on the left')
%%
% L2 = sin((4/Fs).*T);
L2 = audioread('German.m4a');
L2 = L2(5*Fs:10*Fs);
R2 = shift_track(L2,n,'R');
subplot(3,4,3:4)
plot(L2,'b')
hold on
plot(R2,'r')
plot((L2+R2)./2,'k','LineStyle','--')
legend('Left Mic','Right Mic','Location','southwest')
title('English Speaker standing on the right')
%%
ML = (L + L2)./2;
MR = (R + R2)./2;
subplot(3,4,5:6)
plot(ML,'b')
hold on
plot((ML+MR)./2,'k','LineStyle','--')
title('Mixed audio on left mic')
subplot(3,4,7:8)
plot(MR,'r')
hold on 
plot((ML+MR)./2,'k','LineStyle','--')
title('Mixed audio on right mic')

%% Perform beamforming 
Beamform_to_left = ML-shift_track(MR,n,'L');
subplot(3,4,9:10)
plot(Beamform_to_left,'m')
title('Beamform towards left')

Beamform_to_right = ML-shift_track(MR,n,'R');
subplot(3,4,11:12)
plot(Beamform_to_right,'m')
title('Beamform towards right')


%% There exists an optimize n to make this work the best

% Brief function to to shift audio track to L/R
function output = shift_track(input,n,direction)
    unsigned_n = abs(n);
    if direction == 'R' % Shifts to the right
        output = [input(unsigned_n+1:end);zeros(unsigned_n,1)];
    elseif direction == 'L' % Shifts to the left 
        output = [zeros(unsigned_n,1);input(1:end-unsigned_n)];
    end
end