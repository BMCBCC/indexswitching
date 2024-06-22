import pandas as pd
import sys

InFileName=sys.argv[1]

def create_frequency_matrix_from_text(file_path):
    # Read tab-delimited plain text table into a DataFrame
    df = pd.read_csv(file_path, delimiter='\t',header=None)
    
    # Combine the words from two columns into pairs
    pairs = df.apply(lambda x: (x[0], x[1]), axis=1)
    
    # Count the frequency of each pair
    pair_counts = pairs.value_counts()
    
    # Extract unique words
    unique_words_column1 = sorted(df.iloc[:, 0].unique())
    unique_words_column2 = sorted(df.iloc[:, 1].unique())
    
    # Create an empty frequency matrix table
    frequency_matrix = pd.DataFrame(index=unique_words_column1, columns=unique_words_column2)
    frequency_matrix = frequency_matrix.fillna(0)
    
    # Populate the frequency matrix table with pair frequencies
    for pair, count in pair_counts.items():
        word1, word2 = pair
        frequency_matrix.loc[word1, word2] = count
    
    return frequency_matrix

# Example usage:
file_path = InFileName  # Provide the path to your tab-delimited plain text file

frequency_matrix = create_frequency_matrix_from_text(file_path)

df = pd.DataFrame(frequency_matrix)

excel_file_path = 'barcode_freq_matrix.xlsx'

df.to_excel(excel_file_path, index=True)

print(f"Matrix has been written to {excel_file_path}")
