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


## Feature Selection
# skb = SelectKBest(mutual_info_classif, k=12)
# skb.fit(X[:6,:],Y[:6])
# X = skb.transform(X)


## PCA X
pca = PCA(n_components=2) # 2차원으로 분류
pca.fit(X)
X_PCA = pca.transform(X)

## Plot PCA Result
fig, ax = plt.subplots()

ax.scatter(X_PCA[:,0], X_PCA[:,1],c=Y)
for i, txt in enumerate(Y):
    ax.annotate(i+1,(X_PCA[i,0], X_PCA[i,1]))
fig.suptitle('PCA result')

## SVM
clf_raw = SVC(probability=True)
# clf_raw.fit(X[:6,:],Y[:6])
clf_raw.fit(X[:6,:],Y[:6])
print(clf_raw.predict(X))
print(clf_raw.score(X[:6,:], Y[:6]))

result = clf_raw.predict_proba(X)

for gr, prob in enumerate(result[:,0]):
    if prob > 0.5:
        star = '***'
    else:
        star = ''
    print('GR'+str(gr+1)+' : P("GR145"st) = %.3f' %prob + star)

plt.show()

## Plot Decision Regions
#plot_decision_regions_PCA(X_PCA, Y, clf_raw, pca)
