close all;
clear;
clc;

load('ActividadCanalMultitrayecto20201.mat');
figure('units','normalized','outerposition',[0 0 1 1])

tau = linspace(0, 1e-3, size(H1, 1));
PDP = mean(abs(H1), 2);

plot(tau, PDP);
title({'PDP - Habitación 1'; 'Condiciones de Campaña'}, ...
       'FontSize', 15);
xlabel('\tau (s)', 'FontSize', 15);
ylabel('P(\tau)', 'FontSize', 15);
% saveas(gcf,'PDP.png');

BW = 80e3;
[HNew, Samples] = delimitarBW(H1, BW, tau);
PDPNew = mean(abs(HNew), 2);

stem(Samples, PDPNew);
title({'PDP - Habitación 1'; 'Condiciones de Grupo'}, ...
       'FontSize', 15);
xlabel('\tau [n]', 'FontSize', 15);
ylabel('P(\tau)', 'FontSize', 15);
% saveas(gcf,'PDPParametros.png');