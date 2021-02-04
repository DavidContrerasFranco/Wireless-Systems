close all;
clear;
clc;

load('ActividadCanalMultitrayecto20201.mat');
figure('units','normalized','outerposition',[0 0 1 1])
format shortEng
format compact

t = linspace(0, 20/3, length(H1));
tau = linspace(0, 1e-3, size(H1, 1));
fd = 40;
Fs = 3e9;

PDP = mean(abs(H1), 2);
RetardoMedio = sum(PDP.*tau')./sum(PDP);
RetardoRMS = sum(PDP.*tau'.^2)./sum(PDP);

sigma = sqrt(RetardoRMS - RetardoMedio^2);
Bc = 1/(5*sigma);
Tc = 9/(16*pi*fd);

disp('Campaña:')
disp(['   Ancho de banda de coherencia: ', ...
      num2str(round(Bc, 2)), ' Hz.'])
disp(['   Tiempo de coherencia: ', ...
      num2str(round(Tc*1e3, 2)), ' ms.'])

BW = 80e3;
[HNew, Samples] = delimitarBW(H1, BW, tau);
PDPNew = mean(abs(HNew), 2);
RetardoMedioNew = sum(PDPNew.*(Samples / BW)')./sum(PDPNew);
RetardoRMSNew = sum(PDPNew.*(Samples / BW)'.^2)./sum(PDPNew);

sigmaNew = sqrt(RetardoRMSNew - RetardoMedioNew^2);
BcNew = 1/(5*sigmaNew);
deltaBc = BcNew / Bc;
TcNew = deltaBc * Tc;

disp('Grupo:')
disp(['   Ancho de banda de coherencia: ', ...
      num2str(round(BcNew, 2)), ' Hz.'])
% disp(['   Tiempo de coherencia: ', ...
%       num2str(round(TcNew*1e3, 2)), ' ms.'])

[c, lags] = xcorr(PDPNew, PDPNew, 'normalized');
stem(lags/BW, c)
title({'Autocorrelación PDP Normalizada- Habitación 1'; 'Condiciones de Grupo'}, ...
       'FontSize', 15);
xlabel('\tau (s)', 'FontSize', 15);
ylabel('P(\tau)', 'FontSize', 15);
saveas(gcf,'XCORRTC.png');

Amount = 0.5;
MinDelta = min(lags(c > Amount));
MaxDelta = max(lags(c > Amount));
disp(['   Tiempo de coherencia: ', ...
      num2str(round((MaxDelta - MinDelta)*1e3/BW, 2)), ' ms.'])
