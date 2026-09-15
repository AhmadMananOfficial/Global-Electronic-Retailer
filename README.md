# Retail Performance & Profitability Analysis

## Background

This project analyzes the performance of a global electronics retailer
with **67 stores across 9 countries**, using sales, customer, product,
and store data.

The goal was not just to report sales, but to understand where the
business is performing well, where value is being created or lost, and
which areas deserve management attention.

I approached the analysis around three business decisions:

-   Where should the company focus its store resources?
-   Which products should the business prioritize while protecting
    profitability?
-   Which customers should the business prioritize to increase customer
    value?

I used **MySQL** for data preparation and analysis, including reusable
analytical views, and **Power BI** for the final dashboard.

------------------------------------------------------------------------

## Executive Summary

- The business generated **\$55.8M in revenue** and **\$32.7M in gross profit**, with an overall **58.6% gross margin**. 
- Performance is concentrated around a relatively small part of the business: **28% of products generate about 80% of revenue**, while **41% of customers
generate 80% of revenue**. 
- Store productivity varies significantly across locations, with revenue per square meter ranging from **\$23 to \$1,454**, while **9 of 67 stores have no recorded sales**. 
- The biggest customer opportunity appears to be increasing purchase frequency, as **7,272 repeat-customers generate \$45.9M**, compared with **\$9.8M from
4,615 one-time customers**.

------------------------------------------------------------------------

## Insights Deep Dive

### 1. Store productivity varies much more than store size suggests

The retailer has **67 stores**, but only **58 have recorded sales**. The
remaining **9 stores** have no recorded sales in the dataset and should
be investigated before making decisions about their future.

Among stores with sales, revenue productivity varies considerably:

-   **Wyoming:** \$1,454 revenue/m²
-   **Nevada:** \$1,236 revenue/m²
-   **Tasmania:** \$221 revenue/m²
-   **Northern Territory:** \$23 revenue/m²

That is roughly a **63× difference** between the highest and lowest
revenue per square meter.

The interesting part is that store size and age alone do not explain
this difference. A smaller store can be highly productive, while a
larger store can perform poorly.

**What this means:** store resources should not be allocated based on
size alone. The low-productivity locations need further investigation
into factors such as local market conditions, product mix, competition,
location, and store format before any expansion or closure decision is
made.

### 2. A relatively small group of products drives most of the business

The dataset contains **2,517 products**, of which **2,492 have recorded
sales**.

The revenue distribution is highly dependented:

-   **709 products (28%) generate about 80% of revenue**
-   These same products generate about **81% of gross profit**

At category level, the largest revenue contributors are:

| Category              | Revenue |     Gross Margin |
| ----------------------------- | --------: | ----------: |
| Computers                 | $19.3M    |     58.43%
| Home Appliances           | $10.8M    |     58.32%
| Cameras and camcorders    |  $6.5M    |     60.12%
| Cell phones               |  $6.2M    |     56.58%
| TV and Video              |  $5.9M    |     59.65%

Looking one level deeper, **Desktops generate \$9.9M**, making them the
largest individual subcategory by revenue. **Projectors & Screens**
generate \$3.8M with a 62.57% gross margin, while **Televisions**
generate \$4.3M with a 61.08% gross margin.

**What this means:** the business does not need to manage every product
with the same level of attention. The core product range has a
disproportionate effect on revenue and profit, so availability, pricing,
inventory, and product strategy around these products matter most.

### 3. Some high-revenue products have relatively lower margins

Revenue alone does not tell the full story.

Using the **54.01% median product margin** as an exploratory benchmark,
I identified **226 relatively high-revenue products below that
benchmark**.

Together, these products generate:

-   **\$7.89M revenue**
-   **\$3.87M gross profit**

This does not mean these products are necessarily underperforming. A
product can have a lower margin and still be commercially important
because of its sales volume.

The purpose of this segmentation was to identify where management should
investigate further.

**What this means:** these products are worth reviewing for pricing,
supplier cost, discounting, and product mix before making assortment
decisions. The 54.01% figure is an analytical benchmark from this
dataset, not a recommended minimum margin.

### 4. Customer value is driven more by frequency than order size

There are **15,266 customers** in the customer table, with **11,887
customers having recorded sales**.

Customer revenue is also highly concentrated:

-   **4,873 customers (41%) generate 80% of revenue**
-   Average revenue per active customer: **\$4,690**
-   Highest customer revenue: **\$61,872**

The difference between one-time and repeat customers is particularly
interesting:

|  Customer Type  |   Customers |    Revenue |   Revenue / Customer |       AOV
| ----------------------------- | --------: | ----------: | ----------: | ----------: |
|  One-time     |         4,615 |   $9.82M       |       $2,128 |  $2,128
|  Repeat       |         7,272 |   $45.94M      |       $6,317 |  $2,116

Repeat customers generate roughly **82% of total revenue**, but their
average order value is almost the same as one-time customers.

**What this means:** the biggest difference is not how much customers
spend in a single order. It is how often they come back.

### 5. High-value frequent customers are the most important customer group

Customer segmentation based on revenue and purchase frequency produced
four groups:

|  Segment         |              Customers  |  Revenue |  Share of Revenue |
| ----------------------------- | --------: | ----------: | ----------: |
|  High Revenue + Frequent       |    3,206 |  \$30.05M   |          53.89% 
|  High Revenue + Infrequent     |    2,738 |  \$18.25M   |          32.74%
|  Low Revenue + Infrequent      |    5,287 |   \$6.18M   |          11.09%
|  Low Revenue + Frequent        |      656 |   \$1.27M   |           2.29%

The first two groups contain **5,944 customers**, about half of active
customers, but account for **86.63% of revenue**.

The **3,206 high-revenue frequent customers** are the most valuable
group and should be protected.

The more interesting growth opportunity is the **2,738 high-revenue
infrequent customers**. They already spend enough to be classified as
high-value, but they do not purchase frequently.

**What this means:** customer strategy should focus first on retaining
high-value frequent customers, then on understanding whether high-value
infrequent customers can be encouraged to purchase more often.

### 6. The United States is the largest customer market, but market value is not only about size

The United States is the largest customer market:

-   **5,706 customers**
-   **14,221 orders**
-   **\$29.87M revenue**
-   **\$17.49M gross profit**
-   **\$5,235 revenue per customer**

However, customer value varies across markets.

For example:

-   **Germany:** \$4,708 revenue/customer
-   **Italy:** \$4,671 revenue/customer
-   **Australia:** \$3,472 revenue/customer, but the highest AOV at
    \$2,291 and only 1.52 orders/customer

This shows why looking only at total revenue can hide important
differences in customer behavior.

**What this means:** market decisions should consider both customer
value and purchase frequency rather than simply ranking countries by
total sales.

------------------------------------------------------------------------

## Recommendations

### 1. Investigate store productivity gaps

The large differences in revenue per square meter deserve further
investigation, especially at the lowest-performing locations.

Before recommending store closures, expansion, or relocation, I would
compare:

-   Local market size
-   Product mix
-   Competition
-   Store format
-   Customer demand
-   Store operating costs

The current analysis identifies the locations that need attention; it
does not prove why they are underperforming.

### 2. Protect the core product range

The **709 products generating about 80% of revenue** should receive
priority when reviewing availability, inventory, pricing, and
merchandising.

A disruption in this group could have a much larger financial impact
than changes to the long tail of products.

### 3. Investigate high-revenue, lower-margin products

The **226 products generating \$7.89M revenue below the 54.01% median
margin** are a useful starting point for margin investigation.

The next step would be to examine whether lower margins are caused by:

-   Product pricing
-   Supplier costs
-   Discounts
-   Product mix
-   Market-specific pricing

The objective should be to improve economics where possible without
damaging sales volume.

### 4. Focus on retention and purchase frequency

The business should continue protecting its **3,206 high-revenue
frequent customers**, while investigating the **2,738 high-revenue
infrequent customers** as a potential growth group.

Because repeat and one-time customers have almost identical AOVs,
increasing purchase frequency appears more relevant than simply trying
to increase the size of every order.

------------------------------------------------------------------------

## Final Words

What stood out to me across the analysis is that the business is
performing well overall, but the value is not distributed evenly.

A relatively small group of products and customers drives a large share
of revenue, while store productivity varies significantly across
locations. At the same time, repeat customers generate far more value
mainly because they purchase more often, not because their individual
orders are much larger.

The main takeaway for me is that the next improvement is not simply
about selling more. It is about understanding where the business already
creates the most value, where performance is falling short, and where a
change could have a meaningful financial impact.
