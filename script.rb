#! /usr/bin/env ruby
require 'selenium-webdriver'

EMAIL = 'email@example.com' # TODO: Change this to your email!

CAPTCHA_QUESTION = 'To prove you are not a robot, what is the first letter of the word TekSavvy?'
CAPTCHA_ANSWER = 'T'

driver = Selenium::WebDriver.for :chrome
driver.navigate.to 'http://12days.teksavvy.com'

todays_gift = driver.find_element(:class, 'today')
todays_gift.click

sleep 0.5

form = driver.find_element(:id, 'formParticipate')

prize_info = form.find_element(:class, 'modal-lft-top')
prize = prize_info.find_element(:tag_name, 'h2').text
prize_details = prize_info.find_element(:tag_name, 'p').text

puts prize
puts prize_details

email = form.find_element(:id, 'Email')
email.send_keys EMAIL

rules_checkbox = form.find_element(:id, 'AcceptTermsAndConditions')
rules_checkbox.send_keys ' '

captcha_question = form.find_element(:class, 'form-btm').find_element(:tag_name, 'span')
sleep 0.25
unless captcha_question.text == CAPTCHA_QUESTION
  fail ArgumentError, 'Cannot answer captcha'
end

captcha_field = form.find_element(:name, 'Validation')
captcha_field.send_keys CAPTCHA_ANSWER

form.submit

sleep 0.5

success_submission = driver.find_element(:class, 'success-submission')
if success_submission.text =~ /Thanks.*Stay tuned.*Lucky Winner!/i
  puts 'Success!'
else
  puts 'Something went wrong'
  fail RuntimeError, 'Unable to sign up :('
end

driver.quit
