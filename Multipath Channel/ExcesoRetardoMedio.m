close all;
clear;
clc;

load('ActividadCanalMultitrayecto20201.mat');
figure('units','normalized','outerposition',[0 0 1 1])
format shortEng
format compact

t = linspace(0, 20/3, length(H1));
tau = linspace(0, 1e-3, size(H1, 1));
PDP = mean(abs(H1), 2);
RetardoMedio = sum(PDP.*tau')./sum(PDP);

plot(tau, PDP);
xline(RetardoMedio, '--', {'Exceso de', 'Retardo Medio'}, ...
                    'LabelOrientation', 'horizontal',     ...
                    'LabelVerticalAlignment', 'middle')
title({'PDP - Habitación 1'; 'Condiciones de Campaña'}, ...
       'FontSize', 15);
xlabel('\tau (s)', 'FontSize', 15);
ylabel('P(\tau)', 'FontSize', 15);
% saveas(gcf,'RetardoMedio.png');

disp(['El exceso de retardo medio bajo las condiciones de campaña es: ', ...
      num2str(round(RetardoMedio * 1e6, 2)), ' us.']);

FunRetardoMedio = sum(abs(H1).*tau')./sum(abs(H1));
plot(t, FunRetardoMedio);
title({'Retardo Medio - Habitación 1'; 'Condiciones de Campaña'}, ...
       'FontSize', 15);
yline(RetardoMedio, '--', {'Exceso de', 'Retardo Medio'}, ...
                    'LabelVerticalAlignment', 'bottom')
xlabel('T (s)', 'FontSize', 15);
ylabel('\tau (s)', 'FontSize', 15);
% saveas(gcf,'FunRetardoMedio.png');

BW = 80e3;
[HNew, Samples] = delimitarBW(H1, BW, tau);
PDPNew = mean(abs(HNew), 2);
RetardoMedioNew = sum(PDPNew.*Samples')./sum(PDPNew);

stem(Samples, PDPNew);
xline(RetardoMedioNew, '--', {'Exceso de', 'Retardo Medio'}, ...
                       'LabelOrientation', 'horizontal',     ...
                       'LabelVerticalAlignment', 'middle')
title({'PDP - Habitación 1'; 'Condiciones de Grupo'}, ...
       'FontSize', 15);
xlabel('\tau [n]', 'FontSize', 15);
ylabel('P(\tau)', 'FontSize', 15);
% saveas(gcf,'RetardoMedioGrupo.png');

disp(['El exceso de retardo medio bajo las condiciones de grupo es ', ...
      'equivalente a la muestra número: ',                            ...
      num2str(round(RetardoMedioNew, 2)), '.'])
disp(['Esto equivale al instante: ',                                  ...
      num2str(round(RetardoMedioNew * 1e6 / BW, 2)), ' us.']);