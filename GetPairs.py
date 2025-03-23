import http.client
import json
import pandas as pd

conn = http.client.HTTPSConnection("api.coinbase.com")
conn.request("GET", "/api/v3/brokerage/market/products?product_type=SPOT&product_ids=BTC-USD&product_ids=ETH-USD&products_sort_order=PRODUCTS_SORT_ORDER_LIST_TIME_DESCENDING", '', {'Content-Type': 'application/json'})

res = conn.getresponse()
data = res.read()

response_json = json.loads(data.decode("utf-8"))
df = pd.DataFrame(response_json)



print(df)

# Save filtered DataFrame to file
with open("RecentPairs.txt", "a") as f:
	f.write(df.reset_index(drop=True).to_string(index=False) + "\n")