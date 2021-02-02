# -*- coding: utf-8 -*-
"""
Created on Tue Sep 18 21:59:14 2018

@author: Arthur Medeiros Guimarães
"""

import numpy as np
import scipy
import matplotlib . pyplot as plt



"""
Sinal de Entrada
"""

fs= 1e-3; #tempo de amostragem
t=  np.arange(-5, 5+fs, fs); #tempo do sinal
x=  2*np.sin(t); #sinal de entrada

plt.plot(t,x)
plt.title (" Sinal de Entrada ")
plt.ylabel (" Amplitude do Sinal ") 
plt.xlabel (" Tempo ") 
plt.grid ("on")
plt.show()



"""
Caracteristicas de Quantização
"""

PP=max(x)-min(x); #Picoa Pico do Sinal
b=3; #Quantidade de Bits do Sinal
L=2**b; #Quantidade de Niveis de Quantização
v= PP/L; #Largura de Niveis de Quantização
n= np.arange(min(x),max(x)+v,v); #Niveis de quantização
q_t= np.arange(min(x)-(v/2),max(x)+(v),v); #Tempo de quantização, espaçamento horizontal da quantização com um off_set para ajustar o posicionamento na posição (0,0)
q_t[0]= q_t[0]+(v/2); #Eliminando o off_set aplicado na linha 39 para o primeiro elemento do array
q_t[-1]= q_t[-1]-(v/2); #Eliminando o off_set aplicado na linha 39 para o primeiro elemento do array



"""
Digitalização do Sinal
"""

digita= np.zeros(len(x));

for i in range (len(x)):
    for j in range (L):
        if x[i]>=n[j] and x[i]<=n[j+1]:
            digita[i]=n[j]
            


"""
Plot do Sinal de Entrada e do Sinal Digitalizado
"""

plt.plot(t,x)
plt.plot(t,digita)
plt.title ('Sinal Quantizado a uma Taxa de % bits ')
plt.ylabel (" Amplitude do Sinal ") 
plt.xlabel (" Tempo ") 
plt.grid ("on")
plt.show()



"""
Teorema de Nyquist–Shannon
"""

fs_sample=fs*2;
t_sample=np.arange(min(t),max(t),fs_sample);
amostragem= fs_sample/fs;
sinal_digit= digita[::int(amostragem)]



"""
Plot do Sinal Digital Utilizando o teorema de Nyquist–Shannon
"""

plt.plot(t,x)
plt.plot(t_sample,sinal_digit)
plt.title ('Sinal Digitalizado a uma Taxa de % bits ')
plt.ylabel (" Amplitude do Sinal ") 
plt.xlabel (" Tempo ") 
plt.grid ("on")
plt.show()



