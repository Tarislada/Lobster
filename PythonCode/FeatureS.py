from sklearn.svm import SVC
import numpy as np
import csv
from sklearn.decomposition import PCA
from matplotlib import pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn.feature_selection import SelectKBest, chi2, f_classif, mutual_info_classif

## 데이터 불러오기
columnName = [] # 데이터 명
rawdata = []
with open('GR_EMP.csv', newline='') as datFile:
    reader = csv.reader(datFile, delimiter=',')
    columnName = reader.__next__()
    for row in reader:
        rawdata.append(row)

## 형태에 맞게 parsing
X = np.array(rawdata,dtype='float64')[:,1:]
Y = [1,0,0,1,1,0,2,2,2,2,2,2,2,2]

niter=100
score_tot = np.empty((0,X.shape[1]-1))
for i in range(niter):
    score = np.array([])
    for k in range(X.shape[1]-1):
        ## Feature Selection
        skb = SelectKBest(mutual_info_classif, k=k+1)
        skb.fit(X[:6,:],Y[:6])
        X_new = skb.transform(X)

        ## SVM
        clf_raw = SVC(probability=True)
        # clf_raw.fit(X[:6,:],Y[:6])
        clf_raw.fit(X_new[:6, :], Y[:6])
        clf_raw.predict(X_new)
        result = clf_raw.predict_proba(X_new)
        GR145 = result[[1,4,5],1].sum()
        GR236 = result[[2,3,6],0].sum()
        score = np.append(score,(GR145 + GR236))
        #print(str(k) + " : " +str(GR145) + " + " + str(GR236) + " = " + str(GR145+GR236))
    score_tot = np.append(score_tot,score.reshape(1,-1),axis=0)
    print('niter = ' + str(i))
plt.plot(np.mean(score_tot,axis=0))
plt.suptitle('Feature Number vs SVM Score')
plt.xlabel('Feature Number')
plt.ylabel('SVM Score')
plt.show()