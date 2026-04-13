# Bright-TV-Case-Study

BrightTV’s CEO set a strategic objective to grow the company’s subscription base for the current financial year.

This case study analyzes user profiles and session-level viewership data to generate insights.

The aim is to:

Understand user behavior and consumption trends
Identify factors influencing content consumption
Recommend content strategies for low-usage days
Propose initiatives to grow the subscriber base

Business Objectives:

Look at user and usage trends 
Look at strategies that can be implemented to increase low-day consumption
Propose initiatives to grow subscribers

Tools Used

Databricks, SQL, Miro, Canva, Google looker Studio

Task 1: Planning (Miro)

Data Flow & Miro Diagram that outlines:

• Where the data originates (User Profiles & Viewer Session Data)
• How it is processed (ETL Pipeline in Databricks)
• Time conversion from UTC to SAST (UTC +2)
• Data storage layer Databricks
• Data consumption layer (Excel, Google Looker Studio)

Key Business Insights to Deliver:

• Total sessions per day, week, and month
• Peak and low consumption days
• Average session duration per user

Task 2: Data Processing in Databricks
Data Preparation:

• Left Join the tables
• Convert UTC timestamps to South African Standard Time (SAST)
• Extract new time variables:

Hour of Day
Day of Week
Month

Task 3: Data Analysis in Excel / Visualization Tools

Export the cleaned and transformed dataset into Excel.

Create dashboards or pivot tables showing:

• Viewership by Gender
• Peak vs Low consumption periods
• Viwership by time slots
• Province vs Time slots
• Channel Perfomance
• Total viewing per province 

Task 4: Presentation to the CEO
 20-minute executive presentation including:

Overview of Your Approach

• Business understanding, Recommendations and Insights

