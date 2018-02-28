import csv
import pandas as pd
import numpy as np
from sklearn import metrics
from sklearn import tree
from sklearn import preprocessing
from sklearn.cross_validation import train_test_split


x_ = np.loadtxt('features.csv', delimiter = ",")
y_ = np.loadtxt('onehotLabels.csv', delimiter = ",")

train_x, test_x, train_y, test_y = train_test_split(x_, y_, test_size = 0.3)

###
clf = tree.DecisionTreeClassifier()
dt_clf = clf.fit(train_x, train_y)
test_y_predict = dt_clf.predict(test_x)

acc = metrics.accuracy_score(test_y, test_y_predict)
print acc
