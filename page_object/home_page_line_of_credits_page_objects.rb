require 'site_prism'
require 'capybara'

module PageObjects

  class HomePageLineOfCreditsPageObjects < SitePrism::Page

    attr_reader :new_line_of_credit_href_link


    #new line of credit link
    element :new_line_of_credit_href_link, "a[href='/line_of_credits/new']"
    element :edit_link_of_last_transaction, "tbody>tr:nth-last-of-type(1)>td:nth-of-type(5)"
    element :apr_of_last_transaction, "tbody>tr:nth-last-of-type(1)>td:nth-of-type(1)"


    def has_text_value?(field, value)
      field.value ==value
    end

    def enter_input_data(element, keyword)
      1.times do
        break if has_text_value?(element,keyword)
        element.set keyword
      end
    end


    def method_element(element)
      method_name = "wait_until_#{element}_visible"
      run_method(method_name)
      element.click
    end

    def run_method(method_name)
      "#{self.class.name} => :#{method_name}"
    end


    def element_text_exist(element)
      method_name = "wait_until_#{element}_visible"
      run_method(method_name)
      element.text
    end

    def get_element_input_data(element)
      element.value
    end


    def click_new_line_of_credit_href_link
      wait_for_new_line_of_credit_href_link
      new_line_of_credit_href_link.click
      sleep(0.4)
    end


    def click_edit_link_of_last_transaction_link
      wait_for_edit_link_of_last_transaction
      edit_link_of_last_transaction.click
    end

    def get_apr_of_last_transaction_data
      wait_for_apr_of_last_transaction
      apr_of_last_transaction.text
    end
  end
end
