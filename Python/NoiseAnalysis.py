import numpy as np

def avaliaSegmentacao(I, GS):
	""" Evaluates segmentation accordingly to a gold standard """
	inter = I*GS
	
	VP = (sum(sum(inter))/sum(sum(GS)))*100
	FP = ((I - inter)/GS)*100
	FN = ((GS - inter)/GS)*100

	OD = (200*VP)/(2*VP + FP + FN)
	OR = (100*VP)/(VP + FP + FN)

	return OR, OD, VP, FP, FN

# Root Mean Square Error
eqmn = lambda I, GS: np.sqrt(np.sum((I - GS)**2)/(I.shape[0]*I.shape[1]))

# Maximum Error
emax = lambda I, GS: np.max(np.abs(I - GS))

# Quality Factor
covar = lambda I, GS: (1/(I.shape[0]*I.shape[1]))*np.sum((I - np.mean(I))*(GS - np.mean(GS)))
Q = lambda I, GS: (covar(I, GS)/((np.std(I))*(np.std(GS))))*((2*np.mean(I)*np.mean(GS))/(np.mean(I)**2 + np.mean(GS)**2))*((2*np.std(I)*np.std(GS))/(np.std(I)**2 + np.std(GS)**2))
