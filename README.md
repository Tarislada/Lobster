# Lobster

Lobster Bot 실험 관련 코드
마지막 업데이트 : 2018-02-07 17:51(GMT+9) 
# Files
## functions
**locationParser** : XYXY.csv 데이터를 읽어와서 위치를 출력. (recoverLocData 포함)
**recoverLocData** : 위치 parsing 중에 tracking이 끊긴 곳을 보정해줌.
**getHeadDegree** : 이전 위치에 기반해서 현재 머리가 있는 방향, 혹은 움직이는 방향을 추정함.
**createGaussianHitmap** : 가우시안 히트맵을 생성. (parallel toolbox 업데이트 적용함)
**drawmap** : 원래는 **createGaussianHitmap** 과 함께 사용했지만 연산이 오래걸리기에 그래프 그리는 파트만 따로 뺌.
**firedLocationParser** : .txt 파일을 읽어서 뉴런이 fire 한 곳의 데이터를 출력.
## scripts
**Lobster_script** : 위 기능을 모두 사용할 수 있는 스크립트 파일. 기능별로 구간을 나눠둠.
