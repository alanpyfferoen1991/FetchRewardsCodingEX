-- The purpose of this function is to return a float value representing the percent of a table column that is null
create or replace function getProportionMissing(g_column_name information_schema.sql_identifier, g_table_name information_schema.sql_identifier)
returns float
language plpgsql
as
$$
declare
   v_proportionMissing float;
begin
  execute 'select CAST
            (sum(case when '||quote_ident(g_column_name)||' is null then 1 else 0 end)
            as float) / count(*) as ProportionMissing
          from '||quote_ident(g_table_name)
          into v_proportionMissing;   
   return v_proportionMissing;
end;
$$;