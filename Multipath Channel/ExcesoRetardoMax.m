close all;
clear;
clc;

load('ActividadCanalMultitrayecto20201.mat');
figure('units','normalized','outerposition',[0 0 1 1])
format shortEng
format compact

Sensibilidad = -111.5;
t = linspace(0, 20/3, length(H1));
tau = linspace(0, 1e-3, size(H1, 1));
PDP = mean(abs(H1), 2);
PDPDB = 10*log10(PDP);
RetardoMax = max((PDPDB > Sensibilidad).*tau');

plot(tau, PDPDB);
yline(Sensibilidad, '--', 'Sensibilidad',               ...
                    'LabelVerticalAlignment', 'top')
xline(RetardoMax, '--', {'Exceso de', 'Retardo Máximo'}, ...
                  'LabelOrientation', 'horizontal',     ...
                  'LabelVerticalAlignment', 'middle')
title({'PDP - Habitación 1'; 'Condiciones de campaña'}, ...
       'FontSize', 15);
xlabel('\tau (s)', 'FontSize', 15);
ylabel('P(\tau)', 'FontSize', 15);
% saveas(gcf,'RetardoMax.png');

disp(['El exceso de retardo máximo bajo las condiciones de campaña es: ', ...
      num2str(round(RetardoMax * 1e6, 2)), ' us.']);

FunRetardoMax = max((10*log10(abs(H1)) > Sensibilidad).*tau');
plot(t, FunRetardoMax);
title({'Retardo Máximo - Habitación 1'; 'Condiciones de Campaña'}, ...
       'FontSize', 15);
yline(RetardoMax, '--', {'Exceso de', 'Retardo Máximo'},           ...
                  'LabelVerticalAlignment', 'middle')
xlabel('T (s)', 'FontSize', 15);
ylabel('\tau (s)', 'FontSize', 15);
saveas(gcf,'FunRetardoMax.png');

BW = 80e3;
[HNew, Samples] = delimitarBW(H1, BW, tau);
PDPNew = mean(abs(HNew), 2);
PDPDBNew = 10*log10(PDPNew);
RetardoMaxNew = max((PDPDBNew > Sensibilidad).*Samples');

stem(Samples, PDPDBNew);
xline(RetardoMaxNew, '--', {'Exceso de', 'Retardo Medio'}, ...
                     'LabelOrientation', 'horizontal',     ...
                     'LabelVerticalAlignment', 'bottom',   ...
                     'LabelHorizontalAlignment', 'left')
title({'PDP - Habitación 1'; 'Condiciones de Grupo'},      ...
       'FontSize', 15);
xlabel('\tau [n]', 'FontSize', 15);
ylabel('P(\tau)', 'FontSize', 15);
% saveas(gcf,'RetardoMaxGrupo.png');

disp(['El exceso de retardo máximo bajo las condiciones de grupo es ', ...
      'equivalente a la muestra número: ',                             ...
      num2str(round(RetardoMaxNew, 2)), '.'])
disp(['Esto equivale al instante: ',                                   ...
      num2str(round(RetardoMaxNew * 1e3 /BW, 2)), ' ms.']);