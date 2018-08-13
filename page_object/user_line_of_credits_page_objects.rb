require 'site_prism'
require 'site_prism/table'
require 'capybara'

module PageObjects

  class UserLineOfCreditsPageObjects < SitePrism::Page
    extend  SitePrism::Table

    attr_reader :type_selection,
                :amount_input,
                        :applied_at_day_selection,
                        :save_transaction_btn,
                        :credit_line_opened_text,
                        :interest_text,
                        :total_pay_off_text,
                        :credit_available_text,
                        :apr_text,
                        :back_link

    #new line of credit link
    element :type_selection, 'select[id="transaction_type"]'
    element :amount_input, 'input[id="transaction_amount"]'
    element :applied_at_day_selection, 'select[id="transaction_applied_at"]'
    element :save_transaction_btn, 'input[value="Save Transaction"]'
    element :credit_line_opened_text, :xpath, '//*[text()="Credit Line Opened:"]/..'
    element :interest_text, :xpath, '//*[text()="Interest at 30 days:"]/..'
    element :total_pay_off_text, :xpath, '//*[text()="Total Payoff at 30 days:"]/..'
    element :credit_available_text, :xpath, '//*[text()="Credit Available:"]/..'
    element :apr_text, :xpath, '//*[text()="Apr:"]/..'
    element :error_exceed_credit_limit, '#error_explanation>ul>li'
    element :error_credit_limit_cannot_be_blank, '#error_explanation>ul>li:nth-of-type(1)'
    element :error_credit_limit_is_not_a_number, '#error_explanation>ul>li:nth-of-type(2)'
    element :back_link, 'a[href="/line_of_credits"]'
    element :message, 'p[id="notice"]'

    def has_text_value?(field, value)
      field.value ==value
    end

    def enter_input_data(element, keyword)
      1.times do
        break if has_text_value?(element,keyword)
        element.set keyword
      end
    end


    def select_element_input_data(element,keyword)
      element.select(keyword)
    end

    def run_method(method_name)
      "#{self.class.name} => :#{method_name}"
    end


    def element_text_exist(element)
      method_name = "wait_until_#{element}_visible(10)"
      run_method(method_name)
      element.text
    end

    def click_amount_input
      wait_for_amount_input
      amount_input.click
    end

    def click_save_transaction_btn
      wait_for_save_transaction_btn
      save_transaction_btn.click
    end

    def get_credit_available_text_data
        loop do
          if (credit_available_text.text.split(": ")[1].split(" ")[0]) != '$0.00'
            return credit_available_text.text
          end
        end
    end

    def get_apr_data
      wait_for_apr_text
      apr_text.text
    end

    def get_interest_at_30_days
      wait_for_interest_text
      interest_text.text
    end

    def get_total_payoff_at_30_days
      wait_for_total_pay_off_text
      total_pay_off_text.text
    end

    def click_back_link
      wait_for_back_link
      back_link.click
    end

    def transaction_table_remove_link(selector)
     return  "//tbody/tr[#{selector}]/td[6]/a"
    end

    def get_error_exceed_limit
      element_text_exist(error_exceed_credit_limit)
    end

    def get_error_credit_limit_cannot_be_blank
      element_text_exist(error_credit_limit_cannot_be_blank)
    end

    def get_error_credit_limit_is_not_a_number
      element_text_exist(error_credit_limit_is_not_a_number)
    end

    def get_message
      element_text_exist(message)
    end

  end
end
