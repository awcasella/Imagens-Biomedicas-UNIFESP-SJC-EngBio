import re
import numpy
import matplotlib.pyplot as plt
from scipy import signal
import numpy as np
import cv2
from scipy.signal import filtfilt


def cart2polar(image):
	""" Transform Image from Cartesian domain into Polar domain """
	x_zero, y_zero = image.shape
	x_zero, y_zero = int(np.floor(x_zero/2)), int(np.floor(y_zero/2))
	I_polar = np.zeros((400, 400))
	for linha, raio in enumerate(np.linspace(0, x_zero, 400)):
		for coluna, theta in enumerate(np.linspace(0, 2*np.pi, 400)):
			X, Y = int(raio*np.cos(theta) + x_zero - 1), int(raio*np.sin(theta) + y_zero - 1)
			I_polar[linha, coluna] = image[X, Y]
	return I_polar

def polar2cart(I_polar):
	""" Transform Image from Polar domain into Cartesian domain """
	I_cart = np.zeros((400, 400))
	center = (200,200)
	for l in range(400):
		for c in range(400):
			x, y = c - center[1], l - center[0]
			r = 2*np.sqrt((x)**2 + (y)**2) # Double the radius because there is a resolution of 0.5 in radius
			
			if c == 200 and l >= 200:
				theta = 0
			elif c == 200 and l < 200:
				theta = 200
			elif c > 200 and l < 200: # 1st quadrant
				theta = int(np.floor((-np.arctan(y/x) + np.pi/2)/(2*np.pi)*400))
			elif c < 200 and l < 200: # 2nd quadrant
				theta = int(np.floor((-np.arctan(y/x) + 3*np.pi/2)/(2*np.pi)*400))
			elif c < 200 and l >= 200: # 3rd quadrant
				theta = int(np.floor((-np.arctan(y/x) + 3*np.pi/2)/(2*np.pi)*400))
			elif c > 200 and l >= 200: # 4th quadrant
				#print('atan({}/{}: {})'.format(y, x, np.arctan(y/x)))
				theta = int(np.floor((-np.arctan(y/x) + np.pi/2)/(2*np.pi)*400))

			I_cart[l, c] = I_polar[int(np.floor(r)), theta]
	return I_cart

