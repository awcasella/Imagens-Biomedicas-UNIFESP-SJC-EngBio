import re
import numpy
import matplotlib.pyplot as plt
from scipy import signal
import numpy as np
import cv2
from scipy.signal import filtfilt


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

def histogram(I):
	""" Computes Histogram of a given image """
	h = np.zeros(256)
	for l in range(I.shape[0]):
		for c in range(I.shape[1]):
			h[I[l,c]] = h[I[l,c]] + 1

	return np.linspace(1, 256, 256), h

