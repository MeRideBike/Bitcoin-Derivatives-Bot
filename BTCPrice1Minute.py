import http.client
import pandas as pd
import json

conn = http.client.HTTPSConnection("api.coinbase.com")
conn.request("GET", "/api/v3/brokerage/market/products/BTC-USD/candles?granularity=ONE_MINUTE&limit=350", '', {'Content-Type': 'application/json'})
res = conn.getresponse()
data = res.read()

response_json = json.loads(data.decode("utf-8"))

if 'candles' in response_json:
    df = pd.DataFrame(response_json["candles"])

    # Convert numerical columns to float for calculations
    numeric_cols = ['open', 'high', 'low', 'close']
    df[numeric_cols] = df[numeric_cols].astype(float)

    # Convert timestamp to datetime object
    df['Timestamp'] = pd.to_datetime(df['start'].astype(int), unit='s').dt.tz_localize('UTC').dt.tz_convert('US/Eastern')

    # Sort dataframe chronologically (oldest first)
    df.sort_values(by='Timestamp', ascending=False, inplace=True)

    # Calculate percentage changes
    #pct_change = df[numeric_cols].pct_change().abs()

    # Keep rows where ANY of the price columns changed by >= 0.1%
    #significant_change_mask = pct_change.ge(0.01).any(axis=1)
    #significant_change_mask.iloc[0] = True  # Include first row

    # Filter dataframe
    #df_filtered = df[significant_change_mask].copy()

    # Calculate absolute and percentage change in Close price
    #df_filtered['$ Change'] = df_filtered['close'].diff().round(0).fillna(0).map(lambda x: f"${x:,.0f}")
    #df_filtered['% Change'] = df_filtered['close'].pct_change().mul(100).round(2).fillna(0).map(lambda x: f"{x}%")

    # Format timestamp after filtering
    df['Timestamp'] = df['Timestamp'].dt.strftime('%m-%d-%y %I:%M%p')

    # Formatting numerical columns after filtering
    for col in numeric_cols:
        df[col.capitalize()] = df[col].round(0).astype(int).map(lambda x: f"${x:,}")

    df['Volume'] = df['volume'].astype(float).round(2)

    # Final selection and renaming of columns
    df = df[['Timestamp', 'Open', 'High', 'Low', 'Close', 'Volume']]

    # Display filtered DataFrame
    print(df.reset_index(drop=True))

    # Save filtered DataFrame to file
    with open("BTCPrettyPrice1Min.txt", "a") as f:
        f.write(df.reset_index(drop=True).to_string(index=False) + "\n")
else:
    print("No candle data found in response.")
