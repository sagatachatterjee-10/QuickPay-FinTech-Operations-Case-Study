# Spreadsheet Answers

## Cleaning Steps
1. Loaded transactions_raw.csv, merchant_master.csv, and exchange_rates.csv.
2. Standardized merchant names by stripping spaces and applying title case.
3. Standardized status values by converting to lowercase, stripping spaces, and mapping to standard values (captured, failed, chargeback).
4. Cleaned risk_score by extracting numeric values from strings like "score:62" or "risk-83".
5. Standardized gateway_region by stripping spaces and converting to uppercase.
6. Converted transaction_date to datetime format.
7. Converted all amounts to USD using exchange_rates.csv by merging on date and currency.
8. Enriched data by merging with merchant_master.csv on standardized merchant_name.
9. Added high_value_flag based on region and amount_usd thresholds.
10. Added high_risk_flag based on risk_score >= 70 or status containing 'chargeback'.

## Standardization Rules
- Merchant names: Strip spaces, title case.
- Status: Lowercase, strip, map 'failed e05 timeout' to 'failed'.
- Risk score: Extract integer from prefixed strings.
- Gateway region: Strip, uppercase.
- Dates: Parse to datetime.

## Lookup and Enrichment Logic
- Used pandas merge to join transactions with exchange_rates on transaction_date and currency.
- Used pandas merge to join transactions with merchants on merchant_name after standardization.

## Final Answers
- Total raw rows: 30
- Total cleaned rows: 30
- Invalid/missing rows handled: 45
- Top region by GMV: APAC
- Number of high value transactions: 6
- Number of high risk transactions: 9
- Top merchant by captured GMV: Alpha Mart

## Formula Samples
- Amount USD: =raw_amount * VLOOKUP(currency & date, exchange_rates, usd_rate)
- High value flag: =IF(AND(region="APAC", amount_usd>5000), 1, IF(AND(region="EU", amount_usd>6000), 1, IF(AND(region="US", amount_usd>7000), 1, 0)))
- High risk flag: =IF(OR(risk_score>=70, status="chargeback"), 1, 0)