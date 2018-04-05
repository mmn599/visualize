# Visualize

Visualize is a SQL Server tool to create data visualizations without the data leaving the server. It uses Machine Learning Services for SQL Server

# Getting Started

First, make sure Machine Learning Services for SQL Server (including Python) is installed: https://docs.microsoft.com/en-us/sql/advanced-analytics/install/sql-machine-learning-services-windows-install

## Generating Scatter Plots
1. Execute the VisualizeScatter.sql query against the database you want to use. This installs a stored procedure that generates and stores scatter plots of your data. 
2. Call the stored procedure like so:

```sql
-- Generates a scatter plot of CRSDepTime vs. ArrDelay columns from the AirlineDemoSmall table.
-- Stores the .png image data of this scatter plot in the MyPlots table.

declare @table_name varchar(MAX) = 'AirlineDemoSmall'
declare @x_col varchar(MAX) = 'CRSDepTime'
declare @y_col varchar(MAX) = 'ArrDelay'
declare @plot_table_name varchar(MAX) = 'MyPlots'
declare @plot_name varchar(MAX) = 'MyFirstPlot'

exec VisualizeScatter @table_name, @x_col, @y_col, @plot_table_name, @plot_name
```
3. You can use a tool like BCP to export the image you created. Run the below command to save your image as C:\myfirstplot.png:

```cmd
BCP "SELECT top 1 PlotData FROM MyPlots where PlotName = 'MyFirstPlot'" queryout "C:\myfirstplot.png" -T -C RAW -d RevoTestDB
```

```
Enter the file storage type of field PlotData [varbinary(max)]: I
Enter prefix-length of field PlotData [4]: 0
Enter length of field PlotData [0]: 0
Enter field terminator [none]:
Do you want to save this format information in a file? [Y/n] n
```

Open the image saved in C:\myfirstplot.png:

![alt text](https://raw.githubusercontent.com/mmnormyle/visualize/master/myfirstplot.png)
