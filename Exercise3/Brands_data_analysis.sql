-- Check for records where the BrandCode is not unique 
select "brandCode"
      ,count(*)
from "Brands"
group by "brandCode"
having count(*) > 1

-- Review the records that are not unique. The GOODNITES and HUGGIES brandCode's have 2 records.
-- These records can yield different results when trying to see which is a topBrand.
select *
from "Brands"
where "brandCode" in (select "brandCode"
                      from "Brands"
                      where "brandCode" in ('GOODNITES','HUGGIES')
                      group by "brandCode"
                      having count(*) > 1)