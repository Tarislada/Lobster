import numpy as np
import csv
from sklearn.svm import SVC
from sklearn.decomposition import PCA
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.model_selection import train_test_split
from matplotlib import pyplot as plt


## 데이터 불러오기
rawdata = []
with open('AES.csv', newline='') as datFile:
    reader = csv.reader(datFile, delimiter=',')
    columnName = reader.__next__()
    for row in reader:
        rawdata.append(row)

## 형태에 맞게 parsing
X = np.array(rawdata,dtype='float64')
y = np.zeros([948,1])
y[0:405] = 1 # Avoid
y[405:810] = 2 # Escape
y[810:] = 3 # Suc

y = np.ravel(y)

## PCA X
pca = PCA(n_components=20) # 2차원으로 분류
X_PCA = pca.fit_transform(X)

## LDA X
lda = LinearDiscriminantAnalysis()
X_LDA = lda.fit_transform(X_PCA,y)

## Plot PCA Result
fig, ax = plt.subplots(1,2)

ax[0].scatter(X_PCA[0:405,0], X_PCA[0:405,1],c='r',marker='.')
ax[0].scatter(X_PCA[405:810,0], X_PCA[405:810,1],c='g',marker='.')
ax[0].scatter(X_PCA[810:,0], X_PCA[810:,1],c='b',marker='.')

ax[1].scatter(X_LDA[0:405,0], X_LDA[0:405,1],c='r',marker='.')
ax[1].scatter(X_LDA[405:810,0], X_LDA[405:810,1],c='g',marker='.')
ax[1].scatter(X_LDA[810:,0], X_LDA[810:,1],c='b',marker='.')

fig.show()

## Classification

## Training Set / Test Set Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33,stratify=y)

svc = SVC(degree = 3)
svc.fit(X_train,y_train)
print(svc.score(X_test,y_test))