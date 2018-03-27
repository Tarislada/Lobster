from sklearn import svm
import numpy as np
import csv
from sklearn.decomposition import PCA
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D



## 데이터 불러오기
columnName = [] # 데이터 명
rawdata = []
with open('GR_EMP.csv', newline='') as datFile:
    reader = csv.reader(datFile, delimiter=',')
    columnName = reader.__next__()
    for row in reader:
        rawdata.append(row)

## 형태에 맞게 parsing
data = np.array(rawdata,dtype='float64')[:,1:]
trainingData_X = data[0:6,:]
trainingData_Y = np.array([1,0,0,1,1,0]) # GR1,4,5 => 1 else => 0

## PCA X
pca = PCA(n_components=3)
pca.fit(data)
Data_x = pca.transform(data)


clabel = [1,0,0,1,1,0,2,2,2,2,2,2,2,2]
# 3d plot
# pca = PCA(n_components=3)

# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')
#
# ax.scatter(Data_x[:,0], Data_x[:,1],Data_x[:,2],c=clabel)

# plt.show()

pca = PCA(n_components=2)
pca.fit(data)
Data_x = pca.transform(data)

fig, ax = plt.subplots()

ax.scatter(Data_x[:,0], Data_x[:,1],c=clabel)
for i, txt in enumerate(clabel):
    ax.annotate(txt,(Data_x[i,0], Data_x[i,1]))
fig.show()


