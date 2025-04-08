%% Load in the files
clear

[English, Fs] = audioread('English.m4a');
[German, Fs] = audioread('German.m4a');
German(height(English)+1:end) = [];

%%  
English_Stereo = zeros(size(English,1),2);
English_Stereo(:,1) = English;
English_Stereo(:,2) = English;

%% Shift the sound to the right/left
n = 80;
English_StandingRight = English_Stereo;
English_StandingRight(:,2) = [English_Stereo(n+1:end,2);zeros(n,1)];

English_StandingLeft = English_Stereo;
English_StandingLeft(:,1) = [English_Stereo(n+1:end,1);zeros(n,1)];


%% Play right-shifted sound, can you feel it? Wear a headphone!
player = audioplayer(English_StandingRight, Fs);
play(player);  % Start playing
pause(5);
stop(player);

%% Play left-shifted sound, can you feel it? Wear a headphone!
player = audioplayer(English_StandingLeft, Fs);
play(player);  % Start playing
pause(5);
stop(player);

%% Mix Germand and English, can you still understand the speaker?
Mix = (German + English)./2;
player = audioplayer(Mix, Fs);
play(player);  % Start playing
pause(5);
stop(player);

%% Now shift German speaker to the right, and English to the left, then mix
n = 80;

% Create stereo German
German_Stereo = zeros(size(German,1),2);
German_Stereo(:,1) = German;
German_Stereo(:,2) = German;

% Shift to the right
German_StandingRight = German_Stereo;
German_StandingRight(:,2) = [German_Stereo(n+1:end,2);zeros(n,1)];

% Mix German_R with English_L
Mix_Stereo = (German_StandingRight + English_StandingLeft)/2;

player = audioplayer(Mix_Stereo, Fs);
play(player);  % Start playing
pause(5);
stop(player);

%% Try using beamforming on the Mix_Stereo to let the English speaker stand out more.
M_Mono = Mix_Stereo(:,1);
M_Shift = [M_Mono(n+1:end);zeros(n,1)];
L = (M_Shift + M_Mono)/2;
Residue = Mix_Stereo(:,2) - M_Shift;

figure
subplot(3,1,1)
plot(M_Mono)
subplot(3,1,2)
plot(Residue)
% subplot(3,1,3)
% plot(German)
%%
player = audioplayer(Residue, Fs);
play(player);  % Start playing
pause(5);
stop(player);





