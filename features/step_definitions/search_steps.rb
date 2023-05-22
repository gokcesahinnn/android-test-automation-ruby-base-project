search_page = SearchPage.new

Then(/^verify search result contains searched keyword on search result page$/) do
  search_page.verify_search_result
end