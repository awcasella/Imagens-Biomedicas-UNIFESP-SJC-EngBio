import cv2
import numpy as np
from scipy.signal import filtfilt
import matplotlib.pyplot as plt

def histogram(I):
	h = np.zeros(256)
	for l in range(I.shape[0]):
		for c in range(I.shape[1]):
			h[I[l,c]] = h[I[l,c]] + 1

	return np.linspace(1, 256, 256), h

eqmn = lambda I, GS: np.sqrt(np.sum((I - GS)**2)/(I.shape[0]*I.shape[1]))
emax = lambda I, GS: np.max(np.abs(I - GS))
covar = lambda I, GS: (1/(I.shape[0]*I.shape[1]))*np.sum((I - np.mean(I))*(GS - np.mean(GS)))
Q = lambda I, GS: (covar(I, GS)/((np.std(I))*(np.std(GS))))*((2*np.mean(I)*np.mean(GS))/(np.mean(I)**2 + np.mean(GS)**2))*((2*np.std(I)*np.std(GS))/(np.std(I)**2 + np.std(GS)**2))


I = cv2.imread('ImComRuido.pgm', 0)
GS = cv2.imread('ImSemRuido.pgm', 0)

Original = I.copy()

x1, h1 = histogram(I)

tam = 3
for lin in range(I.shape[0]):
	I[lin, :] = filtfilt(np.ones(tam)/tam, 1, I[lin, :])

for col in range(I.shape[1]):
	I[:, col] = filtfilt(np.ones(tam)/tam, 1, I[:, col])


I = cv2.blur(I, (9,9))
I = cv2.medianBlur(I, 5)
x2, h2 = histogram(I)


plt.figure()
plt.subplot(1,2,1)
plt.plot(x1, h1, 'g')
plt.plot(x2, h2, 'r')
plt.subplot(1,2,2)
plt.imshow(I, plt.cm.gray)
plt.show()



e1, e2, e3 = eqmn(I, GS), emax(I, GS), Q(I, GS)

print('Para a imagem Filtrada: \n\nO erro eqmn eh: {} \nO erro max eh: {} \nO erro Q eh: {}\n\n'.format(e1, e2, e3))

e1, e2, e3 = eqmn(Original, GS), emax(Original, GS), Q(Original, GS)

print('Para a imagem Original: \n\nO erro eqmn eh: {} \nO erro max eh: {} \nO erro Q eh: {}\n\n'.format(e1, e2, e3))

e1, e2, e3 = eqmn(GS, GS), emax(GS, GS), Q(GS, GS)

print('Calibrando: \n\nO erro eqmn eh: {} \nO erro max eh: {} \nO erro Q eh: {}'.format(e1, e2, e3))