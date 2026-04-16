import pandas as pd

FILE_PATH = "data/fx rate data (updated every EOM).xlsx"
OUTPUT_CSV = "danacita_analytics/seeds/src_fx_rate_cleaned.csv"

# Load file
df = pd.read_excel(FILE_PATH, header=None, engine="openpyxl")

# Remove empty rows and columns
df = df.dropna(how="all").dropna(axis=1, how="all")

# Set first row as header
df.columns = df.iloc[0]
df = df.iloc[1:].reset_index(drop=True)

# Rename first column to label
df = df.rename(columns={df.columns[0]: "label"})

# Remove unwanted columns
df = df.drop(columns=["FY2024"], errors="ignore")

# Create rate_type column
df["rate_type"] = (
    df["label"]
    .where(df["label"].isin(["Closing rate", "Average rate"]))
    .ffill()
)

# Remove section rows
df = df[~df["label"].isin(["Closing rate", "Average rate"])]

df = df.rename(columns={"label": "currency"})

# Reshape to long format
df_clean = df.melt(
    id_vars=["rate_type", "currency"],
    var_name="date",
    value_name="value"
)

# Convert types and remove empty values
df_clean["date"] = pd.to_datetime(df_clean["date"], errors="coerce")
df_clean = df_clean.dropna(subset=["date", "value"])

df_clean["value"] = pd.to_numeric(df_clean["value"])

# Save result
df_clean.to_csv(OUTPUT_CSV, index=False)