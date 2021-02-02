% Reset do Matlab
clear('variables'); close('all'); clc;

% Lê o sinal de entrada
[x, fs] = audioread('aplausos.wav');

% Calcula o tempo
t = 0:1/fs:(length(x)-1)/fs;

% Pergunta se quer reproduzir o sim
resposta = questdlg('Deseja reproduzir este arquivo de audio?', ...
    'Reproduzir','Sim', 'Não','Não');
if strcmp(resposta,'Sim')   % Compara as strings
    sound(x,fs);
end

% Gráfico
figure(1)
subplot(2,1,1);
plot(t,x,'b-');
title('Sinal de Entrada e seu Espectro');
xlabel('Tempo [s]');
ylabel('Amplitude');
legend('Sinal de entrada');
grid('minor');
subplot(2,1,2);
% X, Transformada de Fourier
% F, Vetor de frequências
% freqz, Comando para analise de respostas em frequência de filtros
% x, repreenta o b em coeficientes de filtros, equivalente ao sinal de
% entrada
% 1, representa A, que equivale a realimentação do filtro
% 1024, representa a quantidade de pontos do espectro
[X, F] = freqz(x,1,1024,fs);
plot(F/1000,abs(X),'b-');
xlabel('Frequência [kHz]');
ylabel('Magnitude');
legend('Sinal de entrada');
axis([0 8 0 max(abs(X))]);
set(gcf,'color','w');
grid('minor');

%% Parâmetros do ADC
ADC_fs = 8000; % em amostras/segundo
ADC_quantizacao = 8; % em bits

% Amostragem do sinal
ADC_x = x(1:fs/ADC_fs:end);
ADC_t = t(1:fs/ADC_fs:end);

% Gráfico
figure(2)
plot(t,x,'b-');
hold('on');
stem(ADC_t,ADC_x,'r');
title('Sinal Amostrado');
xlabel('Tempo [s]');
ylabel('Amplitude');
legend('Sinal de entrada','Sinal Amostrado (não Quantizado)');
set(gcf,'color','w');
grid('minor');

% Define os níveis lógicos
ADC_QtoNiveis = 2^ADC_quantizacao;
% Cria os níveis lógicos
ADC_niveis = min(x):(max(x)-min(x))/(ADC_QtoNiveis-1):max(x);
% Cria um vetor com o mesmo tamanho de x com zeros
ADC_quantizado = zeros(size(ADC_x));
for i = 1:length(ADC_x)
    ADC_quantizado(i) = ...
        ADC_niveis(find(ADC_niveis>=ADC_x(i),1));
end
ADC_Tquantizado = ADC_t(round(1:0.5:length(ADC_t))) - (ADC_t(2)-ADC_t(1))/2;
ADC_Xquantizado = ADC_quantizado(floor(1:0.5:length(ADC_t)));
% Gráfico
figure(3)
plot(t,x,'b-');
hold('on');
title('Sinal Digital');
stem(ADC_t,ADC_x,'r');
xlabel('Tempo [s]');
ylabel('Amplitude');
% Plot ilustrativo de quantização
plot(ADC_Tquantizado, ADC_Xquantizado,'k-','LineWidth',1);
% Plot do ponto exato de referência
plot(ADC_t, ADC_quantizado,'kd','LineWidth',2);
set(gcf,'color','w');
grid('minor');
legend('Sinal Analógico','Sinal Amostrado','Sinal Amostrado e Quantizado','Sinal Digital')
