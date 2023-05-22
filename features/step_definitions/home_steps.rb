home_page = HomePage.new

Given(/^search "([^"]*)" on home page$/) do |word|
  $searched_word = word
  home_page.search(word)
end