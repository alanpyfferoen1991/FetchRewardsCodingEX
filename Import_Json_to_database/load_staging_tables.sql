create table users_import (doc jsonb);
\copy public.users_import from 'C:\Users\alanp\Documents\FetchRewardsCodingExercise\users.json'
create table receipts_import (doc jsonb);
\copy public.receipts_import from 'C:\Users\alanp\Documents\FetchRewardsCodingExercise\receipts.json'
create table brands_import (doc jsonb);
\copy public.brands_import from 'C:\Users\alanp\Documents\FetchRewardsCodingExercise\brands.json'