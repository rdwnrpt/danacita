
import pandas as pd

FILE_PATH = "/Users/ridwan/code/danacita/data/loanbook_onlyforreference.xlsx"
OUTPUT_CSV = "danacita_analytics/seeds/src_loanbook.csv"

# Load file
df = pd.read_excel(FILE_PATH, engine="openpyxl")

df.to_csv(OUTPUT_CSV, index=False)



