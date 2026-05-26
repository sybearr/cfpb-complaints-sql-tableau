# CFPB Consumer Complaint Analysis Dashboard

## Project Background
The Consumer Financial Protection Bureau (CFPB) is a U.S. government agency that ensures banks, lenders, and other financial companies treat consumers fairly. As a Data Analyst specializing in consumer risk and regulatory compliance, tracking these complaints is critical for identifying systemic market issues, monitoring institutional operational risks, and uncovering areas where financial products fail to meet consumer needs. 

This project analyzes **951,695 consumer complaint records** spanning from May 2022 to April 2023. By evaluating how financial organizations manage disputes, this analysis provides actionable insights into industry-wide operational gaps, customer friction points, and regulatory compliance risks.

Insights and recommendations focus on four core areas:
* **Product & Issue Concentration:** Identifying which financial products drive the most disputes and highlighting the specific flaws causing consumer friction.
* **Institutional Risk Mapping:** Evaluating which financial firms and credit bureaus face the highest complaint volumes and regulatory exposure.
* **Operational Responsiveness & Resolution Performance:** Assessing corporate compliance with response deadlines alongside final dispute resolution types (such as monetary relief vs. simple explanations).
* **Submission Channels & Volume Timing:** Analyzing how consumers submit complaints (web, phone, mail) and tracking monthly volume spikes over the fiscal year.

* The SQL queries used to inspect and clean the data for this analysis can be found here **[https://github.com/sybearr/cfpb-complaints-sql-tableau/blob/eefb69b3c74737fefabd174f743b6d67fcbc0a03/01_cleaning.sql]**.
* Targeted SQL queries regarding various business questions can be found here **[https://github.com/sybearr/cfpb-complaints-sql-tableau/blob/eefb69b3c74737fefabd174f743b6d67fcbc0a03/02_analysis.sql]**.
* An interactive Tableau dashboard used to report and explore complaint trends can be found here **[https://public.tableau.com/views/CFPBFinancialConsumerComplaintsDashboard/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link]**.

---

## Data Structure & Initial Checks
The dataset is hosted in a centralized PostgreSQL database containing **951,695 records** across a single comprehensive staging table representing the CFPB Public Complaints registry. Key attributes inspected include:
* **Temporal Fields:** Date received, Date sent to company (used to evaluate corporate response speed)
* **Categorical Categorizations:** Product, Sub-product, Issue, Sub-issue
* **Corporate Entities:** Company name, State, Zip Code
* **Resolution Performance:** Company response, Timely response (Y/N), Consumer disputed (Y/N), Submitted via

### Data Cleaning Workflow
Prior to building visualizations, the raw dataset underwent data cleaning and transformation inside a **PostgreSQL 18** environment via pgAdmin:
1. **Text Standardization:** Leveraged `INITCAP()` to standardize mixed casing across fields like `Product` and `Company`.
2. **Date Format Inconsistencies:** The raw dataset contained two incompatible date formats. The data was split in Excel into two groups, imported separately into PostgreSQL, corrected using MAKE_DATE(), then recombined with UNION ALL and removed any duplicate ids.
3. **Data Type Casts:** Handled manual date transformations to properly parse system timestamps into relational `DATE` fields.
4. **Feature Engineering:** Generated calculated columns for `Complaint Year`, `Month`, and `Quarter` using window and date functions to power time-series trends in Tableau.

---

## Executive Summary

### Overview of Findings
Over the 12-month period analyzed, consumer complaints reached a massive volume of 951.6K, heavily concentrated in credit reporting complaints, with the "Big Three" bureaus accounting for over 71.6% of all filings. While financial institutions demonstrate strong compliance with response deadlines (99.5% timely response rate), the overwhelmingly high rate of accounts closed with simple "explanations" over tangible relief underscores a potential gap in proactive consumer resolution. From a stakeholder perspective, these insights highlight that data integrity in credit reporting represents the the biggest operational risk area in the retail consumer finance ecosystem.

<img width="1354" height="984" alt="Screenshot 2026-05-25 at 3 50 31 PM" src="https://github.com/user-attachments/assets/ed7b55ac-d08a-4c3d-a2f3-a4d963754ea4" />

---

## Insights Deep Dive

### Product & Issue Concentration
* **Credit Reporting Dominance:** Credit reporting is the single largest driver of consumer disputes, accounting for **78% of all complaints (743,583 records)**. Debt collection follows at a distant second (59,882), with credit cards ranking third (43,821).
* **Data Accuracy Failures:** The top consumer grievance is the **"Improper use of your report"** (288,701 complaints), followed closely by "Incorrect information on your report" (262,902 complaints). Together, these two data-quality issues account for over half of the entire database.

### Institutional Risk Mapping
* **Credit Bureau Exposure:** The "Big Three" credit reporting agencies—**Equifax, TransUnion, and Experian**—shoulder the vast majority of consumer complaints, combining for **71.6% of total complaints**. Equifax leads with 233,420 records, followed by TransUnion (228,713) and Experian (219,377).
* **Retail Banking Exposure:** Outside of the credit bureaus, traditional commercial banks see much lower but highly concentrated volumes. **Wells Fargo (17,907)**, **Capital One (14,474)**, and **Bank of America (13,533)** are the most complained-about banking institutions, primarily driven by credit card and checking account disputes.

### Operational Responsiveness & Resolution Performance
* **Strong SLA Compliance:** Financial institutions maintain a **99.5% timely response rate**. This demonstrates that corporate automated workflows are highly effective at meeting regulatory deadlines.
* **Explanation vs. Relief:** While **99.9% of complaints are successfully closed**, financial restitution is rare. **64.6% of complaints are closed with an explanation**, 33.5% receive non-monetary relief, and only **1.9% result in direct monetary relief** (refunds or compensation).

### Submission Channels & Volume Timing
* **Digital-First Preferences:** A dominant **95.7% of all consumer complaints are submitted via the Web**, with legacy channels like phone, email, and postal mail handling the remaining 4.3%. 
* **Volume Surges:** Complaint volume peaked significantly in **March 2023, reaching 89,900 complaints** for the month. Geographically, dispute volumes scale with state population density, with California, Texas, and Florida anchoring the highest activity.

---

## Recommendations

Based on these analytical findings, a retail banking risk or compliance team should prioritize the following actions:

* **Audit Third-Party Credit Bureau Integrations:** Since credit reporting errors drive 78% of all disputes, banks must frequently audit the customer data pipelines sent to Equifax, TransUnion, and Experian to catch inaccuracies before they turn into formal regulatory complaints.
* **Optimize Digital Self-Service Dispute Portals:** With 95.7% of consumers preferring online channels, banks should introduce guided dispute tools directly inside their mobile banking applications. Intercepting customer issues early prevents escalation to the CFPB database.
* **Implement Automated Case Routing:** Because "improper use of report" and "incorrect information" dominate customer issues, text-tagging automation can help operational teams route these high-volume complaints to specialized resolution units faster.
* **Investigate Retail Banking Friction Points:** Traditional retail banking components face persistent complaints regarding checking and savings accounts. Risk teams should audit account terms, fee disclosures, and hold policies to identify and resolve recurring consumer triggers.

---

