drop procedure IF Exists VisualizeScatter
GO

create procedure VisualizeScatter @table_name varchar(MAX), @x_col varchar(MAX), @y_col varchar(MAX), @plot_table_name varchar(MAX), @plot_name varchar(MAX)
AS

declare @database varchar(MAX) = (SELECT DB_NAME())

exec sp_execute_external_script
@language = N'Python',
@script = N'
import sqlalchemy
import pandas as pd
import matplotlib.pyplot as plt
import io
from urllib import parse

connection_string = "Driver=SQL Server;Server=localhost;Trusted_Connection=Yes;Database=" + database
engine = sqlalchemy.create_engine("mssql+pyodbc:///?odbc_connect={}".format(parse.quote_plus(connection_string)))

df = pd.read_sql("select top 100 " + x_col + ", " + y_col + " from " + table_name, engine)

title = x_col + " vs . " + y_col

plt.scatter(df[x_col], df[y_col])
plt.xlabel(x_col)
plt.ylabel(y_col)
plt.title(title)

buf = io.BytesIO()
plt.savefig(buf, format="jpg")

df_plt = pd.DataFrame()
df_plt["PlotTitle"] = [title]
df_plt["PlotType"] = ["Scatter"]
df_plt["PlotTable"] = [table_name]
df_plt["PlotData"] = [buf.getvalue()]
df_plt["PlotName"] = [plot_name]

df_plt.to_sql(plot_table_name, engine, if_exists="replace", dtype={"PlotData": sqlalchemy.types.LargeBinary})
'
, @params = N'
@database varchar(max),
@table_name varchar(max),
@x_col varchar(max),
@y_col varchar(max),
@plot_table_name varchar(max),
@plot_name varchar(max)
'
  , @database = @database
  , @table_name = @table_name
  , @x_col = @x_col
  , @y_col = @y_col
  , @plot_table_name = @plot_table_name
  , @plot_name = @plot_name