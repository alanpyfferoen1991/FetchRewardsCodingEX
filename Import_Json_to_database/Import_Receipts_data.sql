-- Run this script to populate the Receipts table and ReceiptItemList table
do $$
 <<import_Receipts_date>>
declare
-- This cursor will contain all the Receipts data that has a user In the users table
-- do to the foreign key constraint "Receipts_userId_fkey". Make sure that the import_users_data.sql
-- was ran first or this will fail. It may take a while to run.
  cur_receipts cursor for
    select (r.doc -> '_id' ->> '$oid')::varchar as receiptId
          ,(r.doc ->> 'userId')::varchar as userId
          ,(r.doc ->> 'bonusPointsEarned')::numeric as bonusPointsEarned
          ,(r.doc ->> 'bonusPointsEarnedReason')::varchar as bonusPointsEarnedReason
          ,to_timestamp((r.doc -> 'createDate' ->> '$date')::numeric/1000) as createDate
          ,to_timestamp((r.doc -> 'dateScanned' ->> '$date')::numeric/1000) as dateScanned
          ,to_timestamp((r.doc -> 'finishedDate' ->> '$date')::numeric/1000) as finishedDate
          ,to_timestamp((r.doc -> 'modifyDate' ->> '$date')::numeric/1000) as modifyDate
          ,to_timestamp((r.doc -> 'pointsAwardedDate' ->> '$date')::numeric/1000) as pointsAwardedDate
          ,(r.doc ->> 'pointsEarned')::numeric as pointsEarned
          ,to_timestamp((r.doc -> 'purchaseDate' ->> '$date')::numeric/1000) as purchaseDate
          ,(r.doc ->> 'purchasedItemCount')::numeric as purchasedItemCount
          ,(r.doc ->> 'rewardsReceiptStatus')::varchar as rewardsReceiptStatus
          ,(r.doc ->> 'totalSpent')::numeric as totalSpent
    from users as u
	    ,receipts_import as r
	where u."userId" = (r.doc ->> 'userId')::varchar
    order by 1;
-- This cursor will contain all the Receipt Items data
  cur_ReceiptItemList cursor (c_receiptId varchar) for
    with jTable as (
    select l.receiptId
          ,jsonb_array_elements(l.doc) as doc
    from (select (doc -> '_id' ->> '$oid')::varchar as receiptId
                ,doc -> 'rewardsReceiptItemList' as doc
          from receipts_import) l
    )
    select j.receiptId
          ,(j.doc ->> 'partnerItemId')::numeric as partnerItemId
          ,(j.doc ->> 'rewardsProductPartnerId')::varchar as rewardsProductPartnerId
          ,(j.doc ->> 'pointsPayerId')::varchar as pointsPayerId
          ,(j.doc ->> 'metabriteCampaignId')::varchar as metabriteCampaignId
          ,(j.doc ->> 'userFlaggedPrice')::numeric as userFlaggedPrice
          ,(j.doc ->> 'pointsEarned')::numeric as pointsEarned
          ,(j.doc ->> 'competitiveProduct')::boolean as competitiveProduct
          ,(j.doc ->> 'needsFetchReview')::boolean as needsFetchReview
          ,(j.doc ->> 'finalPrice')::numeric as finalPrice
          ,(j.doc ->> 'targetPrice')::numeric as targetPrice
          ,(j.doc ->> 'discountedItemPrice')::numeric as discountedItemPrice
          ,(j.doc ->> 'originalFinalPrice')::numeric as originalFinalPrice
          ,(j.doc ->> 'itemPrice')::numeric as itemPrice
          ,(j.doc ->> 'description')::varchar as description
          ,(j.doc ->> 'needsFetchReviewReason')::varchar as needsFetchReviewReason
          ,(j.doc ->> 'rewardsGroup')::varchar as rewardsGroup
          ,(j.doc ->> 'quantityPurchased')::numeric as quantityPurchased
          ,(j.doc ->> 'priceAfterCoupon')::numeric as priceAfterCoupon
          ,(j.doc ->> 'userFlaggedDescription')::varchar as userFlaggedDescription
          ,(j.doc ->> 'userFlaggedBarcode')::numeric as userFlaggedBarcode
          ,(j.doc ->> 'pointsNotAwardedReason')::varchar as pointsNotAwardedReason
          ,(j.doc ->> 'originalMetaBriteBarcode')::varchar as originalMetaBriteBarcode
          ,(j.doc ->> 'originalMetaBriteItemPrice')::numeric as originalMetaBriteItemPrice
          ,(j.doc ->> 'originalMetaBriteDescription')::varchar as originalMetaBriteDescription
          ,(j.doc ->> 'barcode')::varchar as barcode
          ,(j.doc ->> 'competitorTargetGapPoints')::numeric as competitorTargetGapPoints
          ,(j.doc ->> 'brandCode')::varchar as brandCode
          ,(j.doc ->> 'itemNumber')::numeric as itemNumber
          ,(j.doc ->> 'originalMetaBriteQuantityPurchased')::numeric as originalMetaBriteQuantityPurchased
          ,(j.doc ->> 'userFlaggedNewItem')::boolean as userFlaggedNewItem
          ,(j.doc ->> 'originalReceiptItemText')::varchar as originalReceiptItemText
          ,(j.doc ->> 'userFlaggedQuantity')::numeric as userFlaggedQuantity
          ,(j.doc ->> 'preventTargetGapPoints')::boolean as preventTargetGapPoints
    from jTable as j
    where j.receiptId = c_receiptId
    order by 1, 2;
-- This cursor checks if the rewardsReceiptItemList exists
  cur_ReceiptItemList_exist cursor (c_receiptId varchar) for
    with jTable as (
    select l.receiptId
          ,jsonb_array_elements(l.doc) as doc
    from (select (doc -> '_id' ->> '$oid')::varchar as receiptId
                ,doc -> 'rewardsReceiptItemList' as doc
          from receipts_import) l
    )
    select distinct 'Y' exist_flag
    from jTable as j
    where j.receiptId = c_receiptId;
--
  v_ReceiptItemListId  varchar(100)  := null;
  v_exists_flag        varchar(1);
--
begin
   raise notice 'start program';
-- Begin importing data into Receipts table and ReceiptsItemList table
  for rec_receipts in cur_receipts loop
    v_exists_flag              := 'N';
    v_ReceiptItemListId := null;
    -- check the receipt to see it there are any items
    open cur_ReceiptItemList_exist( c_receiptId := rec_receipts.receiptId );
    fetch cur_ReceiptItemList_exist into v_exists_flag;
    close cur_ReceiptItemList_exist;
    -- if item exist create unique id to tie the Receipts table with ReceiptsItemList table
    if v_exists_flag = 'Y' then
      v_ReceiptItemListId := uuid_generate_v4();
    end if;
    -- insert receipt record
    insert into public."Receipts"
      ("receiptId",
       "bonusPointsEarned",
       "bonusPointsEarnedReason",
       "createDate",
       "dateScanned",
       "finishedDate",
       "modifyDate",
       "pointsAwardedDate",
       "pointsEarned",
       "purchaseDate",
       "purchasedItemCount",
       "ReceiptItemListId",
       "rewardsReceiptStatus",
       "totalSpent",
       "userId")
    values
      (rec_receipts.receiptId,
       rec_receipts.bonusPointsEarned,
       rec_receipts.bonusPointsEarnedReason,
       rec_receipts.createDate,
       rec_receipts.dateScanned,
       rec_receipts.finishedDate,
       rec_receipts.modifyDate,
       rec_receipts.pointsAwardedDate,
       rec_receipts.pointsEarned,
       rec_receipts.purchaseDate,
       rec_receipts.purchasedItemCount,
       v_ReceiptItemListId,
       rec_receipts.rewardsReceiptStatus,
       rec_receipts.totalSpent,
       rec_receipts.userId);
    for rec_ReceiptItemList in cur_ReceiptItemList( c_receiptId := rec_receipts.receiptId ) loop
      -- check to make sure that the ReceiptItemListId was created then insert record into ReceiptItemList
      if v_ReceiptItemListId is not null then
        insert into public."ReceiptItemList"
          ("ReceiptItemListId",
            "partnerItemId",
            "rewardsProductPartnerId",
            "pointsPayerId",
            "metabriteCampaignId",
            "userFlaggedPrice",
            "pointsEarned",
            "competitiveProduct",
            "needsFetchReview",
            "finalPrice",
            "targetPrice",
            "discountedItemPrice",
            "originalFinalPrice",
            "itemPrice",
            DESCRIPTION,
            "needsFetchReviewReason",
            "rewardsGroup",
            "quantityPurchased",
            "priceAfterCoupon",
            "userFlaggedDescription",
            "userFlaggedBarcode",
            "pointsNotAwardedReason",
            "originalMetaBriteBarcode",
            "originalMetaBriteItemPrice",
            "originalMetaBriteDescription",
            BARCODE,
            "competitorTargetGapPoints",
            "brandCode",
            "itemNumber",
            "originalMetaBriteQuantityPurchased",
            "userFlaggedNewItem",
            "originalReceiptItemText",
            "userFlaggedQuantity",
            "preventTargetGapPoints")
        values
          (v_ReceiptItemListId,
           rec_ReceiptItemList.partnerItemId,
           rec_ReceiptItemList.rewardsProductPartnerId,
           rec_ReceiptItemList.pointsPayerId,
           rec_ReceiptItemList.metabriteCampaignId,
           rec_ReceiptItemList.userFlaggedPrice,
           rec_ReceiptItemList.pointsEarned,
           rec_ReceiptItemList.competitiveProduct,
           rec_ReceiptItemList.needsFetchReview,
           rec_ReceiptItemList.finalPrice,
           rec_ReceiptItemList.targetPrice,
           rec_ReceiptItemList.discountedItemPrice,
           rec_ReceiptItemList.originalFinalPrice,
           rec_ReceiptItemList.itemPrice,
           rec_ReceiptItemList.description,
           rec_ReceiptItemList.needsFetchReviewReason,
           rec_ReceiptItemList.rewardsGroup,
           rec_ReceiptItemList.quantityPurchased,
           rec_ReceiptItemList.priceAfterCoupon,
           rec_ReceiptItemList.userFlaggedDescription,
           rec_ReceiptItemList.userFlaggedBarcode,
           rec_ReceiptItemList.pointsNotAwardedReason,
           rec_ReceiptItemList.originalMetaBriteBarcode,
		   rec_ReceiptItemList.originalMetaBriteItemPrice,
           rec_ReceiptItemList.originalMetaBriteDescription,
           rec_ReceiptItemList.barcode,
           rec_ReceiptItemList.competitorTargetGapPoints,
           rec_ReceiptItemList.brandCode,
           rec_ReceiptItemList.itemNumber,
           rec_ReceiptItemList.originalMetaBriteQuantityPurchased,
           rec_ReceiptItemList.userFlaggedNewItem,
           rec_ReceiptItemList.originalReceiptItemText,
           rec_ReceiptItemList.userFlaggedQuantity,
           rec_ReceiptItemList.preventTargetGapPoints);
      end if;
    end loop;
    
  end loop;
  raise notice 'end program';
--
exception
  when others then
    --rollback;
    raise notice 'Failed: % %',sqlstate,sqlerrm;
end import_Receipts_date $$;