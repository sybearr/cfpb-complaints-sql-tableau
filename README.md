# CFPB Consumer Complaint Analysis Dashboard

## Project Background
The Consumer Financial Protection Bureau (CFPB) is a U.S. government agency that ensures banks, lenders, and other financial companies treat consumers fairly. As a Data Analyst specializing in consumer risk and regulatory compliance, tracking these complaints is critical for identifying systemic market issues, monitoring institutional operational risks, and uncovering areas where financial products fail to meet consumer needs. 

This project analyzes **951,695 consumer complaint records** spanning from May 2022 to April 2023. By evaluating how financial organizations manage disputes, this analysis provides actionable insights into industry-wide operational gaps, customer friction points, and regulatory compliance risks.

Insights and recommendations are provided on the following key areas:
* **Product & Issue Concentration:** Evaluation of systemic product friction points across the financial sector, focusing on volume drivers and primary consumer grievances like credit reporting inaccuracies.
* **Bureau & Institutional Risk Mapping:** An analysis of organizational exposure, contrasting the massive compliance burdens of the "Big Three" credit bureaus against traditional retail banking leaders.
* **Operational Responsiveness & Resolution Performance:** An assessment of corporate SLA compliance, evaluating timely response rates alongside the ultimate financial and non-monetary outcomes of disputes.
* **Submission & Geographic Trends:** An evaluation of consumer engagement dynamics across digital and legacy intake channels, tracking spatial volume distribution and monthly macroeconomic surges.

* The SQL queries used to inspect and clean the data for this analysis can be found here **[Link to Clean Queries]**.
* Targeted SQL queries regarding various business questions can be found here **[Link to Analytical Queries]**.
* An interactive Tableau dashboard used to report and explore complaint trends can be found here **[Link to Tableau Public Dashboard]**.

---

## Data Structure & Initial Checks
The dataset is hosted in a centralized PostgreSQL database containing **951,695 records** across a single comprehensive staging table representing the CFPB Public Complaints registry. Key attributes inspected include:
* **Temporal Fields:** Date received, Date sent to company (used to evaluate corporate response speed)
* **Categorical Categorizations:** Product, Sub-product, Issue, Sub-issue
* **Corporate Entities:** Company name, State, Zip Code
* **Resolution Performance:** Company response, Timely response (Y/N), Consumer disputed (Y/N), Submitted via

### Data Cleaning Workflow
Prior to building visualizations, the raw dataset underwent rigorous ETL inside a **PostgreSQL 18** environment via pgAdmin:
1. **Text Standardization:** Leveraged `INITCAP()` to standardize mixed casing across fields like `Product` and `Company`.
2. **Missing Value Management:** Identified and handled missing text entries in `Sub-product` and `Sub-issue` via conditional logic.
3. **Data Type Casts:** Handled manual date transformations to properly parse system timestamps into relational `DATE` fields.
4. **Feature Engineering:** Generated calculated columns for `Complaint Year`, `Month`, and `Quarter` using window and date functions to power time-series trends in Tableau.

---

## Executive Summary

### Overview of Findings
Over the 12-month period analyzed, consumer complaints reached a massive volume of 951.6K, heavily dominated by failures in credit reporting infrastructure, with the "Big Three" bureaus accounting for over 71.6% of all filings. While financial institutions demonstrate elite compliance with statutory response windows (99.5% timely response rate), the overwhelmingly high rate of accounts closed with simple "explanations" over tangible relief underscores a potential gap in proactive consumer resolution. From a stakeholder perspective, these insights highlight that data integrity in credit reporting represents the largest operational and reputational risk vector in the retail consumer finance ecosystem.

![CFPB Consumer Complaint Dashboard Screenshot](Screenshot%202026-05-25%20at%203.50.31 PM.jpg)

---

## Insights Deep Dive

### Product & Issue Concentration
* **Credit Reporting Dominance:** Credit reporting is the clear epicenter of consumer friction, making up **78% of all complaints (743,583 total records)**. Far behind in second and third place are Debt Collection (59,882) and Credit Cards (43,821).
* **Data Integrity Failures:** The single largest industry-wide pain point is the **"Improper use of your report"**, capturing **288,701 complaints**, closely followed by "Incorrect information on your report" at **262,902 complaints**. Together, these two data-quality issues account for more than half of the entire database.

### Bureau & Institutional Risk Mapping
* **The Big Three Exposure:** The credit reporting giants—**Equifax, TransUnion, and Experian**—shoulder the vast majority of consumer backlash, combining for **71.6% of total market complaints**. Equifax leads with 233,420 complaints, followed closely by TransUnion (228,713) and Experian (219,377).
* **Banking Sector Outliers:** Outside of the credit bureaus, traditional retail banks see substantially lower but highly concentrated volume. **Wells Fargo (17,907)**, **Capital One (14,474)**, and **Bank of America (13,533)** represent the most heavily complained-about traditional banking institutions, mostly driven by credit card and checking/savings disputes.

### Operational Responsiveness & Resolution Performance
* **High Regulatory Compliance:** Financial institutions maintain an exceptional **99.5% timely response rate**. This indicates robust automated compliance workflows and a strict adherence to legal SLA windows across major players.
* **Explanation Over Compensation:** While the **overall resolution rate sits at 99.9% closed**, the nature of these closures leans heavily away from financial adjustments. **64.6% of complaints are closed with an explanation**, 33.5% result in non-monetary relief, and only **1.9% result in direct monetary relief** to the consumer.

### Submission & Geographic Trends
* **Digital-First Engagement:** A staggering **95.7% of all consumer complaints are routed through the Web**, with only 4.3% utilizing legacy channels like Email, Phone, or Postal Mail. Digital submission pathways act as the main pipeline for intake.
* **Volatilities and Surges:** Macroeconomic shifts and potential data security incidents drove a significant volume spike in **March 2023, peaking at 89,900 complaints**, marking the highest volume month within the dataset. Geographically, complaints scale relative to state population sizes, with California, Texas, and Florida anchoring the highest volumes.

---

## Recommendations

Based on the insights and findings above, a risk management and retail banking team should consider the following strategic actions:

* **Audit Third-Party Credit Bureau Integrations:** Because credit reporting discrepancies comprise 78% of market disputes, retail banking arms must conduct frequent data-integrity audits on data payloads transmitted to Equifax, TransUnion, and Experian to minimize downstream regulatory penalties and dispute handling costs.
* **Optimize Self-Service Resolution for Digital Channels:** Since 95.7% of consumers utilize web-based platforms to register complaints, migrating standard dispute forms directly into the internal mobile banking application could intercept grievances *before* they escalate to the federal CFPB database.
* **Refine Dispute Categorization Routing:** Given that "Improper use of report" and "Incorrect information" dominate systemic issues, pre-sorting complaints using automated NLP (Natural Language Processing) tools could significantly reduce internal processing times for operational risk teams.
* **Review Root Causes of Checking & Savings Disputes:** While traditional retail banking complaints are low compared to credit bureaus, institutions like Wells Fargo and Capital One face continuous friction. Digging deeper into checking/savings account management could reveal policies triggering high volumes of complaints.

---

## Assumptions and Caveats

* **Assumption 1:** Unpopulated or blank sub-product fields were assumed to mean that the consumer did not select a sub-tier category during digital submission; these were recoded as "Not Specified" rather than dropping the primary product records.
* **Assumption 2:** The "Timely Response" flag is determined by the company's compliance with standard CFPB administrative timelines (usually 15 days); this analysis assumes the accuracy of the CFPB's internal system timestamp evaluations.
* **Assumption 3:** Financial values or specific losses suffered by consumers are not fully quantified in the public database, limiting this analysis to volume and classification trends rather than exact dollar-amount risk exposures.
