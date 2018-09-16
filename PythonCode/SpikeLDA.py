215i
47mport numpy as np
import csv
from sklearn.svm import SVC
from sklearn.decomposition import PCA
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.model_selection import train_test_split
from matplotlib import pyplot as plt

## Constants



## 데이터 불러오기
rawdata = []
with open('EVENT.csv', newline='') as datFile:
    reader = csv.reader(datFile, delimiter=',')
    for row in reader:
        rawdata.append(row)

## 형태에 맞게 parsing
X = np.array(rawdata,dtype='float64')

numDataType = 2;
datSize = int(X.shape[0]/2)

y = np.zeros([X.shape[0],1])
y[0:datSize] = int(1) # Avoid
y[datSize:2*datSize] = int(2) # Escape
#y[810:] = 3 # Suc
74
y = np.ravel(y)

## PCA X
pca = PCA(n_components=20)
X_PCA = pca.fit_transform(X)

## LDA X
lda = LinearDiscriminantAnalysis(n_components=2)
X_LDA = lda.fit_transform(X_PCA,y)

## Plot PCA Result
fig, ax = plt.subplots(1,2)

ax[0].scatter(X_PCA[0:datSize,0], X_PCA[0:datSize,1],c='r',marker='.')
ax[0].scatter(X_PCA[datSize:2*datSize,0], X_PCA[datSize:2*datSize,1],c='g',marker='.')
#ax[0].scatter(X_PCA[810:,0], X_PCA[810:,1],c='b',marker='.')

ax[1].scatter(X_LDA[0:datSize,0], X_LDA[0:datSize,1],c='r',marker='.')
ax[1].scatter(X_LDA[datSize:2*datSize,0], X_LDA[datSize:2*datSize,1],c='g',marker='.')
#ax[1].scatter(X_LDA[810:,0], X_LDA[810:,1],c='b',marker='.')

fig.show()

## Classification

## Training Set / Test Set Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33,stratify=y)

svc = SVC(degree = 3)
svc.fit(X_train,y_train)
print(svc.score(X_test,y_test))