# Apresentação do Quantizador
Quantizador de Audio. Vai separar o sinal por níveis de tensão, podendo diminuir o custo de memória de um sinal. 

Em audio é um recurso usado para deixar um audio robotizado ou com um carater mais "retrô".

Tem a versão do código em C MATLAB e a versão do código em PYTHON.

Há um arquivo Quantizador.pdf que explica todo o programa. É um mini relatório de quando fiz esse código para o mestrado.


## C Matlab

O arquivo é o "quantizador.m".
A variável responsavel por quantizar o sinal em uma determinada quantidade de bits é a variavel "b" na linha 57.


## Python

O arquivo é o "quantizador.py"
A variável responsavel por quantizar o sinal em uma determinada quantidade de bits é a variavel "b" na linha 36.
Quando mandar rodar o programa, só vai rodar um novo gráfico quando fechar o gráfico atual.


### Fundamentação Teórica

Para descrever uma grandeza analógica de forma computacional é necessário realizar uma conversão de Analógica para Digital, esta conversão é feita por intermédio de um Conversor A/D. O Conversor A/D segue o esquemático da Figura 1, no qual possuímos um sinal de entrada analógico, esse sinal de entrada é amostrado por meio do Amostrador, após amostrado o sinal torna-se analógico em amplitude e discreto no tempo, posterior ao Amostrador existe o Quantizador, no qual é responsável por discretizar o sinal em amplitude, transformando o sinal de entrada analógico num sinal de saída digital.

  Sinal Quantizado(png)
  
  
 O Amostrador é o responsável por discretizar o sinal no tempo, ou
seja, transforma o sinal com infinitos valores no tempo num sinal com
valores finitos no tempo, para obter um sinal finito no tempo o amostrador
pega valores a cada instante igualmente espaçado no tempo, esta etapa é
chamada de amostragem do sinal e a relação de quantidade de amostras por
segundo é dada de acordo com o Teorema de Nyquist-Shannon. O Teorema
diz que um sinal pode ser recuperado desde que a taxa de amostragem seja,
pelo menos, duas vezes maior que a maior frequência do sinal. A Figura 2
ilustra um sinal de entrada analógico em azul e um sinal amostrado em
vermelho. 

Comparativo sinal analógico e sinal amostrado

Após realizada a amostragem do sinal, faz-se necessário realizar a
discretização da amplitude do sinal, esta etapa do conversor A/D dar-se por
intermédio do quantizador, no qual transformar em finitos os números
assumidos na amplitude. Para tal, o quantizador define uma quantidade de
valores possíveis para a amplitude, esses valores são chamados de níveis de
quantização e possui quantidade limitadas de acordo com o número de bits
disponível. A quantidade de níveis é de acordo com a quantidade de valores
que uma determinada quantidade de bits pode representar, por exemplo um
quantizador de 3 bits possui 8 níveis de quantização, enquanto um
quantizador de 8 bits assume um total de 256 níveis de quantização. O
processo de quantização provoca um erro chamado de erro de quantização e quanto menor a quantidade bits maior é o erro de quantização. A Figura 3
ilustra um comparativo entra os sinais analógico, o sinal amostrado e o sinal
digital.


