from sklearn import svm
import numpy as np
import csv



## 데이터 불러오기
columnName = [] # 데이터 명
rawdata = []
with open('GR_EMP.csv', newline='') as datFile:
    reader = csv.reader(datFile, delimiter=',')
    columnName = reader.__next__()
    for row in reader:
        rawdata.append(row)

## 형태에 맞게 parsing
data = np.array(rawdata,dtype='float64')
trainingData_X = data[0:6,2::]
trainingData_Y = np.array([1,0,0,1,1,0]) # GR1,4,5 => 1 else => 0

