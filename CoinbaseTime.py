import http.client
import json

conn = http.client.HTTPSConnection("api.coinbase.com")
payload = ''
headers = {
  'Content-Type': 'application/json'
}
conn.request("GET", "/api/v3/brokerage/time", payload, headers)
res = conn.getresponse()
data = res.read()

with open("output.txt", "a") as f:
  print("Time: " + data.decode("utf-8"), file=f)
