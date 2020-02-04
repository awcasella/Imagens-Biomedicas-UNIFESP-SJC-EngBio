import re
import numpy
import matplotlib.pyplot as plt
from scipy import signal
import numpy as np
import cv2
from scipy.signal import filtfilt


def movingAverage(I, n):
	""" Creates a nxn kernel filled with ones to perform a arithmetic moving average """
	kernel = np.ones(n)
	result = signal.convolve2d(I, kernel, mode='valid')
	return result

def gaussianMean(mu, sigma, n):
	""" Creates a nxn kernel following a gaussian distribution with mean=mu and std=sigma """
	x = np.linspace(mu - (n-1)/2, mu + (n-1)/2, n)
	g = np.array([(1/(np.sqrt(2*np.pi*sigma**2)))*np.exp(-0.5*(x - mu)*(x - mu)*(1/(sigma**2)))])
	kernel = g.T.dot(g)
	kernel = kernel/np.sum(kernel)
	return kernel

def gradient(I, tipo : str = 'sobel'):
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

def laplacian(I, tipo : str = 'torre'):
	""" Computes the laplacian of an image using either one of two options for kernel """

	# Defining kernels
	torre = np.array([[0, 1, 0],[1, -4, 1],[0, 1, 0]])
	dama = np.array([[1, 1, 1],[1, -8, 1],[1, 1, 1]])
	if tipo.lower() == 'torre':
		result = signal.convolve2d(I, np.rot90(torre,2), mode='valid')
	elif tipo.lower() == 'dama':
		result = signal.convolve2d(I, np.rot90(dama,2), mode='valid')
	return result
