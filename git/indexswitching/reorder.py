import pandas as pd

# Step 1: Read the barcode file to get the desired order of rows and columns
order_file = 'ilab_barcodes_clean'
with open(order_file, 'r') as file:
    order = [line.strip().upper().split() for line in file]

# Extract row and column order from the list of tuples
row_order = [item[0] for item in order]
column_order = [item[1] for item in order]

# Step 2: Read the Excel file into a DataFrame
excel_file = 'barcode_freq_matrix.xlsx'
#df = pd.read_excel(excel_file)
df = pd.read_excel(excel_file,header=0,index_col=0)

# Ensure the row and column orders are valid
missing_rows = set(row_order) - set(df.index.str.upper())
missing_cols = set(column_order) - set(df.columns.str.upper())

if missing_rows:
    print(f"Warning: Missing rows in the data: {missing_rows}")
if missing_cols:
    print(f"Warning: Missing columns in the data: {missing_cols}")

# Filter out any invalid rows or columns
valid_row_order = [row for row in row_order if row in df.index.str.upper()]
valid_column_order = [col for col in column_order if col in df.columns.str.upper()]

# Adjust the DataFrame to have uppercased index and columns for comparison
df.index = df.index.str.upper()
df.columns = df.columns.str.upper()

# Step 3: Reorder the DataFrame
df_reordered = df.loc[valid_row_order, valid_column_order]

# Step 4: Write the reordered DataFrame back to an Excel file
output_file = 'reordered_data.xlsx'
df_reordered.to_excel(output_file, index=True)
