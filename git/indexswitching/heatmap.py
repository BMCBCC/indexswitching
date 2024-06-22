import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Read the Excel file with row and column headers
excel_file_path = 'reordered_data.xlsx'
df = pd.read_excel(excel_file_path, index_col=0)

# Calculate the sum of each row and each column
row_sums = df.sum(axis=1)
col_sums = df.sum(axis=0)

# Create a new DataFrame to store the adjusted values
adjusted_df = df.copy()

# Adjust each value by dividing by the average of the corresponding row and column sum
for i in df.index:
    for j in df.columns:
        adjusted_value = df.loc[i, j] / ((row_sums[i] + col_sums[j]) / 2)
        adjusted_df.loc[i, j] = adjusted_value



# Take the logarithm of the adjusted values
adjusted_df = adjusted_df.where(df >= 0.01, 0.01)
log_adjusted_df = -1*np.log(adjusted_df)

# Create another heatmap
plt.figure(figsize=(10, 8))
sns.heatmap(log_adjusted_df, annot=True, fmt=".2f", cmap='viridis')
plt.title('-log(count/mean(rowsum+colsum))')
plt.savefig("barcode_heatmap.jpg", format='jpg')
plt.show()

