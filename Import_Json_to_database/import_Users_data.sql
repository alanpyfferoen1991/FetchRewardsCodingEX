-- Run this script to populate the users table. I used a group by to remove any duplicate records.
-- userId needs to be unique and this data contains duplicates.
with users_table as(
select (doc -> '_id' ->> '$oid')::varchar as userId
      ,(doc ->> 'active')::boolean as active
	  ,to_timestamp((doc -> 'createdDate' ->> '$date')::numeric/1000) as createdDate
	  ,to_timestamp((doc -> 'lastLogin' ->> '$date')::numeric/1000) as lastLogin
	  ,(doc ->> 'role')::varchar as role
	  ,(doc ->> 'signUpSource')::varchar as signUpSource
	  ,(doc ->> 'state')::varchar as state
from users_import
)
insert into users
	("userId"
     ,active
	 ,"createdDate"
	 ,"lastLogin"
	 ,role
	 ,"signUpSource"
	 ,state)
select userId
      ,active
	  ,createdDate
	  ,lastLogin
	  ,role
	  ,signUpSource
	  ,state
from users_table
group by userId
      ,active
	  ,createdDate
	  ,lastLogin
	  ,role
	  ,signUpSource
	  ,state