-- Run this script to populate the brands data.
with brands_tb as (
select (doc -> '_id' ->> '$oid')::varchar as brandsId
      ,(doc ->> 'barcode')::varchar as barcode
      ,(doc ->> 'category')::varchar as category
      ,(doc ->> 'categoryCode')::varchar as categoryCode
      ,(doc -> 'cpg' -> '$id' ->> '$oid')::varchar as cpg
      ,(doc ->> 'brandCode')::varchar as brandCode
      ,(doc ->> 'name')::varchar as name
      ,(doc ->> 'topBrand')::boolean as topBrand
from public.brands_import
)
insert into public."Brands"
  ("brandsId"
  ,barcode
  ,category
  ,"categoryCode"
  ,cpg
  ,"brandCode"
  ,name
  ,"topBrand")
select brandsId
      ,barcode
      ,category
      ,categoryCode
      ,cpg
      ,brandCode
      ,name
      ,topBrand
from brands_tb;