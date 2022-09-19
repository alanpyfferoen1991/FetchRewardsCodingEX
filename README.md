# FetchRewardsCodingEX
Fetch Rewards Coding Exercise

#Development Environment#
 - Languages: PostgreSQL, PL/pgSQL, Python
 - Tools: pgAdmin 4,Visual Studio Code - Extentions: Python, Pylance, Jupyter
 - Resources: Resources_Used.txt

##########################
######  EXERCISE 1  ######
##########################
View: Exercise1 folder
View ERD.png. I used pgAdmins ERD tool to create the ERD for this exercise.

There will also be a Create_Tables.sql file that can be used to create all the tables 
I used in exercise 2. Before running the Create_Table.sql if you don't have schema named
public you'll have to edit the script or create a public schema. 

Now that we have our table created we import the data from the json file. In the Import_Json_to_database folder
there is a file called readMe.txt. Follow the instruction for running the scripts. Once finished you will be 
ready for exercise 2.


##########################
######  EXERCISE 2  ######
##########################
View: Exercise2 folder
- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
View the Query_answers.sql for the answers to the questions above.


##########################
######  EXERCISE 3  ######
##########################
View: Exercise3 folder
Run the Create_functions.sql to create the getProportionMissing function. This will be needed for the FindQualityIssues.sql
View FindQualityIssues.sql and Brands_data_analysis.sql, in those files I use sql to do my analysis.
If you look at the Tracked_issues.txt you'll see some issues I tracked.
I also used python and the pandas library to review the users.json data. You can review the User_Data_Analysis.pdf to see how did that.


##########################
######  EXERCISE 4  ######
##########################
View: Exercise4 folder
I wrote an email for this exercise. The Stakeholders Email.pdf will have an attachment that is located in the Email_attachment folder.
