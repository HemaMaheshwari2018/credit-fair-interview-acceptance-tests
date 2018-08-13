require 'spec_helper'
require 'faker'
require 'money'
require 'active_support/core_ext/module/delegation'
require_relative '../spec/helpers/helpers'
require_relative '../spec/helpers/base_helpers'




describe 'Line Of Credit Specs-'   do


  delegate :click_new_line_of_credit_href_link,
                       :apr_input,
                       :credit_limit_input,
                       :click_create_line_of_credit_btn,
                       :select_type_line_of_credit,
                       :get_credit_available_value,
                       :amount_input,
                       :click_save_transaction_btn,
                       :get_credit_line_opened_value,
                       :calculate_interest_owed,
                       :get_total_payoff_at_30_days_value,
                       :get_apr_value,
                       :get_interest_at_30_days_value,
                       :file_split,
                       :select_day,
                       :get_transacations_table,
                       :get_error_exceed_limit_text,
                       :get_error_credit_limit_cannot_be_blank,
                       :get_error_credit_limit_is_not_a_number,
                       :get_transaction_table_remove_link,
                       :click_back_link,
                       :home_page_last_edit_link,
                       :get_message,
                       :get_edit_line_of_credit_text,
                       :get_apr_of_last_transaction_data,
           to: BaseHelpers

  before do
    @data = IO.readlines("test-data/scenario_test_data")
  end

  it 'scenario 1 : available line of credit is $1000 for 35% apr, Day 1 withdrawl = $500, no more withdrawl for 30 days'  do

    #scenario input and expected data
    apr = file_split(@data[1], 0)[1].to_i
    credit_limit = file_split(@data[1], 0)[2].to_i
    amount_withdrawn_on_applied_day = file_split(@data[1], 0)[5].to_i
    interest_charged_days = file_split(@data[1], 0)[6].to_i
    amount_balance_at_30_days = file_split(@data[1], 0)[7].to_i
    expected_interest_owed_at_30_days = calculate_interest_owed(amount_balance_at_30_days, apr, interest_charged_days)
    expected_total_pay_off_at_30_days = amount_balance_at_30_days + expected_interest_owed_at_30_days

    #start the test -
    #1.apply for new line fo credit
     visit_credit_home_page
     click_new_line_of_credit_href_link
     apr_input(apr)
     credit_limit_input(credit_limit)
     click_create_line_of_credit_btn

    #2.with draw from credit line

     select_type_line_of_credit(file_split(@data[1], 0)[4].strip)
     #applied day is default Day 1
     amount_input(amount_withdrawn_on_applied_day)
     click_save_transaction_btn

    #verify transactions
     expect((get_apr_value.split(": ")[1])).to eq '%.3f%' % apr
     expect(get_credit_available_value.split(": ")[1].split(" ")[0]).to eq Money.new(amount_balance_at_30_days*100, "USD").format
     expect(get_interest_at_30_days_value.split(": ")[1]).to eq Money.new(expected_interest_owed_at_30_days*100, "USD").format
     expect(get_total_payoff_at_30_days_value.split(": ")[1]). to eq Money.new(expected_total_pay_off_at_30_days*100, "USD").format

  end

  it 'scenario 2 : available line of credit is $1000 for 35% apr, Day 1 withdrawl = $500, Day 15 payment =$200, Day 25 withdrawl = $100'  do

    #scenario input and expected data
    balance = []
    days=[]
    apr = file_split(@data[2], 0)[1].to_i
    credit_limit = file_split(@data[2], 0)[2].to_i
    applied_at_day = file_split(@data[2], 0)[3].to_i
    applied_at_day_15 = file_split(@data[3], 0)[3].to_i
    applied_at_day_25 = file_split(@data[4], 0)[3].to_i
    amount_withdrawn_on_applied_day_1 = file_split(@data[2], 0)[5].to_i
    amount_paid_on_applied_day_15 = file_split(@data[3], 0)[5].to_i
    amount_withdrawn_on_applied_day_25 = file_split(@data[4], 0)[5].to_i
    interest_charged_days_day_1 = file_split(@data[2], 0)[6].to_i
    amount_balance_at_30_days = file_split(@data[2], 0)[7].to_i
    expected_interest_owed_at_30_days = calculate_interest_owed(amount_balance_at_30_days, apr, interest_charged_days_day_1)
    expected_total_pay_off_at_30_days = amount_balance_at_30_days + expected_interest_owed_at_30_days



    #start the test -
    #1.apply for new line of credit
    visit_credit_home_page
    click_new_line_of_credit_href_link
    apr_input(apr)
    credit_limit_input(credit_limit)
    click_create_line_of_credit_btn

    #2.with draw from credit line of $500
    select_type_line_of_credit(file_split(@data[2], 0)[4].strip)
    amount_input(amount_withdrawn_on_applied_day_1)
    click_save_transaction_btn

    #verify transactions
    expect((get_apr_value.split(": ")[1])).to eq '%.3f%' % apr
    expect(get_credit_available_value.split(": ")[1].split(" ")[0]).to eq Money.new(amount_balance_at_30_days*100, "USD").format
    expect(get_interest_at_30_days_value.split(": ")[1]).to eq Money.new(expected_interest_owed_at_30_days*100, "USD").format
    expect(get_total_payoff_at_30_days_value.split(": ")[1]). to eq Money.new(expected_total_pay_off_at_30_days*100, "USD").format

    #2.make payment of $200 against credit line
    select_type_line_of_credit(file_split(@data[3], 0)[4].strip)
    amount_input(amount_paid_on_applied_day_15)
    select_day(applied_at_day_15)
    click_save_transaction_btn
    wait_for_ajax

    #3. with draw from credit line of $100
    select_type_line_of_credit(file_split(@data[4], 0)[4].strip)
    amount_input(amount_withdrawn_on_applied_day_25)
    select_day(applied_at_day_25)
    click_save_transaction_btn
    wait_for_ajax

    #verify actual_total_interest is $11.99 and actual_total_money_owed is $411.99
    rows = get_transacations_table
    rows.length
    rows.map{|x| balance <<  x['Principal Balance']}
    rows.map{|x| days << x['Day']}
    actual_total_interest = calculate_interest_owed(balance[0].gsub("$", "").to_i, apr, days[1].to_i) + calculate_interest_owed(balance[1].gsub("$", "").to_i, apr, days[2].to_i - days[1].to_i) + calculate_interest_owed(balance[2].gsub("$", "").to_i, apr, 30 - days[2].to_i )
    actual_total_money_owed = balance[2].gsub("$", "").to_i + actual_total_interest
    expect(actual_total_interest).to eq file_split(@data[4], 0)[8].to_f
    expect(actual_total_money_owed).to eq (file_split(@data[4], 0)[7].to_f + file_split(@data[4], 0)[8].to_f)


end

  it 'scenario 3 - draw more amount than available credit' do

    #scenario input and expected data
    apr = file_split(@data[5], 0)[1].to_i
    credit_limit = file_split(@data[5], 0)[2].to_i
    applied_at_day = file_split(@data[5], 0)[3].to_i
    amount_withdrawn_on_applied_day_1 = file_split(@data[5], 0)[5].to_i

    #1.apply for new line of credit
    visit_credit_home_page
    click_new_line_of_credit_href_link
    apr_input(apr)
    credit_limit_input(credit_limit)
    click_create_line_of_credit_btn

    #2.with draw from credit line of $500
    select_type_line_of_credit(file_split(@data[5], 0)[4].strip)
    amount_input(amount_withdrawn_on_applied_day_1)
    click_save_transaction_btn

    #3 verify the error message
    expect(get_error_exceed_limit_text).to eq 'Amount cannot exceed the credit limit'

  end

  it 'scenario 4 - draw amount is 0' do

    #scenario input and expected data
    apr = file_split(@data[6], 0)[1].to_i
    credit_limit = file_split(@data[6], 0)[2].to_i
    applied_at_day = file_split(@data[6], 0)[3].to_i
    amount_withdrawn_on_applied_day_1 = file_split(@data[6], 0)[5].to_i

    #1.apply for new line of credit
    visit_credit_home_page
    click_new_line_of_credit_href_link
    apr_input(apr)
    credit_limit_input(credit_limit)
    click_create_line_of_credit_btn

    #2.with draw from credit line of $0
    select_type_line_of_credit(file_split(@data[6], 0)[4].strip)
    amount_input(amount_withdrawn_on_applied_day_1)
    click_save_transaction_btn

    #verify
    expect(get_error_exceed_limit_text).to eq 'Amount must be greater than 0'

  end

  it 'scenario 5 - click "Create Line of credit" button without entering credit limit' do

    #scenario input and expected data
    apr = file_split(@data[6], 0)[1].to_i

    #1.apply for new line of credit without specifying credit limit
    visit_credit_home_page
    click_new_line_of_credit_href_link
    apr_input(apr)
    click_create_line_of_credit_btn

    #verify error messages
    expect(get_error_credit_limit_cannot_be_blank).to eq "Credit limit can't be blank"
    expect(get_error_credit_limit_is_not_a_number). to eq "Credit limit is not a number"

  end

  it 'scenario 6 - click "Create Line of credit" button without entering apr' do

    #scenario input and expected data
    apr = file_split(@data[6], 0)[1].to_i

    #1.apply for new line of credit without specifying apr
    visit_credit_home_page
    click_new_line_of_credit_href_link
    credit_limit_input(1000)
    click_create_line_of_credit_btn

    #verify error messages
    expect(get_error_credit_limit_cannot_be_blank).to eq "Apr can't be blank"
    expect(get_error_credit_limit_is_not_a_number). to eq "Apr is not a number"

  end

  it 'scenario 7 : try to draw multiple times and then try to exceed the credit limit in the last transaction in a single day'  do

    #scenario input and expected data
    apr = file_split(@data[7], 0)[1].to_i
    credit_limit = file_split(@data[7], 0)[2].to_i
    amount_withdrawn_on_applied_day = file_split(@data[7], 0)[5].to_i

    #start the test - apply for new line of credit
    visit_credit_home_page
    click_new_line_of_credit_href_link
    apr_input(apr)
    credit_limit_input(credit_limit)
    click_create_line_of_credit_btn

    #with draw from credit line in different transactions on same day
    i=0
     while(i<=21)
      select_type_line_of_credit(file_split(@data[7], 0)[4].strip)
      #applied day is default Day 1
      amount_input(amount_withdrawn_on_applied_day)
      click_save_transaction_btn
      wait_for_ajax
      i+=1
     end

    #verify error message
    expect(get_error_exceed_limit_text).to eq 'Amount cannot exceed the credit limit'
  end

  it 'scenario 8 : interest at 30 days owed is $0 when same day Draw amd complete payment is done '  do

    #scenario input and expected data
    apr = file_split(@data[1], 0)[1].to_i
    credit_limit = file_split(@data[1], 0)[2].to_i
    amount_withdrawn_on_applied_day = file_split(@data[1], 0)[5].to_i
    interest_charged_days = file_split(@data[1], 0)[6].to_i
    amount_balance_at_30_days = file_split(@data[1], 0)[7].to_i
    expected_interest_owed_at_30_days = calculate_interest_owed(amount_balance_at_30_days, apr, interest_charged_days)
    expected_total_pay_off_at_30_days = amount_balance_at_30_days + expected_interest_owed_at_30_days

    #start the test - apply for new line of credit
    visit_credit_home_page
    click_new_line_of_credit_href_link
    apr_input(apr)
    credit_limit_input(credit_limit)
    click_create_line_of_credit_btn

    #with draw from credit line

    select_type_line_of_credit(file_split(@data[1], 0)[4].strip)
    #applied day is default Day 1
    amount_input(amount_withdrawn_on_applied_day)
    click_save_transaction_btn
    wait_for_ajax

    #verify transactions
    expect((get_apr_value.split(": ")[1])).to eq '%.3f%' % apr
    expect(get_credit_available_value.split(": ")[1].split(" ")[0]).to eq Money.new(amount_balance_at_30_days*100, "USD").format
    expect(get_interest_at_30_days_value.split(": ")[1]).to eq Money.new(expected_interest_owed_at_30_days*100, "USD").format
    expect(get_total_payoff_at_30_days_value.split(": ")[1]). to eq Money.new(expected_total_pay_off_at_30_days*100, "USD").format

    #complete payment amount on same day
    select_type_line_of_credit("Payment")
    #applied day is default Day 1
    amount_input(amount_withdrawn_on_applied_day)
    click_save_transaction_btn
    wait_for_ajax

    #verify interest owed is $0
    expect(get_interest_at_30_days_value.split(": ")[1]).to eq Money.new(0*100, "USD").format
  end


  it 'scenario 9 : User draws from Line of Credit, Makes full Payment, Then removes the payment transacation from line of credit and user still owes interest and money(same as first time withdrawl) '  do

    #scenario input and expected data
    apr = file_split(@data[1], 0)[1].to_i
    credit_limit = file_split(@data[1], 0)[2].to_i
    amount_withdrawn_on_applied_day = 100
    interest_charged_days = file_split(@data[1], 0)[6].to_i
    amount_balance_at_30_days = 100
    expected_interest_owed_at_30_days = calculate_interest_owed(amount_balance_at_30_days, apr, interest_charged_days)
    expected_total_pay_off_at_30_days = amount_balance_at_30_days + expected_interest_owed_at_30_days

    #start the test - apply for new line fo credit
    visit_credit_home_page
    click_new_line_of_credit_href_link
    apr_input(apr)
    credit_limit_input(credit_limit)
    click_create_line_of_credit_btn

    #with draw from credit line

    select_type_line_of_credit(file_split(@data[1], 0)[4].strip)
    amount_input(amount_withdrawn_on_applied_day)
    click_save_transaction_btn
    wait_for_ajax

    #payment complete amount on same day
    select_type_line_of_credit(file_split(@data[1], 0)[4].strip)
    amount_input(amount_withdrawn_on_applied_day)
    click_save_transaction_btn
    wait_for_ajax

    #remove payment transaction
    page.find(:xpath, "#{get_transaction_table_remove_link(2)}").click
    wait_for_ajax

    #verify that
    expect(get_message).to eq 'Transaction was successfully destroyed.'
    expected_total_pay_off_at_30_days = amount_balance_at_30_days + expected_interest_owed_at_30_days
    puts expected_total_pay_off_at_30_days
    expect(get_total_payoff_at_30_days_value.split(": ")[1]). to eq Money.new(expected_total_pay_off_at_30_days*100, "USD").format

  end

  it 'scenario 10 : edit line of credit and verify that edited apr, interest owed, total payment owed are upated per the expected formula and verify that apr is updated on home page for the loc'  do

    #scenario input and expected data
    apr = file_split(@data[1], 0)[1].to_i
    updated_apr = 25
    credit_limit = file_split(@data[1], 0)[2].to_i
    amount_withdrawn_on_applied_day = file_split(@data[1], 0)[5].to_i
    interest_charged_days = file_split(@data[1], 0)[6].to_i
    amount_balance_at_30_days = file_split(@data[1], 0)[7].to_i
    expected_interest_owed_at_30_days = calculate_interest_owed(amount_balance_at_30_days, apr, interest_charged_days)
    updated_expected_interest_owed_at_30_days = calculate_interest_owed(amount_balance_at_30_days, updated_apr, interest_charged_days)
    expected_total_pay_off_at_30_days = amount_balance_at_30_days + expected_interest_owed_at_30_days
    updated_expected_total_pay_off_at_30_days = amount_balance_at_30_days + updated_expected_interest_owed_at_30_days

    #start the test -
    #1.apply for new line fo credit
    visit_credit_home_page
    click_new_line_of_credit_href_link
    apr_input(apr)
    credit_limit_input(credit_limit)
    click_create_line_of_credit_btn

    #2.with draw from credit line
    select_type_line_of_credit(file_split(@data[1], 0)[4].strip)
    #applied day is default Day 1
    amount_input(amount_withdrawn_on_applied_day)
    click_save_transaction_btn
    wait_for_ajax

    #verify transactions
    expect((get_apr_value.split(": ")[1])).to eq '%.3f%' % apr
    expect(get_credit_available_value.split(": ")[1].split(" ")[0]).to eq Money.new(amount_balance_at_30_days*100, "USD").format
    expect(get_interest_at_30_days_value.split(": ")[1]).to eq Money.new(expected_interest_owed_at_30_days*100, "USD").format
    expect(get_total_payoff_at_30_days_value.split(": ")[1]). to eq Money.new(expected_total_pay_off_at_30_days*100, "USD").format

    #3.click back link on loc page and user navigates to home page
    click_back_link
    page.driver.browser.navigate.refresh

    # 4.click edit link on home page for the new line of credit created in step1
    home_page_last_edit_link
    page.driver.browser.navigate.refresh

    #5. user id on edit line of credit page and updates apr(different from step #1)
    expect(get_edit_line_of_credit_text).to eq 'Editing Line Of Credit'
    apr_input(updated_apr)
    credit_limit_input(credit_limit)
    click_create_line_of_credit_btn
    wait_for_ajax

    #verify that interest owed is caluclated based on updated apr
    expect(get_message).to eq 'Line of credit was successfully updated.'
    expect((get_apr_value.split(": ")[1])).to eq '%.3f%' % updated_apr
    expect(get_credit_available_value.split(": ")[1].split(" ")[0]).to eq Money.new(amount_balance_at_30_days*100, "USD").format
    expect(get_interest_at_30_days_value.split(": ")[1]).to eq Money.new(updated_expected_interest_owed_at_30_days*100, "USD").format
    expect(get_total_payoff_at_30_days_value.split(": ")[1]). to eq Money.new(updated_expected_total_pay_off_at_30_days*100, "USD").format

    #6. click back link on loc page and user navigates to home page and ensure that on home page apr is updated for the loc created on step #1
    click_back_link
    page.driver.browser.navigate.refresh
    expect(get_apr_of_last_transaction_data).to eq '%.1f' % updated_apr

  end
end