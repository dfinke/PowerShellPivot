import pandas as pd

data = pd.read_csv('TempAndHumidity.csv')

# pivot = pd.pivot_table(data, index='date', aggfunc=[min, max])
pivot = pd.pivot_table(data, index='date')
# pivot = pd.pivot_table(data, index='date', columns='city')
# pivot = pd.pivot_table(data, index='city', columns='date')
print(pivot)
