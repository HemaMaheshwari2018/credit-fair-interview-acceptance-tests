# Thanks very much for the opportunity !!!
##### - Name - Hema Maheshwari, QA Engg

# About The Test Automation Framework

- This is a RSpec/Capybara/Site Prism based framework.
- Tests execution is parallelized using parallel_split_test gem.
- Tests execution config are set up in Rakefile Tasks.
- In Rakefile each tasks is designed for a specific browser, enviornment (currently it's set up for prod).
- Test Data is set up test-data/scenario_test_data file. 
- html reports for separate browsers are generated in the root directory. You can click it from finder to open on browser.
- Page Objects and Actions on page objects are separately maintained in "page_object" directory.
- helpers/base_helpers.rb class delegates Page Object actions to individual specs. The idea behind this is to ensure that when more spec files/suites exists, then actions are delegated in centralized way.


# How to Run Tests
##### chrome browser / production env - 
|rake chrome_prod|
|----------------|

#### firefox browser / production env- 
|rake firefox_prod|
|----------------|

#### cross browser / production env- 
|rake test_cross_browser_prod|
|----------------|

# Automated Sceanrios 
|Scenario_Num|Test_Steps|
|-----------| ----------|
|<b>1</b> |available line of credit is $1000 for 35% apr, Day 1 withdrawl = $500, no more withdrawl for 30 days|
|<b>2</b> |available line of credit is $1000 for 35% apr, Day 1 withdrawl = $500, Day 15 payment =$200, Day 25 withdrawl = $100|
|<b>3</b> |draw more amount than available credit|
|<b>4</b>|draw amount is 0|
|<b>5</b>|click "Create Line of credit" button without entering credit limit|
|<b>6</b>|click "Create Line of credit" button without entering apr|
|<b>7</b>|try to draw multiple times and then try to exceed the credit limit in the last transaction in a single day|
|<b>8</b>|interest at 30 days owed is $0 when same day Draw amd complete Payment is done|
|<b>9</b>|User draws from Line of Credit, Makes full Payment, Then removes the payment transacation from line of credit and user still owes interest and money(same as first time withdrawl)|
|<b>10</b>|edit line of credit and verify that edited apr, interest owed, total payment owed are upated per the expected formula and verify that apr is updated on home page for the loc|


# Bugs -

### Issue # 1
#### url - https://credit-test.herokuapp.com/line_of_credits/[credit id]
#### Summary - Interest at 30 Days is not caluclated based on the real number of days when the first withdrawl occurs on Day other than Day 1
##### Scenario Steps -
1. Navigate to https://credit-test.herokuapp.com
2. Enter 9.000% APR
3. Enter $999.99 for credit limit.
4. Click "Create Line of credit"
5. User is navigated to /line_of_credits page.
6. Select Type="Draw"
7. Select Applied Day = 7
8. Enter Amount = $999
6. Click "Save Transaction"

##### Issue - For the above transaction, Interest at 30 days is $7.39. 
##### Expected Behavior - For the above transaction, Interest at 30 days should be $5.92, which is based on real number of days "24" as the first withdrawl occured on Day 7. Per requirement #4, "APR Calculation based on the outstanding principal balance over real number of days."
 

### Issue # 2
#### url - https://credit-test.herokuapp.com/line_of_credits/[credit id]
#### Summary - Credit Available is incorrect labeled. It currently indicates, how much money user has drawn from available line of credit instead of available credit.
##### Scenario Steps -
1. Navigate to https://credit-test.herokuapp.com
2. Enter 35.000% APR
3. Enter $1000 for credit limit.
4. Click "Create Line of credit"
5. User is navigated to /line_of_credits page.
6. Select Type="Draw"
7. Select Applied Day = 1
8. Enter Amount = $600
6. Click "Save Transaction"

##### Issue - "Credit Available" indicates -  Credit Available: $600.00 of $1,000.00
##### Expected Behavior - Since user has drawn $600, "Credit Available" should indicate $400 of $1,000.

### Issue #3 -
#### url - https://credit-test.herokuapp.com/line_of_credits
#### Summary - "Destroy" link is not working on Listing Line of Credits
##### Scenario Steps -
1. Navigate to https://credit-test.herokuapp.com/line_of_credits
2. Click on "Destroy" link for a credit histroy entry.

##### Issue  - user is unable to remove "credit" entry.
##### Expected Behavior - "Destory" link should supposedly remove credit line from credit listing.

### Issue # 4 -
#### url - https://credit-test.herokuapp.com/line_of_credits/[credit id]
#### Summary - Internal Server error returned when user does not enter amount and clicks "Save Transactions" on /line_of_credits/[credit id] page
##### Scenario Steps-
1. Navigate to https://credit-test.herokuapp.com
2. Enter 35.000% APR
3. Enter $1000 for credit limit.
4. Click "Create Line of credit"
5. User is navigated to /line_of_credits page.
6. Select Tpe="Draw"
7. Select Applied Day = 1
8. Do not enter any amount
9. Click "Save Transaction"

##### Issue - Internal Server error returned when user does not enter amount and clicks "Save Transactions".
##### Scenario-Expected Behavior - Error handling should occur and error message should be returned indciating user to enter amount.

### Issue # 5 
#### Summary - User is not allowed to pay in cents. This way user will not be able to pay complete amount(when interest is accrued in cents)
##### Scenario Steps -
1. Navigate to https://credit-test.herokuapp.com
2. Enter 35.000% APR
3. Enter $1000 for credit limit.
4. Click "Create Line of credit"
5. User is navigated to /line_of_credits page.
6. Select Tpe="Draw"
7. Select Applied Day = 1
8. Enter Amount = $50
9. Click "Save Transaction", Interest accrued is $0.41
10. Select Tpe="Payment"
11.Select Applied Day = 30
12.Enter Amount = $50.41 in order to pay off the complete amount(principal + interest)

##### Issue - Application doesn't allow user to pay in cents
##### Expected Behavior - Application should be able to accept amount in cents also (amount data type should be float)


# Suggestions For Improvement -
- Implement min and max limits on credit limit and apr. If user enters a very large amount then it can crash database.
- Do not allow user to "Destroy" a transaction. The user can withdraw the money and then easily reset the owed amouny by removing the transaction in line of credit page.
- Applied Number of Days on /line_of_credit/[credit id] page should have max number of days = 31 as the max number of days in months varies between 28-31 inclusive.
- HTML table alignment could be better and clear.
