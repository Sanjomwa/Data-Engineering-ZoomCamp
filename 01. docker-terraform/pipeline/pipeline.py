import sys
import pandas as pd
df = pd.DataFrame({'day': [1,2], 'num_passengers': [3,4]})
month = int(sys.argv[1])
df['month'] = month
print(df.head())
print("Arguments passed to the pipeline:", sys.argv)
print(f"Pipeline module loaded successfully., month={month}")
df.to_parquet(f"output_{month}.parquet")
print(f'Data saved to output, month={month}')