# RetailPulse: Regional Retail Chain Performance & Inventory Analysis

## Business Problem

A retail chain ("Kavin Mart") runs 10 stores across Tamil Nadu. Some stores do much better than others, even though they work the same way. The Regional Manager wants to know: **which stores and product types actually make the most profit, and does poor stock management make things worse?**

## Stakeholders

- Regional Operations Manager — in charge of overall performance
- Store Managers — handle day-to-day decisions at each store
- Inventory/Procurement Lead — decides stock levels and reordering

## Dataset

I built this dataset myself to act like real retail data, including real-looking problems on purpose (mixed-up date formats, missing values, duplicate rows, and genuine product returns). I built it from scratch because no public dataset had this exact setup — 4 connected tables (stores, products, transactions, inventory). The full reasoning is in the `/sql` and `/notebooks` folders.

**Tables:**
- `stores` — 10 stores across Tamil Nadu cities (location, size, area type)
- `products` — 114 products across 6 categories
- `sales_transactions` — around 16,000 sales
- `inventory_snapshots` — weekly stock counts per store/product

## Methodology

1. **Data Cleaning (Excel + Python/Pandas)** — I checked all 4 tables for mixed-up dates, missing values, and duplicates. When `qty` or `revenue` was missing, I calculated it using the formula `revenue = qty × price`, instead of guessing or just deleting the row. One missing product price was worked out using the average profit margin of similar products. Returns (negative-revenue rows) were kept separate from normal sales, not mixed in silently.

2. **Statistics (Python)** — I calculated average revenue per store, how much that revenue varies, and built a 95% confidence range for each store. This helped tell which stores are *really* different, versus which differences could just be random chance. I also checked if store size and average sale value are related.

3. **SQL (PostgreSQL)** — I answered business questions using joins, grouping, subqueries, and date filtering. I hit a bug while comparing sales and returns — traced it back to the real cause (returns and sales never share the same transaction ID, by design) and fixed it by summarizing each table separately before joining them.

4. **Charts (Matplotlib)** — I made 4 charts, each tied to a real finding: store revenue with confidence ranges, store size vs. revenue, monthly revenue trend, and revenue by category.

## Tools Used

Excel (lookups, pivot tables) · Python (Pandas, NumPy, Matplotlib) · PostgreSQL · Git/GitHub

## Key Findings

1. **Store ST006 is genuinely the top performer, not just lucky** — its confidence range doesn't overlap with most other stores, so this is a real pattern, not noise. Store ST004 is genuinely the weakest. The stores in the middle (ST001, ST008, ST009, ST003, ST002, ST005) overlap with each other too much to confidently rank them.

2. **Smaller stores tend to have higher average sale values** (correlation = -0.53). This is worth digging into further — it doesn't yet prove *why*.

3. **Grocery and Beverages bring in the most revenue**, more than all other categories combined.

4. **September earned about 22% more than a typical month**, suggesting a real seasonal bump — but see the limitation below.

## Business Recommendations

- Look into what ST006 and ST004 are doing differently (staffing, local marketing, stock levels) — this gap is confirmed real, not random, so it's worth understanding and possibly repeating or fixing.
- Make sure Grocery and Beverages are well-stocked and promoted across all stores, since they drive the most revenue.
- Dig deeper into why smaller stores sell more per transaction before using store size to plan future store formats — correlation alone doesn't explain the reason.

## Limitations

- **The dataset only goes up to September 27, 2025** — so I could only check September for the "festival season" effect. October and December weren't available, so I can't yet confirm a full festival-season pattern, only a September one.
- This dataset is synthetic — I built it to behave like real data because no public dataset matched this project's structure. The methodology and reasoning are real; a real company would need to validate this against actual data.
- I compared stores one pair at a time, not with a single test across all 10 stores together (like ANOVA) — a more advanced version of this project could add that.

## Future Improvements

- Get a full 12-month dataset to properly check for seasonality.
- Connect inventory stockouts more directly to the profitability numbers (planned, but skipped for time).
- Build a Power BI dashboard for ongoing tracking (planned for Project 2).

## Repository Structure

```
retailpulse-analysis/
├── data/
│   ├── raw/              # Original dataset (Excel + individual CSVs)
│   └── processed/        # Cleaned master dataset and returns
├── notebooks/            # Data cleaning, stats, and visualization notebook
├── sql/                  # All business-question SQL queries
├── reports/              # Exported chart images
└── README.md
```
