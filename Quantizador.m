clear ('variables')
close all
clc



%% Sinal De Entrada

[x,Fs]=audioread('aplauso_curto(1).wav'); %leitura de sinal de audio de entrada, Fs = frequencia de amostragem

double t; %torna o t(tempo) como uma variavel double para ter mais casas decimais
t=[0]; %iniciar o t(tempo) como um(a) vetor/matriz (1,1) para servir de inicio ao vetor do tempo do audio

while length(t) < length(x) %enquanto o numero de pontos do tempo for menor que o numero de pontos do sinal de entrada ele fará a condição abaixo  
	
    t(length(t)+1)=t(length(t))+(1/Fs); %irá aumentar o valor do vetor tempo no passo da frequencia de amostragem (convertido para segundos (1/Fs)
    %o valor de tempo adicionado será sempre na linha abaixo da ultima linha do vetor do tempo
end

Y = fft(x); %Encontra a frequencia rapida de fourier (fast frequency fourier - fft)
P2 = abs(Y/length(x)); %Elimina todos os valores complexos da transformada de fourier
P1 = P2(1:length(x)/2+1); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trecho tirado do help da fft do matlab - vou revisar essa parte ainda %%%%%%%%%%%%%%%%%%%%%%%%% 
P1(2:end-1) = 2*P1(2:end-1); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trecho tirado do help da fft do matlab - vou revisar essa parte ainda %%%%%%%%%%%%%%%%%%%%%%%%%
f = Fs*(0:(length(x)/2))/length(x); %Gera o espectro da frequencia do sinal

figure()
plot(f,P1)
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')


%%%%%%%%%%%%%%% Senoide de Teste %%%%%%%%%%%%%%%%%%%%

% fs = 1e-3; %Frequencia de amostragem em segundos
% t = -5:fs:5; %tempo do sinal e seu passo de calculo
% x = 2*sin(t); %amplitude do sinal senoidal

%%%%%%%%%%%% Fim da Senoide de Teste %%%%%%%%%%%%%%%%

%% Plot do Sinal de Entrada

figure()
plot(t,x);
title('Sinal de Entrada')
legend('Sinal de Entrada')
xlabel('Tempo')
ylabel('Amplitude')
axis([min(t) max(t) min(x)-1 max(x)+1])
grid on



%% Caracteristicas da Quantização

PP = max(x)-min(x); %pico a pico do sinal
b = 8; %bits do sinal a ser quantizado
L = 2^b; %Quantidade de niveís de quantização
v = PP/L; %largura dos niveis da quantização
n = min(x):v:max(x); %Niveis de quantização
n = [n(1,1:length(n)-1) n(1,length(n)-1)]; %Modifica o ultimo valor do nivel de quantização para ele ficar interpolado com o tempo de quantização
q_t = min(x)-(v/2):v:max(x)+(v/2); %Tempo de quantização, espaçamento horizontal da quantização com um off_set para ajustar o posicionamento na posição (0,0)
q_t = [min(q_t)+(v/2) q_t(2:length(q_t)-1) max(q_t)-(v/2)]; %Eliminando o off_set aplicado na linha acima desta


%% Digitalização do sinal

digita=zeros(1,length(x)); %Criação do sinal que será substituido pelos valores a serem digitalizados

for i=1:length(x) %% Varia de 1 até a quantidade de pontos da amostra do sinal de entrada
    for j=1:length(q_t)-1  %% Varia de um até a quantidade de pontos do tempo de quantização menos o ultimo ponto (-1) (o -1 é para não dar erro de matriz no if abaixo, no momento em que J for igual ao ultimo ponto do tempo de quantização q_t)
        if x(i)>=q_t(j) && x(i)<=q_t(j+1); %% Verifica se o sinal esta em determinada faixa de do tempo de quantização, entre o atual (j) e o proximo (j+1)
        	digita(i)=n(j); %% Declara a digitalização "i", em relação ao tempo de quantização "j" com o nivel da quantização "j"
        end
    end
end


%% Plot do Sinal de Entrada e do Sinal Digitalizado não Amostrado

figure()
hold on
plot(t,x);
plot(t,digita);
title(['Sinal Não Amostrado Quantizado a uma Taxa de ', num2str(b), ' Bits'])
legend('Sinal de Entrada','Sinal Digitalizado')
xlabel('Tempo')
ylabel('Amplitude')
axis([min(t) max(t) min(x)-1 max(x)+1])
grid on

%% Teorema de Nyquist–Shannon

fmax = max(f); %FREQUENCIA MAXIMA - encontra a maxima frequencia determinada no espectro da frequencia
f_sample = 4*fmax; %FREQUENCIA DE AMOSTRAGEM - torna a frequencia da amostra 4 vezes maior que a frequencia maxima (o minimo tem de ser 2)
amostragem = f_sample/Fs; %determina quantas veses a frequencia de amostragem é maior que a frequencia de amostras do sinal analisado, isso vai servir como passo para amostrar o sinal
t_sample = t(1,1:amostragem:(length(t))); % TEMPO AMOSTRADO - seleciona os pontos do tempo no passo da amostragem
x_sample = x(1:amostragem:(length(x)),1); % SINAL DE ENTRADA AMOSTRADO - seleciona os pontos do sinal de entrada no passo da amostragem

%% Digitalização do Sinal de Entrada amostrado

digita_sample=zeros(1,length(x_sample)); %Criação do sinal que será substituido pelos valores a serem digitalizados do sinal de entrada amostrado

for i=1:length(x_sample) %% Varia de 1 até a quantidade de pontos da amostra do sinal de entrada amostrado
    for j=1:length(q_t)-1  %% Varia de um até a quantidade de pontos do tempo de quantização menos o ultimo ponto (-1) (o -1 é para não dar erro de matriz no if abaixo, no momento em que J for igual ao ultimo ponto do tempo de quantização q_t)
        if x_sample(i)>=q_t(j) && x_sample(i)<=q_t(j+1); %% Verifica se o sinal esta em determinada faixa de do tempo de quantização, entre o atual (j) e o proximo (j+1)
        	digita_sample(i)=n(j); %% Declara a digitalização amostrada "i", em relação ao tempo de quantização "j" com o nivel da quantização "j"
        end
    end
end


%% Plot do Sinal Digital Utilizando o teorema de Nyquist–Shannon

figure()
hold on
plot(t,x)
plot(t_sample,digita_sample)
title(['Teorema de Nyquist–Shannon - Sinal Quantizado a uma Taxa de ', num2str(b), ' Bits'])
legend('Sinal de Entrada','Sinal Digitalizado Amostrado')
xlabel('Tempo')
ylabel('Amplitude')
axis([min(t) max(t) min(x)-1 max(x)+1])
grid on






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCONSIDERAR DAQUI PARA BAIXO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Tentativa de Codificação

% wordlength = log2(L); %saber quantos bits serão necessarios para a codificação
% for i=1:length(sinal_digit)
%     teste(i,1) = fi(sinal_digit(i),1,wordlength);
% end
% testando = teste.bin;
% 


%% Plot do Erro de Quantização (Entrada - Saída)
% Vrms=x/sqrt(2); %Tensão RMS
% P=Vrms.^2; %Potencia do Sinal
% P_R=(1/12)*((PP/L).^2); %Potência do Ruído de Quantização (Erro Médio Quadrático de Quantização)
% R_Q=P/P_R; %Sinal Para Ruído de Quantização
% 
% 
% figure()
% subplot(2,1,1);
% plot(t,x)
% hold on
% plot(t,digita);
% title(['Sinal Quantizado a uma Taxa de ', num2str(b), ' Bits'])
% legend('Sinal de Entrada','Sinal Quantizado')
% xlabel('Tempo')
% ylabel('Tensão')
% % axis([min(t) max(t) min(x)-1 max(x)+1])
% grid on
% 
% subplot(2,1,2);
% plot(t_sample,sinal_digit,'.k');
% title('Erro de Quantização')
% legend('Erro de quantização')
% xlabel('Tempo')
% ylabel('Tensão')
% % axis([min(t) max(t) min(x)-1 max(x)+1])
% grid on





