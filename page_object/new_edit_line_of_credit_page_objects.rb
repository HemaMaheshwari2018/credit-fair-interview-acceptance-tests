require 'site_prism'
require 'capybara'

module PageObjects

  class NewLineOfCreditsPageObjects < SitePrism::Page

    attr_reader :apr_input,
                :create_line_of_credit_btn,
                :credit_limit_input



    #new line of credit link
    element :apr_input, "input[id=line_of_credit_apr]"
    element :credit_limit_input, "input[id=line_of_credit_credit_limit]"
    element :create_line_of_credit_btn, 'input[type="submit"]'
    element :editing_line_of_credit_text, 'body > h1'

    def has_text_value?(field, value)
      field.value ==value
    end

    def enter_input_data(element, keyword)
      1.times do
        break if has_text_value?(element,keyword)
        element.set keyword
      end
    end


    def get_element_input_data(element)
      element.value
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

    def click_apr_input
      wait_for_apr_input
      apr_input.click
    end

    def click_create_line_of_credit_btn
      wait_for_create_line_of_credit_btn
      create_line_of_credit_btn.click
    end


    def get_editing_line_of_credit_text
      element_text_exist(editing_line_of_credit_text)
    end


  end
end
