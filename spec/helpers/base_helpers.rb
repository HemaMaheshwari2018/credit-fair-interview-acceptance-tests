require 'spec_helper'
require 'csv'
require 'pp'
require_relative '../../page_object/home_page_line_of_credits_page_objects'
require_relative '../../page_object/new_edit_line_of_credit_page_objects'
require_relative '../../page_object/user_line_of_credits_page_objects'


class BaseHelpers

  attr_reader  :test_data


$home_page_line_of_credits = PageObjects::HomePageLineOfCreditsPageObjects.new
$new_line_of_credits = PageObjects::NewLineOfCreditsPageObjects.new
$user_line_of_credits = PageObjects::UserLineOfCreditsPageObjects.new

def initialize
  @test_data = IO.foreach('test-data/scenario_test_data').to_a
end


  def self.click_new_line_of_credit_href_link
    $home_page_line_of_credits.click_new_line_of_credit_href_link
  end

  def self.apr_input(keyword)
    $new_line_of_credits.enter_input_data($new_line_of_credits.apr_input, keyword)
  end

  def self.credit_limit_input(keyword)
    $new_line_of_credits.enter_input_data($new_line_of_credits.credit_limit_input, keyword)
  end

  def self.click_create_line_of_credit_btn
    $new_line_of_credits.click_create_line_of_credit_btn
  end

  def self.select_type_line_of_credit(keyword)
    $user_line_of_credits.select_element_input_data($user_line_of_credits.type_selection,keyword)
  end

  def self.select_day(keyword)
    $user_line_of_credits.select_element_input_data($user_line_of_credits.applied_at_day_selection,keyword)
  end

  def self.get_apr_value
    $user_line_of_credits.get_apr_data
  end

  def self.get_credit_available_value
    $user_line_of_credits.element_text_exist($user_line_of_credits.credit_available_text)
    $user_line_of_credits.get_credit_available_text_data
  end

  def self.get_credit_line_opened_value
    $user_line_of_credits.get_credit_line_opened_data
  end

  def self.get_total_payoff_at_30_days_value
    $user_line_of_credits.get_total_payoff_at_30_days
  end

  def self.get_interest_at_30_days_value
    $user_line_of_credits.get_interest_at_30_days
  end

  def self.amount_input(keyword)
    $user_line_of_credits.enter_input_data($user_line_of_credits.amount_input, keyword)
  end

  def self.click_save_transaction_btn
    $user_line_of_credits.click_save_transaction_btn
  end

  def self.get_error_exceed_limit_text
    $user_line_of_credits.get_error_exceed_limit
  end

  def self.get_error_credit_limit_cannot_be_blank
    $user_line_of_credits.get_error_credit_limit_cannot_be_blank
  end

  def self.get_error_credit_limit_is_not_a_number
    $user_line_of_credits.get_error_credit_limit_is_not_a_number
  end

  def self.get_transaction_table_remove_link(selector)
   $user_line_of_credits.transaction_table_remove_link(selector)
  end

  def self.click_back_link
    $user_line_of_credits.click_back_link
  end

  def self.get_message
    $user_line_of_credits.get_message
  end

  def self.get_edit_line_of_credit_text
    $new_line_of_credits.get_editing_line_of_credit_text
  end

  def self.home_page_last_edit_link
    $home_page_line_of_credits.click_edit_link_of_last_transaction_link
  end

  def self.get_apr_of_last_transaction_data
    $home_page_line_of_credits.get_apr_of_last_transaction_data
  end

  def self.get_transacations_table
    doc = Nokogiri::HTML( $user_line_of_credits.html)
    headers = []
      doc.xpath('//*/table/thead/tr/th').each do |th|
      headers << th.text
    end

    # get table rows
      rows = []
          doc.xpath('//*/table/tbody/tr').each_with_index do |row, i|
          rows[i] = {}
          row.xpath('td').each_with_index do |td, j|
          rows[i][headers[j]] = td.text
          end
      end
    return rows
  end



  def self.file_split(file_value, num)
    a=[]
    a << file_value
    values =  a[num].to_s.split(",")
    return values
  end

  def self.calculate_interest_owed(amount_drawn, apr, credit_period)
    return (((amount_drawn * (apr / 100.0)) / (365)) * credit_period).round(2)
  end



end
