base_page = BasePage.new

Given(/^agree chrome terms on base page$/) do
  base_page.agree_terms
end

And(/^refuse account sync on base page$/) do
  base_page.refuse_account_sync
end