import re
import numpy
import matplotlib.pyplot as plt
from scipy import signal
import numpy as np
import cv2
from scipy.signal import filtfilt

""" This script contains all methods in one file. """


def read_pgm(filename, byteorder='>'):
    """Return image data from a raw PGM file as numpy array.

    Format specification: http://netpbm.sourceforge.net/doc/pgm.html

    """
    with open(filename, 'rb') as f:
        buffer = f.read()
    try:
        header, width, height, maxval = re.search(
            b"(^P5\s(?:\s*#.*[\r\n])*"
            b"(\d+)\s(?:\s*#.*[\r\n])*"
            b"(\d+)\s(?:\s*#.*[\r\n])*"
            b"(\d+)\s(?:\s*#.*[\r\n]\s)*)", buffer).groups()
    except AttributeError:
        raise ValueError("Not a raw PGM file: '%s'" % filename)
    return numpy.frombuffer(buffer, dtype='u1' if int(maxval) < 256 else byteorder+'u2',
                            count=int(width)*int(height), offset=len(header)).reshape((int(height), int(width)))


def gradient(I, tipo = 'sobel' : str):
    """ Compute the gradient of an image using either sobel or prewitt method using a 3x3 method"""

    # Defining kernels
    xsobel = np.array([[-1, 0, 1],[-2, 0, 2],[-1, 0, 1]])
    ysobel = xsobel.T
    xprewitt = np.array([[-1, 0, 1],[-1, 0, 1],[-1, 0, 1]])
    yprewitt = xprewitt.T

    if tipo.lower() == 'sobel':
        delfdelx = signal.convolve2d(I, np.rot90(xsobel,2), mode='valid')
        delfdely = signal.convolve2d(I, np.rot90(ysobel,2), mode='valid')
    elif tipo.lower() == 'prewitt':
        delfdelx = signal.convolve2d(I, np.rot90(xprewitt,2), mode='valid')
        delfdely = signal.convolve2d(I, np.rot90(yprewitt,2), mode='valid')
    return np.sqrt(delfdely**2 + delfdelx**2)

def laplacian(I, tipo = 'torre' : str):
	""" Computes the laplacian of an image using either one of two options for kernel """

	# Defining kernels
	torre = np.array([[0, 1, 0],[1, -4, 1],[0, 1, 0]])
	dama = np.array([[1, 1, 1],[1, -8, 1],[1, 1, 1]])
	if tipo.lower() == 'torre':
        result = signal.convolve2d(I, np.rot90(torre,2), mode='valid')
    elif tipo.lower() == 'dama':
        result = signal.convolve2d(I, np.rot90(dama,2), mode='valid')
    return result

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


def avaliaSegmentacao(I, GS):
	""" Evaluates segmentation accordingly to a gold standard """
	inter = I*GS
	
	VP = (sum(sum(inter))/sum(sum(GS)))*100
	FP = ((I - inter)/GS)*100
	FN = ((GS - inter)/GS)*100

	OD = (200*VP)/(2*VP + FP + FN)
	OR = (100*VP)/(VP + FP + FN)

	return OR, OD, VP, FP, FN

def histogram(I):
	""" Computes Histogram of a given image """
	h = np.zeros(256)
	for l in range(I.shape[0]):
		for c in range(I.shape[1]):
			h[I[l,c]] = h[I[l,c]] + 1

	return np.linspace(1, 256, 256), h


# Root Mean Square Error
eqmn = lambda I, GS: np.sqrt(np.sum((I - GS)**2)/(I.shape[0]*I.shape[1]))

# Maximum Error
emax = lambda I, GS: np.max(np.abs(I - GS))

# Quality Factor
covar = lambda I, GS: (1/(I.shape[0]*I.shape[1]))*np.sum((I - np.mean(I))*(GS - np.mean(GS)))
Q = lambda I, GS: (covar(I, GS)/((np.std(I))*(np.std(GS))))*((2*np.mean(I)*np.mean(GS))/(np.mean(I)**2 + np.mean(GS)**2))*((2*np.std(I)*np.std(GS))/(np.std(I)**2 + np.std(GS)**2))
