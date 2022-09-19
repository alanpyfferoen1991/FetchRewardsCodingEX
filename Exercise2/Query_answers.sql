-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ 
-- or ‘Rejected’, which is greater? 'Accepted' is Greater
-- When considering total number of items purchased from receipts with 
-- 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? Accepted is Greater
-- I have to assume that rewardsReceiptStatus value of FINISHED is the same as being Accepted.
select "rewardsReceiptStatus"
      ,sum("purchasedItemCount") totalItemsPurchased
      ,avg("totalSpent") avg_totalSpent
from "Receipts"
where "rewardsReceiptStatus" in ('REJECTED','FINISHED')
  and COALESCE("totalSpent") > 0
  and COALESCE("purchasedItemCount") > 0
group by "rewardsReceiptStatus"
