-- This query is used to determine the degree of missing data in any particular column
-- This query will show all the columns of a table and run the getProportionMissing function against each column.
-- You can use this too find out if there are columns that are rarely populated with data.
with Q1 as (
select column_name, 
       table_name,
       getProportionMissing(column_name, table_name) proportion_missing
from information_schema.columns
where table_schema = 'public' -- Replace with name of your schema
  and table_name = 'ReceiptItemList' -- replace with table name you want investigate
)
select *
from Q1
where proportion_missing > 0.75

-- This query checks the user table for duplicate records.
select "userId"
      ,active
      ,"createdDate"
      ,"lastLogin"
      ,role
      ,"signUpSource"
      ,State
from users
group by "userId"
        ,active
        ,"createdDate"
        ,"lastLogin"
        ,role
        ,"signUpSource"
        ,State
having count(*) > 1