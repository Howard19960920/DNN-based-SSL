#This program will apply onehot encode on the labels, and produce another CSV file called onehotLables.csv


import csv
import numpy as np
from numpy import array
from numpy import argmax
from keras.utils import to_categorical



ret = np.loadtxt('labels.csv', delimiter =',')

encoded = to_categorical(ret)
encoded = np.delete(encoded, [0], 1)

with open('onehotLabels.csv', 'w') as f:
  w = csv.writer(f)
  w.writerows(encoded)

